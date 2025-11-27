const { Buffer } = require('buffer');
const { NATTypes, MessageTypes, StatusTypes, Config } = require('./constants');

class ConnectionManager {
    constructor() {
        this.sockets = [];
        this.udpConnectionInfo = [];
        this.currentConnectionPairs = {};
        this.connectionId = 1;
    }

    addSocket(socket, remoteAddress, remotePort, timeout) {
        const socketInfo = {
            socket,
            ip: remoteAddress,
            tcpPort: remotePort,
            timeout,
            natType: NATTypes.Unknown,
            localPort: 0,
            externalPortOne: 0,
            externalPortTwo: 0,
            clientID: Math.random().toString(),
            isServer: false  // Track if this is a registered server
        };
        this.sockets.push(socketInfo);
        return socketInfo;
    }

    removeSocket(socket, clientID = null) {
        let index = -1;
        if (clientID) {
            index = this.sockets.findIndex(s => s.clientID === clientID);
        } else {
            index = this.sockets.findIndex(s => s.socket === socket);
        }

        if (index !== -1) {
            const socketInfo = this.sockets[index];
            // Clean up any pending connections for this client
            this.cleanupPendingConnections(socketInfo);
            // Remove associated UDP info
            this.removeUDPInfo(socketInfo.ip);
            this.sockets.splice(index, 1);
            console.log(`Removed client ${socketInfo.clientID} (${socketInfo.ip}:${socketInfo.tcpPort})`);
        }
    }

    cleanupPendingConnections(socketInfo) {
        // Find any connection pairs involving this socket and notify the other party
        Object.entries(this.currentConnectionPairs).forEach(([id, pair]) => {
            if (pair.server_info === socketInfo.ip || pair.client_info === socketInfo.ip) {
                // Find the other party in the connection
                const otherSocket = this.sockets.find(s =>
                    (pair.server_info === socketInfo.ip && s.ip === pair.client_info) ||
                    (pair.client_info === socketInfo.ip && s.ip === pair.server_info)
                );

                if (otherSocket) {
                    // Notify the other party that the connection attempt failed
                    otherSocket.socket.write(Buffer.from(JSON.stringify({
                        ID: MessageTypes.ConnectionTimeout,
                        Message: "Peer disconnected"
                    })));
                }

                // Free up the UDP connection status for both peers
                this.udpConnectionInfo.forEach((info) => {
                    if (pair.server_info === info.ip || pair.client_info === info.ip) {
                        info.status.type = StatusTypes.Free;
                    }
                });

                // Clean up the connection pair
                delete this.currentConnectionPairs[id];
            }
        });
    }

    addUDPInfo(address, port) {
        const existing = this.udpConnectionInfo.find(info => info.ip === address);
        if (existing) {
            // Update the port to the most recent one observed
            existing.port = port;
        } else {
            this.udpConnectionInfo.push({
                ip: address,
                port,
                status: {
                    id: this.connectionId,
                    type: StatusTypes.Free
                }
            });
        }
    }

    removeUDPInfo(ip) {
        const index = this.udpConnectionInfo.findIndex(info => info.ip === ip);
        if (index !== -1) {
            this.udpConnectionInfo.splice(index, 1);
        }
    }

    updateTimeout(address) {
        const socket = this.sockets.find(s => s.ip === address);
        if (socket) {
            socket.timeout = Config.DEFAULT_TIMEOUT;
        }
    }

    processTimeouts() {
        for (let i = this.sockets.length - 1; i >= 0; i--) {
            const socket = this.sockets[i];
            if (socket.natType !== NATTypes.Unknown) {
                socket.timeout--;
                if (socket.timeout <= 0) {
                    console.log(`Timeout: Removing ${socket.isServer ? 'server' : 'client'} ${socket.ip}:${socket.tcpPort} (NAT type: ${socket.natType})`);
                    this.removeSocket(socket.socket);
                }
            }
        }
    }

    checkNATType(socket, localPort, externalPortOne, externalPortTwo) {
        let natType = NATTypes.Unknown;

        if (externalPortOne !== 0 && externalPortTwo !== 0) {
            if (localPort === externalPortOne && localPort === externalPortTwo) {
                natType = NATTypes.DirectMapping;
            } else if (externalPortOne === externalPortTwo) {
                natType = NATTypes.Restricted;
            } else {
                natType = NATTypes.Symmetric;
            }

            socket.write(Buffer.from(JSON.stringify({
                ID: MessageTypes.NATTypeResponse,
                NATType: natType,
            })));

            // Store NAT type on socket info
            const socketInfo = this.sockets.find(s => s.socket === socket);
            if (socketInfo) {
                socketInfo.natType = natType;

                // Check if this socket is for a specific connection (server-side per-client tunnel)
                if (socketInfo.forConnectionID) {
                    const connectionId = socketInfo.forConnectionID;

                    // Trigger callback to send ConnectionBegin to waiting client
                    if (this.onServerTunnelReady) {
                        this.onServerTunnelReady(connectionId, socketInfo, natType);
                    }
                }
            }
        }

        return natType;
    }

    findSocketByAddress(address) {
        return this.sockets.find(s => s.ip === address);
    }

    updateNATTestPort(clientID, port, isFirstPort = true) {
        const socket = this.sockets.find(s => s.clientID === clientID);
        if (socket) {
            if (isFirstPort) {
                socket.externalPortOne = port;
            } else {
                socket.externalPortTwo = port;
            }
            return socket;
        }
        return null;
    }
}

module.exports = ConnectionManager;