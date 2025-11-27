// Load Balancer Message Types
const LBMessageTypes = {
    // Server -> Load Balancer
    MediationServerRegister: 100,
    MediationServerHeartbeat: 101,
    MediationServerMetrics: 102,
    MediationServerShutdown: 103,
    
    // Load Balancer -> Server
    RegistrationAck: 110,
    HealthCheckRequest: 111,
    
    // Client -> Load Balancer
    GetAvailableServer: 120,
    
    // Load Balancer -> Client
    ServerAssignment: 121,
    NoServersAvailable: 122
};

// Mediation Server Status
const MediationServerStatus = {
    Healthy: 0,
    Degraded: 1,
    Unhealthy: 2,
    Offline: 3
};

// Load Balancing Strategies
const LoadBalancingStrategy = {
    RoundRobin: 0,
    LeastConnections: 1,
    LeastLoad: 2,
    Random: 3
};

// Load Balancer Configuration
const LBConfig = {
    TCP_PORT: 6500, // Load balancer listens on a different port
    BIND_ADDRESS: "0.0.0.0",
    
    // Health check settings
    HEARTBEAT_INTERVAL: 10000, // 10 seconds - servers should send heartbeat
    HEARTBEAT_TIMEOUT: 30000, // 30 seconds - mark unhealthy if no heartbeat
    HEALTH_CHECK_INTERVAL: 5000, // 5 seconds - how often to check server health
    
    // Server removal settings
    OFFLINE_TIMEOUT: 60000, // 60 seconds - remove server after this time offline
    
    // Load balancing
    DEFAULT_STRATEGY: LoadBalancingStrategy.LeastConnections,
    
    // Metrics
    METRICS_INTERVAL: 30000 // 30 seconds - servers should report metrics
};

module.exports = {
    LBMessageTypes,
    MediationServerStatus,
    LoadBalancingStrategy,
    LBConfig
};
