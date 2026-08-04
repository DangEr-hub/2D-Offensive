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
        buffer_seek(receive_buffer, buffer_seek_start, 0);
        var packet_type = buffer_read(receive_buffer, buffer_u8);
        var sequence = buffer_read(receive_buffer, buffer_u32);

        var key = sender_ip + ":" + string(sender_port);
        ds_map_set(client_timeout, key, current_time);

        switch (packet_type) {
            case PACKET.CONNECT_REQUEST: handle_connect_request(sender_ip, sender_port); break;

            case PACKET.TICK_UPDATE: handle_tick_update_server(key); break;

            case PACKET.PROJECTILE_SPAWN: handle_projectile_spawn_server(key); break;

			case PACKET.OBJECT_SYNC: handle_object_sync_server(key); break;

            case PACKET.HEARTBEAT: break;
				
			case PACKET.EQUIP_SYNC: handle_equipment_update_server(key); break;

            case PACKET.DISCONNECT: handle_client_disconnect(key); break;

            case PACKET.HIT: handle_hit_server(key); break;
			
			case PACKET.WEAPON_SYNC: handle_weapon_update_server(key); break;
			
			case PACKET.REQUEST_INIT: handle_init_sync_server(key); break;
			
			case PACKET.PLAYER_RESPAWN: handle_player_respawn_server(key); break;
			
			case PACKET.PING: handle_ping_server(sender_ip, sender_port); break;
			
			case PACKET.BIRD_SYNC: handle_bird_sync_server(key); break;

			case PACKET.GRENADE_SYNC: handle_grenade_sync_server(key); break;

			case PACKET.AIRPLANE_SYNC: handle_airplane_sync_server(key); break;
			
			
		
			//case PACKET.WEATHER_SYNC: handle_weather_sync_server(key); break;
        }
    }
}

function handle_bird_sync_server(socket_key) {
	/* Funkce pokud client zabije ptáka u sebe */
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_key)) return;

        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case 1:
                var bird_id = buffer_read(receive_buffer, buffer_u8);
				var damage = buffer_read(receive_buffer, buffer_f16);
                var inst = find_instance_by_network_id(oBird, bird_id);

                if (instance_exists(inst)) {
                    server_process_bird_death(inst, damage);
                }/* else {
                    ds_map_delete(bird_registry, bird_id);
					
					/// broadcast
					if(is_server){
		
					    buffer_seek(send_buffer, buffer_seek_start, 0);
					    buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
					    buffer_write(send_buffer, buffer_u32, send_sequence++);
					    buffer_write(send_buffer, buffer_u8, 1); // destroy
					    buffer_write(send_buffer, buffer_u8, bird_id);	
						buffer_write(send_buffer, buffer_f16, damage);
					
				        var first_socket_key = ds_map_find_first(clients);
				        for (var i = 0; i < ds_map_size(clients); i++) {
				            sent_server_udp(server_socket, first_socket_key, send_buffer);
				            first_socket_key = ds_map_find_next(clients, first_socket_key);
				        }
					}
                }*/
            break;
        }
    }
}

function server_process_bird_death(bird_inst, damage, make_snd = true){
    with (oNetworkManager) {
        if (!is_server) return;
		
		net_id = bird_inst.network_id;

        if (!is_undefined(net_id)) {
            ds_map_delete(bird_registry, net_id);
		    if (net_id >= 0) {
		        ds_stack_push(free_bird_ids, net_id);
		    }
			
			/// broadcast
	        buffer_seek(send_buffer, buffer_seek_start, 0);
	        buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
	        buffer_write(send_buffer, buffer_u32, send_sequence++);
	        buffer_write(send_buffer, buffer_u8, 1); // destroy
	        buffer_write(send_buffer, buffer_u8, net_id);	
			buffer_write(send_buffer, buffer_f16, damage);
			buffer_write(send_buffer, buffer_u8, make_snd);
	        var socket_key = ds_map_find_first(clients);
	        for (var i = 0; i < ds_map_size(clients); i++) {
	            sent_server_udp(server_socket, socket_key, send_buffer);
	            socket_key = ds_map_find_next(clients, socket_key);
	        }
        }
    }
	
	if(make_snd == true){
		var BloodSplashNumber = round(damage / 5);
		var BloodParticleNumber = round(damage / 2);
		create_blood(BloodSplashNumber, bird_inst.x, bird_inst.y, c_red, BloodParticleNumber);
	
		play_sound(x, y, snd_BirdDeath, find_instance_by_network_id(oPlayer, oNetworkManager.my_pid));
	}
    instance_destroy(bird_inst);
}

function server_process_bird_change(bird_inst, action) {
    with (oNetworkManager) {
        if (!is_server) return;

        if (bird_inst.network_id < 0) {
            bird_inst.network_id = compute_bird_network_id();
        }

        ds_map_set(bird_registry, bird_inst.network_id, [bird_inst.state, bird_inst.x, bird_inst.y, bird_inst.direction, bird_inst.speed, bird_inst.alarm[0],
		bird_inst.move_timer, bird_inst.move_pos[0], bird_inst.move_pos[1]]);

		switch(action){
			case 0:
		        buffer_seek(send_buffer, buffer_seek_start, 0);
		        buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
		        buffer_write(send_buffer, buffer_u32, send_sequence++);
		        buffer_write(send_buffer, buffer_u8, 0); // spawn
		        buffer_write(send_buffer, buffer_u8, bird_inst.network_id);
				buffer_write(send_buffer, buffer_u8, bird_inst.state);
		        buffer_write(send_buffer, buffer_f16, bird_inst.x);
		        buffer_write(send_buffer, buffer_f16, bird_inst.y);
				buffer_write(send_buffer, buffer_f16, bird_inst.direction);
				buffer_write(send_buffer, buffer_f16, bird_inst.speed);
				buffer_write(send_buffer, buffer_s16, bird_inst.alarm[0]);
			break;
		
			case 2:
		        buffer_seek(send_buffer, buffer_seek_start, 0);
		        buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
		        buffer_write(send_buffer, buffer_u32, send_sequence++);
		        buffer_write(send_buffer, buffer_u8, 2); // change state
		        buffer_write(send_buffer, buffer_u8, bird_inst.network_id);
				buffer_write(send_buffer, buffer_u8, bird_inst.state);
				buffer_write(send_buffer, buffer_f16, bird_inst.direction);
				buffer_write(send_buffer, buffer_f16, bird_inst.speed);
				buffer_write(send_buffer, buffer_s16, bird_inst.alarm[0]);
			break;
			
			case 3:
		        buffer_seek(send_buffer, buffer_seek_start, 0);
		        buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
		        buffer_write(send_buffer, buffer_u32, send_sequence++);
		        buffer_write(send_buffer, buffer_u8, 3); // movement update
		        buffer_write(send_buffer, buffer_u8, bird_inst.network_id);
		        buffer_write(send_buffer, buffer_s16, bird_inst.move_timer);
		        buffer_write(send_buffer, buffer_f16, bird_inst.move_pos[0]);
		        buffer_write(send_buffer, buffer_f16, bird_inst.move_pos[1]);
			break;

			case 4:
		        buffer_seek(send_buffer, buffer_seek_start, 0);
		        buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
		        buffer_write(send_buffer, buffer_u32, send_sequence++);
		        buffer_write(send_buffer, buffer_u8, 4); // full update
		        buffer_write(send_buffer, buffer_u8, bird_inst.network_id);
				buffer_write(send_buffer, buffer_u8, bird_inst.state);
		        buffer_write(send_buffer, buffer_f16, bird_inst.x);
		        buffer_write(send_buffer, buffer_f16, bird_inst.y);
				buffer_write(send_buffer, buffer_f16, bird_inst.direction);
				buffer_write(send_buffer, buffer_f16, bird_inst.speed);
				buffer_write(send_buffer, buffer_s16, bird_inst.alarm[0]);
		        buffer_write(send_buffer, buffer_s16, bird_inst.move_timer);
		        buffer_write(send_buffer, buffer_f16, bird_inst.move_pos[0]);
		        buffer_write(send_buffer, buffer_f16, bird_inst.move_pos[1]);
			break;
		
		}

		// broadcast
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function handle_airplane_sync_server(socket_key) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_key)) return;

        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case AIRPLANE_SYNC_ACTION.REQUEST_DAMAGE:
                var net_id = buffer_read(receive_buffer, buffer_u16);
                var damage = buffer_read(receive_buffer, buffer_f16);
                var hit_x = buffer_read(receive_buffer, buffer_f16);
                var hit_y = buffer_read(receive_buffer, buffer_f16);
                var plane = find_instance_by_network_id(oAirPlane, net_id);
                if (instance_exists(plane)) {
                    server_process_airplane_damage(plane, damage, hit_x, hit_y);
                }
            break;
        }
    }
}

