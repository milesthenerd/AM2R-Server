/// send_to_client(client_key, buffer, size)
// Sends UDP packet to client identified by IP:port key
// This is a helper to simplify sending to UDP clients

var client_key = argument0;
var buf = argument1;
var size = argument2;

var colon_pos = string_pos(":", client_key);
if (colon_pos > 0) {
    var client_ip = string_copy(client_key, 1, colon_pos - 1);
    var client_port = real(string_copy(client_key, colon_pos + 1, string_length(client_key) - colon_pos));

    network_send_udp(udp_socket, client_ip, client_port, buf, size);
} else {
    show_debug_message("ERROR: Invalid client_key format: " + client_key);
}
