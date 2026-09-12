/* Tracer networking functions */
function handle_projectile_spawn_client() {
    with (oNetworkManager) {
        var proj_id   = buffer_read(receive_buffer, buffer_u16);
        var owner_pid = buffer_read(receive_buffer, buffer_u8);
        var x_pos     = buffer_read(receive_buffer, buffer_f16);
        var y_pos     = buffer_read(receive_buffer, buffer_f16);
        var angle       = buffer_read(receive_buffer, buffer_f16);
        var spd       = buffer_read(receive_buffer, buffer_f16);
		var index	  = buffer_read(receive_buffer, buffer_u8);
        var bx     = buffer_read(receive_buffer, buffer_f16);
        var by     = buffer_read(receive_buffer, buffer_f16);
		var dmg       = buffer_read(receive_buffer, buffer_f16);
		var item_id   = buffer_read(receive_buffer, buffer_u16);
		var owner_visible = buffer_read(receive_buffer, buffer_u8);
		var owner_name    = buffer_read(receive_buffer, buffer_string);
		var max_dist = buffer_read(receive_buffer, buffer_f16);

        if (ds_map_exists(projectiles_seen, proj_id)) return;
        if (owner_pid == my_pid) return;

        ds_map_set(projectiles_seen, proj_id, true);
		var p = find_instance_by_network_id(oPlayer, owner_pid)

        // Spawn traceru
		var tracer_object = create_bullet_tracer(
			[x_pos, y_pos],
			[bx, by],
			index,
			[
				item_id,
				angle,
				spd,
				max_dist
			],
			p,
			dmg,
			-1,
			[owner_name, owner_visible],
			noone,
			[0, 0],
			true,
			[false, true],
			[proj_id, owner_pid]
		);
		if(p != noone){
			p.network_shoot_timer = 2;
		}
    }
}

/// @function handle_projectile_spawn_server(socket_id)
function handle_projectile_spawn_server(key) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, key)) return; // neznámý klient

        var proj_id = buffer_read(receive_buffer, buffer_u16);
        var owner_pid_claim = buffer_read(receive_buffer, buffer_u8);
        var x_pos = buffer_read(receive_buffer, buffer_f16);
        var y_pos = buffer_read(receive_buffer, buffer_f16);
        var angle = buffer_read(receive_buffer, buffer_f16);
        var spd   = buffer_read(receive_buffer, buffer_f16);
        var index = buffer_read(receive_buffer, buffer_u8);
        var bx    = buffer_read(receive_buffer, buffer_f16);
        var by    = buffer_read(receive_buffer, buffer_f16);
		var dmg   = buffer_read(receive_buffer, buffer_f16);
		var item_id = buffer_read(receive_buffer, buffer_u16);
		var owner_visible = buffer_read(receive_buffer, buffer_u8);
		var owner_name    = buffer_read(receive_buffer, buffer_string);
		var max_dist = buffer_read(receive_buffer, buffer_f16);
		var owner_pid = ds_map_find_value(clients, key);

		if (!server_valid_weapon_id(item_id)) {
			return;
		}

		var server_x = server_player_state_value(owner_pid, "x", x_pos);
		var server_y = server_player_state_value(owner_pid, "y", y_pos);
		if (point_distance(server_x, server_y, x_pos, y_pos) > 192) {
			return;
		}

		max_dist = global.ItemIndex[# item_id, ItemStat.Range];
		var suppressor_id = server_player_state_value(owner_pid, "weapon_suppressor", Item.None);
		var damage_multiplier = 1;
		if (suppressor_id != Item.None) {
			damage_multiplier = global.ItemIndex[# suppressor_id, ItemStat.Defense];
		}
		dmg = global.ItemIndex[# item_id, ItemStat.Damage] * damage_multiplier;

		if (!server_validate_projectile_spawn(owner_pid, proj_id, item_id)) {
			return;
		}

		var p = find_instance_by_network_id(oPlayer, owner_pid);
		
        // tracer pro hosta
        if (owner_pid != my_pid) {
			create_bullet_tracer(
				[x_pos, y_pos],
				[bx, by],
				index,
				[
					item_id,
					angle,
					spd,
					global.ItemIndex[# item_id, ItemStat.Range]
				],
				p,
				dmg,
				-1,
				[owner_name, owner_visible],
				noone,
				[0, 0],
				true,
				[false, true],
				[proj_id, owner_pid]
			);
        }
		
		if(p != noone){
			p.network_shoot_timer = 2;
		}
		

        // rebroadcast
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8,  PACKET.PROJECTILE_SPAWN);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, proj_id);
        buffer_write(send_buffer, buffer_u8, owner_pid);
        buffer_write(send_buffer, buffer_f16, x_pos);
        buffer_write(send_buffer, buffer_f16, y_pos);
        buffer_write(send_buffer, buffer_f16, angle);
        buffer_write(send_buffer, buffer_f16, spd);
        buffer_write(send_buffer, buffer_u8,  index);
        buffer_write(send_buffer, buffer_f16, bx);
        buffer_write(send_buffer, buffer_f16, by);
		buffer_write(send_buffer, buffer_f16, dmg);
		buffer_write(send_buffer, buffer_u16, item_id);
		buffer_write(send_buffer, buffer_u8,  owner_visible);
		buffer_write(send_buffer, buffer_string, owner_name);
		buffer_write(send_buffer, buffer_f16, max_dist);

        var k = ds_map_find_first(clients);
        var n = ds_map_size(clients);
        for (var i = 0; i < n; i++) {
            if (k != key) sent_server_udp(server_socket, k, send_buffer);
            k = ds_map_find_next(clients, k);
        }
    }
}

