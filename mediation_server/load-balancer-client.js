const tcp = require('net');
const os = require('os');
const { LBMessageTypes } = require('./load-balancer-constants');
const { Buffer } = require('buffer');

class LoadBalancerClient {
    constructor(loadBalancerHost, loadBalancerPort, mediationServerConfig) {
        this.lbHost = loadBalancerHost;
        this.lbPort = loadBalancerPort;
        this.config = mediationServerConfig;
        
        this.socket = null;
        this.serverID = null;
        this.connected = false;
        this.reconnectAttempts = 0;
        this.maxReconnectAttempts = -1; // Infinite retries
        this.reconnectDelay = 5000; // 5 seconds
        
        this.heartbeatInterval = null;
        this.metricsInterval = null;
        
        // Metrics tracking
        this.metrics = {
            activeConnections: 0,
            totalConnections: 0,
            successfulConnections: 0,
            failedConnections: 0
        };
    }

    connect() {
        if (this.connected) {
            console.log('Already connected to load balancer');
            return;
        }

        console.log(`Connecting to load balancer at ${this.lbHost}:${this.lbPort}...`);
        
        this.socket = new tcp.Socket();
        this.socket.dataBuffer = '';

        this.socket.connect(this.lbPort, this.lbHost, () => {
            this.handleConnected();
        });

        this.socket.on('data', (data) => this.handleData(data));
        
        this.socket.on('close', () => {
            this.handleDisconnected();
        });

        this.socket.on('error', (err) => {
            console.error('Load balancer connection error:', err.message);
            this.handleDisconnected();
        });
    }

    handleConnected() {
        console.log('Connected to load balancer');
        this.connected = true;
        this.reconnectAttempts = 0;
        this.register();
    }

    handleDisconnected() {
        if (!this.connected) return;
        
        console.log('Disconnected from load balancer');
        this.connected = false;
        
        // Clear intervals
        if (this.heartbeatInterval) {
            clearInterval(this.heartbeatInterval);
            this.heartbeatInterval = null;
        }
        
        if (this.metricsInterval) {
            clearInterval(this.metricsInterval);
            this.metricsInterval = null;
        }

        // Attempt to reconnect
        this.scheduleReconnect();
    }

    handleData(data) {
        // Append incoming data to buffer
        this.socket.dataBuffer += data.toString();

        // Parse complete JSON objects
        let braceCount = 0;
        let startIndex = 0;

        for (let i = 0; i < this.socket.dataBuffer.length; i++) {
            if (this.socket.dataBuffer[i] === '{') {
                if (braceCount === 0) {
                    startIndex = i;
                }
                braceCount++;
            } else if (this.socket.dataBuffer[i] === '}') {
                braceCount--;
                if (braceCount === 0) {
                    const jsonStr = this.socket.dataBuffer.substring(startIndex, i + 1);
                    try {
                        const message = JSON.parse(jsonStr);
                        this.handleMessage(message);
                    } catch (e) {
                        console.error('Invalid JSON from load balancer:', e);
                    }
                    this.socket.dataBuffer = this.socket.dataBuffer.substring(i + 1);
                    i = -1;
                    braceCount = 0;
                }
            }
        }

        if (this.socket.dataBuffer.length > 10000) {
            this.socket.dataBuffer = '';
        }
    }

    handleMessage(message) {
        switch (message.ID) {
            case LBMessageTypes.RegistrationAck:
                this.handleRegistrationAck(message);
                break;
            
            case LBMessageTypes.HealthCheckRequest:
                this.handleHealthCheck(message);
                break;
            
            default:
                console.log('Unknown message from load balancer:', message);
        }
    }

    register() {
        const message = {
            ID: LBMessageTypes.MediationServerRegister,
            ServerID: this.serverID, // Will be null on first registration
            Name: this.config.name || os.hostname(),
            Port: this.config.port || 6510,
            TCPPort: this.config.tcpPort || 6510,
            UDPPort: this.config.udpPort || 6510,
            MaxConnections: this.config.maxConnections || 1000,
            Region: this.config.region || 'default'
        };

        this.sendMessage(message);
        console.log('Sent registration to load balancer');
    }

    handleRegistrationAck(message) {
        if (message.Success) {
            this.serverID = message.ServerID;
            console.log(`Successfully registered with load balancer as ${this.serverID}`);
            
            // Start heartbeat
            const heartbeatInterval = message.HeartbeatInterval || 10000;
            this.startHeartbeat(heartbeatInterval);
            
            // Start metrics reporting
            const metricsInterval = message.MetricsInterval || 30000;
            this.startMetricsReporting(metricsInterval);
        } else {
            console.error('Registration failed:', message.Message);
        }
    }

