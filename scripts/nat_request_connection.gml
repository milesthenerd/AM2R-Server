/// nat_request_connection(server_ip_address)
// Requests connection to a game server via NAT traversal
// server_ip_address: The server's IP to connect to

var server_ip_address = argument0;

if (!use_nat_traversal || mediation_socket == -1) {
    show_debug_message("Cannot request connection - not connected to mediation");
    return false;
}

if (nat_state != NAT_STATE_WAITING) {
    show_debug_message("Cannot request connection - NAT detection not complete. Current state: " + string(nat_state));
    return false;
}

// Send ConnectionRequest to mediation server
var params = ds_map_create();
ds_map_add(params, "EndpointString", server_ip_address + ":0");
ds_map_add(params, "NATType", nat_type);
ds_map_add(params, "ClientID", nat_client_id);

nat_send_tcp_message(mediation_socket, MSG_CONNECTION_REQUEST, params);
ds_map_destroy(params);

show_debug_message("Requested connection to server: " + server_ip_address);
nat_state = NAT_STATE_WAITING;  // Wait for ConnectionBegin

return true;
