const tcp = require('net');
const { LBConfig } = require('./load-balancer-constants');
const MediationServerRegistry = require('./mediation-server-registry');
const LoadBalancerMessageHandler = require('./load-balancer-message-handler');

class LoadBalancerServer {
    constructor(port = LBConfig.TCP_PORT, bindAddress = LBConfig.BIND_ADDRESS) {
        this.port = port;
        this.bindAddress = bindAddress;
        this.registry = new MediationServerRegistry();
        this.messageHandler = new LoadBalancerMessageHandler(this.registry);
        this.tcpServer = null;
        this.connections = [];
    }

    start() {
        this.initializeTCPServer();
        this.startHealthChecks();
        this.startStatisticsReporting();
        console.log('Load Balancer Server starting...');
    }

    initializeTCPServer() {
        this.tcpServer = tcp.createServer((socket) => {
            this.handleNewConnection(socket);
        });

        this.tcpServer.on('listening', () => {
            const address = this.tcpServer.address();
            console.log('='.repeat(50));
            console.log('Load Balancer Server Information:');
            console.log(`  Port: ${address.port}`);
            console.log(`  IP: ${address.address}`);
            console.log(`  Family: ${address.family}`);
            console.log('='.repeat(50));
            console.log('Waiting for mediation servers to register...');
        });

        this.tcpServer.on('error', (err) => {
            console.error('TCP Server Error:', err);
            if (err.code === 'EADDRINUSE') {
                console.error(`Port ${this.port} is already in use. Please choose a different port.`);
                process.exit(1);
            }
        });

        this.tcpServer.listen(this.port, this.bindAddress);
    }

    handleNewConnection(socket) {
        const connectionInfo = {
            socket,
            remoteAddress: socket.remoteAddress,
            remotePort: socket.remotePort,
            connectedAt: Date.now(),
            serverID: null,
            isMediationServer: false
        };

        this.connections.push(connectionInfo);
        console.log(`New connection from ${socket.remoteAddress}:${socket.remotePort}`);

        // Buffer for handling partial/concatenated JSON messages
        socket.dataBuffer = '';

        socket.on('data', (data) => this.handleData(data, socket, connectionInfo));

        socket.on('close', () => {
            this.handleConnectionClose(socket, connectionInfo);
        });

        socket.on('error', (err) => {
            if (err.code === 'ECONNRESET') {
                this.handleConnectionClose(socket, connectionInfo);
            } else {
                console.error(`Socket error:`, err);
            }
        });
    }

    handleData(data, socket, connectionInfo) {
        // Append incoming data to buffer
        socket.dataBuffer += data.toString();

        // Try to parse complete JSON objects
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
                        this.messageHandler.handleMessage(message, socket, connectionInfo);
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

        // If buffer gets too large without finding complete JSON, clear it
        if (socket.dataBuffer.length > 50000) {
            console.error('Buffer overflow, clearing buffer');
            socket.dataBuffer = '';
        }
    }

    handleConnectionClose(socket, connectionInfo) {
        // Remove from connections list
        const index = this.connections.indexOf(connectionInfo);
        if (index !== -1) {
            this.connections.splice(index, 1);
        }

        // If this was a mediation server, remove it from registry
        if (connectionInfo.isMediationServer && connectionInfo.serverID) {
            console.log(`Mediation server ${connectionInfo.serverID} disconnected`);
            this.registry.removeServer(connectionInfo.serverID);
        } else {
            console.log(`Connection closed from ${connectionInfo.remoteAddress}:${connectionInfo.remotePort}`);
        }
    }

    startHealthChecks() {
        setInterval(() => {
            this.registry.checkServerHealth();
        }, LBConfig.HEALTH_CHECK_INTERVAL);
    }

    startStatisticsReporting() {
        setInterval(() => {
            const stats = this.registry.getStatistics();
            console.log('\n--- Load Balancer Statistics ---');
            console.log(`Total Servers: ${stats.totalServers}`);
            console.log(`  Healthy: ${stats.healthyServers}`);
            console.log(`  Degraded: ${stats.degradedServers}`);
            console.log(`  Unhealthy: ${stats.unhealthyServers}`);
            console.log(`Active Connections: ${stats.totalActiveConnections}`);
            console.log(`Total Capacity: ${stats.totalCapacity}`);
            console.log(`Utilization: ${stats.utilizationPercent}%`);
            console.log('-------------------------------\n');
        }, 60000); // Every 60 seconds
    }

    getRegistry() {
        return this.registry;
    }

    getMessageHandler() {
        return this.messageHandler;
    }

    stop() {
        console.log('Shutting down Load Balancer Server...');
        
        // Close all connections
        for (const conn of this.connections) {
            try {
                conn.socket.destroy();
            } catch (e) {
                // Ignore errors on shutdown
            }
        }

        // Close TCP server
        if (this.tcpServer) {
            this.tcpServer.close(() => {
                console.log('Load Balancer Server stopped');
            });
        }
    }
}

// Start the load balancer if run directly
if (require.main === module) {
    const server = new LoadBalancerServer();
    server.start();

    // Graceful shutdown handlers
    process.on('SIGINT', () => {
        console.log('\nReceived SIGINT, shutting down gracefully...');
        server.stop();
        setTimeout(() => process.exit(0), 1000);
    });

    process.on('SIGTERM', () => {
        console.log('\nReceived SIGTERM, shutting down gracefully...');
        server.stop();
        setTimeout(() => process.exit(0), 1000);
    });
}

module.exports = LoadBalancerServer;