function server_process_airplane_spawn(airplane_inst) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(airplane_inst)) return;

        if (airplane_inst.network_id < 0) {
            airplane_inst.network_id = compute_airplane_network_id();
        }

        airplane_inst.network_authority = true;
        ds_map_set(airplane_registry, airplane_inst.network_id, [
            airplane_inst.x,
            airplane_inst.y,
            airplane_inst.direction,
            airplane_inst.stats.Health_points,
            airplane_inst.alarm[0],
            airplane_inst.base_spd
        ]);

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.AIRPLANE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, AIRPLANE_SYNC_ACTION.SPAWN);
        buffer_write(send_buffer, buffer_u16, airplane_inst.network_id);
        buffer_write(send_buffer, buffer_f16, airplane_inst.x);
        buffer_write(send_buffer, buffer_f16, airplane_inst.y);
        buffer_write(send_buffer, buffer_f16, airplane_inst.direction);
        buffer_write(send_buffer, buffer_f16, airplane_inst.stats.Health_points);
        buffer_write(send_buffer, buffer_s16, airplane_inst.alarm[0]);
        buffer_write(send_buffer, buffer_f16, airplane_inst.base_spd);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_process_airplane_update(airplane_inst) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(airplane_inst) || airplane_inst.network_id < 0) return;

        ds_map_set(airplane_registry, airplane_inst.network_id, [
            airplane_inst.x,
            airplane_inst.y,
            airplane_inst.direction,
            airplane_inst.stats.Health_points,
            airplane_inst.alarm[0],
            airplane_inst.base_spd
        ]);

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.AIRPLANE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, AIRPLANE_SYNC_ACTION.UPDATE);
        buffer_write(send_buffer, buffer_u16, airplane_inst.network_id);
        buffer_write(send_buffer, buffer_f16, airplane_inst.x);
        buffer_write(send_buffer, buffer_f16, airplane_inst.y);
        buffer_write(send_buffer, buffer_f16, airplane_inst.direction);
        buffer_write(send_buffer, buffer_f16, airplane_inst.stats.Health_points);
        buffer_write(send_buffer, buffer_s16, airplane_inst.alarm[0]);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_process_airplane_destroy(airplane_inst, explode_visual) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(airplane_inst)) return;

        var net_id = airplane_inst.network_id;
        var plane_x = airplane_inst.x;
        var plane_y = airplane_inst.y;
        var damage = airplane_inst.stats.Damage;
        var item_id = airplane_inst.stats.Item_id;

        if (net_id >= 0) {
            ds_map_delete(airplane_registry, net_id);
            if (free_airplane_ids != -1 && ds_exists(free_airplane_ids, ds_type_stack)) {
                ds_stack_push(free_airplane_ids, net_id);
            }
        }

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.AIRPLANE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, AIRPLANE_SYNC_ACTION.DESTROY);
        buffer_write(send_buffer, buffer_u16, net_id);
        buffer_write(send_buffer, buffer_u8, explode_visual);
        buffer_write(send_buffer, buffer_f16, plane_x);
        buffer_write(send_buffer, buffer_f16, plane_y);
        buffer_write(send_buffer, buffer_u16, item_id);
        buffer_write(send_buffer, buffer_f16, damage);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_process_airplane_damage(airplane_inst, damage, hit_x, hit_y) {
    if (!instance_exists(airplane_inst)) return;

    damage = clamp(damage, 0, 250);
    if (damage <= 0) return;

    with (airplane_inst) {
        var p_number = round(damage / 10);
        play_sound(hit_x, hit_y, snd_BulletMetal);
        part_particles_create(global.ParticleSystem, hit_x, hit_y, oParticleSystem.Spark, p_number);
        part_particles_create(global.ParticleSystem, hit_x, hit_y, oParticleSystem.headshot_particle, p_number);
        damage_indicator("-" + string(damage), hit_x, hit_y, c_white, spr_Icons, ICON.health);
        stats.Health_points = max(stats.Health_points - damage, 0);
    }

    server_process_airplane_update(airplane_inst);
}

function server_process_airplane_bomb_spawn(missile_inst, airplane_inst) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(missile_inst)) return;

        if (missile_inst.network_id < 0) {
            missile_inst.network_id = compute_airplane_network_id();
        }

        missile_inst.network_authority = true;
        missile_inst.network_visual_only = false;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.AIRPLANE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, AIRPLANE_SYNC_ACTION.BOMB_SPAWN);
        buffer_write(send_buffer, buffer_u16, missile_inst.network_id);
        buffer_write(send_buffer, buffer_u16, instance_exists(airplane_inst) ? airplane_inst.network_id : 65535);
        buffer_write(send_buffer, buffer_f16, missile_inst.x);
        buffer_write(send_buffer, buffer_f16, missile_inst.y);
        buffer_write(send_buffer, buffer_u16, missile_inst.stats.Item_id);
        buffer_write(send_buffer, buffer_f16, missile_inst.stats.Damage);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_process_airplane_bomb_explode(missile_inst) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(missile_inst) || missile_inst.bomb_explosion_broadcasted) return;

        missile_inst.bomb_explosion_broadcasted = true;
        var exp_pos = [missile_inst.x, missile_inst.y];

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.AIRPLANE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, AIRPLANE_SYNC_ACTION.BOMB_EXPLODE);
        buffer_write(send_buffer, buffer_u16, missile_inst.network_id);
        buffer_write(send_buffer, buffer_f16, exp_pos[0]);
        buffer_write(send_buffer, buffer_f16, exp_pos[1]);
        buffer_write(send_buffer, buffer_u16, missile_inst.stats.Item_id);
        buffer_write(send_buffer, buffer_f16, missile_inst.stats.Damage);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function handle_connect_request(sender_ip, sender_port) {
    with (oNetworkManager) {
        var client_key = sender_ip + ":" + string(sender_port);
        var pid = -1;

        if (ds_map_exists(clients, client_key)) {
            pid = ds_map_find_value(clients, client_key);
        } else {
            for (var candidate_pid = 1; candidate_pid <= max_clients; candidate_pid++) {
                var pid_used = false;
                var clients_count = ds_map_size(clients);

                if (clients_count > 0) {
                    var key = ds_map_find_first(clients);
                    for (var i = 0; i < clients_count; i++) {
                        if (ds_map_find_value(clients, key) == candidate_pid) {
                            pid_used = true;
                            break;
                        }
                        key = ds_map_find_next(clients, key);
                    }
                }

                if (!pid_used) {
                    pid = candidate_pid;
                    break;
                }
            }

            if (pid == -1) {
                show_debug_message("Connection rejected: server is full");
                return;
            }

            ds_map_add(clients, client_key, pid);
        }

        ds_map_set(client_timeout, client_key, current_time);

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.CONNECT_ACCEPT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, pid);
        network_send_udp(server_socket, sender_ip, sender_port, send_buffer, buffer_tell(send_buffer));
    }
}

function server_player_display_name(pid) {
	var player = find_instance_by_network_id(oPlayer, pid);
	if (instance_exists(player)) {
		return player.stats.Name;
	}

	return "Player " + string(pid);
}

