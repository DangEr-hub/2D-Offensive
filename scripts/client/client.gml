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
			
			case PACKET.BIRD_SYNC: handle_bird_sync_client(); break;

			case PACKET.GRENADE_SYNC: handle_grenade_sync_client(); break;

			case PACKET.AIRPLANE_SYNC: handle_airplane_sync_client(); break;
			
        }
    }
}

function send_bird_death_request(net_id, damage) {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.BIRD_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 1); // destroy
        buffer_write(send_buffer, buffer_u8, net_id);
		buffer_write(send_buffer, buffer_f16, damage);

        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_bird_sync_client() {
    with (oNetworkManager) {
        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case 0:
                var net_id = buffer_read(receive_buffer, buffer_u8);
				var bird_state = buffer_read(receive_buffer, buffer_u8);
                var x_pos = buffer_read(receive_buffer, buffer_f16);
                var y_pos = buffer_read(receive_buffer, buffer_f16);
				var dir = buffer_read(receive_buffer, buffer_f16);
				var spd = buffer_read(receive_buffer, buffer_f16);
				var timer = buffer_read(receive_buffer, buffer_s16);

                var bird_inst = instance_create_depth(x_pos, y_pos, -100, oBird);
                bird_inst.network_id = net_id;
				bird_inst.is_local = false;
				bird_inst.state = bird_state;
				bird_inst.direction = dir;
				bird_inst.image_angle = dir;
				bird_inst.speed = spd;
				bird_inst.alarm[0] = timer;
				
                if(bird_state == 1){
                        bird_inst.sprite_index = spr_BirdFlying;
                        bird_inst.image_speed = 0.75;
                        bird_inst.depth = -100;
                }else{
                        bird_inst.sprite_index = spr_BirdWalking;
                        bird_inst.image_speed = 0.25;
                        bird_inst.depth = 100;
                }
				
            break;
            case 1: 
                var net_id_destroy = buffer_read(receive_buffer, buffer_u8);
				var damage = buffer_read(receive_buffer, buffer_f16);
				var make_snd = buffer_read(receive_buffer, buffer_u8);
                var inst_destroy = find_instance_by_network_id(oBird, net_id_destroy);

				var BloodSplashNumber = round(damage / 5);
				var BloodParticleNumber = round(damage / 2);
				if (instance_exists(inst_destroy)) {
					if(make_snd == true){
						create_blood(BloodSplashNumber, inst_destroy.x, inst_destroy.y, c_red, BloodParticleNumber);		
						play_sound(x, y, snd_BirdDeath, find_instance_by_network_id(oPlayer, oNetworkManager.my_pid));
					}
                    instance_destroy(inst_destroy);
                }
            break;
			
			case 2:
                net_id = buffer_read(receive_buffer, buffer_u8);
				bird_state = buffer_read(receive_buffer, buffer_u8);
				dir = buffer_read(receive_buffer, buffer_f16);
				spd = buffer_read(receive_buffer, buffer_f16);
				timer = buffer_read(receive_buffer, buffer_s16);

                var bird_inst = find_instance_by_network_id(oBird, net_id);
                if (instance_exists(bird_inst)) {
					bird_inst.direction = dir;
					bird_inst.image_angle = dir;
					bird_inst.speed = spd;
					bird_inst.state = bird_state;
					bird_inst.alarm[0] = timer;
					bird_inst.image_index = 0;
					
					if(bird_state == 1){
						bird_inst.sprite_index = spr_BirdFlying;
						bird_inst.image_speed = 0.75;
						bird_inst.depth = -100;
					}else{
						bird_inst.sprite_index = spr_BirdWalking;
						bird_inst.image_speed = 0.25;
						bird_inst.depth = 100;
					}
                }
			break;
			
            case 3:
	            net_id = buffer_read(receive_buffer, buffer_u8);
	            var move_timer = buffer_read(receive_buffer, buffer_s16);
	            var move_x = buffer_read(receive_buffer, buffer_f16);
	            var move_y = buffer_read(receive_buffer, buffer_f16);

	            var bird_inst = find_instance_by_network_id(oBird, net_id);
	            if (instance_exists(bird_inst)) {
	                bird_inst.move_timer = move_timer;
	                bird_inst.move_pos[0] = move_x;
	                bird_inst.move_pos[1] = move_y;
	            }
			break;

			case 4:
	            net_id = buffer_read(receive_buffer, buffer_u8);
				bird_state = buffer_read(receive_buffer, buffer_u8);
	            var bird_x = buffer_read(receive_buffer, buffer_f16);
	            var bird_y = buffer_read(receive_buffer, buffer_f16);
				dir = buffer_read(receive_buffer, buffer_f16);
				spd = buffer_read(receive_buffer, buffer_f16);
				timer = buffer_read(receive_buffer, buffer_s16);
	            move_timer = buffer_read(receive_buffer, buffer_s16);
	            move_x = buffer_read(receive_buffer, buffer_f16);
	            move_y = buffer_read(receive_buffer, buffer_f16);

	            bird_inst = find_instance_by_network_id(oBird, net_id);
	            if (instance_exists(bird_inst)) {
					bird_inst.x = bird_x;
					bird_inst.y = bird_y;
					bird_inst.direction = dir;
					bird_inst.image_angle = dir;
					bird_inst.speed = spd;
					bird_inst.state = bird_state;
					bird_inst.alarm[0] = timer;
	                bird_inst.move_timer = move_timer;
	                bird_inst.move_pos[0] = move_x;
	                bird_inst.move_pos[1] = move_y;

					if(bird_state == 1){
						bird_inst.sprite_index = spr_BirdFlying;
						bird_inst.image_speed = 0.75;
						bird_inst.depth = -100;
					}else{
						bird_inst.sprite_index = spr_BirdWalking;
						bird_inst.image_speed = 0.25;
						bird_inst.depth = 100;
					}
	            }
			break;
        }
    }
}