function send_projectile_spawn(start_pos, angle_spd_id_dist, shot_pos, damage, item_id, owner_visible, owner_name) {
    with (oNetworkManager) {
        if ((!is_server && !is_connected) || (is_server && server_socket < 0)) return;
        
        var proj_id = irandom(65535); // Random unique ID
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
		buffer_write(send_buffer, buffer_u8,  PACKET.PROJECTILE_SPAWN);
		buffer_write(send_buffer, buffer_u32, send_sequence++);
		buffer_write(send_buffer, buffer_u16, proj_id);
		buffer_write(send_buffer, buffer_u8, my_pid);
		buffer_write(send_buffer, buffer_f16, start_pos[0]);
		buffer_write(send_buffer, buffer_f16, start_pos[1]);
		buffer_write(send_buffer, buffer_f16, angle_spd_id_dist[0]);
		buffer_write(send_buffer, buffer_f16, angle_spd_id_dist[1]);
		buffer_write(send_buffer, buffer_u8,  angle_spd_id_dist[2]);
		buffer_write(send_buffer, buffer_f16, shot_pos[0]);
		buffer_write(send_buffer, buffer_f16, shot_pos[1]);
		buffer_write(send_buffer, buffer_f16, damage);
		buffer_write(send_buffer, buffer_u16, item_id);
        buffer_write(send_buffer, buffer_u8,  owner_visible);
        buffer_write(send_buffer, buffer_string, owner_name);
		buffer_write(send_buffer, buffer_f16,  angle_spd_id_dist[3]);
		

		
        
        if (is_server) {
			if (!server_validate_projectile_spawn(my_pid, proj_id, item_id)) {
				return -1;
			}

            // Broadcast to all clients
            var socket_key = ds_map_find_first(clients);
            for (var i = 0; i < ds_map_size(clients); i++) {
                sent_server_udp(server_socket, socket_key, send_buffer);
                socket_key = ds_map_find_next(clients, socket_key);
            }
        } else {
            // Send to server
            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
        }
        
		if (!is_server) {
			ds_map_set(projectiles_seen, proj_id, true);
		}
        return proj_id;
    }
}

