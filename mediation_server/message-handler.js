const { MessageTypes, StatusTypes, Config } = require('./constants');
const { Buffer } = require('buffer');

class MessageHandler {
    constructor(connectionManager) {
        this.connectionManager = connectionManager;

        // Set up callback for when server tunnel completes NAT detection
        this.connectionManager.onServerTunnelReady = (connectionId, socketInfo, natType) => {
            this.handleServerTunnelReady(connectionId, socketInfo, natType);
        };
    }

    handleTCPMessage(message, socket) {
        if (!message) return;

        switch (message.ID) {
            case MessageTypes.ServerRegister:
                this.handleServerRegister(message, socket);
                break;
            case MessageTypes.NATTypeRequest:
                this.handleNATTypeRequest(message, socket);
                break;
            case MessageTypes.ConnectionRequest:
                this.handleConnectionRequest(message, socket);
                break;
            case MessageTypes.ReceivedPeer:
                this.handleReceivedPeer(message);
                break;
            case MessageTypes.ConnectionTimeout:
                this.handleConnectionTimeout(message.ConnectionID);
                break;
            case MessageTypes.KeepAlive:
                this.handleKeepAlive(socket);
                break;
        }
    }

    handleKeepAlive(socket) {
        // Reset timeout for this connection
        const socketInfo = this.connectionManager.sockets.find(s => s.socket === socket);
        if (socketInfo) {
            socketInfo.timeout = require('./constants').Config.DEFAULT_TIMEOUT;
            console.log(`KeepAlive from ${socketInfo.ip}:${socketInfo.tcpPort} - timeout reset to ${socketInfo.timeout}`);

            // Send keepalive response back to client
            socket.write(Buffer.from(JSON.stringify({
                ID: MessageTypes.KeepAlive
            })));
        }
    }

    handleServerRegister(message, socket) {
        const socketInfo = this.connectionManager.sockets.find(s => s.socket === socket);
        if (socketInfo) {
            socketInfo.isServer = true;
            console.log(`Registered server: ${socketInfo.ip}:${socketInfo.tcpPort}`);
        }
    }

    handleNATTypeRequest(message, socket) {
        const socketInfo = this.connectionManager.sockets.find(s => s.socket === socket);
        if (socketInfo) {
            socketInfo.localPort = message.LocalPort;
            socketInfo.clientID = message.ClientID;
        }

        // Check if this is a per-connection tunnel (server-side tunnel for specific client)
        if (message.ConnectionID) {
            // Mark this socket as being for a specific connection
            socketInfo.forConnectionID = message.ConnectionID;
        }

        socket.write(Buffer.from(JSON.stringify({
            ID: MessageTypes.NATTestBegin,
            NATTestPortOne: Config.NAT_TEST_PORT_ONE,
            NATTestPortTwo: Config.NAT_TEST_PORT_TWO
        })));
    }

