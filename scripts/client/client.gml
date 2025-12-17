/* Client-side networking functions */
function connect_to_server(ip, port) {
    with (oNetworkManager) {
        server_ip = ip;
        server_port = port;
        client_socket = network_create_socket(network_type);
		is_server = false;
        
        if (client_socket < 0) {
            show_debug_message("Failed to create client socket!");return false;
        }
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.CONNECT_REQUEST);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_string, "Player_" + string(irandom(9999)));

        var result = network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
        	
        return true;
    }
}

function handle_client_receive() {
    with (oNetworkManager) {
        buffer_seek(receive_buffer, buffer_seek_start, 0);
        
        var packet_type = buffer_read(receive_buffer, buffer_u8);
        var sequence = buffer_read(receive_buffer, buffer_u32);
		
        
        switch (packet_type) {
            case PACKET.CONNECT_ACCEPT: handle_connect_accept(); break;
                
            case PACKET.TICK_UPDATE: handle_tick_update_client(); break;
                
            case PACKET.PROJECTILE_SPAWN: handle_projectile_spawn_client(); break;
                
            case PACKET.DISCONNECT: handle_player_disconnect_client(); break;
			
            case PACKET.EQUIP_SYNC: handle_equipment_update_client(); break;
			
			case PACKET.OBJECT_SYNC: handle_object_sync_client(); break;
			
			case PACKET.HIT: handle_hit_client(); break;
			
			case PACKET.WEAPON_SYNC: handle_weapon_update_client(); break;
			
			case PACKET.INIT: handle_init_sync_client(); break;
			
			case PACKET.WEATHER_SYNC: handle_weather_update_client(); break;
			
			case PACKET.OBJECT_POS_SYNC: handle_object_pos_sync_client(); break;
			
			case PACKET.PLAYER_DEATH: handle_player_death_client(); break;
			
			case PACKET.PLAYER_RESPAWN: handle_player_respawn_client(); break;
			
			case PACKET.PING: handle_ping_response_client(); break;
			
        }
    }
}


function handle_player_death_client() {
    with (oNetworkManager) {
        var attacker_pid = buffer_read(receive_buffer, buffer_u8);
        var victim_pid = buffer_read(receive_buffer, buffer_u8);

        var victim = find_instance_by_network_id(oPlayer, victim_pid);
        if (instance_exists(victim)) {
            with (victim) {
                stats.Health_points = 0;
                death_from_server = true;
                death_attacker_pid = attacker_pid;
            }
        }
    }
}

function handle_player_respawn_client() {
    with (oNetworkManager) {
        var player_pid = buffer_read(receive_buffer, buffer_u8);
        var new_hp = buffer_read(receive_buffer, buffer_f16);

        var player = find_instance_by_network_id(oPlayer, player_pid);
		
		if(player_pid == my_pid){
			oDraw.RespawnMenu = false;
			with(objUIBlack){zui_destroy();}
			with(objUIWindow){ zui_destroy();}
		}
        if (instance_exists(player)) {
            with (player) {
                stats.Health_points = new_hp;
                death_from_server = false;
				x = respawn_x;
				y = respawn_y;
				depth = 100;
            }
		}
	}
}

function handle_object_pos_sync_client() {
    with (oNetworkManager) {
        var count = buffer_read(receive_buffer, buffer_u16);

        for (var i = 0; i < count; i++) {
            var net_id = buffer_read(receive_buffer, buffer_u16);
            var x_pos  = buffer_read(receive_buffer, buffer_f16);
            var y_pos  = buffer_read(receive_buffer, buffer_f16);

            var inst = find_instance_by_network_id(oItems, net_id);

            if (instance_exists(inst)) {
                with (inst) {
                    target_x = x_pos;
                    target_y = y_pos;
                }
            }
        }
    }
}

