/// nat_handle_server_tcp_message(message_map, from_socket)
// Handles incoming TCP messages from mediation server for game server
// message_map: ds_map returned from json_parse_nat_message()
// from_socket: the TCP socket that received this message
// Call this from Async Networking event

var msg = argument0;
var from_socket = argument1;

if (!ds_exists(msg, ds_type_map)) {
    exit;
}

var msg_id = ds_map_find_value(msg, "ID");
if (is_undefined(msg_id)) {
    exit;
}

switch (msg_id) {
    case MSG_CONNECTED:
        // Connected to mediation server
        mediation_connected = true;
        nat_state = NAT_STATE_NAT_DETECTING;

        // Send NAT type request - use actual listening port, not socket ID
        var params = ds_map_create();
        ds_map_add(params, "LocalPort", port);  // 'port' is the server's listening port from settings
        ds_map_add(params, "ClientID", nat_server_id);
        nat_send_tcp_message(mediation_socket, MSG_NAT_TYPE_REQUEST, params);
        ds_map_destroy(params);
        break;

    case MSG_NAT_TEST_BEGIN:
        // Mediation server wants us to send UDP to test ports
        var test_port_one = ds_map_find_value(msg, "NATTestPortOne");
        var test_port_two = ds_map_find_value(msg, "NATTestPortTwo");

        if (!is_undefined(test_port_one) && !is_undefined(test_port_two)) {
            // Always use the main client ID for NAT tests
            var client_id = nat_server_id;

            // Send NAT test packets to both ports
            var test_params = ds_map_create();
            ds_map_add(test_params, "ClientID", client_id);
            var test_json = json_encode_nat_message(MSG_NAT_TEST, test_params);
            ds_map_destroy(test_params);

            var test_buf = buffer_create(string_length(test_json) + 1, buffer_fixed, 1);
            buffer_seek(test_buf, buffer_seek_start, 0);
            buffer_write(test_buf, buffer_text, test_json);

            network_send_udp_raw(udp_socket, mediation_server_ip, test_port_one, test_buf, buffer_tell(test_buf));
            network_send_udp_raw(udp_socket, mediation_server_ip, test_port_two, test_buf, buffer_tell(test_buf));

            buffer_delete(test_buf);
        }
        break;

    case MSG_NAT_TYPE_RESPONSE:
        // Received NAT type from server
        var detected_nat_type = ds_map_find_value(msg, "NATType");

        if (!is_undefined(detected_nat_type)) {
            // Main server NAT detection complete
            nat_type = detected_nat_type;
            nat_state = NAT_STATE_WAITING;

            var type_name = "Unknown";
            if (nat_type == NAT_TYPE_DIRECT_MAPPING) type_name = "Direct Mapping (Full Cone)";
            else if (nat_type == NAT_TYPE_RESTRICTED) type_name = "Restricted";
            else if (nat_type == NAT_TYPE_SYMMETRIC) type_name = "Symmetric";

            // Now register as a server
            var reg_params = ds_map_create();
            nat_send_tcp_message(mediation_socket, MSG_SERVER_REGISTER, reg_params);
            ds_map_destroy(reg_params);
        }
        break;

    case MSG_CONNECTION_REQUEST:
        // Client wants to connect - create a per-client tunnel
        var client_endpoint = ds_map_find_value(msg, "EndpointString");
        var client_nat_type = ds_map_find_value(msg, "NATType");
        var connection_id = ds_map_find_value(msg, "ConnectionID");

        if (!is_undefined(connection_id)) {
            nat_create_client_tunnel(connection_id, client_endpoint, client_nat_type);
        }
        break;

    case MSG_CONNECTION_BEGIN:
        // Mediation server coordinated - start hole punching
        var endpoint_str = ds_map_find_value(msg, "EndpointString");
        var peer_nat = ds_map_find_value(msg, "NATType");
        var conn_id = ds_map_find_value(msg, "ConnectionID");
        var is_server = ds_map_find_value(msg, "IsServer");

        if (!is_undefined(endpoint_str) && !is_undefined(conn_id)) {
            // Find the tunnel for this connection
            var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
            if (tunnel != noone && ds_exists(tunnel, ds_type_map)) {
                // Parse endpoint "ip:port"
                var colon_pos = string_pos(":", endpoint_str);
                if (colon_pos > 0) {
                    var peer_ip = string_copy(endpoint_str, 1, colon_pos - 1);
                    var peer_port = real(string_copy(endpoint_str, colon_pos + 1, string_length(endpoint_str) - colon_pos));

                    ds_map_replace(tunnel, "peer_ip", peer_ip);
                    ds_map_replace(tunnel, "peer_port", peer_port);
                    ds_map_replace(tunnel, "peer_nat_type", peer_nat);
                    ds_map_replace(tunnel, "state", NAT_STATE_PUNCHING);
                    ds_map_replace(tunnel, "hole_punch_timer", 0);
                    ds_map_replace(tunnel, "hole_punch_count", 0);
                    ds_map_replace(tunnel, "hole_punch_received", 0);
                }
            }
        }
        break;

    case MSG_CONNECTION_COMPLETE:
        // Connection established for a tunnel
        var conn_id = ds_map_find_value(msg, "ConnectionID");
        if (!is_undefined(conn_id)) {
            var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
            if (tunnel != noone && ds_exists(tunnel, ds_type_map)) {
                ds_map_replace(tunnel, "state", NAT_STATE_CONNECTED);

                // Get the peer endpoint - this is now the client's punched address
                var peer_ip = ds_map_find_value(tunnel, "peer_ip");
                var peer_port = ds_map_find_value(tunnel, "peer_port");

                // Register this client in the UDP proxy system
                var client_key = peer_ip + ":" + string(peer_port);
                if (!ds_map_exists(udp_clients, client_key)) {
                    var client_state = ds_map_create();
                    ds_map_add(client_state, "tcp_socket", -1);  // Will be created when client sends data
                    ds_map_add(client_state, "last_activity", current_time);
                    ds_map_add(client_state, "pending_acks", ds_map_create());
                    ds_map_add(client_state, "smoothed_rtt", 100);
                    ds_map_add(client_state, "rtt_variance", 50);
                    ds_map_add(udp_clients, client_key, client_state);
                }
            }
        }
        break;

    case MSG_CONNECTION_TIMEOUT:
        // Connection failed
        var conn_id = ds_map_find_value(msg, "ConnectionID");
        if (!is_undefined(conn_id)) {
            nat_cleanup_tunnel(conn_id);
        }
        break;

    case MSG_KEEP_ALIVE:
        // Keepalive response from mediation server
        nat_last_mediation_response = current_time;
        break;
}
