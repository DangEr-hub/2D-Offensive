/* Server-side networking functions */
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
		//write_debug("Packet received from " + sender_ip + ":" + string(sender_port), "server_debug.txt");
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
                handle_player_state_update_server(key);
                break;

            case PACKET.PROJECTILE_SPAWN:
                handle_projectile_spawn_server(key);
                break;

            case PACKET.HEARTBEAT:
                break;
				
			case PACKET.EQUIP_SYNC:
				handle_equipment_update_server(key);
			break;

            case PACKET.DISCONNECT:
                handle_client_disconnect(key);
            break;

            case PACKET.HIT:
                handle_hit_server(key);
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
		
		///Broadcast v step eventu oNetworkManagera pro rozeslání všech equipmentů
		equipment_changed = true;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.CONNECT_ACCEPT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, pid);
        network_send_udp(server_socket, sender_ip, sender_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_player_state_update_server(socket_id) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_id)) return;
        
        var pid = ds_map_find_value(clients, socket_id);
        var x_pos = buffer_read(receive_buffer, buffer_f32);
        var y_pos = buffer_read(receive_buffer, buffer_f32);
        var direction_facing = buffer_read(receive_buffer, buffer_f16);
        var state = buffer_read(receive_buffer, buffer_u8);
		var hp = buffer_read(receive_buffer, buffer_f16);
        
        
        // Store player position
        var player_data = ds_map_find_value(player_states, pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, pid, player_data);
        }
        
        ds_map_set(player_data, "x", x_pos);
        ds_map_set(player_data, "y", y_pos);
        ds_map_set(player_data, "dir", direction_facing);
        ds_map_set(player_data, "state", state);
		ds_map_set(player_data, "health", hp);
        ds_map_set(player_data, "timestamp", current_time);

        var p = find_player_by_network_id(pid);
        if (p == noone) {
            p = create_remote_player(pid, x_pos, y_pos);
        }
        if (instance_exists(p)) {
            with (p) {
                target_x = x_pos;
                target_y = y_pos;
                target_direction = direction_facing;
                network_bit_state = state;
				stats.Health_points = hp;
            }
        }
    }
	
}

/// @function send_player_state_to_all()
function send_player_state_to_all() {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PLAYER_STATE);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        // Write number of players
        var player_count = ds_map_size(player_states);
        buffer_write(send_buffer, buffer_u8, player_count);
        
        // Write each player's data
        var key = ds_map_find_first(player_states);
        for (var i = 0; i < player_count; i++) {
            var pid = key;
            var player_data = ds_map_find_value(player_states, pid);
            
            buffer_write(send_buffer, buffer_u16, pid);
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "x"));
            buffer_write(send_buffer, buffer_f32, ds_map_find_value(player_data, "y"));
            buffer_write(send_buffer, buffer_f16, ds_map_find_value(player_data, "dir"));
            buffer_write(send_buffer, buffer_u8, ds_map_find_value(player_data, "state"));     
			buffer_write(send_buffer, buffer_f16, ds_map_find_value(player_data, "health"));   
            key = ds_map_find_next(player_states, key);
        }
        
        // Broadcast to all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer)
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function handle_client_disconnect(socket_id) {
    with (oNetworkManager) {
        if (ds_map_exists(clients, socket_id)) {
            var pid = ds_map_find_value(clients, socket_id);
            show_debug_message("Player " + string(pid) + " disconnected");
            
            // Remove player data
            ds_map_delete(clients, socket_id);
            ds_map_delete(client_timeout, socket_id);
            ds_map_delete(player_states, pid);
            
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

function handle_equipment_update_server(socket_id) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_id)) return;
        
        var pid = ds_map_find_value(clients, socket_id);
        
        // Read equipment data
        var helmet_id  = buffer_read(receive_buffer, buffer_u16);
        var helmet_dur = buffer_read(receive_buffer, buffer_f16);
        var armour_id  = buffer_read(receive_buffer, buffer_u16);
        var armour_dur = buffer_read(receive_buffer, buffer_f16);
        
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
        
        // Update the player object
        var p = find_player_by_network_id(pid);
        if (instance_exists(p)) {
            with (p) {
                network_helmet_id = helmet_id;
                network_helmet_dur = helmet_dur;
                network_armour_id = armour_id;
                network_armour_dur = armour_dur;
            }
        }
     
	 equipment_changed = true;
    }
}

