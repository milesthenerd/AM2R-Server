/// nat_cleanup()
// Cleans up NAT traversal resources
// Call this in Destroy event

if (mediation_socket != -1) {
    network_destroy(mediation_socket);
    mediation_socket = -1;
}

nat_state = NAT_STATE_DISCONNECTED;
show_debug_message("NAT client cleaned up");
