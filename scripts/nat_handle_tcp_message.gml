/// nat_handle_tcp_message(message_map)
// Handles incoming TCP messages from mediation server
// message_map: ds_map returned from json_parse_nat_message()
// Call this from Async Networking event

var msg = argument0;

if (!ds_exists(msg, ds_type_map)) {
    exit;
}

var msg_id = ds_map_find_value(msg, "ID");
if (is_undefined(msg_id)) {
    exit;
}

show_debug_message("Received NAT message type: " + string(msg_id));

switch (msg_id) {
    case MSG_CONNECTED:
        // Connected to mediation server - start NAT detection
        mediation_connected = true;
        nat_state = NAT_STATE_NAT_DETECTING;
        
        // Send NAT type request
        var params = ds_map_create();
        ds_map_add(params, "LocalPort", socket);  // Our UDP port
        ds_map_add(params, "ClientID", nat_client_id);
        nat_send_tcp_message(mediation_socket, MSG_NAT_TYPE_REQUEST, params);
        ds_map_destroy(params);
        
        show_debug_message("Connected to mediation server, requesting NAT type");
        break;
        
    case MSG_NAT_TEST_BEGIN:
        // Mediation server wants us to send UDP to test ports
        var test_port_one = ds_map_find_value(msg, "NATTestPortOne");
        var test_port_two = ds_map_find_value(msg, "NATTestPortTwo");
        
        if (!is_undefined(test_port_one) && !is_undefined(test_port_two)) {
            nat_local_port = socket;
            
            // Send NAT test packets to both ports
            var test_params = ds_map_create();
            ds_map_add(test_params, "ClientID", nat_client_id);
            var test_json = json_encode_nat_message(MSG_NAT_TEST, test_params);
            ds_map_destroy(test_params);
            
            var test_buf = buffer_create(string_length(test_json) + 1, buffer_fixed, 1);
            buffer_seek(test_buf, buffer_seek_start, 0);
            buffer_write(test_buf, buffer_text, test_json);
            
            network_send_udp_raw(socket, mediation_server_ip, test_port_one, test_buf, buffer_tell(test_buf));
            network_send_udp_raw(socket, mediation_server_ip, test_port_two, test_buf, buffer_tell(test_buf));
            
            buffer_delete(test_buf);
            
            show_debug_message("Sent NAT test packets to ports " + string(test_port_one) + " and " + string(test_port_two));
        }
        break;
        
    case MSG_NAT_TYPE_RESPONSE:
        // Received NAT type from server
        nat_type = ds_map_find_value(msg, "NATType");
        
        if (!is_undefined(nat_type)) {
            nat_state = NAT_STATE_WAITING;
            
            var type_name = "Unknown";
            if (nat_type == NAT_TYPE_DIRECT_MAPPING) type_name = "Direct Mapping (Full Cone)";
            else if (nat_type == NAT_TYPE_RESTRICTED) type_name = "Restricted";
            else if (nat_type == NAT_TYPE_SYMMETRIC) type_name = "Symmetric";
            
            show_debug_message("NAT type detected: " + type_name);
        }
        break;
        
    case MSG_CONNECTION_BEGIN:
        // Mediation server is coordinating connection - start hole punching
        var endpoint_str = ds_map_find_value(msg, "EndpointString");
        var peer_nat = ds_map_find_value(msg, "NATType");
        var conn_id = ds_map_find_value(msg, "ConnectionID");
        
        if (!is_undefined(endpoint_str) && !is_undefined(peer_nat)) {
            // Parse endpoint "ip:port"
            var colon_pos = string_pos(":", endpoint_str);
            if (colon_pos > 0) {
                nat_peer_ip = string_copy(endpoint_str, 1, colon_pos - 1);
                nat_peer_port = real(string_copy(endpoint_str, colon_pos + 1, string_length(endpoint_str) - colon_pos));
                nat_peer_nat_type = peer_nat;
                nat_connection_id = conn_id;
                
                // Check for unsupported Symmetric-to-Symmetric
                if (nat_type == NAT_TYPE_SYMMETRIC && nat_peer_nat_type == NAT_TYPE_SYMMETRIC) {
                    show_message("Connection not possible - both sides have Symmetric NAT");
                    nat_state = NAT_STATE_ERROR;
                    exit;
                }
                
                // Start hole punching
                nat_state = NAT_STATE_PUNCHING;
                nat_hole_punch_timer = 0;
                nat_hole_punch_count = 0;
                nat_hole_punch_received = 0;
                
                show_debug_message("Starting hole punch to " + nat_peer_ip + ":" + string(nat_peer_port));
            }
        }
        break;
        
    case MSG_CONNECTION_COMPLETE:
        // Connection established!
        nat_state = NAT_STATE_CONNECTED;
        
        // Update oClient to use the discovered endpoint
        server_ip = nat_peer_ip;
        server_port = nat_peer_port;
        
        show_debug_message("NAT traversal complete! Connected to " + server_ip + ":" + string(server_port));
        popup_text("Connected!");
        break;
        
    case MSG_SERVER_NOT_AVAILABLE:
        show_message("Server not available");
        nat_state = NAT_STATE_ERROR;
        break;
        
    case MSG_CONNECTION_TIMEOUT:
        show_message("Connection timeout");
        nat_state = NAT_STATE_ERROR;
        break;
}
