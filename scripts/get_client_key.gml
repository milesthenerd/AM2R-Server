/// get_client_key(ip, port)
// Returns a unique key for IP:port combination
// Used to identify UDP clients since they don't have unique socket IDs

var ip = argument0;
var port = argument1;

return ip + ":" + string(port);