function server_item_display_name(item_id) {
	if (!is_undefined(item_id) && item_id > Item.None && item_id < Item.Total) {
		return global.ItemIndex[# item_id, ItemStat.Name];
	}

	return "Unknown";
}

function player_respawn_broadcast(player_pid, hp, respawn_pos_x, respawn_pos_y) {
        with (oNetworkManager) {
                buffer_seek(send_buffer, buffer_seek_start, 0);
                buffer_write(send_buffer, buffer_u8, PACKET.PLAYER_RESPAWN);
                buffer_write(send_buffer, buffer_u32, send_sequence++);
                buffer_write(send_buffer, buffer_u8, player_pid);
				buffer_write(send_buffer, buffer_f16, hp);
				buffer_write(send_buffer, buffer_f16, respawn_pos_x);
				buffer_write(send_buffer, buffer_f16, respawn_pos_y);

                var socket_key = ds_map_find_first(clients);
                for (var i = 0; i < ds_map_size(clients); i++) {
                        sent_server_udp(server_socket, socket_key, send_buffer);
                        socket_key = ds_map_find_next(clients, socket_key);
                }
        }
}

function process_server_respawn(){
	/* Host hráč má PID=0 */
    with (oNetworkManager){
        var player_data = ds_map_find_value(player_states, 0);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, 0, player_data);
        }

        ds_map_set(player_data, "hp", global.player_stats_struct.Max_health);

        var p = find_instance_by_network_id(oPlayer, 0);		
		var spawn_x = 0;
		var spawn_y = 0;
		oDraw.RespawnMenu = false;
		with(objUIBlack){zui_destroy();}
		with(objUIWindow){ zui_destroy();}
        if (instance_exists(p)) {
            spawn_x = p.respawn_x;
            spawn_y = p.respawn_y;
            with (p) {
                stats.Health_points = global.player_stats_struct.Max_health;
                death_from_server = false;
                death_attacker_pid = -1;
                KilledByName = "No one";
                KilledByWeapon = "Nothing";
                x = spawn_x;
                y = spawn_y;
                target_x = spawn_x;
                target_y = spawn_y;
                depth = 100;
            }
        }
        ds_map_set(player_data, "x", spawn_x);
        ds_map_set(player_data, "y", spawn_y);
        ds_map_set(player_data, "state", 0);

        player_respawn_broadcast(0, global.player_stats_struct.Max_health, spawn_x, spawn_y);
    }
}

function handle_ping_server(sender_ip, sender_port) {
    with (oNetworkManager) {
        var ping_type = buffer_read(receive_buffer, buffer_u8); // 0=request, 1=response
        var client_timestamp = buffer_read(receive_buffer, buffer_u32);

        if (ping_type == 0) {
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, PACKET.PING);
            buffer_write(send_buffer, buffer_u32, send_sequence++);
            buffer_write(send_buffer, buffer_u8, 1); // response
            buffer_write(send_buffer, buffer_u32, client_timestamp);

            network_send_udp(server_socket, sender_ip, sender_port, send_buffer, buffer_tell(send_buffer));
        }
    }
}

function handle_player_respawn_server(socket_key) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_key)) return;

        var pid_claim = buffer_read(receive_buffer, buffer_u8);
        var pid = ds_map_find_value(clients, socket_key);
        if (pid < 0) {
			pid = pid_claim;
        }

        var player_data = ds_map_find_value(player_states, pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, pid, player_data);
        }

        ds_map_set(player_data, "hp", global.player_stats_struct.Max_health);

        var player_obj = find_instance_by_network_id(oPlayer, pid);
        var spawn_x = server_player_state_value(pid, "x", 0);
        var spawn_y = server_player_state_value(pid, "y", 0);
        if (instance_exists(player_obj)) {
            spawn_x = player_obj.respawn_x;
            spawn_y = player_obj.respawn_y;
            with (player_obj) {
                stats.Health_points = global.player_stats_struct.Max_health;
                death_from_server = false;
                death_attacker_pid = -1;
                KilledByName = "No one";
                KilledByWeapon = "Nothing";
				x = spawn_x;
				y = spawn_y;
                target_x = spawn_x;
                target_y = spawn_y;
				depth = 100;
            }
        }
        ds_map_set(player_data, "x", spawn_x);
        ds_map_set(player_data, "y", spawn_y);
        ds_map_set(player_data, "state", 0);

        player_respawn_broadcast(pid, global.player_stats_struct.Max_health, spawn_x, spawn_y);
    }
}

function server_get_player_state(pid) {
    with (oNetworkManager) {
        var player_data = ds_map_find_value(player_states, pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, pid, player_data);
        }
        return player_data;
    }
}

