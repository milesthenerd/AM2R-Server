const { MediationServerStatus, LoadBalancingStrategy, LBConfig } = require('./load-balancer-constants');

class MediationServerRegistry {
    constructor() {
        this.servers = new Map(); // serverID -> server info
        this.lastRoundRobinIndex = 0;
    }

    registerServer(serverID, serverInfo) {
        const existingServer = this.servers.get(serverID);
        
        if (existingServer) {
            // Server is re-registering (reconnect)
            console.log(`Server ${serverID} re-registered (${serverInfo.address}:${serverInfo.port})`);
            existingServer.address = serverInfo.address;
            existingServer.port = serverInfo.port;
            existingServer.socket = serverInfo.socket;
            existingServer.status = MediationServerStatus.Healthy;
            existingServer.lastHeartbeat = Date.now();
            existingServer.reconnectCount = (existingServer.reconnectCount || 0) + 1;
        } else {
            // New server registration
            const server = {
                serverID,
                address: serverInfo.address,
                port: serverInfo.port,
                tcpPort: serverInfo.tcpPort || 6510,
                udpPort: serverInfo.udpPort || 6510,
                socket: serverInfo.socket,
                name: serverInfo.name || `MediationServer-${serverID}`,
                
                // Health tracking
                status: MediationServerStatus.Healthy,
                lastHeartbeat: Date.now(),
                registrationTime: Date.now(),
                reconnectCount: 0,
                
                // Load metrics
                activeConnections: 0,
                totalConnections: 0,
                successfulConnections: 0,
                failedConnections: 0,
                cpuUsage: 0,
                memoryUsage: 0,
                
                // Capacity
                maxConnections: serverInfo.maxConnections || 1000,
                
                // Region/location (for future geo-routing)
                region: serverInfo.region || 'default'
            };
            
            this.servers.set(serverID, server);
            console.log(`New server registered: ${serverID} (${server.address}:${server.port})`);
        }
        
        return this.servers.get(serverID);
    }

    updateHeartbeat(serverID) {
        const server = this.servers.get(serverID);
        if (server) {
            server.lastHeartbeat = Date.now();
            if (server.status === MediationServerStatus.Unhealthy) {
                server.status = MediationServerStatus.Healthy;
                console.log(`Server ${serverID} recovered to healthy state`);
            }
            return true;
        }
        return false;
    }

    updateMetrics(serverID, metrics) {
        const server = this.servers.get(serverID);
        if (server) {
            server.activeConnections = metrics.activeConnections || 0;
            server.totalConnections = metrics.totalConnections || server.totalConnections;
            server.successfulConnections = metrics.successfulConnections || server.successfulConnections;
            server.failedConnections = metrics.failedConnections || server.failedConnections;
            server.cpuUsage = metrics.cpuUsage || 0;
            server.memoryUsage = metrics.memoryUsage || 0;
            
            // Update status based on load
            if (server.activeConnections >= server.maxConnections * 0.9) {
                server.status = MediationServerStatus.Degraded;
            } else if (server.status === MediationServerStatus.Degraded) {
                server.status = MediationServerStatus.Healthy;
            }
            
            return true;
        }
        return false;
    }

    removeServer(serverID) {
        const server = this.servers.get(serverID);
        if (server) {
            console.log(`Removing server ${serverID} (${server.address}:${server.port})`);
            this.servers.delete(serverID);
            return true;
        }
        return false;
    }

    checkServerHealth() {
        const now = Date.now();
        const serversToRemove = [];
        
        for (const [serverID, server] of this.servers.entries()) {
            const timeSinceHeartbeat = now - server.lastHeartbeat;
            
            if (timeSinceHeartbeat > LBConfig.OFFLINE_TIMEOUT) {
                // Server hasn't responded in a long time, remove it
                server.status = MediationServerStatus.Offline;
                serversToRemove.push(serverID);
            } else if (timeSinceHeartbeat > LBConfig.HEARTBEAT_TIMEOUT) {
                // Server is not responding, mark as unhealthy
                if (server.status !== MediationServerStatus.Unhealthy) {
                    server.status = MediationServerStatus.Unhealthy;
                    console.log(`Server ${serverID} marked as unhealthy (no heartbeat for ${timeSinceHeartbeat}ms)`);
                }
            }
        }
        
        // Remove offline servers
        for (const serverID of serversToRemove) {
            this.removeServer(serverID);
        }
    }

