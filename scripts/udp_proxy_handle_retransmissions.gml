/// udp_proxy_handle_retransmissions()
// Check all clients for packets needing retransmission
// Call this in Step event

var current = current_time;
var key = ds_map_find_first(global.udp_proxy_clients);

while (!is_undefined(key)) {
    var next_key = ds_map_find_next(global.udp_proxy_clients, key);
    var client_state = ds_map_find_value(global.udp_proxy_clients, key);
    
    // Handle retransmissions for pending ACKs
    if (ds_map_exists(client_state, "pending_acks")) {
        // Calculate adaptive retransmit timeout for this client
        var smoothed_rtt = ds_map_find_value(client_state, "smoothed_rtt");
        var rtt_variance = ds_map_find_value(client_state, "rtt_variance");
        var retransmit_timeout = clamp(smoothed_rtt + (4 * rtt_variance), 200, 3000);
        
        var pending_acks = ds_map_find_value(client_state, "pending_acks");
        var seq_num = ds_map_find_first(pending_acks);
        
        while (!is_undefined(seq_num)) {
            var next_seq = ds_map_find_next(pending_acks, seq_num);
            var ack_data = ds_map_find_value(pending_acks, seq_num);
            var send_time = ds_map_find_value(ack_data, "send_time");
            var retransmits = ds_map_find_value(ack_data, "retransmits");
            
            // Check if we need to retransmit
            if (current - send_time > retransmit_timeout) {
                if (retransmits < global.MAX_RETRANSMITS) {
                    // Retransmit the packet
                    var pkt_buffer = ds_map_find_value(ack_data, "buffer");
                    var pkt_size = ds_map_find_value(ack_data, "size");
                    var client_ip = ds_map_find_value(client_state, "ip");
                    var client_port = ds_map_find_value(client_state, "port");
                    
                    network_send_udp(global.udp_proxy_socket, client_ip, client_port, pkt_buffer, pkt_size);
                    
                    // Update retransmit tracking
                    ds_map_replace(ack_data, "send_time", current);
                    ds_map_replace(ack_data, "retransmits", retransmits + 1);
                } else {
                    // Max retransmits reached, give up
                    var pkt_buffer = ds_map_find_value(ack_data, "buffer");
                    buffer_delete(pkt_buffer);
                    ds_map_destroy(ack_data);
                    ds_map_delete(pending_acks, seq_num);
                }
            }
            
            seq_num = next_seq;
        }
    }
    
    key = next_key;
}
