/// nat_handle_tunnel_connected(tunnel_socket)
// Handles when a per-client tunnel connects to mediation server
// tunnel_socket: The TCP socket that just connected

var tunnel_socket = argument0;

// Find the tunnel that uses this socket
var conn_id = ds_map_find_first(nat_client_tunnels);
while (!is_undefined(conn_id)) {
    var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
    if (ds_exists(tunnel, ds_type_map)) {
        var sock = ds_map_find_value(tunnel, "socket");
        if (sock == tunnel_socket) {
            // Found the tunnel - start NAT detection for it
            ds_map_replace(tunnel, "state", NAT_STATE_NAT_DETECTING);

            var client_id = ds_map_find_value(tunnel, "client_id");

            // Send NAT type request with connection ID so mediation server knows this is for a specific connection
            var params = ds_map_create();
            ds_map_add(params, "LocalPort", udp_socket);
            ds_map_add(params, "ClientID", client_id);
            ds_map_add(params, "ConnectionID", conn_id);
            nat_send_tcp_message(tunnel_socket, MSG_NAT_TYPE_REQUEST, params);
            ds_map_destroy(params);

            show_debug_message("NAT Server: Tunnel " + string(conn_id) + " connected, requesting NAT type");
            exit;
        }
    }
    conn_id = ds_map_find_next(nat_client_tunnels, conn_id);
}

show_debug_message("NAT Server: Could not find tunnel for socket");
