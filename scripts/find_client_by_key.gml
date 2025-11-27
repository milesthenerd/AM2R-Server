/// find_client_by_key(key)
// Returns client data for given IP:port key, or undefined if not found
// Use this to look up client information from UDP packets

var key = argument0;
return ds_map_find_value(udp_clients, key);
