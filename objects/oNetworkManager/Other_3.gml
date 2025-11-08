if (is_server) {
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