function send_airplane_damage_request(net_id, damage, hit_x, hit_y) {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0 || net_id < 0) return;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.AIRPLANE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, AIRPLANE_SYNC_ACTION.REQUEST_DAMAGE);
        buffer_write(send_buffer, buffer_u16, net_id);
        buffer_write(send_buffer, buffer_f16, damage);
        buffer_write(send_buffer, buffer_f16, hit_x);
        buffer_write(send_buffer, buffer_f16, hit_y);

        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_airplane_sync_client() {
    with (oNetworkManager) {
        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case AIRPLANE_SYNC_ACTION.SPAWN:
                var net_id = buffer_read(receive_buffer, buffer_u16);
                var x_pos = buffer_read(receive_buffer, buffer_f16);
                var y_pos = buffer_read(receive_buffer, buffer_f16);
                var plane_dir = buffer_read(receive_buffer, buffer_f16);
                var hp = buffer_read(receive_buffer, buffer_f16);
                var drop_timer = buffer_read(receive_buffer, buffer_s16);
                var plane_base_spd = buffer_read(receive_buffer, buffer_f16);

                var plane = find_instance_by_network_id(oAirPlane, net_id);
                if (!instance_exists(plane)) {
                    plane = instance_create_depth(x_pos, y_pos, -1500, oAirPlane);
                }

                with (plane) {
                    network_id = net_id;
                    network_authority = false;
                    network_visual_only = true;
                    network_target_x = x_pos;
                    network_target_y = y_pos;
                    network_target_direction = plane_dir;
                    x = x_pos;
                    y = y_pos;
                    direction = plane_dir;
                    image_angle = plane_dir;
                    stats.Health_points = hp;
                    alarm[0] = drop_timer;
                    base_spd = plane_base_spd;
                }
            break;

            case AIRPLANE_SYNC_ACTION.UPDATE:
                net_id = buffer_read(receive_buffer, buffer_u16);
                x_pos = buffer_read(receive_buffer, buffer_f16);
                y_pos = buffer_read(receive_buffer, buffer_f16);
                plane_dir = buffer_read(receive_buffer, buffer_f16);
                hp = buffer_read(receive_buffer, buffer_f16);
                drop_timer = buffer_read(receive_buffer, buffer_s16);

                plane = find_instance_by_network_id(oAirPlane, net_id);
                if (instance_exists(plane)) {
                    with (plane) {
                        network_target_x = x_pos;
                        network_target_y = y_pos;
                        network_target_direction = plane_dir;
                        direction = plane_dir;
                        stats.Health_points = hp;
                        alarm[0] = drop_timer;
                    }
                }
            break;

            case AIRPLANE_SYNC_ACTION.DESTROY:
                net_id = buffer_read(receive_buffer, buffer_u16);
                var explode_visual = buffer_read(receive_buffer, buffer_u8);
                x_pos = buffer_read(receive_buffer, buffer_f16);
                y_pos = buffer_read(receive_buffer, buffer_f16);
                var item_id = buffer_read(receive_buffer, buffer_u16);
                var damage = buffer_read(receive_buffer, buffer_f16);

                plane = find_instance_by_network_id(oAirPlane, net_id);
                if (instance_exists(plane)) {
                    instance_destroy(plane);
                }

                if (explode_visual) {
                    create_grenade_explosion_visual(x_pos, y_pos, item_id, damage);
                }
            break;

            case AIRPLANE_SYNC_ACTION.BOMB_SPAWN:
                var bomb_id = buffer_read(receive_buffer, buffer_u16);
                var plane_id = buffer_read(receive_buffer, buffer_u16);
                x_pos = buffer_read(receive_buffer, buffer_f16);
                y_pos = buffer_read(receive_buffer, buffer_f16);
                item_id = buffer_read(receive_buffer, buffer_u16);
                damage = buffer_read(receive_buffer, buffer_f16);

                var bomb = find_instance_by_network_id(oMissile, bomb_id);
                if (!instance_exists(bomb)) {
                    bomb = instance_create_layer(x_pos, y_pos, "OtherO", oMissile);
                }

                with (bomb) {
                    network_id = bomb_id;
                    network_authority = false;
                    network_visual_only = true;
                    stats.Item_id = item_id;
                    stats.Damage = damage;
                    stats.Owner_name = "Aircraft";
                    stats.Object = noone;
                }
            break;

            case AIRPLANE_SYNC_ACTION.BOMB_EXPLODE:
                bomb_id = buffer_read(receive_buffer, buffer_u16);
                x_pos = buffer_read(receive_buffer, buffer_f16);
                y_pos = buffer_read(receive_buffer, buffer_f16);
                item_id = buffer_read(receive_buffer, buffer_u16);
                damage = buffer_read(receive_buffer, buffer_f16);

                bomb = find_instance_by_network_id(oMissile, bomb_id);
                if (instance_exists(bomb)) {
                    instance_destroy(bomb);
                }

                create_grenade_explosion_visual(x_pos, y_pos, item_id, damage);
            break;
        }
    }
}

