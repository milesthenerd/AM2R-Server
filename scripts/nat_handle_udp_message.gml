/// nat_handle_udp_message(buffer, size, ip, port)
// Checks if a UDP message is a NAT hole punch packet
// Returns true if it was a hole punch (and handled), false otherwise
// Call this BEFORE processing normal game UDP packets

var buf = argument0;
var buf_size = argument1;
var from_ip = argument2;
var from_port = argument3;

if (!use_nat_traversal) return false;
if (nat_state != NAT_STATE_PUNCHING) return false;

// Try to parse as JSON to see if it's a hole punch
buffer_seek(buf, buffer_seek_start, 0);
var msg_str = buffer_read(buf, buffer_string);

// Quick check - does it look like JSON?
if (string_char_at(msg_str, 1) != "{") {
    return false;
}

// Try to parse
var msg = json_parse_nat_message(msg_str);
if (msg == noone) {
    return false;
}

var msg_id = ds_map_find_value(msg, "ID");
var is_hole_punch = false;

if (!is_undefined(msg_id)) {
    if (msg_id == MSG_HOLE_PUNCH_ATTEMPT) {
        // This is a hole punch packet from peer!
        nat_hole_punch_received++;
        is_hole_punch = true;
        
        show_debug_message("Received hole punch packet #" + string(nat_hole_punch_received) + " from " + from_ip + ":" + string(from_port));
        
        // If we haven't confirmed the exact peer IP/port yet, update it
        if (nat_peer_ip == "" || nat_peer_port == 0) {
            nat_peer_ip = from_ip;
            nat_peer_port = from_port;
            show_debug_message("Updated peer endpoint to " + nat_peer_ip + ":" + string(nat_peer_port));
        }
    }
}

ds_map_destroy(msg);
return is_hole_punch;
