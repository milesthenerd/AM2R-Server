/// nat_cleanup_tunnel(connection_id)
// Cleans up a specific client tunnel
// connection_id: The tunnel's connection ID

var conn_id = argument0;

if (!ds_map_exists(nat_client_tunnels, conn_id)) {
    exit;
}

var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
if (ds_exists(tunnel, ds_type_map)) {
    // Close the TCP socket
    var sock = ds_map_find_value(tunnel, "socket");
    if (is_real(sock) && sock != -1) {
        network_destroy(sock);
    }

    // Destroy the tunnel map
    ds_map_destroy(tunnel);
}

// Remove from tunnels map
ds_map_delete(nat_client_tunnels, conn_id);

show_debug_message("NAT Server: Cleaned up tunnel " + string(conn_id));