function handle_object_sync_client() {
    with (oNetworkManager) {
        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case 0: { // create
                var net_id  = buffer_read(receive_buffer, buffer_u16);
                var o_index = buffer_read(receive_buffer, buffer_u16);
                var x_pos   = buffer_read(receive_buffer, buffer_f16);
                var y_pos   = buffer_read(receive_buffer, buffer_f16);
                var img_idx = buffer_read(receive_buffer, buffer_u8);
				var scope = buffer_read(receive_buffer, buffer_u8);
				var barrel = buffer_read(receive_buffer, buffer_u8);
				var grip = buffer_read(receive_buffer, buffer_u8);
				var suppressor = buffer_read(receive_buffer, buffer_u8);
				var clip_ammo = buffer_read(receive_buffer, buffer_u16);
				var ammo = buffer_read(receive_buffer, buffer_u8);
				var durability = buffer_read(receive_buffer, buffer_f16);
				var amount  = buffer_read(receive_buffer, buffer_u8);

                var inst = instance_create_layer(x_pos, y_pos, "ItemsO", o_index);
                inst.network_id = net_id;
                inst.image_index = img_idx;
				inst.scope_attachment = scope;
				inst.barrel_attachment = barrel;
				inst.grip_attachment = grip;
				inst.suppressor_attachment = suppressor;
				inst.ClipAmmo = clip_ammo;
				inst.Ammo = ammo;
				inst.Durability = durability;
				inst.Amount = amount;
                break;
            }
            case 1: { // destroy
                var net_id_destroy = buffer_read(receive_buffer, buffer_u16);
				var obj_ind_destroy = buffer_read(receive_buffer, buffer_u16);
                var inst_destroy = find_instance_by_network_id(oItems, net_id_destroy);

                if (instance_exists(inst_destroy)) {
                    instance_destroy(inst_destroy);
                }
                break;
            }
        }
    }
}

function handle_init_sync_client() {
    with (oNetworkManager) {	
		/// Itemy
        var count = buffer_read(receive_buffer, buffer_u16);
        for (var i = 0; i < count; i++) {
            var net_id  = buffer_read(receive_buffer, buffer_u16);
            var o_index = buffer_read(receive_buffer, buffer_u16);
            var x_pos   = buffer_read(receive_buffer, buffer_f16);
            var y_pos   = buffer_read(receive_buffer, buffer_f16);
            var img_idx = buffer_read(receive_buffer, buffer_u8);
			var scope = buffer_read(receive_buffer, buffer_u8);
			var barrel = buffer_read(receive_buffer, buffer_u8);
			var grip = buffer_read(receive_buffer, buffer_u8);
			var suppressor = buffer_read(receive_buffer, buffer_u8);
			var clip_ammo = buffer_read(receive_buffer, buffer_u16);
			var ammo = buffer_read(receive_buffer, buffer_u8);
			var durability = buffer_read(receive_buffer, buffer_f16);
			var amount = buffer_read(receive_buffer, buffer_u8);

            var inst = instance_create_layer(x_pos, y_pos, "ItemsO", o_index);
            inst.network_id = net_id;
            inst.image_index = img_idx;
			inst.scope_attachment = scope;
			inst.barrel_attachment = barrel;
			inst.grip_attachment = grip;
			inst.suppressor_attachment = suppressor;
			inst.ClipAmmo = clip_ammo;
			inst.Ammo = ammo;
			inst.Durability = durability;
			inst.Amount = amount;
        }

		// Weather
        global.Weather = buffer_read(receive_buffer, buffer_u8);

		// Hráči
        var player_count = buffer_read(receive_buffer, buffer_u8);
        for (var i = 0; i < player_count; i++) {
            var pid        = buffer_read(receive_buffer, buffer_u8);
            var helmet_id  = buffer_read(receive_buffer, buffer_u8);
            var helmet_dur = buffer_read(receive_buffer, buffer_f16);
            var armour_id  = buffer_read(receive_buffer, buffer_u8);
            var armour_dur = buffer_read(receive_buffer, buffer_f16);
            var weapon_id  = buffer_read(receive_buffer, buffer_u8);

            if (pid == my_pid) continue;

            // ulož vše do player_states
            var player_data = ds_map_find_value(player_states, pid);
            if (is_undefined(player_data)) {
                player_data = ds_map_create();
                ds_map_add(player_states, pid, player_data);
            }
            ds_map_set(player_data, "helmet_id",  helmet_id);
            ds_map_set(player_data, "helmet_dur", helmet_dur);
            ds_map_set(player_data, "armour_id",  armour_id);
            ds_map_set(player_data, "armour_dur", armour_dur);
            ds_map_set(player_data, "weapon_id",  weapon_id);

            var p = find_instance_by_network_id(oPlayer, pid);
            if (instance_exists(p)) {
                with (p) {
                    network_helmet_id  = helmet_id;
                    network_helmet_dur = helmet_dur;
                    network_armour_id  = armour_id;
                    network_armour_dur = armour_dur;
                    network_weapon_id  = weapon_id;
                }
            }
        }
    }
}

