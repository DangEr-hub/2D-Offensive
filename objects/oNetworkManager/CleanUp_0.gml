/* oNetworkManager clean up event */
global.sudo = false;

if(ds_exists(player_stats, ds_type_map)){
	var stat_keys = ds_map_keys_to_array(player_stats);
	for(var stat_index = 0; stat_index < array_length(stat_keys); stat_index++){
		var stats = ds_map_find_value(player_stats, stat_keys[stat_index]);
		if(ds_exists(stats, ds_type_map)) ds_map_destroy(stats);
	}
	ds_map_destroy(player_stats);
}

if (ds_exists(item_registry, ds_type_map)) {
    var key = ds_map_find_first(item_registry);
    var count = ds_map_size(item_registry);
    for (var i = 0; i < count; i++) {
        var data = ds_map_find_value(item_registry, key);
        ds_map_destroy(data);
        key = ds_map_find_next(item_registry, key);
    }
    ds_map_destroy(item_registry);
}

ds_list_destroy(item_pos_buffer);
if(free_item_ids != -1){
	ds_stack_destroy(free_item_ids);
}

ds_map_destroy(bird_registry);
ds_map_destroy(grenade_registry);
ds_map_destroy(airplane_registry);

if(free_bird_ids != -1){
	ds_stack_destroy(free_bird_ids);
}

if(free_grenade_ids != -1){
	ds_stack_destroy(free_grenade_ids);
}

if(free_airplane_ids != -1){
	ds_stack_destroy(free_airplane_ids);
}

if (oNetworkManager.is_server) {
    // Server shutdown
    if (server_socket >= 0) {
        // Notify all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, PACKET.DISCONNECT);
            buffer_write(send_buffer, buffer_u32, send_sequence++);
			buffer_write(send_buffer, buffer_u8, 0); // Host PID.
			buffer_write(send_buffer, buffer_u8, true);

			var host_data = ds_map_find_value(player_states, 0);
			var host_weapon_id = Item.None;
			if (!is_undefined(host_data)) host_weapon_id = ds_map_find_value(host_data, "weapon_id");
			var has_host_weapon = !is_undefined(host_weapon_id) && host_weapon_id > Item.None && host_weapon_id < Item.Total;
			buffer_write(send_buffer, buffer_u8, has_host_weapon);
			if (has_host_weapon) {
				var host_player = find_instance_by_network_id(oPlayer, 0);
				var host_x = ds_map_find_value(host_data, "x");
				var host_y = ds_map_find_value(host_data, "y");
				if (instance_exists(host_player)) {
					host_x = host_player.x;
					host_y = host_player.y;
				}
				if (is_undefined(host_x)) host_x = 0;
				if (is_undefined(host_y)) host_y = 0;

				var host_scope = ds_map_find_value(host_data, "weapon_scope");
				var host_barrel = ds_map_find_value(host_data, "weapon_barrel");
				var host_grip = ds_map_find_value(host_data, "weapon_grip");
				var host_suppressor = ds_map_find_value(host_data, "weapon_suppressor");
				var host_ammo = ds_map_find_value(host_data, "weapon_ammo");
				var host_clip_ammo = ds_map_find_value(host_data, "weapon_clip_ammo");
				if (is_undefined(host_scope)) host_scope = Item.None;
				if (is_undefined(host_barrel)) host_barrel = Item.None;
				if (is_undefined(host_grip)) host_grip = Item.None;
				if (is_undefined(host_suppressor)) host_suppressor = Item.None;
				if (is_undefined(host_ammo)) host_ammo = -1;
				if (is_undefined(host_clip_ammo)) host_clip_ammo = -1;

				buffer_write(send_buffer, buffer_f16, host_x);
				buffer_write(send_buffer, buffer_f16, host_y);
				buffer_write(send_buffer, buffer_u16, host_weapon_id);
				buffer_write(send_buffer, buffer_u8, host_scope);
				buffer_write(send_buffer, buffer_u8, host_barrel);
				buffer_write(send_buffer, buffer_u8, host_grip);
				buffer_write(send_buffer, buffer_u8, host_suppressor);
				buffer_write(send_buffer, buffer_s16, host_ammo);
				buffer_write(send_buffer, buffer_s16, host_clip_ammo);
			}
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