function send_equipment_to_all() {
    with (oNetworkManager) {
        if (!is_server) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.EQUIP_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        // Count players
        var player_count = ds_map_size(player_states);
        buffer_write(send_buffer, buffer_u8, player_count);
        
        var key = ds_map_find_first(player_states);
        for (var i = 0; i < player_count; i++) {
            var pid = key;
            var player_data = ds_map_find_value(player_states, pid);

            // Read values with safe defaults (fix undefined crash)
            var helmet_id  = ds_map_find_value(player_data, "helmet_id");
            var helmet_dur = ds_map_find_value(player_data, "helmet_dur");
            var armour_id  = ds_map_find_value(player_data, "armour_id");
            var armour_dur = ds_map_find_value(player_data, "armour_dur");

            if (is_undefined(helmet_id))  helmet_id  = 0;
            if (is_undefined(helmet_dur)) helmet_dur = 0;
            if (is_undefined(armour_id))  armour_id  = 0;
            if (is_undefined(armour_dur)) armour_dur = 0;

            // Write safe values to buffer
            buffer_write(send_buffer, buffer_u16, pid);
            buffer_write(send_buffer, buffer_u16, helmet_id);
            buffer_write(send_buffer, buffer_f16, helmet_dur);
            buffer_write(send_buffer, buffer_u16, armour_id);
            buffer_write(send_buffer, buffer_f16, armour_dur);

            key = ds_map_find_next(player_states, key);
        }
        
        // Send to all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}


function server_process_hit(attacker_pid, victim_pid, damage, hitbox_type, impact_pos, hit_spd_mod, aimpunch_modifier, equip_dur) {
    with (oNetworkManager) {
        if (!is_server) return;

        var victim_obj = find_player_by_network_id(victim_pid);
        if (instance_exists(victim_obj)) {	
			hit_remote_object(damage, victim_obj, hitbox_type, [impact_pos[0], impact_pos[1]], hit_spd_mod, aimpunch_modifier, equip_dur);
        }

        if (victim_pid == my_pid) {
            return;
        }


        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8,  PACKET.HIT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, attacker_pid);
        buffer_write(send_buffer, buffer_u16, victim_pid);
        buffer_write(send_buffer, buffer_f16, damage);
        buffer_write(send_buffer, buffer_u8,  hitbox_type);
        buffer_write(send_buffer, buffer_f16, impact_pos[0]);
        buffer_write(send_buffer, buffer_f16, impact_pos[1]);
		buffer_write(send_buffer, buffer_f16, hit_spd_mod);
		buffer_write(send_buffer, buffer_f16, aimpunch_modifier);
		buffer_write(send_buffer, buffer_f16, equip_dur[0]);
		buffer_write(send_buffer, buffer_f16, equip_dur[1]);

        var k = ds_map_find_first(clients);
        var n = ds_map_size(clients);
        for (var i = 0; i < n; i++) {
            sent_server_udp(server_socket, k, send_buffer);
            k = ds_map_find_next(clients, k);
        }
    }
}

function handle_hit_server(socket_key) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_key)) return;

        var attacker_pid_claim = buffer_read(receive_buffer, buffer_u16);
        var victim_pid   = buffer_read(receive_buffer, buffer_u16);
        var damage       = buffer_read(receive_buffer, buffer_f16);
        var hitbox_type    = buffer_read(receive_buffer, buffer_u8);
        var impact_x     = buffer_read(receive_buffer, buffer_f16);
        var impact_y     = buffer_read(receive_buffer, buffer_f16);
		var hit_spd_mod = buffer_read(receive_buffer, buffer_f16);
		var aimpunch_modifier = buffer_read(receive_buffer, buffer_f16);
		var armour_dur = buffer_read(receive_buffer, buffer_f16);
		var helmet_dur = buffer_read(receive_buffer, buffer_f16);

        var attacker_pid = ds_map_find_value(clients, socket_key);
        if (attacker_pid < 0) {
            attacker_pid = attacker_pid_claim;
        }

        server_process_hit(attacker_pid, victim_pid, damage, hitbox_type, [impact_x, impact_y], hit_spd_mod, aimpunch_modifier, [armour_dur, helmet_dur]);
    }
}
