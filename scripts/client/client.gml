/* Client-side networking functions */
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
                
            case PACKET.PLAYER_STATE:
                handle_player_state_update_client();
            break;
                
            case PACKET.PROJECTILE_SPAWN:
                handle_projectile_spawn_client();
                break;
                
            case PACKET.DISCONNECT:
                handle_player_disconnect_client();
                break;
            case PACKET.EQUIP_SYNC:
                handle_equipment_update_client();
            break;
        }
    }
}

function handle_connect_accept() {
    with (oNetworkManager) {
        my_pid = buffer_read(receive_buffer, buffer_u16);
        is_connected = true;
        show_debug_message("Connected! My player ID: " + string(my_pid));
        room_goto(rm_ServerTest);
    }
}

function handle_player_state_update_client() {
    with (oNetworkManager) {
        var player_count = buffer_read(receive_buffer, buffer_u8);
        
        for (var i = 0; i < player_count; i++) {
            var pid = buffer_read(receive_buffer, buffer_u16);
            var x_pos = buffer_read(receive_buffer, buffer_f32);
            var y_pos = buffer_read(receive_buffer, buffer_f32);
            var direction_facing = buffer_read(receive_buffer, buffer_f32);
			var bit_states = buffer_read(receive_buffer, buffer_u8);
			
            
            // Přeskoč lokálního hráče
            if (pid == my_pid) {
                continue;
            }
            
            // Update or create remote player
            var player = find_player_by_network_id(pid);
            
            if (player == noone) {
                player = create_remote_player(pid, x_pos, y_pos);
            }
            
            if (instance_exists(player)) {
                with (player) {
                    target_x = x_pos;
                    target_y = y_pos;
                    target_direction = direction_facing;    
                    network_bit_state = bit_states;
                }
            }
        }
    }
}

function handle_equipment_update_client() {
    with (oNetworkManager) {
        var player_count = buffer_read(receive_buffer, buffer_u8);
        
        for (var i = 0; i < player_count; i++) {
            var pid = buffer_read(receive_buffer, buffer_u16);
            var helmet_id  = buffer_read(receive_buffer, buffer_u16);
            var helmet_dur = buffer_read(receive_buffer, buffer_f16);
            var armour_id  = buffer_read(receive_buffer, buffer_u16);
            var armour_dur = buffer_read(receive_buffer, buffer_f16);
            
            // Skip local player (we already have our own equipment)
            if (pid == my_pid) {
                continue;
            }
            
            // Store in player_states
            var player_data = ds_map_find_value(player_states, pid);
            if (is_undefined(player_data)) {
                player_data = ds_map_create();
                ds_map_add(player_states, pid, player_data);
            }
            
            ds_map_set(player_data, "helmet_id", helmet_id);
            ds_map_set(player_data, "helmet_dur", helmet_dur);
            ds_map_set(player_data, "armour_id", armour_id);
            ds_map_set(player_data, "armour_dur", armour_dur);
            
            // Update remote player object
            var player = find_player_by_network_id(pid);
            if (instance_exists(player)) {
                with (player) {
                    network_helmet_id = helmet_id;
                    network_helmet_dur = helmet_dur;
                    network_armour_id = armour_id;
                    network_armour_dur = armour_dur;
                }
            }
        }
    }
}

function send_equipment_update_client() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        var player = find_player_by_network_id(my_pid);
        if (!instance_exists(player)) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.EQUIP_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        with (player) {
            buffer_write(other.send_buffer, buffer_u16, global.Inventory[# OtherSlot.Helmet, Index.slot_id]);
            buffer_write(other.send_buffer, buffer_f16, global.Inventory[# OtherSlot.Helmet, Index.slot_durability]);
            buffer_write(other.send_buffer, buffer_u16, global.Inventory[# OtherSlot.Armour, Index.slot_id]);
            buffer_write(other.send_buffer, buffer_f16, global.Inventory[# OtherSlot.Armour, Index.slot_durability]);
        }
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function send_player_state_update_client() {
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
			
			var bit_states = 0;
			if(global.GodMode == true){
				bit_states |= PLAYER_FLAGS.GODMODE;
			}
        }
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function send_heartbeat() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.HEARTBEAT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_server_disconnect() {
    with (oNetworkManager) {
        show_debug_message("Disconnected from server");
        
        is_connected = false;
        
        if (client_socket >= 0) {
            network_destroy(client_socket);
            client_socket = -1;
        }
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