const udp = require('dgram');
const tcp = require('net');
const { Config, MessageTypes } = require('./constants');
const ConnectionManager = require('./connection-manager');
const MessageHandler = require('./message-handler');
const LoadBalancerClient = require('./load-balancer-client');

class NATServer {
    constructor(config = {}) {
        this.config = {
            tcpPort: config.tcpPort || Config.TCP_PORT,
            udpPort: config.udpPort || Config.UDP_PORT,
            natTestPortOne: config.natTestPortOne || Config.NAT_TEST_PORT_ONE,
            natTestPortTwo: config.natTestPortTwo || Config.NAT_TEST_PORT_TWO,
            bindAddress: config.bindAddress || Config.BIND_ADDRESS,

            // Load balancer configuration
            enableLoadBalancer: config.enableLoadBalancer || false,
            loadBalancerHost: config.loadBalancerHost || 'localhost',
            loadBalancerPort: config.loadBalancerPort || 6500,
            serverName: config.serverName || 'MediationServer',
            serverRegion: config.serverRegion || 'default',
            maxConnections: config.maxConnections || 1000
        };

        this.connectionManager = new ConnectionManager();
        this.messageHandler = new MessageHandler(this.connectionManager);

        this.tcpServer = null;
        this.udpServer = null;
        this.natTestServer1 = null;
        this.natTestServer2 = null;

        // Load balancer client
        this.loadBalancerClient = null;

        // Track connection metrics for load balancer
        this.setupMetricsTracking();
    }

    start() {
        this.initializeTCPServer();
        this.initializeUDPServer();
        this.initializeNATTestServers();
        this.startTimeoutCheck();

        // Connect to load balancer if enabled
        if (this.config.enableLoadBalancer) {
            this.connectToLoadBalancer();
        }
    }

    setupMetricsTracking() {
        // Hook into connection manager to track metrics
        const originalAddSocket = this.connectionManager.addSocket.bind(this.connectionManager);
        this.connectionManager.addSocket = (...args) => {
            const result = originalAddSocket(...args);
            if (this.loadBalancerClient) {
                this.loadBalancerClient.incrementActiveConnections();
            }
            return result;
        };

        const originalRemoveSocket = this.connectionManager.removeSocket.bind(this.connectionManager);
        this.connectionManager.removeSocket = (...args) => {
            originalRemoveSocket(...args);
            if (this.loadBalancerClient) {
                this.loadBalancerClient.decrementActiveConnections(true);
            }
        };
    }

    connectToLoadBalancer() {
        console.log('Connecting to load balancer...');

        this.loadBalancerClient = new LoadBalancerClient(
            this.config.loadBalancerHost,
            this.config.loadBalancerPort,
            {
                name: this.config.serverName,
                port: this.config.tcpPort,
                tcpPort: this.config.tcpPort,
                udpPort: this.config.udpPort,
                maxConnections: this.config.maxConnections,
                region: this.config.serverRegion
            }
        );

        this.loadBalancerClient.connect();
    }

    initializeTCPServer() {
        this.tcpServer = tcp.createServer((socket) => {
            this.handleNewTCPConnection(socket);
        });

        this.tcpServer.on('listening', () => this.logServerInfo('TCP', this.tcpServer));
        this.tcpServer.on('error', (err) => console.error('TCP Server Error:', err));
        this.tcpServer.listen(this.config.tcpPort, this.config.bindAddress);
    }

    initializeUDPServer() {
        this.udpServer = this.createUDPSocket('Main UDP');
        this.udpServer.bind(this.config.udpPort);
    }

    initializeNATTestServers() {
        this.natTestServer1 = this.createNATTestSocket('NAT Test 1', this.config.natTestPortOne, true);
        this.natTestServer2 = this.createNATTestSocket('NAT Test 2', this.config.natTestPortTwo, false);

        this.natTestServer1.bind(this.config.natTestPortOne);
        this.natTestServer2.bind(this.config.natTestPortTwo);
    }

    createUDPSocket(name) {
        const socket = udp.createSocket({ type: 'udp4', reuseAddr: true });

        socket.on('error', (err) => console.error(`${name} Error:`, err));
        socket.on('message', (msg, info) => this.handleUDPMessage(msg, info));
        socket.on('listening', () => this.logServerInfo(name, socket));
        socket.on('close', () => console.log(`${name} socket closed`));

        return socket;
    }

    createNATTestSocket(name, port, isFirstPort) {
        const socket = udp.createSocket({ type: 'udp4', reuseAddr: true });

        socket.on('error', (err) => console.error(`${name} Error:`, err));
        socket.on('message', (msg, info) => this.handleNATTestMessage(msg, info, isFirstPort));
        socket.on('listening', () => console.log(`${name} listening on port ${port}`));
        socket.on('close', () => console.log(`${name} socket closed`));

        return socket;
    }

