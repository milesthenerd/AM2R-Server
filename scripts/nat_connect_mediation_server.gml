/// nat_connect_mediation_server()
// Connects to mediation server and registers as a game server
// Call this when server starts with NAT traversal enabled

if (!use_nat_traversal) {
    show_debug_message("NAT traversal not enabled");
    exit;
}

if (mediation_socket != -1) {
    show_debug_message("Already connected to mediation server");
    exit;
}

// Create TCP connection to mediation server
mediation_socket = network_create_socket(network_socket_tcp);
var result = network_connect_raw(mediation_socket, mediation_server_ip, mediation_server_port);

if (result >= 0) {
    nat_state = NAT_STATE_CONNECTING;
    show_debug_message("NAT Server: Connecting to mediation server at " + mediation_server_ip + ":" + string(mediation_server_port));
} else {
    show_debug_message("NAT Server: Failed to connect to mediation server (result: " + string(result) + ")");
    network_destroy(mediation_socket);
    mediation_socket = -1;
    nat_state = NAT_STATE_ERROR;
}
