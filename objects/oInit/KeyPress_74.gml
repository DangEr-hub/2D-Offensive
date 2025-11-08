/* Joining the game - Press J event in oInit */
// Make sure NetworkManager exists
if (!instance_exists(oNetworkManager)) {
    instance_create_layer(100, 100, "Instances", oNetworkManager);
}
    
var ip_address = "127.0.0.1"; // For local testing
var port = 50000;  
    
// Connect to server
if (connect_to_server(ip_address, port)) {
    show_debug_message("Connecting to server...");
} else {
    show_debug_message("Failed to connect to server!");
} 