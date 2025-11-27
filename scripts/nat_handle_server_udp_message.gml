/// nat_handle_server_udp_message(buffer, sender_ip, sender_port, receiving_socket)
// Handles incoming UDP messages that might be hole punch packets
// Call this from Async Networking event for UDP messages
// receiving_socket: The socket that received this packet (to detect random socket success)
// Returns true if it was a NAT message, false otherwise

var buf = argument0;
var sender_ip = argument1;
var sender_port = argument2;
var receiving_socket = argument3;

// Check if we have any tunnels in hole punching state
var found_punching = false;
var conn_id = ds_map_find_first(nat_client_tunnels);
while (!is_undefined(conn_id)) {
    var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
    if (ds_exists(tunnel, ds_type_map)) {
        var state = ds_map_find_value(tunnel, "state");
        if (state == NAT_STATE_PUNCHING) {
            found_punching = true;
            break;
        }
    }
    conn_id = ds_map_find_next(nat_client_tunnels, conn_id);
}

if (!found_punching) {
    return false;
}

// Try to read as text to see if it's a JSON NAT message
buffer_seek(buf, buffer_seek_start, 0);
var data = buffer_read(buf, buffer_text);

// Check if it starts with { (JSON)
if (string_char_at(data, 1) != "{") {
    return false;  // Not a JSON NAT message, quietly return
}

// Try to parse as NAT message
var msg = json_parse_nat_message(data);
if (msg == noone) {
    return false;
}

var msg_id = ds_map_find_value(msg, "ID");
ds_map_destroy(msg);

if (is_undefined(msg_id)) {
    return false;
}

// Check if it's a hole punch attempt
if (msg_id == MSG_HOLE_PUNCH_ATTEMPT) {
    // Find the tunnel that matches this sender
    conn_id = ds_map_find_first(nat_client_tunnels);
    while (!is_undefined(conn_id)) {
        var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
        if (ds_exists(tunnel, ds_type_map)) {
            var state = ds_map_find_value(tunnel, "state");
            var peer_ip = ds_map_find_value(tunnel, "peer_ip");

            if (state == NAT_STATE_PUNCHING && sender_ip == peer_ip) {
                var received = ds_map_find_value(tunnel, "hole_punch_received");
                received++;
                ds_map_replace(tunnel, "hole_punch_received", received);

                // Update peer port if different (NAT may have assigned different port)
                // But only during initial hole punching, not after connection is confirmed
                var expected_port = ds_map_find_value(tunnel, "peer_port");
                var confirmed = ds_map_find_value(tunnel, "confirmed");
                if (is_undefined(confirmed)) confirmed = false;

                if (sender_port != expected_port && !confirmed) {
                    ds_map_replace(tunnel, "peer_port", sender_port);
                }

                // If we're symmetric and received on one of our random sockets, replace main socket
                if (nat_type == NAT_TYPE_SYMMETRIC && receiving_socket != udp_socket) {
                    // Check if this is one of our random sockets
                    var socket_index = ds_list_find_index(nat_random_sockets, receiving_socket);
                    if (socket_index >= 0) {
                        // Destroy old main socket
                        network_destroy(udp_socket);

                        // Replace with successful random socket
                        udp_socket = receiving_socket;

                        // Remove from random sockets list
                        ds_list_delete(nat_random_sockets, socket_index);

                        // Clean up remaining random sockets
                        for (var i = ds_list_size(nat_random_sockets) - 1; i >= 0; i--) {
                            var sock = ds_list_find_value(nat_random_sockets, i);
                            network_destroy(sock);
                        }
                        ds_list_clear(nat_random_sockets);
                    }
                }

                return true;
            }
        }
        conn_id = ds_map_find_next(nat_client_tunnels, conn_id);
    }
}

return false;
