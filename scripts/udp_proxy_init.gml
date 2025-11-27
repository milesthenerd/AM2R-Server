/// udp_proxy_init(port, max_clients)
// Initialize UDP proxy system
// Returns the UDP socket ID

var port = argument0;
var max_clients = argument1;

// Create UDP socket for client connections
var udp_sock = network_create_socket_ext(network_socket_udp, port);

// Create internal TCP server on random port
var tcp_port = irandom_range(50000, 60000);
var tcp_serv = network_create_server(network_socket_tcp, tcp_port, max_clients);

// Initialize data structures
global.udp_proxy_socket = udp_sock;
global.udp_proxy_tcp_server = tcp_serv;
global.udp_proxy_tcp_port = tcp_port;
global.udp_proxy_clients = ds_map_create();  // "ip:port" -> client state
global.udp_proxy_tcp_to_udp = ds_map_create();  // TCP socket -> "ip:port"
global.udp_proxy_forward_buffer = buffer_create(65536, buffer_grow, 1);

// Timeouts
global.UDP_CLIENT_TIMEOUT = 30000;  // 30 seconds
global.TCP_CLIENT_TIMEOUT = 10000;  // 10 seconds

// Fragmentation settings
global.UDP_MAX_FRAGMENT_SIZE = 1200;
global.next_fragment_id = 0;

// Reliable UDP settings
global.next_sequence_number = 0;
global.RETRANSMIT_TIMEOUT = 200;
global.MAX_RETRANSMITS = 5;

return udp_sock;
