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
			-1,
			dmg,
			-1,
			[owner_name, owner_visible],
			noone,
			[0, 0],
			true,
			[false, true],
			[proj_id, owner_pid]
		);
		
		var p = find_instance_by_network_id(oPlayer, owner_pid);
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
        var owner_pid = buffer_read(receive_buffer, buffer_u8);
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
					global.ItemIndex[#global.Inventory[# item_id, Index.slot_id], ItemStat.Range]
				],
				-1,
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
		
		var p = find_instance_by_network_id(oPlayer, owner_pid);
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
        
		ds_map_set(projectiles_seen, proj_id, true);
        return proj_id;
    }
}