/// nat_find_tunnel_by_socket(socket)
// Finds a tunnel data map by its TCP socket
// Returns the tunnel ds_map or noone if not found

var search_socket = argument0;

// Don't search if it's the main mediation socket
if (search_socket == mediation_socket) {
    return noone;
}

var conn_id = ds_map_find_first(nat_client_tunnels);
while (!is_undefined(conn_id)) {
    var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
    if (ds_exists(tunnel, ds_type_map)) {
        var sock = ds_map_find_value(tunnel, "socket");
        if (sock == search_socket) {
            return tunnel;
        }
    }
    conn_id = ds_map_find_next(nat_client_tunnels, conn_id);
}

return noone;