    getHealthyServers() {
        return Array.from(this.servers.values()).filter(
            server => server.status === MediationServerStatus.Healthy
        );
    }

    getAllServers() {
        return Array.from(this.servers.values());
    }

    getServerByID(serverID) {
        return this.servers.get(serverID);
    }

    selectServer(strategy = LoadBalancingStrategy.LeastConnections, region = null) {
        let availableServers = this.getHealthyServers();
        
        // Filter by region if specified
        if (region) {
            const regionServers = availableServers.filter(s => s.region === region);
            if (regionServers.length > 0) {
                availableServers = regionServers;
            }
        }
        
        if (availableServers.length === 0) {
            return null;
        }
        
        switch (strategy) {
            case LoadBalancingStrategy.RoundRobin:
                return this.selectRoundRobin(availableServers);
            
            case LoadBalancingStrategy.LeastConnections:
                return this.selectLeastConnections(availableServers);
            
            case LoadBalancingStrategy.LeastLoad:
                return this.selectLeastLoad(availableServers);
            
            case LoadBalancingStrategy.Random:
                return this.selectRandom(availableServers);
            
            default:
                return this.selectLeastConnections(availableServers);
        }
    }

    selectRoundRobin(servers) {
        if (servers.length === 0) return null;
        
        this.lastRoundRobinIndex = (this.lastRoundRobinIndex + 1) % servers.length;
        return servers[this.lastRoundRobinIndex];
    }

    selectLeastConnections(servers) {
        if (servers.length === 0) return null;
        
        return servers.reduce((least, server) => {
            if (!least || server.activeConnections < least.activeConnections) {
                return server;
            }
            return least;
        }, null);
    }

    selectLeastLoad(servers) {
        if (servers.length === 0) return null;
        
        return servers.reduce((least, server) => {
            const serverLoad = this.calculateServerLoad(server);
            if (!least) return server;
            
            const leastLoad = this.calculateServerLoad(least);
            return serverLoad < leastLoad ? server : least;
        }, null);
    }

    selectRandom(servers) {
        if (servers.length === 0) return null;
        
        const randomIndex = Math.floor(Math.random() * servers.length);
        return servers[randomIndex];
    }

    calculateServerLoad(server) {
        // Calculate a load score based on multiple factors
        const connectionLoad = server.activeConnections / server.maxConnections;
        const cpuLoad = server.cpuUsage / 100;
        const memoryLoad = server.memoryUsage / 100;
        
        // Weighted average (connections have highest weight)
        return (connectionLoad * 0.6) + (cpuLoad * 0.2) + (memoryLoad * 0.2);
    }

    getStatistics() {
        const servers = this.getAllServers();
        const healthy = servers.filter(s => s.status === MediationServerStatus.Healthy).length;
        const degraded = servers.filter(s => s.status === MediationServerStatus.Degraded).length;
        const unhealthy = servers.filter(s => s.status === MediationServerStatus.Unhealthy).length;
        
        const totalConnections = servers.reduce((sum, s) => sum + s.activeConnections, 0);
        const totalCapacity = servers.reduce((sum, s) => sum + s.maxConnections, 0);
        
        return {
            totalServers: servers.length,
            healthyServers: healthy,
            degradedServers: degraded,
            unhealthyServers: unhealthy,
            totalActiveConnections: totalConnections,
            totalCapacity,
            utilizationPercent: totalCapacity > 0 ? (totalConnections / totalCapacity * 100).toFixed(2) : 0
        };
    }
}

module.exports = MediationServerRegistry;
