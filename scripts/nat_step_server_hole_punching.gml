/// nat_step_server_hole_punching()
// Handles hole punching for all active client tunnels
// Call this from oServer Step event when using NAT traversal

if (!use_nat_traversal) exit;
if (!ds_exists(nat_client_tunnels, ds_type_map)) exit;

// Iterate through all tunnels and handle hole punching
var conn_id = ds_map_find_first(nat_client_tunnels);
while (!is_undefined(conn_id)) {
    var tunnel = ds_map_find_value(nat_client_tunnels, conn_id);
    if (ds_exists(tunnel, ds_type_map)) {
        var state = ds_map_find_value(tunnel, "state");

        if (state == NAT_STATE_PUNCHING) {
            // If WE are symmetric, create 256 random UDP sockets (birthday paradox) - only once
            if (nat_type == NAT_TYPE_SYMMETRIC && !nat_random_sockets_created) {
                for (var i = 0; i < 256; i++) {
                    var random_socket = network_create_socket_ext(network_socket_udp, 0);
                    if (random_socket >= 0) {
                        ds_list_add(nat_random_sockets, random_socket);
                    }
                }
                nat_random_sockets_created = true;
            }

            var timer = ds_map_find_value(tunnel, "hole_punch_timer");
            timer++;
            ds_map_replace(tunnel, "hole_punch_timer", timer);

            // Send hole punch packet every NAT_HOLE_PUNCH_INTERVAL steps
            if (timer >= NAT_HOLE_PUNCH_INTERVAL) {
                ds_map_replace(tunnel, "hole_punch_timer", 0);

                var count = ds_map_find_value(tunnel, "hole_punch_count");
                count++;
                ds_map_replace(tunnel, "hole_punch_count", count);

                var peer_ip = ds_map_find_value(tunnel, "peer_ip");
                var peer_port = ds_map_find_value(tunnel, "peer_port");
                var tunnel_nat = ds_map_find_value(tunnel, "nat_type");
                var peer_nat = ds_map_find_value(tunnel, "peer_nat_type");

                // Determine punch strategy based on OUR NAT type and PEER's NAT type
                if (nat_type == NAT_TYPE_SYMMETRIC) {
                    // WE are symmetric - send from all 256 random sockets to peer's known port
                    // This creates 256 different source ports, leveraging birthday paradox
                    var socket_count = ds_list_size(nat_random_sockets);
                    for (var i = 0; i < socket_count; i++) {
                        var random_socket = ds_list_find_value(nat_random_sockets, i);
                        nat_send_hole_punch(random_socket, peer_ip, peer_port);
                    }
                } else if (peer_nat == NAT_TYPE_SYMMETRIC) {
                    // PEER is symmetric - we scan random ports to find their dynamic port
                    for (var i = 0; i < 256; i++) {
                        var random_port = irandom_range(1024, 65535);
                        nat_send_hole_punch(udp_socket, peer_ip, random_port);
                    }
                } else {
                    // Neither is symmetric - simple bidirectional punch to known port
                    nat_send_hole_punch(udp_socket, peer_ip, peer_port);
                }

                // After receiving enough packets, confirm connection (only once)
                var received = ds_map_find_value(tunnel, "hole_punch_received");
                var confirmed = ds_map_find_value(tunnel, "confirmed");
                if (is_undefined(confirmed)) confirmed = false;

                if (received >= NAT_HOLE_PUNCH_THRESHOLD && !confirmed) {
                    // Send confirmation to mediation server (using main socket)
                    var params = ds_map_create();
                    ds_map_add(params, "ConnectionID", conn_id);
                    ds_map_add(params, "IsServer", true);
                    nat_send_tcp_message(mediation_socket, MSG_RECEIVED_PEER, params);
                    ds_map_destroy(params);

                    ds_map_replace(tunnel, "confirmed", true);
                }

                // Timeout after too many attempts
                if (count > 300) {  // 30 seconds
                    ds_map_replace(tunnel, "state", NAT_STATE_ERROR);
                }
            }
        }
    }
    conn_id = ds_map_find_next(nat_client_tunnels, conn_id);
}