function server_valid_weapon_id(item_id) {
    if (is_undefined(item_id)) return false;
    return (item_id > Item.None && item_id < Item.Total && global.ItemIndex[# item_id, ItemStat.Type] == "Weapon");
}

function server_valid_server_damage_item(item_id) {
    if (is_undefined(item_id) || item_id <= Item.None || item_id >= Item.Total) return false;

    var item_type = global.ItemIndex[# item_id, ItemStat.Type];
    return (item_type == "Weapon" || item_type == "Grenade" || item_type == "Landmine");
}

function server_reload_duration_ms(item_id) {
    return max(1, global.ItemIndex[# item_id, ItemStat.ReloadSpeed]) * (1000 / game_get_speed(gamespeed_fps));
}

function server_shoot_interval_ms(pid, item_id) {
    var adaptive = 1;
    var barrel = server_player_state_value(pid, "weapon_barrel", Item.None);
    if (barrel != Item.None) {
        adaptive = global.ItemIndex[# barrel, ItemStat.ShootTimer];
    }

    var interval_frames = max(1, global.ItemIndex[# item_id, ItemStat.ShootTimer] * adaptive);
    var shooting_modes = global.ItemIndex[# item_id, ItemStat.ShootingMode];
    if (!is_undefined(shooting_modes) && ds_exists(shooting_modes, ds_type_list) && ds_list_find_index(shooting_modes, "Burst") != -1) {
        interval_frames = min(interval_frames, max(interval_frames / 2, 5));
    }

    return interval_frames * (1000 / game_get_speed(gamespeed_fps));
}

function server_complete_reload(player_data, item_id) {
    if (!server_valid_weapon_id(item_id)) return;

    var max_ammo = global.ItemIndex[# item_id, ItemStat.MaxAmmo];
    if (max_ammo <= 0) return;

    var ammo = ds_map_find_value(player_data, "weapon_ammo");
    var clip_ammo = ds_map_find_value(player_data, "weapon_clip_ammo");
    if (is_undefined(ammo)) ammo = max_ammo;
    if (is_undefined(clip_ammo)) clip_ammo = 0;

    ammo = clamp(ammo, 0, max_ammo);
    clip_ammo = max(clip_ammo, 0);

    if (ammo < max_ammo && clip_ammo > 0) {
        if (global.ItemIndex[# item_id, ItemStat.BaseDurability] != 1) {
            var ammo_needed = max_ammo - ammo;
            var ammo_loaded = min(ammo_needed, clip_ammo);
            ammo += ammo_loaded;
            clip_ammo -= ammo_loaded;
        } else {
            ammo += 1;
            clip_ammo -= 1;
        }
    }

    ds_map_set(player_data, "weapon_ammo", ammo);
    ds_map_set(player_data, "weapon_clip_ammo", clip_ammo);
    ds_map_set(player_data, "weapon_reloading", false);
    ds_map_set(player_data, "weapon_reload_until", -1);
}

function server_update_reload_state(pid, state_flags) {
    with (oNetworkManager) {
        var player_data = server_get_player_state(pid);
        var item_id = ds_map_find_value(player_data, "weapon_id");
        if (is_undefined(item_id) || !server_valid_weapon_id(item_id)) return;

        var is_reloading_client = (state_flags & PLAYER_FLAGS.RELOADING) != 0;
        var is_reloading_server = ds_map_find_value(player_data, "weapon_reloading");
        var reload_until = ds_map_find_value(player_data, "weapon_reload_until");
        if (is_undefined(is_reloading_server)) is_reloading_server = false;
        if (is_undefined(reload_until)) reload_until = -1;

        if (is_reloading_server && reload_until >= 0 && current_time + 100 >= reload_until) {
            server_complete_reload(player_data, item_id);
            is_reloading_server = false;
            reload_until = -1;
        }

        if (is_reloading_client) {
            var max_ammo = global.ItemIndex[# item_id, ItemStat.MaxAmmo];
            var ammo = ds_map_find_value(player_data, "weapon_ammo");
            var clip_ammo = ds_map_find_value(player_data, "weapon_clip_ammo");
            if (is_undefined(ammo)) ammo = max_ammo;
            if (is_undefined(clip_ammo)) clip_ammo = 0;

            if (!is_reloading_server && ammo < max_ammo && clip_ammo > 0) {
                ds_map_set(player_data, "weapon_reloading", true);
                ds_map_set(player_data, "weapon_reload_until", current_time + server_reload_duration_ms(item_id));
            }
        } else if (is_reloading_server) {
            ds_map_set(player_data, "weapon_reloading", false);
            ds_map_set(player_data, "weapon_reload_until", -1);
        }
    }
}

function server_register_projectile(pid, projectile_id, item_id) {
    with (oNetworkManager) {
        if (projectile_id < 0) return false;
        if (ds_map_exists(projectiles_seen, projectile_id)) return false;

        ds_map_set(projectiles_seen, projectile_id, {
            owner_pid: pid,
            item_id: item_id,
            created_at: current_time,
            hits: 0
        });

        return true;
    }
}

function server_validate_projectile_spawn(pid, projectile_id, item_id) {
    with (oNetworkManager) {
        if (!server_valid_weapon_id(item_id)) return false;
        if (global.ItemIndex[# item_id, ItemStat.MaxAmmo] == -1) return false;
        if (ds_map_exists(projectiles_seen, projectile_id)) return false;

        var player_data = server_get_player_state(pid);
        var hp = ds_map_find_value(player_data, "hp");
        if (!is_undefined(hp) && hp <= 0) return false;

        var state_weapon = ds_map_find_value(player_data, "weapon_id");
        if (is_undefined(state_weapon) || state_weapon == Item.None) {
            ds_map_set(player_data, "weapon_id", item_id);
        } else if (state_weapon != item_id) {
            return false;
        }

        var stored_state = ds_map_find_value(player_data, "state");
        if (is_undefined(stored_state)) stored_state = 0;
        server_update_reload_state(pid, stored_state);

        var is_reloading = ds_map_find_value(player_data, "weapon_reloading");
        if (is_undefined(is_reloading)) is_reloading = false;

        if (is_reloading) {
            if (global.ItemIndex[# item_id, ItemStat.Defense] == 1) {
                ds_map_set(player_data, "weapon_reloading", false);
                ds_map_set(player_data, "weapon_reload_until", -1);
            } else {
                return false;
            }
        }

        var bullet_count = global.ItemIndex[# item_id, ItemStat.Bullets];
        var pellet_until = ds_map_find_value(player_data, "shot_pellet_window_until");
        var pellet_item = ds_map_find_value(player_data, "shot_pellet_item");
        if (bullet_count > 1 && !is_undefined(pellet_until) && !is_undefined(pellet_item) && current_time <= pellet_until && pellet_item == item_id) {
            return server_register_projectile(pid, projectile_id, item_id);
        }

        var next_shot_at = ds_map_find_value(player_data, "next_shot_at");
        if (!is_undefined(next_shot_at) && current_time + 35 < next_shot_at) {
            return false;
        }

        var max_ammo = global.ItemIndex[# item_id, ItemStat.MaxAmmo];
        var ammo = ds_map_find_value(player_data, "weapon_ammo");
        var clip_ammo = ds_map_find_value(player_data, "weapon_clip_ammo");
        if (is_undefined(ammo)) ammo = max_ammo;
        if (is_undefined(clip_ammo)) clip_ammo = 0;
        ammo = clamp(ammo, 0, max_ammo);

        if (ammo <= 0) {
            ds_map_set(player_data, "weapon_ammo", 0);
            return false;
        }

        ammo -= 1;
        ds_map_set(player_data, "weapon_ammo", ammo);
        ds_map_set(player_data, "weapon_clip_ammo", max(clip_ammo, 0));
        ds_map_set(player_data, "next_shot_at", current_time + server_shoot_interval_ms(pid, item_id));
        ds_map_set(player_data, "shot_pellet_window_until", bullet_count > 1 ? current_time + 80 : current_time);
        ds_map_set(player_data, "shot_pellet_item", item_id);

        return server_register_projectile(pid, projectile_id, item_id);
    }
}

function server_validate_hit_projectile(attacker_pid, projectile_id, weapon_id) {
    with (oNetworkManager) {
        if (server_valid_weapon_id(weapon_id) && global.ItemIndex[# weapon_id, ItemStat.WeaponTypeClass] == WEAPON_CLASS.KNIFE) {
            return true;
        }

        if (projectile_id < 0 || !ds_map_exists(projectiles_seen, projectile_id)) {
            return false;
        }

        var projectile_data = ds_map_find_value(projectiles_seen, projectile_id);
        if (!is_struct(projectile_data)) {
            return true;
        }

        if (projectile_data.owner_pid != attacker_pid) return false;
        if (server_valid_weapon_id(weapon_id) && projectile_data.item_id != weapon_id) return false;
        if (current_time - projectile_data.created_at > 5000) return false;

        projectile_data.hits += 1;
        return true;
    }
}

function server_cleanup_projectiles() {
    with (oNetworkManager) {
        var remove_list = ds_list_create();
        var projectile_count = ds_map_size(projectiles_seen);
        if (projectile_count <= 0) {
            ds_list_destroy(remove_list);
            return;
        }

        var key = ds_map_find_first(projectiles_seen);

        for (var i = 0; i < projectile_count; i++) {
            var projectile_data = ds_map_find_value(projectiles_seen, key);
            if (is_struct(projectile_data) && current_time - projectile_data.created_at > 5000) {
                ds_list_add(remove_list, key);
            }
            key = ds_map_find_next(projectiles_seen, key);
        }

        for (var j = 0; j < ds_list_size(remove_list); j++) {
            ds_map_delete(projectiles_seen, remove_list[| j]);
        }

        ds_list_destroy(remove_list);
    }
}

function handle_tick_update_server(socket_id) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_id)) return;
        
        var pid = ds_map_find_value(clients, socket_id);
        var x_pos = buffer_read(receive_buffer, buffer_f16);
        var y_pos = buffer_read(receive_buffer, buffer_f16);
        var direction_facing = buffer_read(receive_buffer, buffer_f16);
        var state = buffer_read(receive_buffer, buffer_u8);
		var moving_state_id = buffer_read(receive_buffer, buffer_u8);
		var team_id = buffer_read(receive_buffer, buffer_u8);
		var client_hp = buffer_read(receive_buffer, buffer_f16);
		var item_use_id = buffer_read(receive_buffer, buffer_u16);
		moving_state_id = clamp(moving_state_id, STATES_PLAYER.none_state, STATES_PLAYER.mortar_state);
		team_id = clamp(team_id, TEAM.POLICE, TEAM.TERRORIST);
        
        
        // Store player position
        var player_data = ds_map_find_value(player_states, pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, pid, player_data);
        }

		var server_hp = ds_map_find_value(player_data, "hp");
		if (is_undefined(server_hp)) {
			server_hp = global.player_stats_struct.Max_health;
			ds_map_set(player_data, "hp", server_hp);
		}
        
        ds_map_set(player_data, "x", x_pos);
        ds_map_set(player_data, "y", y_pos);
        ds_map_set(player_data, "dir", direction_facing);
        ds_map_set(player_data, "state", state);
        ds_map_set(player_data, "moving_state", moving_state_id);
        ds_map_set(player_data, "team", team_id);
        ds_map_set(player_data, "item_use_id", item_use_id);
        ds_map_set(player_data, "timestamp", current_time);
        server_update_reload_state(pid, state);

        var p = find_instance_by_network_id(oPlayer, pid);
        if (p == noone) {
            p = create_remote_player(pid, x_pos, y_pos);
        }
        if (instance_exists(p)) {
            with (p) {
                target_x = x_pos;
                target_y = y_pos;
                target_direction = direction_facing;
                network_bit_state = state;
                network_moving_state = moving_state_id;
                network_throw_grenade = (state & PLAYER_FLAGS.THROWING_GRENADE) != 0;
                network_item_use_id = item_use_id;
                moving_state = moving_state_id;
				team = team_id;
				stats.Health_points = server_hp;
            }
        }
    }	
}

function send_object_pos_sync_broadcast() {
    with (oNetworkManager) {
        var count = ds_list_size(item_pos_buffer);        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_POS_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, count);

        for (var i = 0; i < count; i++) {
            var inst = item_pos_buffer[| i];

			if (instance_exists(inst) && inst.network_id >= 0 && ds_map_exists(item_registry, inst.network_id)) {
				var data = ds_map_find_value(item_registry, inst.network_id);
				ds_map_set(data, "x", inst.x);
				ds_map_set(data, "y", inst.y);
				ds_map_set(data, "image_index", inst.image_index);
				ds_map_set(data, "scope", inst.scope_attachment);
				ds_map_set(data, "barrel", inst.barrel_attachment);
				ds_map_set(data, "grip", inst.grip_attachment);
				ds_map_set(data, "suppressor", inst.suppressor_attachment);
				ds_map_set(data, "clip_ammo", inst.ClipAmmo);
				ds_map_set(data, "ammo", inst.Ammo);
				ds_map_set(data, "durability", inst.Durability);
				ds_map_set(data, "amount", inst.Amount);
			}

            buffer_write(send_buffer, buffer_u16, inst.network_id);
            buffer_write(send_buffer, buffer_f16, inst.x);
            buffer_write(send_buffer, buffer_f16, inst.y);
        }

        var key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, key, send_buffer);
            key = ds_map_find_next(clients, key);
        }
    }
}

function handle_weather_update_server(socket_id) {
	/* DO BUDOUCNA - POKUD BUDE MÍT KLIENT SV_CHEATS=1, BUDE MOCT MĚNIT POČASÍ */
}

function send_weather_broadcast() {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.WEATHER_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, global.Weather);
        
        // Broadcast to all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function send_tick_broadcast() {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.TICK_UPDATE);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        // Write number of players
        var player_count = ds_map_size(player_states);
        buffer_write(send_buffer, buffer_u8, player_count);
        
        // Write each player's data
        var key = ds_map_find_first(player_states);
        for (var i = 0; i < player_count; i++) {
            var pid = key;
            var player_data = ds_map_find_value(player_states, pid);
            var x_pos = ds_map_find_value(player_data, "x");
            var y_pos = ds_map_find_value(player_data, "y");
            var dir = ds_map_find_value(player_data, "dir");
            var state = ds_map_find_value(player_data, "state");
            var moving_state_id = ds_map_find_value(player_data, "moving_state");
            var team_id = ds_map_find_value(player_data, "team");
            var hp = ds_map_find_value(player_data, "hp");
            var item_use_id = ds_map_find_value(player_data, "item_use_id");

            if (is_undefined(x_pos)) x_pos = 200;
            if (is_undefined(y_pos)) y_pos = 200;
            if (is_undefined(dir)) dir = 0;
            if (is_undefined(state)) state = 0;
            if (is_undefined(moving_state_id)) moving_state_id = STATES_PLAYER.none_state;
            if (is_undefined(team_id)) team_id = TEAM.POLICE;
            if (is_undefined(hp)) hp = global.player_stats_struct.Max_health;
            if (is_undefined(item_use_id)) item_use_id = Item.None;
            
            buffer_write(send_buffer, buffer_u8, pid);
            buffer_write(send_buffer, buffer_f16, x_pos);
            buffer_write(send_buffer, buffer_f16, y_pos);
            buffer_write(send_buffer, buffer_f16, dir);
            buffer_write(send_buffer, buffer_u8, state);
            buffer_write(send_buffer, buffer_u8, moving_state_id);
            buffer_write(send_buffer, buffer_u8, team_id);
			buffer_write(send_buffer, buffer_f16, hp);
			buffer_write(send_buffer, buffer_u16, item_use_id);
            key = ds_map_find_next(player_states, key);
        }
		
        buffer_write(send_buffer, buffer_u8, oLightRenderer.tickCounter);
        buffer_write(send_buffer, buffer_u8, oLightRenderer.CurrentHour);
        buffer_write(send_buffer, buffer_u8, oLightRenderer.CurrentMinute);
        
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
            player_disconnect_broadcast(pid);
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
	
function player_disconnect_broadcast(pid) {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.DISCONNECT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, pid);
        
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
        var helmet_id  = buffer_read(receive_buffer, buffer_u8);
        var helmet_dur = buffer_read(receive_buffer, buffer_f16);
        var armour_id  = buffer_read(receive_buffer, buffer_u8);
        var armour_dur = buffer_read(receive_buffer, buffer_f16);
        var shield_id  = buffer_read(receive_buffer, buffer_u8);
        var shield_dur = buffer_read(receive_buffer, buffer_f16);
        
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
        ds_map_set(player_data, "shield_id", shield_id);
        ds_map_set(player_data, "shield_dur", shield_dur);
        
        // Update the player object
        var p = find_instance_by_network_id(oPlayer, pid);
        if (instance_exists(p)) {
            with (p) {
                network_helmet_id = helmet_id;
                network_helmet_dur = helmet_dur;
                network_armour_id = armour_id;
                network_armour_dur = armour_dur;
                network_shield_id = shield_id;
                network_shield_dur = shield_dur;
            }
        }
     
	 equipment_sync = true;
    }
}

function handle_weapon_update_server(socket_id) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_id)) return;
        
        var pid = ds_map_find_value(clients, socket_id);
        
        var weapon_id  = buffer_read(receive_buffer, buffer_u16);
        var weapon_scope = buffer_read(receive_buffer, buffer_u8);
        var weapon_barrel = buffer_read(receive_buffer, buffer_u8);
        var weapon_grip = buffer_read(receive_buffer, buffer_u8);
        var weapon_suppressor = buffer_read(receive_buffer, buffer_u8);
        var weapon_ammo = buffer_read(receive_buffer, buffer_u16);
        var weapon_clip_ammo = buffer_read(receive_buffer, buffer_u16);
        
        // Store in player_states
        var player_data = ds_map_find_value(player_states, pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, pid, player_data);
        }
        
        ds_map_set(player_data, "weapon_id", weapon_id);
        ds_map_set(player_data, "weapon_scope", weapon_scope);
        ds_map_set(player_data, "weapon_barrel", weapon_barrel);
        ds_map_set(player_data, "weapon_grip", weapon_grip);
        ds_map_set(player_data, "weapon_suppressor", weapon_suppressor);
        ds_map_set(player_data, "weapon_ammo", weapon_ammo);
        ds_map_set(player_data, "weapon_clip_ammo", weapon_clip_ammo);
        ds_map_set(player_data, "weapon_reloading", false);
        ds_map_set(player_data, "weapon_reload_until", -1);
        
        // Update the player object
        var p = find_instance_by_network_id(oPlayer, pid);
        if (instance_exists(p)) {
            with (p) {
                network_weapon_id = weapon_id;
                network_scope = weapon_scope;
                network_barrel = weapon_barrel;
                network_grip = weapon_grip;
                network_suppressor = weapon_suppressor;
            }
        }
     
	 weapon_sync = true;
    }
}

function send_weapon_broadcast() {
    with (oNetworkManager) {
        if (!is_server) return;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.WEAPON_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        
        // Count players
        var player_count = ds_map_size(player_states);
        buffer_write(send_buffer, buffer_u8, player_count);
        
        var key = ds_map_find_first(player_states);
        for (var i = 0; i < player_count; i++) {
            var pid = key;
            var player_data = ds_map_find_value(player_states, pid);

            // Read values with safe defaults (fix undefined crash)
            var weapon_id = ds_map_find_value(player_data, "weapon_id");
            var weapon_scope = ds_map_find_value(player_data, "weapon_scope");
            var weapon_barrel = ds_map_find_value(player_data, "weapon_barrel");
            var weapon_grip = ds_map_find_value(player_data, "weapon_grip");
            var weapon_suppressor = ds_map_find_value(player_data, "weapon_suppressor");
            var weapon_ammo = ds_map_find_value(player_data, "weapon_ammo");
            var weapon_clip_ammo = ds_map_find_value(player_data, "weapon_clip_ammo");

            if (is_undefined(weapon_id)) weapon_id = Item.None;
            if (is_undefined(weapon_scope)) weapon_scope = Item.None;
            if (is_undefined(weapon_barrel)) weapon_barrel = Item.None;
            if (is_undefined(weapon_grip)) weapon_grip = Item.None;
            if (is_undefined(weapon_suppressor)) weapon_suppressor = Item.None;
            if (is_undefined(weapon_ammo)) weapon_ammo = 0;
            if (is_undefined(weapon_clip_ammo)) weapon_clip_ammo = 0;

            buffer_write(send_buffer, buffer_u8, pid);
            buffer_write(send_buffer, buffer_u16, weapon_id);
            buffer_write(send_buffer, buffer_u8, weapon_scope);
            buffer_write(send_buffer, buffer_u8, weapon_barrel);
            buffer_write(send_buffer, buffer_u8, weapon_grip);
            buffer_write(send_buffer, buffer_u8, weapon_suppressor);
            buffer_write(send_buffer, buffer_u16, weapon_ammo);
            buffer_write(send_buffer, buffer_u16, weapon_clip_ammo);
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

function send_equipment_broadcast() {
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
            var shield_id  = ds_map_find_value(player_data, "shield_id");
            var shield_dur = ds_map_find_value(player_data, "shield_dur");

            if (is_undefined(helmet_id))  helmet_id  = 0;
            if (is_undefined(helmet_dur)) helmet_dur = 0;
            if (is_undefined(armour_id))  armour_id  = 0;
            if (is_undefined(armour_dur)) armour_dur = 0;
            if (is_undefined(shield_id))  shield_id  = 0;
            if (is_undefined(shield_dur)) shield_dur = 0;

            // Write safe values to buffer
            buffer_write(send_buffer, buffer_u8, pid);
            buffer_write(send_buffer, buffer_u8, helmet_id);
            buffer_write(send_buffer, buffer_f16, helmet_dur);
            buffer_write(send_buffer, buffer_u8, armour_id);
            buffer_write(send_buffer, buffer_f16, armour_dur);
            buffer_write(send_buffer, buffer_u8, shield_id);
            buffer_write(send_buffer, buffer_f16, shield_dur);

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

function player_death_broadcast(attacker_pid, victim_pid, weapon_id, attacker_name, weapon_name) {
    with (oNetworkManager) {
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PLAYER_DEATH);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, attacker_pid);
        buffer_write(send_buffer, buffer_u8, victim_pid);
        buffer_write(send_buffer, buffer_u16, weapon_id);
        buffer_write(send_buffer, buffer_string, attacker_name);
        buffer_write(send_buffer, buffer_string, weapon_name);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_player_state_value(pid, key_name, default_value) {
	with (oNetworkManager) {
		var player_data = ds_map_find_value(player_states, pid);
		if (is_undefined(player_data)) {
			return default_value;
		}

		var value = ds_map_find_value(player_data, key_name);
		return is_undefined(value) ? default_value : value;
	}
}

function server_calculate_authoritative_hit(attacker_pid, victim_obj, hitbox_type, impact_pos, weapon_id, penetration_damage, shot_start, allow_server_damage_item = false) {
	var result = {
		damage: 0,
		hit_spd_mod: 1,
		aimpunch_modifier: 1,
		equip_dur: [0, 0, 0]
	};

	if (weapon_id < 0 || weapon_id >= Item.Total) {
		return result;
	}

	weapon_id = floor(weapon_id);
	penetration_damage = clamp(penetration_damage, 0, 100);

	var item_type = global.ItemIndex[# weapon_id, ItemStat.Type];
	if (weapon_id == Item.None || (item_type != "Weapon" && !(allow_server_damage_item && server_valid_server_damage_item(weapon_id)))) {
		return result;
	}

	var victim_pid = victim_obj.network_id;
	var armour_id = server_player_state_value(victim_pid, "armour_id", victim_obj.network_armour_id);
	var helmet_id = server_player_state_value(victim_pid, "helmet_id", victim_obj.network_helmet_id);
	var shield_id = server_player_state_value(victim_pid, "shield_id", victim_obj.network_shield_id);
	var armour_dur = server_player_state_value(victim_pid, "armour_dur", victim_obj.network_armour_dur);
	var helmet_dur = server_player_state_value(victim_pid, "helmet_dur", victim_obj.network_helmet_dur);
	var shield_dur = server_player_state_value(victim_pid, "shield_dur", victim_obj.network_shield_dur);

	var suppressor_id = server_player_state_value(attacker_pid, "weapon_suppressor", Item.None);
	var suppressor_multiplier = 1;
	if (item_type == "Weapon" && suppressor_id != Item.None) {
		suppressor_multiplier = global.ItemIndex[# suppressor_id, ItemStat.Defense];
	}

	var attacker_x = server_player_state_value(attacker_pid, "x", shot_start[0]);
	var attacker_y = server_player_state_value(attacker_pid, "y", shot_start[1]);
	var shot_distance = point_distance(attacker_x, attacker_y, impact_pos[0], impact_pos[1]);
	var penetration_power = global.ItemIndex[# weapon_id, ItemStat.PenetrationPower];
	var damage = global.ItemIndex[# weapon_id, ItemStat.Damage] * suppressor_multiplier;
	damage = damage * global.ItemIndex[# weapon_id, ItemStat.damage_drop](shot_distance) / (penetration_damage + 1);

	result.hit_spd_mod = min(1, (1 - (penetration_power / (penetration_damage + 1))) / global.ItemIndex[# armour_id, ItemStat.Defense]);
	result.aimpunch_modifier = penetration_power / (penetration_damage + 1);

	var damage_multiplier = 1;
	if (hitbox_type >= HITBOX.LegProne) {
		damage_multiplier = LEG_MULTIPLIER;
	} else if (hitbox_type >= HITBOX.ArmNoWeapon) {
		damage_multiplier = ARM_MULTIPLIER;
	} else if (hitbox_type >= HITBOX.BodyNoWeapon) {
		damage_multiplier = BODY_MULTIPLIER;
		if (armour_dur > 0 && global.ItemIndex[# armour_id, ItemStat.Defense] <= .95) {
			damage = damage * global.ItemIndex[# armour_id, ItemStat.Defense] * penetration_power;
		}
	} else if (hitbox_type >= HITBOX.Head) {
		damage_multiplier = HEADSHOT_MULTIPLIER;
		if (helmet_dur > 0 && global.ItemIndex[# helmet_id, ItemStat.Defense] <= .95) {
			damage = damage * global.ItemIndex[# helmet_id, ItemStat.Defense] * penetration_power;
		}
	}

	var shield_modifier = 1;
	var victim_weapon_id = server_player_state_value(victim_pid, "weapon_id", victim_obj.network_weapon_id);
	var shield_equipped = victim_obj.shield_equip;
	if (victim_weapon_id != Item.None && global.ItemIndex[# victim_weapon_id, ItemStat.Type] == "Shield") {
		shield_equipped = true;
	}
	if (shield_equipped && shield_dur > 0) {
		shield_modifier = global.ItemIndex[# shield_id, ItemStat.Defense];
	}

	var final_damage = ceil(damage * damage_multiplier * (global.hard_mode == true ? 2 : 1) * shield_modifier);
	final_damage = clamp(final_damage, 0, server_max_damage_per_hit);

	if (shield_equipped && shield_dur > 0) {
		shield_dur = max(shield_dur - (final_damage / 50 / global.ItemIndex[# shield_id, ItemStat.Defense]), 0);
	}

	if (hitbox_type > HITBOX.HeadProne) {
		if (global.ItemIndex[# armour_id, ItemStat.Defense] <= .95 && armour_dur > 0 && hitbox_type < HITBOX.ArmNoWeapon) {
			armour_dur = max(armour_dur - (final_damage / 50 / global.ItemIndex[# armour_id, ItemStat.Defense]), 0);
		}
	} else if (global.ItemIndex[# helmet_id, ItemStat.Defense] <= .95 && helmet_dur > 0) {
		helmet_dur = max(helmet_dur - (final_damage / 50 / global.ItemIndex[# helmet_id, ItemStat.Defense]), 0);
	}

	result.damage = final_damage;
	result.equip_dur = [armour_dur, helmet_dur, shield_dur];
	return result;
}

function server_process_hit(attacker_pid, victim_pid, client_damage, hitbox_type, impact_pos, client_hit_spd_mod, client_aimpunch_modifier, client_equip_dur, weapon_id, penetration_damage, shot_start, projectile_id = -1, server_local_authority = false) {
    with (oNetworkManager) {
        if (!is_server) return;

        var victim_obj = find_instance_by_network_id(oPlayer, victim_pid);
        if (!instance_exists(victim_obj)) return;

        var attacker_data = ds_map_find_value(player_states, attacker_pid);
        if (!is_undefined(attacker_data)) {
            var attacker_hp = ds_map_find_value(attacker_data, "hp");
            if (!is_undefined(attacker_hp) && attacker_hp <= 0) return;
        }

        if (!server_validate_hit_projectile(attacker_pid, projectile_id, weapon_id)) {
            if (!(server_local_authority && !server_valid_weapon_id(weapon_id) && server_valid_server_damage_item(weapon_id))) return;
        }
		
		var player_data = ds_map_find_value(player_states, victim_pid);
        if (is_undefined(player_data)) {
            player_data = ds_map_create();
            ds_map_add(player_states, victim_pid, player_data);
        }

        var current_hp = ds_map_find_value(player_data, "hp");
        if (is_undefined(current_hp)) {
            current_hp = global.player_stats_struct.Max_health;
        }
        if (current_hp <= 0) return;

		var server_hit = server_calculate_authoritative_hit(attacker_pid, victim_obj, hitbox_type, impact_pos, weapon_id, penetration_damage, shot_start, server_local_authority);
		var damage = server_hit.damage;
		var hit_spd_mod = server_hit.hit_spd_mod;
		var aimpunch_modifier = server_hit.aimpunch_modifier;
		var equip_dur = server_hit.equip_dur;
		if (damage <= 0) return;

		hit_remote_object(damage, victim_obj, hitbox_type, [impact_pos[0], impact_pos[1]], hit_spd_mod, aimpunch_modifier, equip_dur, attacker_pid);

        var new_hp = max(0, current_hp - damage);
        ds_map_set(player_data, "hp", new_hp);
        ds_map_set(player_data, "armour_dur", equip_dur[0]);
        ds_map_set(player_data, "helmet_dur", equip_dur[1]);
        ds_map_set(player_data, "shield_dur", equip_dur[2]);
        equipment_sync = true;

        if (instance_exists(victim_obj)) {
            with (victim_obj) {
                stats.Health_points = new_hp;
            }
        }

        if (current_hp > 0 && new_hp <= 0) {
			var attacker_name = server_player_display_name(attacker_pid);
			var weapon_name = server_item_display_name(weapon_id);
			
			// Označ remote obět za mrtvou
		    with (victim_obj) {
		        stats.Health_points = 0;
		        death_from_server = true;
                death_attacker_pid = attacker_pid;
                KilledByName = attacker_name;
                KilledByWeapon = weapon_name;
		    }
	
			// Broadcastni všem klientům, že nějaký hráč s victim_pid zemřel
            player_death_broadcast(attacker_pid, victim_pid, weapon_id, attacker_name, weapon_name);
			
			// Umřel host hráč?
		    if (victim_pid == my_pid && instance_exists(victim_obj)) {
		        with (victim_obj) {
		            stats.Health_points = 0;
		            death_from_server = true;
		            death_attacker_pid = attacker_pid;
                    KilledByName = attacker_name;
                    KilledByWeapon = weapon_name;
		        }
		    }
        }

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8,  PACKET.HIT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, attacker_pid);
        buffer_write(send_buffer, buffer_u8, victim_pid);
        buffer_write(send_buffer, buffer_f16, damage);
        buffer_write(send_buffer, buffer_u8,  hitbox_type);
        buffer_write(send_buffer, buffer_f16, impact_pos[0]);
        buffer_write(send_buffer, buffer_f16, impact_pos[1]);
		buffer_write(send_buffer, buffer_f16, hit_spd_mod);
		buffer_write(send_buffer, buffer_f16, aimpunch_modifier);
		buffer_write(send_buffer, buffer_f16, equip_dur[0]);
		buffer_write(send_buffer, buffer_f16, equip_dur[1]);
		buffer_write(send_buffer, buffer_f16, equip_dur[2]);

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

        var attacker_pid_claim = buffer_read(receive_buffer, buffer_u8);
        var victim_pid   = buffer_read(receive_buffer, buffer_u8);
        var client_damage = buffer_read(receive_buffer, buffer_f16);
        var projectile_id = buffer_read(receive_buffer, buffer_s32);
        var weapon_id = buffer_read(receive_buffer, buffer_u16);
        var penetration_damage = buffer_read(receive_buffer, buffer_f16);
        var shot_start_x = buffer_read(receive_buffer, buffer_f16);
        var shot_start_y = buffer_read(receive_buffer, buffer_f16);
        var hitbox_type    = buffer_read(receive_buffer, buffer_u8);
        var impact_x     = buffer_read(receive_buffer, buffer_f16);
        var impact_y     = buffer_read(receive_buffer, buffer_f16);
		var client_hit_spd_mod = buffer_read(receive_buffer, buffer_f16);
		var client_aimpunch_modifier = buffer_read(receive_buffer, buffer_f16);
		var client_armour_dur = buffer_read(receive_buffer, buffer_f16);
		var client_helmet_dur = buffer_read(receive_buffer, buffer_f16);
		var client_shield_dur = buffer_read(receive_buffer, buffer_f16);

        var attacker_pid = ds_map_find_value(clients, socket_key);
        if (attacker_pid < 0) {
            attacker_pid = attacker_pid_claim;
        }

        server_process_hit(attacker_pid, victim_pid, client_damage, hitbox_type, [impact_x, impact_y], client_hit_spd_mod, client_aimpunch_modifier, [client_armour_dur, client_helmet_dur, client_shield_dur], weapon_id, penetration_damage, [shot_start_x, shot_start_y], projectile_id);
    }
}
	
function handle_object_sync_server(socket_id) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_id)) return;

        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case 0:
                var item_id = buffer_read(receive_buffer, buffer_u8);
				var o_index = buffer_read(receive_buffer, buffer_u16);
                var x_pos   = buffer_read(receive_buffer, buffer_f16);
                var y_pos   = buffer_read(receive_buffer, buffer_f16);
                var scope   = buffer_read(receive_buffer, buffer_u8);
                var barrel  = buffer_read(receive_buffer, buffer_u8);
                var grip    = buffer_read(receive_buffer, buffer_u8);
                var suppressor = buffer_read(receive_buffer, buffer_u8);
                var clip_ammo  = buffer_read(receive_buffer, buffer_s16);
                var ammo    = buffer_read(receive_buffer, buffer_s16);
                var durability = buffer_read(receive_buffer, buffer_f16);
				var amount  = buffer_read(receive_buffer, buffer_u8);

				if (o_index != oItems) return;
				if (item_id <= Item.None || item_id >= Item.Total) return;
				if (amount <= 0) return;

				var requester_pid = ds_map_find_value(clients, socket_id);
				var requester = find_instance_by_network_id(oPlayer, requester_pid);
				if (!instance_exists(requester)) return;

				if (point_distance(requester.x, requester.y, x_pos, y_pos) > 128) {
					x_pos = requester.x;
					y_pos = requester.y;
				}

                var create_data = {
                    img_index: item_id,
                    amount: amount,
                    scope: scope,
                    barrel: barrel,
                    grip: grip,
                    suppressor: suppressor,
                    clip_ammo: clip_ammo,
                    ammo: ammo,
                    durability: durability,
					obj_index: o_index
                };

                sync_object_create(x_pos, y_pos, create_data);
            break;
            case 1: { // destroy request
                var net_id = buffer_read(receive_buffer, buffer_u16);
				var o_index_destroy = buffer_read(receive_buffer, buffer_u16);
                var inst = find_instance_by_network_id(oItems, net_id);

                if (instance_exists(inst)) {
					var requester_pid = ds_map_find_value(clients, socket_id);
					var requester = find_instance_by_network_id(oPlayer, requester_pid);
					var can_pickup = false;

					if (instance_exists(requester)) {
						var pickup_distance = requester.PickUpDistance + 48;
						can_pickup = (point_distance(requester.x, requester.y, inst.x, inst.y) <= pickup_distance);
					}

					if (can_pickup) {
						sync_object_destroy(inst);
					}
                } else {
                    buffer_seek(send_buffer, buffer_seek_start, 0);
                    buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
                    buffer_write(send_buffer, buffer_u32, send_sequence++);
                    buffer_write(send_buffer, buffer_u8, 1);
                    buffer_write(send_buffer, buffer_u16, net_id);
					buffer_write(send_buffer, buffer_u16, o_index_destroy);

					///broadcast
                    var socket_key = ds_map_find_first(clients);
                    for (var i = 0; i < ds_map_size(clients); i++) {
                        sent_server_udp(server_socket, socket_key, send_buffer);
                        socket_key = ds_map_find_next(clients, socket_key);
                    }
                }
                break;
            }
        }
    }
}

function handle_init_sync_server(socket_id) {
    with (oNetworkManager) {
		///Broadcast v step eventu oNetworkManagera pro rozeslání všech equipmentů a zbraní
		equipment_sync = true;
		weapon_sync = true;
		
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.INIT);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        var count = ds_map_size(item_registry);
		
		// Itemy
        buffer_write(send_buffer, buffer_u16, count);

        var key = ds_map_find_first(item_registry);
        for (var i = 0; i < count; i++) {
            var data = ds_map_find_value(item_registry, key);
            buffer_write(send_buffer, buffer_u16, key); // net_id
            buffer_write(send_buffer, buffer_u16, ds_map_find_value(data, "obj_index"));
            buffer_write(send_buffer, buffer_f16, ds_map_find_value(data, "x"));
            buffer_write(send_buffer, buffer_f16, ds_map_find_value(data, "y"));
            buffer_write(send_buffer, buffer_u8,  ds_map_find_value(data, "image_index"));			
            buffer_write(send_buffer, buffer_u8, ds_map_find_value(data, "scope"));
            buffer_write(send_buffer, buffer_u8, ds_map_find_value(data, "barrel"));
            buffer_write(send_buffer, buffer_u8, ds_map_find_value(data, "grip"));
            buffer_write(send_buffer, buffer_u8,  ds_map_find_value(data, "suppressor"));
            buffer_write(send_buffer, buffer_s16, ds_map_find_value(data, "clip_ammo"));
            buffer_write(send_buffer, buffer_s16, ds_map_find_value(data, "ammo"));
            buffer_write(send_buffer, buffer_f16, ds_map_find_value(data, "durability"));
			buffer_write(send_buffer, buffer_u8, ds_map_find_value(data, "amount"));
            key = ds_map_find_next(item_registry, key);
        }
		
		// Počasí
		buffer_write(send_buffer, buffer_u8, global.Weather);
		

        // Birds
        var bird_count = ds_map_size(bird_registry);
        buffer_write(send_buffer, buffer_u8, bird_count);

        var bird_key = ds_map_find_first(bird_registry);
        for (var b = 0; b < bird_count; b++) {
            var bird_data = ds_map_find_value(bird_registry, bird_key);
            buffer_write(send_buffer, buffer_u8, bird_key);
			buffer_write(send_buffer, buffer_u8, bird_data[0]);
            buffer_write(send_buffer, buffer_f16, bird_data[1]);
            buffer_write(send_buffer, buffer_f16, bird_data[2]);
			buffer_write(send_buffer, buffer_f16, bird_data[3]);
			buffer_write(send_buffer, buffer_f16, bird_data[4]);
			buffer_write(send_buffer, buffer_s16, bird_data[5]);
            buffer_write(send_buffer, buffer_s16, bird_data[6]);
            buffer_write(send_buffer, buffer_f16, bird_data[7]);
            buffer_write(send_buffer, buffer_f16, bird_data[8]);
            bird_key = ds_map_find_next(bird_registry, bird_key);
        }

        var airplane_count = ds_map_size(airplane_registry);
        buffer_write(send_buffer, buffer_u8, airplane_count);

        var airplane_key = ds_map_find_first(airplane_registry);
        for (var a = 0; a < airplane_count; a++) {
            var airplane_data = ds_map_find_value(airplane_registry, airplane_key);
            buffer_write(send_buffer, buffer_u16, airplane_key);
            buffer_write(send_buffer, buffer_f16, airplane_data[0]);
            buffer_write(send_buffer, buffer_f16, airplane_data[1]);
            buffer_write(send_buffer, buffer_f16, airplane_data[2]);
            buffer_write(send_buffer, buffer_f16, airplane_data[3]);
            buffer_write(send_buffer, buffer_s16, airplane_data[4]);
            buffer_write(send_buffer, buffer_f16, airplane_data[5]);
            airplane_key = ds_map_find_next(airplane_registry, airplane_key);
        }
		
		// Hráči
        var player_count = ds_map_size(player_states);
        buffer_write(send_buffer, buffer_u8, player_count);
        
        var p_key = ds_map_find_first(player_states);
        for (var i = 0; i < player_count; i++) {
            var pid = p_key;
            var player_data = ds_map_find_value(player_states, pid);

            // Read values with safe defaults
            var helmet_id  = ds_map_find_value(player_data, "helmet_id");
            var helmet_dur = ds_map_find_value(player_data, "helmet_dur");
            var armour_id  = ds_map_find_value(player_data, "armour_id");
            var armour_dur = ds_map_find_value(player_data, "armour_dur");
            var shield_id  = ds_map_find_value(player_data, "shield_id");
            var shield_dur = ds_map_find_value(player_data, "shield_dur");
            var weapon_id = ds_map_find_value(player_data, "weapon_id");
            var weapon_scope = ds_map_find_value(player_data, "weapon_scope");
            var weapon_barrel = ds_map_find_value(player_data, "weapon_barrel");
            var weapon_grip = ds_map_find_value(player_data, "weapon_grip");
            var weapon_suppressor = ds_map_find_value(player_data, "weapon_suppressor");
            var weapon_ammo = ds_map_find_value(player_data, "weapon_ammo");
            var weapon_clip_ammo = ds_map_find_value(player_data, "weapon_clip_ammo");

            if (is_undefined(helmet_id))  helmet_id  = 0;
            if (is_undefined(helmet_dur)) helmet_dur = 0;
            if (is_undefined(armour_id))  armour_id  = 0;
            if (is_undefined(armour_dur)) armour_dur = 0;
            if (is_undefined(shield_id))  shield_id  = 0;
            if (is_undefined(shield_dur)) shield_dur = 0;
            if (is_undefined(weapon_id)) weapon_id = Item.None;
            if (is_undefined(weapon_scope)) weapon_scope = Item.None;
            if (is_undefined(weapon_barrel)) weapon_barrel = Item.None;
            if (is_undefined(weapon_grip)) weapon_grip = Item.None;
            if (is_undefined(weapon_suppressor)) weapon_suppressor = Item.None;
            if (is_undefined(weapon_ammo)) weapon_ammo = 0;
            if (is_undefined(weapon_clip_ammo)) weapon_clip_ammo = 0;

            buffer_write(send_buffer, buffer_u8, pid);
            buffer_write(send_buffer, buffer_u8, helmet_id);
            buffer_write(send_buffer, buffer_f16, helmet_dur);
            buffer_write(send_buffer, buffer_u8, armour_id);
            buffer_write(send_buffer, buffer_f16, armour_dur);
            buffer_write(send_buffer, buffer_u8, shield_id);
            buffer_write(send_buffer, buffer_f16, shield_dur);
            buffer_write(send_buffer, buffer_u16, weapon_id);
            buffer_write(send_buffer, buffer_u8, weapon_scope);
            buffer_write(send_buffer, buffer_u8, weapon_barrel);
            buffer_write(send_buffer, buffer_u8, weapon_grip);
            buffer_write(send_buffer, buffer_u8, weapon_suppressor);
            buffer_write(send_buffer, buffer_u16, weapon_ammo);
            buffer_write(send_buffer, buffer_u16, weapon_clip_ammo);

            p_key = ds_map_find_next(player_states, p_key);
        }

        sent_server_udp(server_socket, socket_id, send_buffer);
    }
}