    startHeartbeat(interval) {
        if (this.heartbeatInterval) {
            clearInterval(this.heartbeatInterval);
        }

        this.heartbeatInterval = setInterval(() => {
            this.sendHeartbeat();
        }, interval);

        console.log(`Heartbeat started with interval ${interval}ms`);
    }

    sendHeartbeat() {
        if (!this.connected) return;

        const message = {
            ID: LBMessageTypes.MediationServerHeartbeat,
            ServerID: this.serverID,
            Timestamp: Date.now()
        };

        this.sendMessage(message);
    }

    startMetricsReporting(interval) {
        if (this.metricsInterval) {
            clearInterval(this.metricsInterval);
        }

        this.metricsInterval = setInterval(() => {
            this.reportMetrics();
        }, interval);

        console.log(`Metrics reporting started with interval ${interval}ms`);
    }

    reportMetrics() {
        if (!this.connected) return;

        const cpuUsage = this.getCPUUsage();
        const memoryUsage = this.getMemoryUsage();

        const message = {
            ID: LBMessageTypes.MediationServerMetrics,
            ServerID: this.serverID,
            ActiveConnections: this.metrics.activeConnections,
            TotalConnections: this.metrics.totalConnections,
            SuccessfulConnections: this.metrics.successfulConnections,
            FailedConnections: this.metrics.failedConnections,
            CPUUsage: cpuUsage,
            MemoryUsage: memoryUsage,
            Timestamp: Date.now()
        };

        this.sendMessage(message);
    }

    handleHealthCheck(message) {
        // Respond to health check with a heartbeat
        this.sendHeartbeat();
    }

    updateMetrics(metricsUpdate) {
        if (metricsUpdate.activeConnections !== undefined) {
            this.metrics.activeConnections = metricsUpdate.activeConnections;
        }
        if (metricsUpdate.totalConnections !== undefined) {
            this.metrics.totalConnections = metricsUpdate.totalConnections;
        }
        if (metricsUpdate.successfulConnections !== undefined) {
            this.metrics.successfulConnections = metricsUpdate.successfulConnections;
        }
        if (metricsUpdate.failedConnections !== undefined) {
            this.metrics.failedConnections = metricsUpdate.failedConnections;
        }
    }

    incrementActiveConnections() {
        this.metrics.activeConnections++;
        this.metrics.totalConnections++;
    }

    decrementActiveConnections(successful = true) {
        this.metrics.activeConnections--;
        if (successful) {
            this.metrics.successfulConnections++;
        } else {
            this.metrics.failedConnections++;
        }
    }

    getCPUUsage() {
        // Simple CPU usage calculation
        const cpus = os.cpus();
        let totalIdle = 0;
        let totalTick = 0;

        cpus.forEach(cpu => {
            for (const type in cpu.times) {
                totalTick += cpu.times[type];
            }
            totalIdle += cpu.times.idle;
        });

        const idle = totalIdle / cpus.length;
        const total = totalTick / cpus.length;
        const usage = 100 - ~~(100 * idle / total);

        return usage;
    }

    getMemoryUsage() {
        const totalMem = os.totalmem();
        const freeMem = os.freemem();
        const usedMem = totalMem - freeMem;
        const usage = (usedMem / totalMem) * 100;

        return usage.toFixed(2);
    }

    sendMessage(message) {
        if (!this.connected || !this.socket) {
            console.log('Cannot send message: not connected to load balancer');
            return false;
        }

        try {
            this.socket.write(Buffer.from(JSON.stringify(message)));
            return true;
        } catch (error) {
            console.error('Error sending message to load balancer:', error);
            return false;
        }
    }

    scheduleReconnect() {
        if (this.maxReconnectAttempts !== -1 && 
            this.reconnectAttempts >= this.maxReconnectAttempts) {
            console.log('Max reconnection attempts reached. Giving up.');
            return;
        }

        this.reconnectAttempts++;
        const delay = Math.min(this.reconnectDelay * this.reconnectAttempts, 60000); // Max 60 seconds
        
        console.log(`Reconnecting to load balancer in ${delay}ms (attempt ${this.reconnectAttempts})...`);
        
        setTimeout(() => {
            this.connect();
        }, delay);
    }

    shutdown() {
        console.log('Shutting down load balancer client...');
        
        if (this.connected && this.serverID) {
            const message = {
                ID: LBMessageTypes.MediationServerShutdown,
                ServerID: this.serverID
            };
            
            this.sendMessage(message);
        }

        // Clear intervals
        if (this.heartbeatInterval) {
            clearInterval(this.heartbeatInterval);
        }
        
        if (this.metricsInterval) {
            clearInterval(this.metricsInterval);
        }

        // Close socket
        if (this.socket) {
            this.socket.destroy();
        }

        this.connected = false;
    }
}

module.exports = LoadBalancerClient;
