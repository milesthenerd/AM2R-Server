/// nat_init_server()
// Initializes NAT traversal variables for server
// Call this in oServer Create event AFTER config is loaded

// Main mediation server connection (for registration and receiving connection requests)
mediation_socket = -1;
mediation_connected = false;

// NAT state for main server registration
nat_state = NAT_STATE_DISCONNECTED;
nat_type = NAT_TYPE_UNKNOWN;

// Server ID (random string for mediation server)
nat_server_id = string(floor(random(999999)));

// TCP message buffer for partial messages
nat_tcp_buffer = "";

// Per-client tunnel management
// Maps connection_id -> tunnel data (socket, state, peer info, etc.)
nat_client_tunnels = ds_map_create();

// Hole punching settings
NAT_HOLE_PUNCH_THRESHOLD = 5;
NAT_HOLE_PUNCH_INTERVAL = 10;  // Send every 10 steps (~100ms)

// Birthday paradox sockets for symmetric NAT
nat_random_sockets = ds_list_create();  // List of random UDP sockets
nat_random_sockets_created = false;
