/// nat_step_hole_punching()
// Handles hole punching in Step event
// Call this from oClient Step event when using NAT traversal

if (!use_nat_traversal) exit;

if (nat_state == NAT_STATE_PUNCHING) {
    nat_hole_punch_timer++;
    
    // Send hole punch packet every NAT_HOLE_PUNCH_INTERVAL steps
    if (nat_hole_punch_timer >= NAT_HOLE_PUNCH_INTERVAL) {
        nat_hole_punch_timer = 0;
        nat_hole_punch_count++;
        
        // Determine punch strategy based on NAT types
        if (nat_type == NAT_TYPE_SYMMETRIC && nat_peer_nat_type != NAT_TYPE_SYMMETRIC) {
            // We are symmetric - just send to exact endpoint
            nat_send_hole_punch(socket, nat_peer_ip, nat_peer_port);
        } else if (nat_type != NAT_TYPE_SYMMETRIC && nat_peer_nat_type == NAT_TYPE_SYMMETRIC) {
            // Peer is symmetric - try multiple ports around their port
            for (var i = -5; i <= 5; i++) {
                nat_send_hole_punch(socket, nat_peer_ip, nat_peer_port + i);
            }
        } else {
            // Both non-symmetric - simple bidirectional punch
            nat_send_hole_punch(socket, nat_peer_ip, nat_peer_port);
        }
        
        // After receiving enough packets, confirm connection
        if (nat_hole_punch_received >= NAT_HOLE_PUNCH_THRESHOLD) {
            // Send confirmation to mediation server
            var params = ds_map_create();
            ds_map_add(params, "ConnectionID", nat_connection_id);
            ds_map_add(params, "IsServer", false);
            nat_send_tcp_message(mediation_socket, MSG_RECEIVED_PEER, params);
            ds_map_destroy(params);
            
            show_debug_message("Hole punch successful - sent confirmation");
        }
        
        // Timeout after too many attempts
        if (nat_hole_punch_count > 300) {  // 30 seconds
            show_message("Connection timeout - could not establish connection");
            nat_state = NAT_STATE_ERROR;
        }
    }
}
