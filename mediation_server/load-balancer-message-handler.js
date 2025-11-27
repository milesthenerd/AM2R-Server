const { LBMessageTypes, LBConfig } = require('./load-balancer-constants');
const { Buffer } = require('buffer');

class LoadBalancerMessageHandler {
    constructor(registry) {
        this.registry = registry;
    }

    handleMessage(message, socket, socketInfo) {
        if (!message || !message.ID) return;

        switch (message.ID) {
            case LBMessageTypes.MediationServerRegister:
                this.handleMediationServerRegister(message, socket, socketInfo);
                break;
            
            case LBMessageTypes.MediationServerHeartbeat:
                this.handleHeartbeat(message, socket);
                break;
            
            case LBMessageTypes.MediationServerMetrics:
                this.handleMetricsReport(message, socket);
                break;
            
            case LBMessageTypes.MediationServerShutdown:
                this.handleServerShutdown(message, socket);
                break;
            
            case LBMessageTypes.GetAvailableServer:
                this.handleGetAvailableServer(message, socket);
                break;
            
            default:
                console.log(`Unknown message type: ${message.ID}`);
        }
    }

    handleMediationServerRegister(message, socket, socketInfo) {
        const serverID = message.ServerID || this.generateServerID();
        
        const serverInfo = {
            address: socketInfo.remoteAddress,
            port: message.Port || 6510,
            tcpPort: message.TCPPort || 6510,
            udpPort: message.UDPPort || 6510,
            socket,
            name: message.Name || `MediationServer-${serverID}`,
            maxConnections: message.MaxConnections || 1000,
            region: message.Region || 'default'
        };

        const server = this.registry.registerServer(serverID, serverInfo);
        
        // Store serverID on socket for easy lookup
        socketInfo.serverID = serverID;
        socketInfo.isMediationServer = true;

        // Send acknowledgment
        const response = {
            ID: LBMessageTypes.RegistrationAck,
            ServerID: serverID,
            Success: true,
            HeartbeatInterval: LBConfig.HEARTBEAT_INTERVAL,
            MetricsInterval: LBConfig.METRICS_INTERVAL
        };

        socket.write(Buffer.from(JSON.stringify(response)));
        
        console.log(`Registered mediation server: ${serverID} at ${serverInfo.address}:${serverInfo.port}`);
    }

    handleHeartbeat(message, socket) {
        const serverID = message.ServerID;
        
        if (!serverID) {
            console.log('Heartbeat without ServerID');
            return;
        }

        const updated = this.registry.updateHeartbeat(serverID);
        
        if (!updated) {
            console.log(`Heartbeat from unknown server: ${serverID}`);
        }
    }

    handleMetricsReport(message, socket) {
        const serverID = message.ServerID;
        
        if (!serverID) {
            console.log('Metrics report without ServerID');
            return;
        }

        const metrics = {
            activeConnections: message.ActiveConnections || 0,
            totalConnections: message.TotalConnections || 0,
            successfulConnections: message.SuccessfulConnections || 0,
            failedConnections: message.FailedConnections || 0,
            cpuUsage: message.CPUUsage || 0,
            memoryUsage: message.MemoryUsage || 0
        };

        const updated = this.registry.updateMetrics(serverID, metrics);
        
        if (!updated) {
            console.log(`Metrics from unknown server: ${serverID}`);
        } else {
            console.log(`Metrics from ${serverID}: ${metrics.activeConnections} active connections`);
        }
    }

    handleServerShutdown(message, socket) {
        const serverID = message.ServerID;
        
        if (!serverID) {
            console.log('Shutdown message without ServerID');
            return;
        }

        console.log(`Server ${serverID} is shutting down gracefully`);
        this.registry.removeServer(serverID);

        // Acknowledge shutdown
        const response = {
            ID: LBMessageTypes.RegistrationAck,
            Success: true,
            Message: 'Shutdown acknowledged'
        };

        socket.write(Buffer.from(JSON.stringify(response)));
    }

    handleGetAvailableServer(message, socket) {
        const strategy = message.Strategy || LBConfig.DEFAULT_STRATEGY;
        const region = message.Region || null;

        const selectedServer = this.registry.selectServer(strategy, region);

        if (selectedServer) {
            const response = {
                ID: LBMessageTypes.ServerAssignment,
                ServerID: selectedServer.serverID,
                Address: selectedServer.address,
                TCPPort: selectedServer.tcpPort,
                UDPPort: selectedServer.udpPort,
                Name: selectedServer.name,
                Region: selectedServer.region
            };

            socket.write(Buffer.from(JSON.stringify(response)));
            console.log(`Assigned server ${selectedServer.serverID} to client`);
        } else {
            const response = {
                ID: LBMessageTypes.NoServersAvailable,
                Message: 'No healthy mediation servers available'
            };

            socket.write(Buffer.from(JSON.stringify(response)));
            console.log('No servers available for client request');
        }
    }

    generateServerID() {
        return `srv_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }

    broadcastToAllServers(message) {
        const servers = this.registry.getAllServers();
        const messageBuffer = Buffer.from(JSON.stringify(message));
        
        for (const server of servers) {
            try {
                if (server.socket && !server.socket.destroyed) {
                    server.socket.write(messageBuffer);
                }
            } catch (error) {
                console.error(`Error broadcasting to server ${server.serverID}:`, error);
            }
        }
    }

    sendHealthCheck(serverID) {
        const server = this.registry.getServerByID(serverID);
        
        if (server && server.socket && !server.socket.destroyed) {
            const message = {
                ID: LBMessageTypes.HealthCheckRequest,
                Timestamp: Date.now()
            };

            server.socket.write(Buffer.from(JSON.stringify(message)));
        }
    }
}

module.exports = LoadBalancerMessageHandler;
