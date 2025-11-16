/* Helper functions for networking */
function bit_state_has(st, flag){ 
	return (st & flag) != 0; 
}


function write_debug(text, file_name = "debug_log.txt"){
	var f = file_text_open_append(file_name);
	file_text_write_string(f, string(text));
	file_text_write_string(f, "\n");
	file_text_close(f);	
}


function equip_network_propagate(){
	/* oPlayer local function */
	if (is_local && instance_exists(oNetworkManager)) {
		oNetworkManager.equipment_changed = true;

		// pokud je to server hráč (pid 0), musí aktualizovat player_states
		if (oNetworkManager.is_server) {
			var data = ds_map_find_value(oNetworkManager.player_states, network_id);
			if (is_undefined(data)) {
				data = ds_map_create();
				ds_map_add(oNetworkManager.player_states, network_id, data);
			}

			ds_map_set(data, "helmet_id",  global.Inventory[# OtherSlot.Helmet, Index.slot_id]);
			ds_map_set(data, "helmet_dur", global.Inventory[# OtherSlot.Helmet, Index.slot_durability]);
			ds_map_set(data, "armour_id",  global.Inventory[# OtherSlot.Armour, Index.slot_id]);
			ds_map_set(data, "armour_dur", global.Inventory[# OtherSlot.Armour, Index.slot_durability]);
		}
	}
}


function get_local_player(){
    with (oPlayer) {
        if (is_local == true) {
            return id;
        }
    }
    return noone;
}

function sent_server_udp(server_socket, socket_key, send_buffer){
	var parts = string_split(socket_key, ":");
	var ip = parts[0];
	var port = real(parts[1]);
	network_send_udp(server_socket, ip, port, send_buffer, buffer_tell(send_buffer));

}

function create_local_player(pid) {
    var player = instance_create_layer(200, 200, "Instances", oPlayer);
    player.network_id = pid;
    player.is_local = true;
    player.is_remote = false;
    
    // Store player data
    with (oNetworkManager) {
        var player_data = ds_map_create();
        ds_map_add(player_data, "x", player.x);
        ds_map_add(player_data, "y", player.y);
        ds_map_add(player_data, "dir", player.RotationAngle);
        
        // Initialize equipment with current values
        ds_map_add(player_data, "helmet_id", global.Inventory[# OtherSlot.Helmet, Index.slot_id]);
        ds_map_add(player_data, "helmet_dur", global.Inventory[# OtherSlot.Helmet, Index.slot_durability]);
        ds_map_add(player_data, "armour_id", global.Inventory[# OtherSlot.Armour, Index.slot_id]);
        ds_map_add(player_data, "armour_dur", global.Inventory[# OtherSlot.Armour, Index.slot_durability]);
        
        ds_map_add(player_states, pid, player_data);
    }
    
    show_debug_message("Created local player with ID: " + string(pid));
    return player;
}

/// @function create_remote_player(pid, x_pos, y_pos)
function create_remote_player(pid, x_pos, y_pos) {
    var player = instance_create_layer(x_pos, y_pos, "Instances", oPlayer);
    player.network_id = pid;
    player.is_local = false;
    player.is_remote = true;
    player.target_x = x_pos;
    player.target_y = y_pos;
    
    show_debug_message("Created remote player with ID: " + string(pid));
    return player;
}

/// @function find_player_by_network_id(pid)
function find_player_by_network_id(pid) {
    with (oPlayer) {
        if (network_id == pid) {
            return id;
        }
    }
    return noone;
}

/// @function sync_object_create(object, x_pos, y_pos, layer_name)
/// Synchronizes object creation across network
function sync_object_create(object, x_pos, y_pos, layer_name) {
    with (oNetworkManager) {
        if (!is_server && !is_connected) return noone;
        
        var obj_id = irandom(65535);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 0); // 0 = create
        buffer_write(send_buffer, buffer_u16, obj_id);
        buffer_write(send_buffer, buffer_u16, object);
        buffer_write(send_buffer, buffer_f32, x_pos);
        buffer_write(send_buffer, buffer_f32, y_pos);
        
        if (is_server) {
            var socket_key = ds_map_find_first(clients);
            for (var i = 0; i < ds_map_size(clients); i++) {
                sent_server_udp(server_socket, socket_key, send_buffer)
                socket_key = ds_map_find_next(clients, socket_key);
            }
        } else {
            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer))
        }
        
        // Create locally
        var inst = instance_create_layer(x_pos, y_pos, layer_name, object);
        inst.network_id = obj_id;
        
        return inst;
    }
}

/// @function sync_object_destroy(inst_id)
/// Synchronizes object destruction across network
function sync_object_destroy(inst_id) {
    with (oNetworkManager) {
        if (!is_server && !is_connected) return;
        
        if (!instance_exists(inst_id)) return;
        
        var net_id = inst_id.network_id;
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 1); // 1 = destroy
        buffer_write(send_buffer, buffer_u16, net_id);
        
        if (is_server) {
            var socket_key = ds_map_find_first(clients);
            for (var i = 0; i < ds_map_size(clients); i++) {
                sent_server_udp(server_socket, socket_key, send_buffer)
                socket_key = ds_map_find_next(clients, socket_key);
            }
        } else {
            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer))
        }
        
        instance_destroy(inst_id);
    }
}