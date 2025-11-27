// NAT type enumeration
const NATTypes = {
    DirectMapping: 0,
    Restricted: 1,
    Symmetric: 2,
    Unknown: -1
};

// Message type enumeration
const MessageTypes = {
    Connected: 0,
    NATTypeRequest: 1,
    NATTestBegin: 2,
    NATTest: 3,
    NATTypeResponse: 4,
    KeepAlive: 5,
    ConnectionRequest: 6,
    ConnectionBegin: 7,
    ServerNotAvailable: 8,
    HolePunchAttempt: 9,
    NATTunnelData: 10,
    SymmetricHolePunchAttempt: 11,
    ConnectionComplete: 12,
    ReceivedPeer: 13,
    ConnectionTimeout: 14,
    PublicKeyRequest: 15,
    PublicKeyResponse: 16,
    SymmetricKeyRequest: 17,
    SymmetricKeyResponse: 18,
    SymmetricKeyConfirm: 19,
    WireGuardPublicKeyExchange: 20,
    WireGuardPublicKeyHash: 21,
    ServerRegister: 22
};

// Client status types
const StatusTypes = {
    Free: 0,
    Busy: 1
};

// Server configuration
const Config = {
    TCP_PORT: 7000,
    UDP_PORT: 7000,
    NAT_TEST_PORT_ONE: 7001,
    NAT_TEST_PORT_TWO: 7002,
    DEFAULT_TIMEOUT: 10, // seconds
    BIND_ADDRESS: "0.0.0.0"
};

module.exports = {
    NATTypes,
    MessageTypes,
    StatusTypes,
    Config
};