    handleConnectionRequest(message, socket) {
        if (!message.hasOwnProperty('NATType')) return;

        const requestedIp = message.EndpointString;
        const clientSocketInfo = this.connectionManager.sockets.find(s => s.socket === socket);

        console.log(`ConnectionRequest from ${clientSocketInfo.ip}:${clientSocketInfo.tcpPort} for server: ${requestedIp}`);
        console.log(`Available servers: ${this.connectionManager.sockets.filter(s => s.isServer).map(s => `${s.ip}:${s.tcpPort}`).join(', ')}`);

        // Store client's NAT type from the ConnectionRequest message
        if (clientSocketInfo && message.NATType !== undefined) {
            clientSocketInfo.natType = message.NATType;
        }

        // Try to find server by IP match first
        let serverSocket = this.connectionManager.sockets.find(s => {
            const matches = requestedIp.includes(s.ip) && s.isServer;
            console.log(`Checking server ${s.ip}:${s.tcpPort}, isServer=${s.isServer}, requestedIp.includes(s.ip)=${requestedIp.includes(s.ip)}, match=${matches}`);
            return matches;
        });

        // If no match by IP, try matching if client and server are from same public IP
        if (!serverSocket) {
            serverSocket = this.connectionManager.sockets.find(s =>
                s.isServer && s.ip === clientSocketInfo.ip
            );
            if (serverSocket) {
                console.log(`Matched server by same public IP: ${serverSocket.ip}`);
            }
        }

        // If still no match, just use the first available server (for testing)
        if (!serverSocket) {
            serverSocket = this.connectionManager.sockets.find(s => s.isServer);
            if (serverSocket) {
                console.log(`Using first available server: ${serverSocket.ip}:${serverSocket.tcpPort}`);
            }
        }

        if (!serverSocket) {
            console.log(`No server found for request from ${clientSocketInfo.ip}, requested: ${requestedIp}`);
            this.sendServerNotAvailable(socket);
            return;
        }

        // Generate connection ID
        const connectionId = this.connectionManager.connectionId++;

        // Get client UDP info
        console.log(`Looking for client UDP info, clientSocketInfo.ip=${clientSocketInfo.ip}`);
        console.log(`Available UDP info: ${this.connectionManager.udpConnectionInfo.map(i => `${i.ip}:${i.port}`).join(', ')}`);

        const clientUDPInfo = this.connectionManager.udpConnectionInfo.find(
            info => clientSocketInfo.ip.includes(info.ip)
        );

        if (!clientUDPInfo) {
            console.log(`No UDP info found for client ${clientSocketInfo.ip}`);
            this.sendServerNotAvailable(socket);
            return;
        }

        const clientEndpoint = `${clientSocketInfo.ip}:${clientUDPInfo.port}`;

        // Store the connection pair
        this.connectionManager.currentConnectionPairs[connectionId] = {
            server_info: serverSocket.ip,
            client_info: clientSocketInfo.ip,
            server_connected: false,
            client_connected: false,
            server_clientID: serverSocket.clientID,
            client_clientID: clientSocketInfo.clientID,
            connection_start_time: Date.now()
        };

        console.log(`New connection ${connectionId}: ${clientSocketInfo.ip} -> ${serverSocket.ip}`);

        // Forward the connection request to server's control connection
        const serverMessage = {
            ID: MessageTypes.ConnectionRequest,
            EndpointString: clientEndpoint,
            NATType: message.NATType,  // Client's NAT type
            ConnectionID: connectionId,
            ClientID: clientSocketInfo.clientID
        };

        serverSocket.socket.write(Buffer.from(JSON.stringify(serverMessage)));

        // Get server UDP info - use the first UDP info from the server IP
        // The server only has one UDP socket that it reuses
        const serverUDPInfo = this.connectionManager.udpConnectionInfo.find(
            info => serverSocket.ip.includes(info.ip)
        );

        if (!serverUDPInfo) {
            console.log(`No UDP info found for server ${serverSocket.ip}`);
            this.sendServerNotAvailable(socket);
            return;
        }

        const serverEndpoint = `${serverSocket.ip}:${serverUDPInfo.port}`;

        // Send ConnectionBegin to both client and server immediately
        // Client message - tell them about the server endpoint
        const clientMessage = {
            ID: MessageTypes.ConnectionBegin,
            EndpointString: serverEndpoint,
            NATType: serverSocket.natType,  // Server's NAT type
            ConnectionID: connectionId,
            IsServer: false
        };
        socket.write(Buffer.from(JSON.stringify(clientMessage)));
        console.log(`Sending ConnectionBegin to client`);

        // Server message - tell them about the client endpoint
        const serverBeginMessage = {
            ID: MessageTypes.ConnectionBegin,
            EndpointString: clientEndpoint,
            NATType: message.NATType,  // Client's NAT type
            ConnectionID: connectionId,
            IsServer: true
        };
        serverSocket.socket.write(Buffer.from(JSON.stringify(serverBeginMessage)));
        console.log(`Sending ConnectionBegin to server tunnel`);

        // Set up connection timeout
        setTimeout(() => {
            const pair = this.connectionManager.currentConnectionPairs[connectionId];
            if (pair && (!pair.server_connected || !pair.client_connected)) {
                console.log(`Connection ${connectionId} timed out`);
                this.handleConnectionTimeout(connectionId);
            }
        }, 30000); // 30 second timeout
    }

