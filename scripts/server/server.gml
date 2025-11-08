/* Server-side networking functions */
/// @function start_server()
function start_server() {
    with (oNetworkManager) {
        server_socket = network_create_socket_ext(network_type, server_port);
        
        if (server_socket < 0) {
            show_debug_message("Failed to create server socket!");
            return false;
        }
        
        is_server = true;
        is_connected = true;
        my_pid = 0; // Server is player 0
        
        show_debug_message("Server started on port " + string(server_port));
        
        return true;
    }
    return false;
}

function handle_server_receive(sender_ip, sender_port) {
    with (oNetworkManager) {
		global.debug_text = "Packet received from " + sender_ip + ":" + string(sender_port);
        buffer_seek(receive_buffer, buffer_seek_start, 0);
        var packet_type = buffer_read(receive_buffer, buffer_u8);
        var sequence = buffer_read(receive_buffer, buffer_u32);

        var key = sender_ip + ":" + string(sender_port);
        ds_map_set(client_timeout, key, current_time);

        switch (packet_type) {
            case PACKET.CONNECT_REQUEST:
                handle_connect_request(sender_ip, sender_port);
                break;

            case PACKET.PLAYER_UPDATE:
                handle_player_update_server(key);
                break;

            case PACKET.PROJECTILE_SPAWN:
                handle_projectile_spawn(key);
                break;

            case PACKET.HEARTBEAT:
                break;

            case PACKET.DISCONNECT:
                handle_client_disconnect(key);
                break;
        }
    }
}


/// @function handle_connect_request(socket_id)
function handle_connect_request(sender_ip, sender_port) {
    with (oNetworkManager) {
        var pid = ds_map_size(clients) + 1;
        var client_key = sender_ip + ":" + string(sender_port);
        ds_map_add(clients, client_key, pid);
        ds_map_add(client_timeout, client_key, current_time);

        global.debug_text = "Player " + string(pid) + " connected from " + client_key;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.CONNECT_ACCEPT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, pid);

        network_send_udp(server_socket, sender_ip, sender_port, send_buffer, buffer_tell(send_buffer));
    }
}

/// @function handle_player_update_server(socket_id)
function handle_player_update_server(socket_id) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_id)) return;
        
        var pid = ds_map_find_value(clients, socket_id);
        var x_pos = buffer_read(receive_buffer, buffer_f32);
        var y_pos = buffer_read(receive_buffer, buffer_f32);
        var direction_facing = buffer_read(receive_buffer, buffer_f32);
        var velocity_x = buffer_read(receive_buffer, buffer_f32);
        var velocity_y = buffer_read(receive_buffer, buffer_f32);
        //var state = buffer_read(receive_buffer, buffer_u8);
        
        // Store player position
        var player_data = ds_map_find_value(player_positions, pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_positions, pid, player_data);
        }
        
        ds_map_set(player_data, "x", x_pos);
        ds_map_set(player_data, "y", y_pos);
        ds_map_set(player_data, "dir", direction_facing);
        ds_map_set(player_data, "vx", velocity_x);
        ds_map_set(player_data, "vy", velocity_y);
        //ds_map_set(player_data, "state", state);
        ds_map_set(player_data, "timestamp", current_time);

        var p = find_player_by_network_id(pid);
        if (p == noone) {
            p = create_remote_player(pid, x_pos, y_pos);     // :contentReference[oaicite:3]{index=3}
        }
        if (instance_exists(p)) {
            with (p) {
                if (interpolation_enabled) {
                    target_x = x_pos;
                    target_y = y_pos;
                    target_direction = direction_facing;
                } else {
                    x = x_pos;
                    y = y_pos;
                    RotationAngle = direction_facing;
                }
                network_vx = velocity_x;
                network_vy = velocity_y;
            }
        }
    }
	
}

/// @function send_game_state_to_all()
function send_game_state_to_all() {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.GAME_STATE);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        // Write number of players
        var player_count = ds_map_size(player_positions);
        buffer_write(send_buffer, buffer_u8, player_count);
        
        // Write each player's data
        var key = ds_map_find_first(player_positions);
        for (var i = 0; i < player_count; i++) {
            var pid = key;
            var player_data = ds_map_find_value(player_positions, pid);
            
            buffer_write(send_buffer, buffer_u16, pid);
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "x"));
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "y"));
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "dir"));
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "vx"));
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "vy"));
           // buffer_write(send_buffer, buffer_u8, ds_map_find_value(player_data, "state"));
            
            key = ds_map_find_next(player_positions, key);
        }
        
        // Broadcast to all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer)
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

/// @function handle_client_disconnect(socket_id)
function handle_client_disconnect(socket_id) {
    with (oNetworkManager) {
        if (ds_map_exists(clients, socket_id)) {
            var pid = ds_map_find_value(clients, socket_id);
            show_debug_message("Player " + string(pid) + " disconnected");
            
            // Remove player data
            ds_map_delete(clients, socket_id);
            ds_map_delete(client_timeout, socket_id);
            ds_map_delete(player_positions, pid);
            
            // Destroy player object
            with (oPlayer) {
                if (network_id == pid) {
                    instance_destroy();
                }
            }
            
            // Notify other clients
            broadcast_player_disconnect(pid);
        }
    }
}

/// @function check_client_timeouts()
function check_client_timeouts() {
    with (oNetworkManager) {
        var socket_key = ds_map_find_first(client_timeout);
        var to_remove = ds_list_create();
        
        for (var i = 0; i < ds_map_size(client_timeout); i++) {
            var last_time = ds_map_find_value(client_timeout, socket_key);
            
            if (current_time - last_time > timeout_threshold) {
                ds_list_add(to_remove, socket_key);
            }
            
            socket_key = ds_map_find_next(client_timeout, socket_key);
        }
        
        // Remove timed out clients
        for (var i = 0; i < ds_list_size(to_remove); i++) {
            handle_client_disconnect(ds_list_find_value(to_remove, i));
        }
        
        ds_list_destroy(to_remove);
    }
}
/// @function broadcast_player_disconnect(pid)
function broadcast_player_disconnect(pid) {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.DISCONNECT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, pid);
        
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer)
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}