function send_grenade_spawn_request(image_id, grenade_speed, target_x, target_y, item_id) {
    with (oNetworkManager) {
        if (!is_connected || client_socket < 0) return;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.GRENADE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, GRENADE_SYNC_ACTION.REQUEST_SPAWN);
        buffer_write(send_buffer, buffer_u8, image_id);
        buffer_write(send_buffer, buffer_f16, grenade_speed);
        buffer_write(send_buffer, buffer_f16, target_x);
        buffer_write(send_buffer, buffer_f16, target_y);
        buffer_write(send_buffer, buffer_u16, item_id);

        network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
    }
}

function handle_grenade_sync_server(socket_key) {
    with (oNetworkManager) {
        if (!ds_map_exists(clients, socket_key)) return;

        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case GRENADE_SYNC_ACTION.REQUEST_SPAWN:
                var image_id = buffer_read(receive_buffer, buffer_u8);
                var grenade_speed = buffer_read(receive_buffer, buffer_f16);
                var target_x = buffer_read(receive_buffer, buffer_f16);
                var target_y = buffer_read(receive_buffer, buffer_f16);
                var item_id = buffer_read(receive_buffer, buffer_u16);

                if (item_id <= Item.None || item_id >= Item.Total) return;
                if (global.ItemIndex[# item_id, ItemStat.Type] != "Grenade") return;

                var owner_pid = ds_map_find_value(clients, socket_key);
                var owner = find_instance_by_network_id(oPlayer, owner_pid);
                if (!instance_exists(owner)) return;

                with (owner) {
                    var spawn_x = x;
                    var spawn_y = y;
                    if (instance_exists(Weapon)) {
                        spawn_x = Weapon.x + lengthdir_x(WeaponDistance / 2, RotationAngle);
                        spawn_y = Weapon.y + lengthdir_y(WeaponDistance / 2, RotationAngle);
                    }
                    create_grenade(spawn_x, spawn_y, image_id, grenade_speed, target_x, target_y, item_id, id);
                }
            break;
        }
    }
}

function handle_grenade_sync_client() {
    with (oNetworkManager) {
        var action = buffer_read(receive_buffer, buffer_u8);

        switch (action) {
            case GRENADE_SYNC_ACTION.SPAWN:
                var net_id = buffer_read(receive_buffer, buffer_u16);
                var owner_pid = buffer_read(receive_buffer, buffer_u8);
                var x_pos = buffer_read(receive_buffer, buffer_f16);
                var y_pos = buffer_read(receive_buffer, buffer_f16);
                var grenade_dir = buffer_read(receive_buffer, buffer_f16);
                var grenade_speed = buffer_read(receive_buffer, buffer_f16);
                var image_id = buffer_read(receive_buffer, buffer_u8);
                var item_id = buffer_read(receive_buffer, buffer_u16);
                var owner_name = buffer_read(receive_buffer, buffer_string);

                if (find_instance_by_network_id(oGrenade, net_id) != noone) return;

                var owner = find_instance_by_network_id(oPlayer, owner_pid);
                var grenade_depth = 0;
                if (instance_exists(owner)) {
                    grenade_depth = owner.depth + 1;
                }

                var grenade = instance_create_depth(x_pos, y_pos, grenade_depth, oGrenade);
                grenade.network_id = net_id;
                grenade.network_owner_pid = owner_pid;
                grenade.network_authority = false;
                grenade.network_visual_only = true;
                grenade.image_index = image_id;
                grenade.stats = {
                    Object_index: oPlayer,
                    Owner_name: owner_name,
                    Speed: grenade_speed,
                    Object: owner,
                    Item_id: item_id,
                    Direction: grenade_dir
                };
            break;

            case GRENADE_SYNC_ACTION.EXPLODE:
                var explode_net_id = buffer_read(receive_buffer, buffer_u16);
                var explode_x = buffer_read(receive_buffer, buffer_f16);
                var explode_y = buffer_read(receive_buffer, buffer_f16);
                var explode_item_id = buffer_read(receive_buffer, buffer_u16);
                var explode_damage = buffer_read(receive_buffer, buffer_f16);

                var visual_grenade = find_instance_by_network_id(oGrenade, explode_net_id);
                if (instance_exists(visual_grenade)) {
                    instance_destroy(visual_grenade);
                }

				create_grenade_explosion_visual(explode_x, explode_y, explode_item_id, explode_damage, explode_net_id);
			break;

			case GRENADE_SYNC_ACTION.MOLOTOV_STATE:
				var impact_count = buffer_read(receive_buffer, buffer_u8);
				for(var impact_i = 0; impact_i < impact_count; impact_i++){
					var impact_net_id = buffer_read(receive_buffer, buffer_u16);
					var impact_x = buffer_read(receive_buffer, buffer_f16);
					var impact_y = buffer_read(receive_buffer, buffer_f16);
					var impact_age = buffer_read(receive_buffer, buffer_f16);

					var stale_grenade = find_instance_by_network_id(oGrenade, impact_net_id);
					if(instance_exists(stale_grenade)){
						instance_destroy(stale_grenade);
					}

					create_grenade_explosion_visual(
						impact_x,
						impact_y,
						Item.MolotovGrenade,
						global.ItemIndex[# Item.MolotovGrenade, ItemStat.Damage],
						impact_net_id,
						impact_age
					);
				}
			break;
		}
    }
}

function server_grenade_spawn_broadcast(grenade_inst) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(grenade_inst)) return;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.GRENADE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, GRENADE_SYNC_ACTION.SPAWN);
        buffer_write(send_buffer, buffer_u16, grenade_inst.network_id);
        buffer_write(send_buffer, buffer_u8, grenade_inst.network_owner_pid);
        buffer_write(send_buffer, buffer_f16, grenade_inst.x);
        buffer_write(send_buffer, buffer_f16, grenade_inst.y);
        buffer_write(send_buffer, buffer_f16, grenade_inst.stats.Direction);
        buffer_write(send_buffer, buffer_f16, grenade_inst.stats.Speed);
        buffer_write(send_buffer, buffer_u8, grenade_inst.image_index);
        buffer_write(send_buffer, buffer_u16, grenade_inst.stats.Item_id);
        buffer_write(send_buffer, buffer_string, grenade_inst.stats.Owner_name);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_grenade_explosion_broadcast(grenade_inst) {
    with (oNetworkManager) {
        if (!is_server || !instance_exists(grenade_inst)) return;
        if (grenade_inst.grenade_explosion_broadcasted) return;

        grenade_inst.grenade_explosion_broadcasted = true;

        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.GRENADE_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, GRENADE_SYNC_ACTION.EXPLODE);
        buffer_write(send_buffer, buffer_u16, grenade_inst.network_id);
        buffer_write(send_buffer, buffer_f16, grenade_inst.x);
        buffer_write(send_buffer, buffer_f16, grenade_inst.y);
        buffer_write(send_buffer, buffer_u16, grenade_inst.stats.Item_id);
        buffer_write(send_buffer, buffer_f16, global.ItemIndex[# grenade_inst.stats.Item_id, ItemStat.Damage]);

        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

function server_molotov_state_broadcast() {
	with(oNetworkManager){
		if(!is_server || ds_map_size(clients) <= 0) return;

		var active_impacts = [];
		var impact_total = instance_number(oMolotovImpact);
		for(var impact_i = 0; impact_i < impact_total; impact_i++){
			var impact = instance_find(oMolotovImpact, impact_i);
			if(instance_exists(impact) && impact.can_damage && impact.network_id >= 0){
				array_push(active_impacts, impact);
				if(array_length(active_impacts) >= 255) break;
			}
		}

		var active_count = array_length(active_impacts);
		if(active_count <= 0) return;

		buffer_seek(send_buffer, buffer_seek_start, 0);
		buffer_write(send_buffer, buffer_u8, PACKET.GRENADE_SYNC);
		buffer_write(send_buffer, buffer_u32, send_sequence++);
		buffer_write(send_buffer, buffer_u8, GRENADE_SYNC_ACTION.MOLOTOV_STATE);
		buffer_write(send_buffer, buffer_u8, active_count);

		for(var state_i = 0; state_i < active_count; state_i++){
			var state_impact = active_impacts[state_i];
			buffer_write(send_buffer, buffer_u16, state_impact.network_id);
			buffer_write(send_buffer, buffer_f16, state_impact.x);
			buffer_write(send_buffer, buffer_f16, state_impact.y);
			buffer_write(send_buffer, buffer_f16, state_impact.age);
		}

		var socket_key = ds_map_find_first(clients);
		for(var client_i = 0; client_i < ds_map_size(clients); client_i++){
			sent_server_udp(server_socket, socket_key, send_buffer);
			socket_key = ds_map_find_next(clients, socket_key);
		}
	}
}

function create_grenade_explosion_visual(x_pos, y_pos, item_id, explosion_damage, network_id = -1, initial_age = 0) {
    if (item_id == Item.SmokeGrenade) {
        create_fog(x_pos, y_pos, random_range(100, 150), random(360), 0.1, random_range(.1, .5), 11, .9, .75, SMOKE_TIME);
        return;
    }

	if (item_id == Item.MolotovGrenade) {
		var impact = noone;
		if(network_id >= 0){
			impact = find_instance_by_network_id(oMolotovImpact, network_id);
		}

		if(!instance_exists(impact)){
			impact = create_molotov_impact(x_pos, y_pos, explosion_damage, noone, item_id, "Noone", -1, false, network_id, initial_age);
		}else{
			impact.x = x_pos;
			impact.y = y_pos;
			impact.age = max(impact.age, initial_age);
		}
		return impact;
	}

    var explosion = instance_create_depth(x_pos, y_pos, -99, oExplosion);
    explosion.ExplosionPower = min(explosion_damage / 10, 2);
    explosion.Angle = random(360);
    explosion.ExplosionWidth = sprite_get_width(spr_Explosion);
    explosion.ExplosionHeight = sprite_get_height(spr_Explosion);
    explosion.LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x_pos, y_pos);
    explosion.LightObject.blend = c_orange;
    explosion.LightObject.xscale = explosion_damage / 10;
    explosion.LightObject.yscale = explosion_damage / 10;

	play_sound(x_pos, y_pos, snd_Explosion, explosion, 100, 2500, .75);

    create_fog(
        x_pos,
        y_pos,
        clamp(random_range(explosion_damage, 1.5 * explosion_damage), 50, 75),
        random(360),
        0.1,
        random_range(.1, .5),
        clamp(round(explosion_damage / 10), 5, 7.5),
        clamp(explosion_damage / 250, .5, .9),
        clamp(explosion_damage / 250, .1, .75),
        2 * game_get_speed(gamespeed_fps)
    );

    if (item_id == Item.FlashBangGrenade && instance_exists(global.local_player)) {
        if (!collision_line(x_pos, y_pos, global.local_player.x, global.local_player.y, oParentTile, true, false)) {
            if (point_distance(x_pos, y_pos, global.local_player.x, global.local_player.y) < global.FlashBangMaxDistance) {
                if (global.GodMode == false) {
                    var angular_diff = abs(point_direction(global.local_player.x, global.local_player.y, x_pos, y_pos) - global.local_player.RotationAngle);
                    if (angular_diff > 180) {
                        angular_diff = 360 - angular_diff;
                    }
                    global.local_player.FlashedBackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
                    global.local_player.Flashed = true;
                    global.local_player.Reloading = false;
                    global.local_player.knife_attack_timer = -1;
                    global.local_player.ReloadTimer = -1;
                    global.local_player.FlashedAlpha = (1 - (angular_diff / 180)) * (1 - (point_distance(x_pos, y_pos, global.local_player.x, global.local_player.y) / global.FlashBangMaxDistance) * .1);
                    global.local_player.FlashedAlpha = clamp(global.local_player.FlashedAlpha, 0, 1);
                }
            }
        }
    }
}