function send_ping_request() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;

        ping_send_time = current_time;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PING);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 0); // request
        buffer_write(send_buffer, buffer_u32, ping_send_time);

        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_ping_response_client() {
    with (oNetworkManager) {
        var ping_type = buffer_read(receive_buffer, buffer_u8);
        var sent_timestamp = buffer_read(receive_buffer, buffer_u32);

        if (ping_type == 1) {
            ping_ms = max(0, current_time - sent_timestamp);
        }
    }
}


function send_player_respawn_request() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
		oDraw.RespawnMenu = false;
		with(objUIBlack){zui_destroy();}
		with(objUIWindow){ zui_destroy();}
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PLAYER_RESPAWN);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, my_pid);

        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function send_request_init() {
    with (oNetworkManager) {

        if (!is_connected || client_socket < 0) return;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.REQUEST_INIT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);

        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_hit_client() {
	with (oNetworkManager) {
		var attacker_pid = buffer_read(receive_buffer, buffer_u8);
		var victim_pid   = buffer_read(receive_buffer, buffer_u8);
		var damage       = buffer_read(receive_buffer, buffer_f16);
		var hitbox_type    = buffer_read(receive_buffer, buffer_u8);
		var impact_x     = buffer_read(receive_buffer, buffer_f16);
		var impact_y     = buffer_read(receive_buffer, buffer_f16);
		var hit_spd_mod  = buffer_read(receive_buffer, buffer_f16);
		var aimpunch_modifier = buffer_read(receive_buffer, buffer_f16);
		var armour_dur = buffer_read(receive_buffer, buffer_f16);
		var helmet_dur = buffer_read(receive_buffer, buffer_f16);

		var victim = find_instance_by_network_id(oPlayer, victim_pid);
		if (instance_exists(victim)) {
			hit_remote_object(damage, victim, hitbox_type, [impact_x, impact_y], hit_spd_mod, aimpunch_modifier, [armour_dur, helmet_dur], attacker_pid);
		}
	}
}

function handle_connect_accept() {
    with (oNetworkManager) {
        my_pid = buffer_read(receive_buffer, buffer_u8);
        is_connected = true;
        show_debug_message("Connected! My player ID: " + string(my_pid));
        room_goto(rm_ServerTest);
    }
}

function handle_tick_update_client() {
    with (oNetworkManager) {
        var player_count = buffer_read(receive_buffer, buffer_u8);
        
        for (var i = 0; i < player_count; i++) {
            var pid = buffer_read(receive_buffer, buffer_u8);
            var x_pos = buffer_read(receive_buffer, buffer_f16);
            var y_pos = buffer_read(receive_buffer, buffer_f16);
            var direction_facing = buffer_read(receive_buffer, buffer_f16);
			var bit_states = buffer_read(receive_buffer, buffer_u8);
			var hp = buffer_read(receive_buffer, buffer_f16);
			
            
            // Přeskoč lokálního hráče
            if (pid == my_pid) {continue;}
            
            // Update or create remote player
            var player = find_instance_by_network_id(oPlayer, pid);   
            if (player == noone) {
                player = create_remote_player(pid, x_pos, y_pos);
            }
            
            if (instance_exists(player)) {
                with (player) {
                    target_x = x_pos;
                    target_y = y_pos;
                    target_direction = direction_facing;    
                    network_bit_state = bit_states;
					if(!is_undefined(stats)){
						stats.Health_points = hp;
					}
                }
            }
        }
		oLightRenderer.tickCounter = buffer_read(receive_buffer, buffer_u8);
		oLightRenderer.CurrentHour = buffer_read(receive_buffer, buffer_u8);
		oLightRenderer.CurrentMinute = buffer_read(receive_buffer, buffer_u8);
    }
}

function handle_equipment_update_client() {
    with (oNetworkManager) {
        var player_count = buffer_read(receive_buffer, buffer_u8);
        
        for (var i = 0; i < player_count; i++) {
            var pid = buffer_read(receive_buffer, buffer_u8);
            var helmet_id  = buffer_read(receive_buffer, buffer_u8);
            var helmet_dur = buffer_read(receive_buffer, buffer_f16);
            var armour_id  = buffer_read(receive_buffer, buffer_u8);
            var armour_dur = buffer_read(receive_buffer, buffer_f16);
            
            // Skip local player (we already have our own equipment)
            if (pid == my_pid) {continue;}
            
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
            var player = find_instance_by_network_id(oPlayer, pid);
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

function handle_weapon_update_client() {
    with (oNetworkManager) {
        var player_count = buffer_read(receive_buffer, buffer_u8);
        
        for (var i = 0; i < player_count; i++) {
            var pid = buffer_read(receive_buffer, buffer_u8);
            var weapon_id  = buffer_read(receive_buffer, buffer_u8);
            
            // Přeskoč local player (víme weapon)
            if (pid == my_pid) {continue;}
            
			//Uložíme weapon_id na serveru pro PID hráče
            var player_data = ds_map_find_value(player_states, pid);
            if (is_undefined(player_data)) {
                player_data = ds_map_create();
                ds_map_add(player_states, pid, player_data);
            }
            ds_map_set(player_data, "weapon_id", weapon_id);
            
            // Update remote player
            var player = find_instance_by_network_id(oPlayer, pid);
            if (instance_exists(player)) {
                with (player) {
                    network_weapon_id = weapon_id;
                }
            }
        }
    }
}

function send_equipment_update_client() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        var player = find_instance_by_network_id(oPlayer, my_pid);
        if (!instance_exists(player)) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.EQUIP_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        with (player) {
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# OtherSlot.Helmet, Index.slot_id]);
            buffer_write(other.send_buffer, buffer_f16, global.Inventory[# OtherSlot.Helmet, Index.slot_durability]);
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# OtherSlot.Armour, Index.slot_id]);
            buffer_write(other.send_buffer, buffer_f16, global.Inventory[# OtherSlot.Armour, Index.slot_durability]);
        }
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function send_weapon_update_client() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        var player = find_instance_by_network_id(oPlayer, my_pid);
        if (!instance_exists(player)) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.WEAPON_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        with (player) {
            buffer_write(other.send_buffer, buffer_u16, global.Inventory[# WeaponID, Index.slot_id]);
        }
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function send_tick_update_client() {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;
        
        var player = find_instance_by_network_id(oPlayer, my_pid);
        if (!instance_exists(player)) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.TICK_UPDATE);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        with (player) {
            buffer_write(other.send_buffer, buffer_f16, x);
            buffer_write(other.send_buffer, buffer_f16, y);
            buffer_write(other.send_buffer, buffer_f16, RotationAngle);
			
			var bit_states = 0;
			if(global.GodMode == true){bit_states |= PLAYER_FLAGS.GODMODE;}
			if(Moving == true){bit_states |= PLAYER_FLAGS.MOVING;}
			if(Reloading == true){bit_states |= PLAYER_FLAGS.RELOADING; }
			if(Flashed == true){bit_states |= PLAYER_FLAGS.FLASHED; }
				
			buffer_write(other.send_buffer, buffer_u8, bit_states);
			buffer_write(other.send_buffer, buffer_f16, stats.Health_points);
        }
        
        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_weather_update_client(){
    with (oNetworkManager) {
        global.Weather = buffer_read(receive_buffer, buffer_u8);
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
        var pid = buffer_read(receive_buffer, buffer_u8);
        
        show_debug_message("Player " + string(pid) + " disconnected");
        
        // Remove player object
        with (oPlayer) {
            if (network_id == pid) {
				instance_destroy(Weapon);
                instance_destroy();
            }
        }
    }
}

function handle_hit_packet_client() {
    with (oNetworkManager) {
        var attacker_pid = buffer_read(receive_buffer, buffer_u8);
        var victim_pid   = buffer_read(receive_buffer, buffer_u8);
        var damage       = buffer_read(receive_buffer, buffer_f16);
        var hitbox_type    = buffer_read(receive_buffer, buffer_u8);
        var impact_x     = buffer_read(receive_buffer, buffer_f16);
        var impact_y     = buffer_read(receive_buffer, buffer_f16);
		var aimpunch_modifier = buffer_read(receive_buffer, buffer_f16);
		var armour_dur = buffer_read(send_buffer, buffer_f16);
		var helmet_dur = buffer_read(send_buffer, buffer_f16);

        if (victim_pid != my_pid) {
            return;
        }

        var player = find_instance_by_network_id(oPlayer, my_pid);
        if (instance_exists(player)) {
			hit_remote_object(damage, player, hitbox_type, [impact_x, impact_y], hit_spd_mod, aimpunch_modifier, [armour_dur, helmet_dur], attacker_pid);
        }
    }
}