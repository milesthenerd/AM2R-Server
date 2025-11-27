/// udp_proxy_cleanup()
// Clean up all UDP proxy resources

// Clean up all client states
var key = ds_map_find_first(global.udp_proxy_clients);
while (!is_undefined(key)) {
    var client_state = ds_map_find_value(global.udp_proxy_clients, key);
    
    // Clean up TCP socket
    var tcp_socket = ds_map_find_value(client_state, "tcp_socket");
    if (tcp_socket != noone) {
        network_destroy(tcp_socket);
    }
    
    // Clean up buffers
    var recv_buffer = ds_map_find_value(client_state, "recv_buffer");
    if (buffer_exists(recv_buffer)) {
        buffer_delete(recv_buffer);
    }
    
    // Clean up pending packets
    if (ds_map_exists(client_state, "pending_packets")) {
        var pending_list = ds_map_find_value(client_state, "pending_packets");
        var packet_count = ds_list_size(pending_list) / 2;
        for (var i = 0; i < packet_count; i++) {
            var pending_buffer = pending_list[| i * 2];
            buffer_delete(pending_buffer);
        }
        ds_list_destroy(pending_list);
    }
    
    // Clean up pending ACKs
    if (ds_map_exists(client_state, "pending_acks")) {
        var pending_acks = ds_map_find_value(client_state, "pending_acks");
        var seq_num = ds_map_find_first(pending_acks);
        while (!is_undefined(seq_num)) {
            var ack_data = ds_map_find_value(pending_acks, seq_num);
            var pkt_buffer = ds_map_find_value(ack_data, "buffer");
            buffer_delete(pkt_buffer);
            ds_map_destroy(ack_data);
            seq_num = ds_map_find_next(pending_acks, seq_num);
        }
        ds_map_destroy(pending_acks);
    }
    
    ds_map_destroy(client_state);
    key = ds_map_find_next(global.udp_proxy_clients, key);
}

// Destroy data structures
ds_map_destroy(global.udp_proxy_clients);
ds_map_destroy(global.udp_proxy_tcp_to_udp);
buffer_delete(global.udp_proxy_forward_buffer);

// Close sockets
network_destroy(global.udp_proxy_socket);
network_destroy(global.udp_proxy_tcp_server);
