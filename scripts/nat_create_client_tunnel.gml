/// nat_create_client_tunnel(connection_id, client_endpoint, client_nat_type)
// Creates a new per-client tunnel for NAT hole punching
// connection_id: The mediation server's connection ID
// client_endpoint: The client's "ip:port" string
// client_nat_type: The client's NAT type

var connection_id = argument0;
var client_endpoint = argument1;
var client_nat_type = argument2;

show_debug_message("NAT Server: Creating tunnel for connection " + string(connection_id) + " to client " + client_endpoint);

// Reuse the existing mediation socket and UDP socket - no need to create new ones
// The server only needs one connection to the mediation server

// Create tunnel data structure
var tunnel = ds_map_create();
ds_map_add(tunnel, "connection_id", connection_id);
ds_map_add(tunnel, "client_endpoint", client_endpoint);
ds_map_add(tunnel, "client_nat_type", client_nat_type);
ds_map_add(tunnel, "state", NAT_STATE_WAITING);
ds_map_add(tunnel, "peer_ip", "");
ds_map_add(tunnel, "peer_port", 0);
ds_map_add(tunnel, "peer_nat_type", NAT_TYPE_UNKNOWN);
ds_map_add(tunnel, "hole_punch_timer", 0);
ds_map_add(tunnel, "hole_punch_count", 0);
ds_map_add(tunnel, "hole_punch_received", 0);

// Store in tunnels map
ds_map_add(nat_client_tunnels, connection_id, tunnel);

show_debug_message("NAT Server: Tunnel created for connection " + string(connection_id));