function handle_player_death_client() {
    with (oNetworkManager) {
        var attacker_pid = buffer_read(receive_buffer, buffer_u8);
        var victim_pid = buffer_read(receive_buffer, buffer_u8);
        var weapon_id = buffer_read(receive_buffer, buffer_u16);
        var attacker_name = buffer_read(receive_buffer, buffer_string);
        var weapon_name = buffer_read(receive_buffer, buffer_string);

        var victim = find_instance_by_network_id(oPlayer, victim_pid);
        if (instance_exists(victim)) {
            with (victim) {
                stats.Health_points = 0;
                death_from_server = true;
                death_attacker_pid = attacker_pid;
                KilledByName = attacker_name;
                KilledByWeapon = weapon_name;
            }
        }
    }
}

function handle_player_respawn_client() {
    with (oNetworkManager) {
        var player_pid = buffer_read(receive_buffer, buffer_u8);
        var new_hp = buffer_read(receive_buffer, buffer_f16);
        var respawn_pos_x = buffer_read(receive_buffer, buffer_f16);
        var respawn_pos_y = buffer_read(receive_buffer, buffer_f16);

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
                death_attacker_pid = -1;
                KilledByName = "No one";
                KilledByWeapon = "Nothing";
				x = respawn_pos_x;
				y = respawn_pos_y;
                target_x = respawn_pos_x;
                target_y = respawn_pos_y;
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
				var clip_ammo = buffer_read(receive_buffer, buffer_s16);
				var ammo = buffer_read(receive_buffer, buffer_s16);
				var durability = buffer_read(receive_buffer, buffer_f16);
				var amount  = buffer_read(receive_buffer, buffer_u8);

                var inst = find_instance_by_network_id(oItems, net_id);
				if (!instance_exists(inst)) {
					inst = instance_create_layer(x_pos, y_pos, "ItemsO", o_index);
				}
                inst.network_id = net_id;
				inst.x = x_pos;
				inst.y = y_pos;
				inst.target_x = x_pos;
				inst.target_y = y_pos;
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
			var clip_ammo = buffer_read(receive_buffer, buffer_s16);
			var ammo = buffer_read(receive_buffer, buffer_s16);
			var durability = buffer_read(receive_buffer, buffer_f16);
			var amount = buffer_read(receive_buffer, buffer_u8);

            var inst = find_instance_by_network_id(oItems, net_id);
			if (!instance_exists(inst)) {
				inst = instance_create_layer(x_pos, y_pos, "ItemsO", o_index);
			}
            inst.network_id = net_id;
			inst.x = x_pos;
			inst.y = y_pos;
			inst.target_x = x_pos;
			inst.target_y = y_pos;
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
		
        // Birds
        var bird_count = buffer_read(receive_buffer, buffer_u8);
        for (var b = 0; b < bird_count; b++) {
            var bird_id = buffer_read(receive_buffer, buffer_u8);
			var bird_state = buffer_read(receive_buffer, buffer_u8);
            var bird_x = buffer_read(receive_buffer, buffer_f16);
            var bird_y = buffer_read(receive_buffer, buffer_f16);
			var bird_dir = buffer_read(receive_buffer, buffer_f16);
			var bird_spd = buffer_read(receive_buffer, buffer_f16);
			var timer = buffer_read(receive_buffer, buffer_s16);
            var move_timer = buffer_read(receive_buffer, buffer_s16);
            var move_x = buffer_read(receive_buffer, buffer_f16);
            var move_y = buffer_read(receive_buffer, buffer_f16);

            var bird_inst = instance_create_depth(bird_x, bird_y, -100, oBird);
            bird_inst.network_id = bird_id;
			bird_inst.is_local = false;
			bird_inst.state = bird_state;
			bird_inst.direction = bird_dir;
			bird_inst.image_angle = bird_dir;
			bird_inst.speed = bird_spd;
			bird_inst.alarm[0] = timer;
            bird_inst.move_timer = move_timer;
            bird_inst.move_pos[0] = move_x;
            bird_inst.move_pos[1] = move_y;
			
			if(bird_state == 1){
				bird_inst.sprite_index = spr_BirdFlying;
				bird_inst.image_speed = 0.75;
				bird_inst.depth = -100;
			}else{
				bird_inst.sprite_index = spr_BirdWalking;
				bird_inst.image_speed = 0.25;
				bird_inst.depth = 100;
			}
			
        }

		// Hráči
		var airplane_count = buffer_read(receive_buffer, buffer_u8);
		for (var a = 0; a < airplane_count; a++) {
			var airplane_id = buffer_read(receive_buffer, buffer_u16);
			var airplane_x = buffer_read(receive_buffer, buffer_f16);
			var airplane_y = buffer_read(receive_buffer, buffer_f16);
			var airplane_dir = buffer_read(receive_buffer, buffer_f16);
			var airplane_hp = buffer_read(receive_buffer, buffer_f16);
			var airplane_timer = buffer_read(receive_buffer, buffer_s16);
			var airplane_base_spd = buffer_read(receive_buffer, buffer_f16);

			var airplane_inst = instance_create_depth(airplane_x, airplane_y, -1500, oAirPlane);
			airplane_inst.network_id = airplane_id;
			airplane_inst.network_authority = false;
			airplane_inst.network_visual_only = true;
			airplane_inst.network_target_x = airplane_x;
			airplane_inst.network_target_y = airplane_y;
			airplane_inst.network_target_direction = airplane_dir;
			airplane_inst.direction = airplane_dir;
			airplane_inst.image_angle = airplane_dir;
			airplane_inst.stats.Health_points = airplane_hp;
			airplane_inst.alarm[0] = airplane_timer;
			airplane_inst.base_spd = airplane_base_spd;
		}

        var player_count = buffer_read(receive_buffer, buffer_u8);
        for (var i = 0; i < player_count; i++) {
            var pid        = buffer_read(receive_buffer, buffer_u8);
            var helmet_id  = buffer_read(receive_buffer, buffer_u8);
            var helmet_dur = buffer_read(receive_buffer, buffer_f16);
            var armour_id  = buffer_read(receive_buffer, buffer_u8);
            var armour_dur = buffer_read(receive_buffer, buffer_f16);
            var shield_id  = buffer_read(receive_buffer, buffer_u8);
            var shield_dur = buffer_read(receive_buffer, buffer_f16);
            var weapon_id  = buffer_read(receive_buffer, buffer_u16);
            var weapon_scope = buffer_read(receive_buffer, buffer_u8);
            var weapon_barrel = buffer_read(receive_buffer, buffer_u8);
            var weapon_grip = buffer_read(receive_buffer, buffer_u8);
            var weapon_suppressor = buffer_read(receive_buffer, buffer_u8);
            var weapon_ammo = buffer_read(receive_buffer, buffer_u16);
            var weapon_clip_ammo = buffer_read(receive_buffer, buffer_u16);

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
            ds_map_set(player_data, "shield_id",  shield_id);
            ds_map_set(player_data, "shield_dur", shield_dur);
            ds_map_set(player_data, "weapon_id",  weapon_id);
            ds_map_set(player_data, "weapon_scope", weapon_scope);
            ds_map_set(player_data, "weapon_barrel", weapon_barrel);
            ds_map_set(player_data, "weapon_grip", weapon_grip);
            ds_map_set(player_data, "weapon_suppressor", weapon_suppressor);
            ds_map_set(player_data, "weapon_ammo", weapon_ammo);
            ds_map_set(player_data, "weapon_clip_ammo", weapon_clip_ammo);

            var p = find_instance_by_network_id(oPlayer, pid);
            if (instance_exists(p)) {
                with (p) {
                    network_helmet_id  = helmet_id;
                    network_helmet_dur = helmet_dur;
                    network_armour_id  = armour_id;
                    network_armour_dur = armour_dur;
                    network_shield_id  = shield_id;
                    network_shield_dur = shield_dur;
                    network_weapon_id  = weapon_id;
                    network_scope = weapon_scope;
                    network_barrel = weapon_barrel;
                    network_grip = weapon_grip;
                    network_suppressor = weapon_suppressor;
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
		var shield_dur = buffer_read(receive_buffer, buffer_f16);

		var victim = find_instance_by_network_id(oPlayer, victim_pid);

		if (attacker_pid == my_pid && victim_pid != my_pid) {
			if (instance_exists(victim)) {
				hit_remote_object(damage, victim, hitbox_type, [impact_x, impact_y], hit_spd_mod, aimpunch_modifier, [armour_dur, helmet_dur, shield_dur], attacker_pid);
			} else {
				var attacker = find_instance_by_network_id(oPlayer, my_pid);
				hitmap_record_given(attacker, victim_pid, "Player " + string(victim_pid), damage);
			}
			return;
		}

		if (instance_exists(victim)) {
			hit_remote_object(damage, victim, hitbox_type, [impact_x, impact_y], hit_spd_mod, aimpunch_modifier, [armour_dur, helmet_dur, shield_dur], attacker_pid);
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
			var moving_state_id = buffer_read(receive_buffer, buffer_u8);
			var team_id = buffer_read(receive_buffer, buffer_u8);
			var hp = buffer_read(receive_buffer, buffer_f16);
			var item_use_id = buffer_read(receive_buffer, buffer_u16);
			moving_state_id = clamp(moving_state_id, STATES_PLAYER.none_state, STATES_PLAYER.mortar_state);
			team_id = clamp(team_id, TEAM.POLICE, TEAM.TERRORIST);
			
            
            // Přeskoč lokálního hráče
            if (pid == my_pid) {
                var local_player = find_instance_by_network_id(oPlayer, my_pid);
                if (instance_exists(local_player) && !is_undefined(local_player.stats)) {
                    local_player.stats.Health_points = hp;
                }
                continue;
            }
            
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
					network_moving_state = moving_state_id;
					network_throw_grenade = (bit_states & PLAYER_FLAGS.THROWING_GRENADE) != 0;
					network_item_use_id = item_use_id;
					moving_state = moving_state_id;
					team = team_id;
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
            var shield_id  = buffer_read(receive_buffer, buffer_u8);
            var shield_dur = buffer_read(receive_buffer, buffer_f16);
            
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
            ds_map_set(player_data, "shield_id", shield_id);
            ds_map_set(player_data, "shield_dur", shield_dur);
            
            // Update remote player object
            var player = find_instance_by_network_id(oPlayer, pid);
            if (instance_exists(player)) {
                with (player) {
                    network_helmet_id = helmet_id;
                    network_helmet_dur = helmet_dur;
                    network_armour_id = armour_id;
                    network_armour_dur = armour_dur;
                    network_shield_id = shield_id;
                    network_shield_dur = shield_dur;
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
            var weapon_id  = buffer_read(receive_buffer, buffer_u16);
            var weapon_scope = buffer_read(receive_buffer, buffer_u8);
            var weapon_barrel = buffer_read(receive_buffer, buffer_u8);
            var weapon_grip = buffer_read(receive_buffer, buffer_u8);
            var weapon_suppressor = buffer_read(receive_buffer, buffer_u8);
            var weapon_ammo = buffer_read(receive_buffer, buffer_u16);
            var weapon_clip_ammo = buffer_read(receive_buffer, buffer_u16);
            
            // Přeskoč local player (víme weapon)
            if (pid == my_pid) {continue;}
            
			//Uložíme weapon_id na serveru pro PID hráče
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
            
            // Update remote player
            var player = find_instance_by_network_id(oPlayer, pid);
            if (instance_exists(player)) {
                with (player) {
                    network_weapon_id = weapon_id;
                    network_scope = weapon_scope;
                    network_barrel = weapon_barrel;
                    network_grip = weapon_grip;
                    network_suppressor = weapon_suppressor;
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
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# OtherSlot.Shield, Index.slot_id]);
            buffer_write(other.send_buffer, buffer_f16, global.Inventory[# OtherSlot.Shield, Index.slot_durability]);
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
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# WeaponID, Index.slot_scope]);
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# WeaponID, Index.slot_barrel]);
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# WeaponID, Index.slot_grip]);
            buffer_write(other.send_buffer, buffer_u8, global.Inventory[# WeaponID, Index.slot_suppressor]);
            buffer_write(other.send_buffer, buffer_u16, global.Inventory[# WeaponID, Index.slot_ammo]);
            buffer_write(other.send_buffer, buffer_u16, global.Inventory[# WeaponID, Index.slot_clip_ammo]);
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
			if(moving_state == STATES_PLAYER.prone_state){bit_states |= PLAYER_FLAGS.PRONE; }
			if(EquippedGrenadeTimer > -1){bit_states |= PLAYER_FLAGS.THROWING_GRENADE; }
				
			buffer_write(other.send_buffer, buffer_u8, bit_states);
			buffer_write(other.send_buffer, buffer_u8, moving_state);
			buffer_write(other.send_buffer, buffer_u8, team);
			buffer_write(other.send_buffer, buffer_f16, stats.Health_points);
			buffer_write(other.send_buffer, buffer_u16, global.Inventory[# item_use_position, Index.slot_id]);
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
		var hit_spd_mod = buffer_read(receive_buffer, buffer_f16);
		var aimpunch_modifier = buffer_read(receive_buffer, buffer_f16);
		var armour_dur = buffer_read(receive_buffer, buffer_f16);
		var helmet_dur = buffer_read(receive_buffer, buffer_f16);
		var shield_dur = buffer_read(receive_buffer, buffer_f16);

        if (victim_pid != my_pid) {
            return;
        }

        var player = find_instance_by_network_id(oPlayer, my_pid);
        if (instance_exists(player)) {
			hit_remote_object(damage, player, hitbox_type, [impact_x, impact_y], hit_spd_mod, aimpunch_modifier, [armour_dur, helmet_dur, shield_dur], attacker_pid);
        }
    }
}