    handleNewTCPConnection(socket) {
        console.log(`New connection from ${socket.remoteAddress}:${socket.remotePort}`);

        const socketInfo = this.connectionManager.addSocket(
            socket,
            socket.remoteAddress,
            socket.remotePort,
            Config.DEFAULT_TIMEOUT
        );

        // Buffer for handling partial/concatenated JSON messages
        socket.dataBuffer = '';

        socket.on('data', (data) => this.handleTCPData(data, socket));

        socket.on('close', () => {
            this.connectionManager.removeSocket(socket, socketInfo.clientID);
        });

        socket.on('error', (err) => {
            // Gracefully handle common disconnection errors
            if (err.code === 'ECONNRESET') {
                this.connectionManager.removeSocket(socket, socketInfo.clientID);
            } else {
                console.error(`Socket error for client ${socketInfo.clientID}:`, err);
            }
        });

        // Send connected message
        socket.write(Buffer.from(JSON.stringify({ ID: MessageTypes.Connected })));
    }

    handleTCPData(data, socket) {
        // Append incoming data to buffer
        socket.dataBuffer += data.toString();

        // Try to parse complete JSON objects separated by newlines or by detecting balanced braces
        let braceCount = 0;
        let startIndex = 0;

        for (let i = 0; i < socket.dataBuffer.length; i++) {
            if (socket.dataBuffer[i] === '{') {
                if (braceCount === 0) {
                    startIndex = i;
                }
                braceCount++;
            } else if (socket.dataBuffer[i] === '}') {
                braceCount--;
                if (braceCount === 0) {
                    // Found a complete JSON object
                    const jsonStr = socket.dataBuffer.substring(startIndex, i + 1);
                    try {
                        const message = JSON.parse(jsonStr);
                        this.messageHandler.handleTCPMessage(message, socket);
                    } catch (e) {
                        console.error('Invalid JSON received:', e);
                        console.error('JSON string was:', jsonStr);
                    }
                    // Remove processed data from buffer
                    socket.dataBuffer = socket.dataBuffer.substring(i + 1);
                    i = -1; // Reset loop to parse next message
                    braceCount = 0;
                }
            }
        }

        // If buffer gets too large without finding complete JSON, clear it to prevent memory issues
        if (socket.dataBuffer.length > 10000) {
            console.error('Buffer overflow, clearing buffer');
            socket.dataBuffer = '';
        }
    }

    handleUDPMessage(msg, info) {
        this.connectionManager.updateTimeout(info.address);
        this.connectionManager.addUDPInfo(info.address, info.port);
    }

    handleNATTestMessage(msg, info, isFirstPort) {
        try {
            const message = JSON.parse(msg);
            if (message.ID === MessageTypes.NATTest) {
                console.log(`Received NAT test from ${info.address}:${info.port} on port ${isFirstPort ? 'ONE' : 'TWO'}, ClientID: ${message.ClientID}`);

                // Store UDP info so we can look it up later for connection requests
                this.connectionManager.addUDPInfo(info.address, info.port);

                const socket = this.connectionManager.updateNATTestPort(message.ClientID, info.port, isFirstPort);
                if (socket) {
                    socket.ip = info.address;
                    this.connectionManager.checkNATType(
                        socket.socket,
                        socket.localPort,
                        socket.externalPortOne,
                        socket.externalPortTwo
                    );
                } else {
                    console.log(`Could not find socket for ClientID: ${message.ClientID}`);
                }
            }
        } catch (e) {
            console.error('Invalid NAT test message:', e);
        }
    }

    logServerInfo(name, server) {
        const address = server.address();
        console.log(`${name} server info:`,
            `\n  Port: ${address.port}`,
            `\n  IP: ${address.address}`,
            `\n  Family: ${address.family}`
        );
    }

    startTimeoutCheck() {
        setInterval(() => {
            this.connectionManager.processTimeouts();
        }, 1000);
    }

    stop() {
        console.log('Shutting down NAT server...');

        // Disconnect from load balancer
        if (this.loadBalancerClient) {
            this.loadBalancerClient.shutdown();
        }

        // Close all servers
        if (this.tcpServer) {
            this.tcpServer.close();
        }
        if (this.udpServer) {
            this.udpServer.close();
        }
        if (this.natTestServer1) {
            this.natTestServer1.close();
        }
        if (this.natTestServer2) {
            this.natTestServer2.close();
        }
    }
}

// Start the server if run directly
if (require.main === module) {
    // Check for command line arguments
    const args = process.argv.slice(2);
    const config = {};

    // Parse command line arguments
    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--load-balancer' && args[i + 1]) {
            config.enableLoadBalancer = true;
            const [host, port] = args[i + 1].split(':');
            config.loadBalancerHost = host;
            config.loadBalancerPort = parseInt(port) || 6500;
            i++;
        } else if (args[i] === '--name' && args[i + 1]) {
            config.serverName = args[i + 1];
            i++;
        } else if (args[i] === '--region' && args[i + 1]) {
            config.serverRegion = args[i + 1];
            i++;
        } else if (args[i] === '--tcp-port' && args[i + 1]) {
            config.tcpPort = parseInt(args[i + 1]);
            i++;
        } else if (args[i] === '--udp-port' && args[i + 1]) {
            config.udpPort = parseInt(args[i + 1]);
            i++;
        }
    }

    const server = new NATServer(config);
    server.start();

    // Graceful shutdown
    process.on('SIGINT', () => {
        console.log('\nReceived SIGINT, shutting down...');
        server.stop();
        setTimeout(() => process.exit(0), 2000);
    });

    process.on('SIGTERM', () => {
        console.log('\nReceived SIGTERM, shutting down...');
        server.stop();
        setTimeout(() => process.exit(0), 2000);
    });
}

module.exports = NATServer;