// Creating server - Press H event in oInit
// Make sure NetworkManager exists
if (!instance_exists(oNetworkManager)) {
    instance_create_layer(100, 100, "Instances", oNetworkManager);
}
    
// Start server
if (start_server()) {
    show_debug_message("Server started successfully!");
    room_goto(rm_ServerTest);
} else {
    show_debug_message("Failed to start server!");
}
 