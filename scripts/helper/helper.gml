/* Helper functions for networking */
function bit_state_has(st, flag){ 
	return (st & flag) != 0; 
}

function compute_item_network_id() {
    static next_id = 0; //Nezmění se při dalším volání zpátky na nulu
    next_id = (next_id + 1) & 0x01FF; // 0..511, max 512 itemů
    return next_id;
}


function hit_remote_object(damage, object, hitbox_type, impact_pos, hit_spd_mod, aimpunch_modifier, equip_dur){
	
	var blood_color = c_red;
	if(hitbox_type <= HitBox.HeadProne){
		blood_color = c_maroon;
	}
	
	damage_indicator("-" + string(damage), impact_pos[0], impact_pos[1], c_white, spr_Icons, icons.health);
	create_blood_particle(ceil(damage / 5), impact_pos[0], impact_pos[1], blood_color, ceil(damage / 2));		
	statistics_hit("Health", damage, object);
	global.Inventory[# OtherSlot.Armour, Index.slot_durability] = equip_dur[0];
	global.Inventory[# OtherSlot.Helmet, Index.slot_durability] = equip_dur[1];
	with(object){
	    AimPunchDir = irandom(sprite_get_number(spr_AimPunch) - 1);
		AimPunchTimer = AimPunchTime;
		AimPunchMultiplier = aimpunch_modifier;
		aimpunch_speed_multiplier = hit_spd_mod;
	}
}

function write_debug(text, file_name = "debug_log.txt"){
	var f = file_text_open_append(file_name);
	file_text_write_string(f, string(text));
	file_text_write_string(f, "\n");
	file_text_close(f);	
}


function equip_network_propagate(){
	/* oPlayer local function */
	if (is_local && IS_NET) {
		oNetworkManager.equipment_sync = true;

		// pokud je to server hráč (pid 0), musí aktualizovat player_states
		if (IS_SERVER) {
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

function weapon_network_propagate(){
	/* oPlayer local function */
	if (is_local && IS_NET) {
		oNetworkManager.weapon_sync = true;

		// pokud je to server hráč (pid 0), musí aktualizovat player_states
		if (IS_SERVER) {
			var data = ds_map_find_value(oNetworkManager.player_states, network_id);
			if (is_undefined(data)) {
				data = ds_map_create();
				ds_map_add(oNetworkManager.player_states, network_id, data);
			}

			ds_map_set(data, "weapon_id",  global.Inventory[# WeaponID, Index.slot_id]);
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
    var player = instance_create_layer(200, 200, "LivingO", oPlayer);
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
    
    return player;
}

/// @function create_remote_player(pid, x_pos, y_pos)
function create_remote_player(pid, x_pos, y_pos) {
    var player = instance_create_layer(x_pos, y_pos, "LivingO", oPlayer);
    player.network_id = pid;
    player.is_local = false;
    player.is_remote = true;
    player.target_x = x_pos;
    player.target_y = y_pos;
	
    var h_id = 0, h_dur = 0, a_id = 0, a_dur = 0, w_id = 0;
    with (oNetworkManager) {
        var pdata = ds_map_find_value(player_states, pid);
        if (!is_undefined(pdata)) {
            other.h_id  = ds_map_find_value(pdata, "helmet_id");
            other.h_dur = ds_map_find_value(pdata, "helmet_dur");
            other.a_id  = ds_map_find_value(pdata, "armour_id");
            other.a_dur = ds_map_find_value(pdata, "armour_dur");
            other.w_id  = ds_map_find_value(pdata, "weapon_id");
        }
    }
	write_debug(h_id);
    with (player) {
        network_helmet_id  = h_id;
        network_helmet_dur = h_dur;
        network_armour_id  = a_id;
        network_armour_dur = a_dur;
        network_weapon_id  = w_id;
    }

    return player;
}


function find_instance_by_network_id(object, net_id) {
	with (object) {
	    if (network_id == net_id) {
	            return id;
	    }
	}
	return noone;
}

function sync_object_create(object_ind, x_pos, y_pos, net_id) {
    with (oNetworkManager) {
        if (!is_server) return noone;
        
        var obj_id = net_id;
        if (is_undefined(obj_id)) {
            obj_id = compute_item_network_id();
        }
        
        var inst = instance_create_layer(x_pos, y_pos, "ItemsO", object_ind);
        inst.network_id = obj_id;
        
        var data = ds_map_create();
        ds_map_set(data, "object_index", object_ind);
        ds_map_set(data, "x", x_pos);
        ds_map_set(data, "y", y_pos);
        ds_map_set(data, "image_index", inst.image_index);
        ds_map_set(item_registry, obj_id, data);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 0);       // create
        buffer_write(send_buffer, buffer_u16, obj_id); // net_id
        buffer_write(send_buffer, buffer_u16, object_ind); // object_index
        buffer_write(send_buffer, buffer_f16, x_pos);
        buffer_write(send_buffer, buffer_f16, y_pos);
        buffer_write(send_buffer, buffer_u8,  inst.image_index);
        
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
        
        return inst;
    }
}


/// @function sync_object_destroy(inst_id)
function sync_object_destroy(inst_id) {
    with (oNetworkManager) {
        if (!is_server) return;
        if (!instance_exists(inst_id)) return;
        if (is_undefined(inst_id.network_id)) {
            instance_destroy(inst_id);
            return;
        }
        
        var net_id = inst_id.network_id;
		var obj_ind = inst_id.object_index;
        
        if (ds_map_exists(item_registry, net_id)) {
            var data = ds_map_find_value(item_registry, net_id);
            ds_map_destroy(data);
            ds_map_delete(item_registry, net_id);
        }
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 1);       // destroy
        buffer_write(send_buffer, buffer_u16, net_id); // id itemu
		buffer_write(send_buffer, buffer_u16, obj_ind);
        
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
        
        instance_destroy(inst_id);
    }
}

/// @function destroy_pickup_instance(inst_id)
/// Routes pickup destruction through the networking layer when available
function destroy_pickup_instance(inst_id) {
    if (!instance_exists(inst_id)) return;

    if (inst_id.object_index == oItems && IS_NET) {
        request_item_pickup(inst_id);
    } else {
		instance_destroy(inst_id);
    }
}

/// @function request_item_pickup(inst_id)
/// Sends a destroy request for an item pickup, or destroys immediately when hosting
function request_item_pickup(inst_id) {
    if (!instance_exists(inst_id)) return;

    with (oNetworkManager) {
        if (!is_connected) {
            instance_destroy(inst_id);
            return;
        }

        if (is_server) {
            sync_object_destroy(inst_id);
        } else {
            var net_id = inst_id.network_id;
			var obj_ind = inst_id.object_index;

            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
            buffer_write(send_buffer, buffer_u32, send_sequence++);
            buffer_write(send_buffer, buffer_u8, 1); // destroy request
            buffer_write(send_buffer, buffer_u16, net_id);
			buffer_write(send_buffer, buffer_u16, obj_ind);

            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
        }
    }
}

