/// Client-side networking functions
/// @function connect_to_server(ip, port)
function connect_to_server(ip, port) {
    with (oNetworkManager) {
        server_ip = ip;
        server_port = port;
        
        client_socket = network_create_socket(network_type);
		is_server = false;
        
        if (client_socket < 0) {
            show_debug_message("Failed to create client socket!");
            return false;
        }
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.CONNECT_REQUEST);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_string, "Player_" + string(irandom(9999)));

        var result = network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
		global.debug_text = "SEND result = " + string(result);
        
		
        return true;
    }
}


/// @function handle_client_receive()
function handle_client_receive() {
    with (oNetworkManager) {
        buffer_seek(receive_buffer, buffer_seek_start, 0);
        
        var packet_type = buffer_read(receive_buffer, buffer_u8);
        var sequence = buffer_read(receive_buffer, buffer_u32);
		
		global.debug_text = "Client received packet type: " + string(packet_type);
        
        switch (packet_type) {
            case PACKET.CONNECT_ACCEPT:
                handle_connect_accept();
                break;
                
            case PACKET.GAME_STATE:
                handle_game_state_update();
                break;
                
            case PACKET.PROJECTILE_SPAWN:
                handle_projectile_spawn_client();
                break;
                
            case PACKET.DISCONNECT:
                handle_player_disconnect_client();
                break;
        }
    }
}

/// @function handle_connect_accept()
function handle_connect_accept() {
    with (oNetworkManager) {
        my_pid = buffer_read(receive_buffer, buffer_u16);
        is_connected = true;
        show_debug_message("Connected! My player ID: " + string(my_pid));


        // TEĎ teprve přepni room
        room_goto(rm_ServerTest);
		
        // Vytvoř lokálního hráče
        //create_local_player(my_pid);
    }
}

/// @function handle_game_state_update()
function handle_game_state_update() {
    with (oNetworkManager) {
        var player_count = buffer_read(receive_buffer, buffer_u8);
        
        for (var i = 0; i < player_count; i++) {
            var pid = buffer_read(receive_buffer, buffer_u16);
            var x_pos = buffer_read(receive_buffer, buffer_f32);
            var y_pos = buffer_read(receive_buffer, buffer_f32);
            var direction_facing = buffer_read(receive_buffer, buffer_f32);
            var velocity_x = buffer_read(receive_buffer, buffer_f32);
            var velocity_y = buffer_read(receive_buffer, buffer_f32);
            
            // Skip own player (we predict locally)
            if (pid == my_pid) {
                continue;
            }
            
            // Update or create remote player
            var player = find_player_by_network_id(pid);
            
            if (player == noone) {
                player = create_remote_player(pid, x_pos, y_pos);
            }
            
            // Apply interpolation for smooth movement
            if (instance_exists(player)) {
                with (player) {
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
                    //network_state = state;
                }
            }
        }
    }
}

/// @function send_player_update()
function send_player_update() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        var player = find_player_by_network_id(my_pid);
        if (!instance_exists(player)) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PLAYER_UPDATE);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        with (player) {
            buffer_write(other.send_buffer, buffer_f32, x);
            buffer_write(other.send_buffer, buffer_f32, y);
            buffer_write(other.send_buffer, buffer_f32, RotationAngle);
            buffer_write(other.send_buffer, buffer_f32, XSpeed);
            buffer_write(other.send_buffer, buffer_f32, YSpeed);
        }
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer))
    }
}

/// @function send_heartbeat()
function send_heartbeat() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.HEARTBEAT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

/// @function handle_server_disconnect()
function handle_server_disconnect() {
    with (oNetworkManager) {
        show_debug_message("Disconnected from server");
        
        is_connected = false;
        
        if (client_socket >= 0) {
            network_destroy(client_socket);
            client_socket = -1;
        }
        
        // Clean up and return to menu
        game_restart();
    }
}

/// @function disconnect_from_server()
function disconnect_from_server() {
    with (oNetworkManager) {
        if (client_socket >= 0) {
            // Send disconnect message
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, PACKET.DISCONNECT);
            buffer_write(send_buffer, buffer_u32, send_sequence++);
            
            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer))
            
            // Clean up
            network_destroy(client_socket);
            client_socket = -1;
        }
        
        is_connected = false;
        show_debug_message("Disconnected from server");
    }
}

/// @function handle_player_disconnect_client()
function handle_player_disconnect_client() {
    with (oNetworkManager) {
        var pid = buffer_read(receive_buffer, buffer_u16);
        
        show_debug_message("Player " + string(pid) + " disconnected");
        
        // Remove player object
        with (oPlayer) {
            if (network_id == pid) {
                instance_destroy();
            }
        }
    }
}
/// @function handle_projectile_spawn_client()
function handle_projectile_spawn_client() {
    with (oNetworkManager) {
        var proj_id = buffer_read(receive_buffer, buffer_u16);
        var owner_id = buffer_read(receive_buffer, buffer_u16);
        var x_pos = buffer_read(receive_buffer, buffer_f32);
        var y_pos = buffer_read(receive_buffer, buffer_f32);
        var dir = buffer_read(receive_buffer, buffer_f32);
        var speed_val = buffer_read(receive_buffer, buffer_f32);
        
        // Create projectile
        var proj = instance_create_layer(x_pos, y_pos, "Instances", obj_projectile);
        proj.network_id = proj_id;
        proj.owner_id = owner_id;
        proj.direction = dir;
        proj.speed = speed_val;
    }
}