    handleServerTunnelReady(connectionId, serverSocketInfo, natType) {
        const pair = this.connectionManager.currentConnectionPairs[connectionId];
        if (!pair) {
            return;
        }

        // Update the connection pair with the actual per-client tunnel's clientID
        // (not the TunnelManager's clientID that was stored initially)
        pair.server_clientID = serverSocketInfo.clientID;

        // Get server tunnel's UDP info - use the most recent UDP info from this IP
        // Since the server tunnel just completed NAT detection, its UDP port should be the latest
        const allServerUDPInfo = this.connectionManager.udpConnectionInfo.filter(
            info => serverSocketInfo.ip.includes(info.ip)
        );

        if (allServerUDPInfo.length === 0) {
            return;
        }

        // Get the most recently added (last) entry for this IP - that's the server tunnel's port
        const serverUDPInfo = allServerUDPInfo[allServerUDPInfo.length - 1];
        const serverEndpoint = `${serverSocketInfo.ip}:${serverUDPInfo.port}`;

        // Find the waiting client
        const clientSocketInfo = this.connectionManager.sockets.find(s => s.clientID === pair.client_clientID);
        if (!clientSocketInfo) {
            return;
        }

        // Get client's UDP info
        const clientUDPInfo = this.connectionManager.udpConnectionInfo.find(
            info => clientSocketInfo.ip.includes(info.ip)
        );

        if (!clientUDPInfo) {
            return;
        }

        const clientEndpoint = `${clientSocketInfo.ip}:${clientUDPInfo.port}`;

        // Get client's NAT type (should be stored from ConnectionRequest)
        const clientNatType = clientSocketInfo.natType !== undefined ? clientSocketInfo.natType : -1;

        if (clientNatType === -1) {
            console.log(`Warning: Client NAT type not available for connection ${connectionId}`);
        }

        // Send ConnectionBegin to client with server's tunnel endpoint
        const clientMessage = {
            ID: MessageTypes.ConnectionBegin,
            EndpointString: serverEndpoint,
            NATType: natType,  // Server tunnel's NAT type
            ConnectionID: connectionId,
            IsServer: false
        };

        console.log(`Sending ConnectionBegin to client`);
        clientSocketInfo.socket.write(Buffer.from(JSON.stringify(clientMessage)));

        // Also send ConnectionBegin to server tunnel with client's endpoint
        const serverMessage = {
            ID: MessageTypes.ConnectionBegin,
            EndpointString: clientEndpoint,
            NATType: clientNatType,  // Client's NAT type
            ConnectionID: connectionId,
            IsServer: true
        };

        console.log(`Sending ConnectionBegin to server tunnel`);
        serverSocketInfo.socket.write(Buffer.from(JSON.stringify(serverMessage)));
    }

    handleReceivedPeer(message) {
        const pair = this.connectionManager.currentConnectionPairs[message.ConnectionID];
        if (!pair) return;

        if (message.IsServer) {
            pair.server_connected = true;
        } else {
            pair.client_connected = true;
        }

        if (pair.server_connected && pair.client_connected) {
            this.completeConnection(message.ConnectionID);
        }
    }

    completeConnection(connectionId) {
        const pair = this.connectionManager.currentConnectionPairs[connectionId];

        // Notify both server and client - use clientID to find the correct socket
        // (not IP, since there may be multiple tunnels from same IP)
        const serverSocket = this.connectionManager.sockets.find(s => s.clientID === pair.server_clientID);
        const clientSocket = this.connectionManager.sockets.find(s => s.clientID === pair.client_clientID);

        console.log(`Completing connection ${connectionId}`);

        if (serverSocket) {
            serverSocket.socket.write(Buffer.from(JSON.stringify({
                ID: MessageTypes.ConnectionComplete
            })));
        }

        if (clientSocket) {
            clientSocket.socket.write(Buffer.from(JSON.stringify({
                ID: MessageTypes.ConnectionComplete
            })));
        }

        // Reset connection status
        this.connectionManager.udpConnectionInfo.forEach(info => {
            if (pair.server_info.includes(info.ip) || pair.client_info.includes(info.ip)) {
                info.status.type = StatusTypes.Free;
            }
        });
    }

    handleConnectionTimeout(connectionId) {
        const pair = this.connectionManager.currentConnectionPairs[connectionId];
        if (!pair) {
            console.log(`ConnectionTimeout for unknown connection ID: ${connectionId}`);
            return;
        }

        console.log(`Connection ${connectionId} timed out`);

        // Reset connection status for both server and client IPs
        this.connectionManager.udpConnectionInfo.forEach((info, index) => {
            if (pair.server_info.includes(info.ip) || pair.client_info.includes(info.ip)) {
                info.status.type = StatusTypes.Free;
            }
        });

        // Clean up the connection pair
        delete this.connectionManager.currentConnectionPairs[connectionId];
    }

    sendServerNotAvailable(socket) {
        socket.write(Buffer.from(JSON.stringify({
            ID: MessageTypes.ServerNotAvailable
        })));
    }

    getMessageTypeName(id) {
        return Object.keys(MessageTypes).find(key => MessageTypes[key] === id) || 'Unknown';
    }
}

module.exports = MessageHandler;