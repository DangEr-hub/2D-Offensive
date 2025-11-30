/* oNetworkManager clean up event */
if (ds_exists(item_registry, ds_type_map)) {
    var key = ds_map_find_first(item_registry);
    var count = ds_map_size(item_registry);
    for (var i = 0; i < count; i++) {
        var data = ds_map_find_value(item_registry, key);
        ds_map_destroy(data);
        key = ds_map_find_next(item_registry, key);
    }
    ds_map_destroy(item_registry);
}

ds_list_destroy(item_pos_buffer);


if (IS_SERVER) {
    // Server shutdown
    if (server_socket >= 0) {
        // Notify all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, PACKET.DISCONNECT);
            buffer_write(send_buffer, buffer_u32, send_sequence++);
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
            
        network_destroy(server_socket);
        server_socket = -1;
    }
} else {
    // Client disconnect
    disconnect_from_server();
}












