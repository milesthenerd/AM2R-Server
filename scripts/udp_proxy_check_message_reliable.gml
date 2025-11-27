/// udp_proxy_check_message_reliable(buffer, size)
// Determine if a message needs reliable delivery based on message ID
// Returns true if the message should use ACK/retransmission

var recv_buffer = argument0;
var size = argument1;

if (size < 5) return false;

buffer_seek(recv_buffer, buffer_seek_start, 0);
buffer_read(recv_buffer, buffer_s32);  // Skip size prefix
var msgid = buffer_peek(recv_buffer, 4, buffer_u8);

// Message IDs that need reliable delivery:
// 2=disconnect, 3=seed, 102=health/ammo sync
// 110-118=item pickups, 150-155=event syncs
return (msgid == 2 || msgid == 3 || msgid == 102 || 
        (msgid >= 110 && msgid <= 118) || 
        (msgid >= 150 && msgid <= 155));
