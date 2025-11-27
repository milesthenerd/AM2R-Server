/// nat_cleanup_server()
// Cleans up all NAT traversal resources for server
// Call this in oServer Destroy event

// Clean up all client tunnels (check if map exists first)
if (ds_exists(nat_client_tunnels, ds_type_map)) {
    var conn_id = ds_map_find_first(nat_client_tunnels);
    while (!is_undefined(conn_id)) {
        var next_id = ds_map_find_next(nat_client_tunnels, conn_id);
        nat_cleanup_tunnel(conn_id);
        conn_id = next_id;
    }
    // Destroy the tunnels map itself
    ds_map_destroy(nat_client_tunnels);
}

// Close main mediation socket
if (mediation_socket != -1) {
    network_destroy(mediation_socket);
    mediation_socket = -1;
}

// Clean up random sockets for symmetric NAT
if (ds_exists(nat_random_sockets, ds_type_list)) {
    for (var i = ds_list_size(nat_random_sockets) - 1; i >= 0; i--) {
        var sock = ds_list_find_value(nat_random_sockets, i);
        network_destroy(sock);
    }
    ds_list_destroy(nat_random_sockets);
}

mediation_connected = false;
nat_state = NAT_STATE_DISCONNECTED;
nat_type = NAT_TYPE_UNKNOWN;

show_debug_message("NAT Server: Cleaned up all NAT resources");
