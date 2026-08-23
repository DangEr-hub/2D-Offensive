/* Helper functions for networking */
function bit_state_has(st, flag){ 
	return (st & flag) != 0; 
}

function compute_item_network_id() {
    with (oNetworkManager) {
        // Použij volné item id
        if (ds_stack_size(free_item_ids) > 0) {
            return ds_stack_pop(free_item_ids);
        }
    }
}

function compute_bird_network_id() {
    with (oNetworkManager) {
        // Použij volné bird id
        if (ds_stack_size(free_bird_ids) > 0) {
            return ds_stack_pop(free_bird_ids);
        }
    }
}

function compute_grenade_network_id() {
    with (oNetworkManager) {
        if (free_grenade_ids != -1 && ds_exists(free_grenade_ids, ds_type_stack) && ds_stack_size(free_grenade_ids) > 0) {
            return ds_stack_pop(free_grenade_ids);
        }
    }
    return irandom(65535);
}

function compute_airplane_network_id() {
    with (oNetworkManager) {
        if (free_airplane_ids != -1 && ds_exists(free_airplane_ids, ds_type_stack) && ds_stack_size(free_airplane_ids) > 0) {
            return ds_stack_pop(free_airplane_ids);
        }
    }
    return irandom(65535);
}

function hit_remote_object(damage, object, BodyPart, impact_pos, hit_spd_mod, aimpunch_modifier, equip_dur, attacker_pid, attacker_item_id = Item.None){
	
	var blood_color = c_red;
	if(BodyPart <= HITBOX.HeadProne){
		blood_color = c_maroon;
	}

	object.attack_damage = damage;

	var armour_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
	var helmet_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
	var shield_id = global.Inventory[# OtherSlot.Shield, Index.slot_id];
	var update_local_inventory = true;
	
	if(IS_NET && object.object_index == oPlayer){
		update_local_inventory = (object.network_id == oNetworkManager.my_pid);

		if(!update_local_inventory){
			armour_id = object.network_armour_id;
			helmet_id = object.network_helmet_id;
			shield_id = object.network_shield_id;
		}
	}

	damage_indicator("-" + string(damage), impact_pos[0], impact_pos[1], c_white, spr_Icons, ICON.health);
	create_blood(round(damage / 5), impact_pos[0], impact_pos[1], blood_color, round(damage / 2));
	hit_effects(BodyPart, armour_id, helmet_id, shield_id,
	equip_dur[0], equip_dur[1], equip_dur[2], impact_pos[0], impact_pos[1], find_instance_by_network_id(oPlayer, attacker_pid), object, true); //true - serverově to je zatím vždy hráč
	statistics_hit("Health", damage, object);

	if(IS_NET && object.object_index == oPlayer){
		with(object){
			network_armour_dur = equip_dur[0];
			network_helmet_dur = equip_dur[1];
			network_shield_dur = equip_dur[2];
		}

		var attacker = find_instance_by_network_id(oPlayer, attacker_pid);
		var attacker_name = "Player " + string(attacker_pid);
		var hitmap_attacker_key = attacker_pid;
		var hitmap_attacker = attacker;
		if(instance_exists(attacker)){
			attacker_name = attacker.stats.Name;
		}
		if (attacker_item_id == Item.Bomb) {
			hitmap_attacker_key = HITMAP_KEY_BOMB;
			attacker_name = global.ItemIndex[# Item.Bomb, ItemStat.Name];
			hitmap_attacker = noone;
		}

		var should_record_hitmap = oNetworkManager.is_server || object.is_local || (instance_exists(attacker) && attacker.is_local);

		if(should_record_hitmap){
			var effective_damage = min(damage, max(object.stats.Health_points, 0));
			hitmap_record_hit(object, hitmap_attacker, hitmap_attacker_key, attacker_name, object.network_id, object.stats.Name, effective_damage);
		}
	}

	if(!IS_NET || update_local_inventory){
		global.Inventory[# OtherSlot.Armour, Index.slot_durability] = equip_dur[0];
		global.Inventory[# OtherSlot.Helmet, Index.slot_durability] = equip_dur[1];
		global.Inventory[# OtherSlot.Shield, Index.slot_durability] = equip_dur[2];
	}
	if(damage > 2){
		with(object){
			AimPunchDir = irandom(sprite_get_number(spr_AimPunch) - 1);
			AimPunchTimer = AimPunchTime;
			AimPunchMultiplier = aimpunch_modifier;
			aimpunch_speed_multiplier = hit_spd_mod;
		}
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
			ds_map_set(data, "shield_id",  global.Inventory[# OtherSlot.Shield, Index.slot_id]);
			ds_map_set(data, "shield_dur", global.Inventory[# OtherSlot.Shield, Index.slot_durability]);
		}
	}
}

function weapon_network_propagate(){
	/* oPlayer local function */
	if (is_local && IS_NET) {
		oNetworkManager.weapon_sync = true;

		// pokud je to server hráč (pid 0), musí aktualizovat player_states
		if (oNetworkManager.is_server) {
			var data = ds_map_find_value(oNetworkManager.player_states, network_id);
			if (is_undefined(data)) {
				data = ds_map_create();
				ds_map_add(oNetworkManager.player_states, network_id, data);
			}

			ds_map_set(data, "weapon_id", global.Inventory[# WeaponID, Index.slot_id]);
			ds_map_set(data, "weapon_scope", global.Inventory[# WeaponID, Index.slot_scope]);
			ds_map_set(data, "weapon_barrel", global.Inventory[# WeaponID, Index.slot_barrel]);
			ds_map_set(data, "weapon_grip", global.Inventory[# WeaponID, Index.slot_grip]);
			ds_map_set(data, "weapon_suppressor", global.Inventory[# WeaponID, Index.slot_suppressor]);
			ds_map_set(data, "weapon_ammo", global.Inventory[# WeaponID, Index.slot_ammo]);
			ds_map_set(data, "weapon_clip_ammo", global.Inventory[# WeaponID, Index.slot_clip_ammo]);
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
        ds_map_add(player_data, "state", 0);
        ds_map_add(player_data, "moving_state", player.moving_state);
        ds_map_add(player_data, "Team", player.stats.Team);
        ds_map_add(player_data, "hp", player.stats.Health_points);
        
        // Initialize equipment with current values
        ds_map_add(player_data, "helmet_id", global.Inventory[# OtherSlot.Helmet, Index.slot_id]);
        ds_map_add(player_data, "helmet_dur", global.Inventory[# OtherSlot.Helmet, Index.slot_durability]);
        ds_map_add(player_data, "armour_id", global.Inventory[# OtherSlot.Armour, Index.slot_id]);
        ds_map_add(player_data, "armour_dur", global.Inventory[# OtherSlot.Armour, Index.slot_durability]);
        ds_map_add(player_data, "shield_id", global.Inventory[# OtherSlot.Shield, Index.slot_id]);
        ds_map_add(player_data, "shield_dur", global.Inventory[# OtherSlot.Shield, Index.slot_durability]);
        ds_map_add(player_data, "weapon_id", global.Inventory[# player.WeaponID, Index.slot_id]);
        ds_map_add(player_data, "weapon_scope", global.Inventory[# player.WeaponID, Index.slot_scope]);
        ds_map_add(player_data, "weapon_barrel", global.Inventory[# player.WeaponID, Index.slot_barrel]);
        ds_map_add(player_data, "weapon_grip", global.Inventory[# player.WeaponID, Index.slot_grip]);
        ds_map_add(player_data, "weapon_suppressor", global.Inventory[# player.WeaponID, Index.slot_suppressor]);
        ds_map_add(player_data, "weapon_ammo", global.Inventory[# player.WeaponID, Index.slot_ammo]);
        ds_map_add(player_data, "weapon_clip_ammo", global.Inventory[# player.WeaponID, Index.slot_clip_ammo]);
        
        ds_map_add(player_states, pid, player_data);
    }
    
    return player;
}

/// @function create_remote_player(pid, x_pos, y_pos)
function apply_remote_player_network_state(player, pid) {
    if (!instance_exists(player) || !instance_exists(oNetworkManager)) return;

    var player_data = ds_map_find_value(oNetworkManager.player_states, pid);
    if (is_undefined(player_data)) return;

    var dir = ds_map_find_value(player_data, "dir");
    var bit_state = ds_map_find_value(player_data, "state");
    var moving_state_id = ds_map_find_value(player_data, "moving_state");
    var team_id = ds_map_find_value(player_data, "Team");
    var item_use_id = ds_map_find_value(player_data, "item_use_id");
    var hp = ds_map_find_value(player_data, "hp");
    var helmet_id = ds_map_find_value(player_data, "helmet_id");
    var helmet_dur = ds_map_find_value(player_data, "helmet_dur");
    var armour_id = ds_map_find_value(player_data, "armour_id");
    var armour_dur = ds_map_find_value(player_data, "armour_dur");
    var shield_id = ds_map_find_value(player_data, "shield_id");
    var shield_dur = ds_map_find_value(player_data, "shield_dur");
    var weapon_id = ds_map_find_value(player_data, "weapon_id");
    var weapon_scope = ds_map_find_value(player_data, "weapon_scope");
    var weapon_barrel = ds_map_find_value(player_data, "weapon_barrel");
    var weapon_grip = ds_map_find_value(player_data, "weapon_grip");
    var weapon_suppressor = ds_map_find_value(player_data, "weapon_suppressor");

    with (player) {
        if (!is_undefined(dir)) {
            RotationAngle = dir;
            target_direction = dir;
        }
        if (!is_undefined(bit_state)) {
            network_bit_state = bit_state;
            network_throw_grenade = (bit_state & PLAYER_FLAGS.THROWING_GRENADE) != 0;
        }
        if (!is_undefined(moving_state_id)) {
            network_moving_state = moving_state_id;
            moving_state = moving_state_id;
        }
        if (!is_undefined(team_id)) stats.Team = team_id;
        if (!is_undefined(item_use_id)) network_item_use_id = item_use_id;
        if (!is_undefined(hp) && !is_undefined(stats)) stats.Health_points = hp;

        if (!is_undefined(helmet_id)) network_helmet_id = helmet_id;
        if (!is_undefined(helmet_dur)) network_helmet_dur = helmet_dur;
        if (!is_undefined(armour_id)) network_armour_id = armour_id;
        if (!is_undefined(armour_dur)) network_armour_dur = armour_dur;
        if (!is_undefined(shield_id)) network_shield_id = shield_id;
        if (!is_undefined(shield_dur)) network_shield_dur = shield_dur;

        if (!is_undefined(weapon_id)) network_weapon_id = weapon_id;
        if (!is_undefined(weapon_scope)) network_scope = weapon_scope;
        if (!is_undefined(weapon_barrel)) network_barrel = weapon_barrel;
        if (!is_undefined(weapon_grip)) network_grip = weapon_grip;
        if (!is_undefined(weapon_suppressor)) network_suppressor = weapon_suppressor;
    }
}

function position_in_bomb_area(_x, _y, _map_id = global.MapID){
	if(_map_id < 0 || _map_id >= MAP.Total){
		return false;
	}

	var bomb_areas = global.MapProperties[# _map_id, MAP_STAT.BombAreas];
	if(!ds_exists(bomb_areas, ds_type_map)){
		return false;
	}

	var area_key = ds_map_find_first(bomb_areas);
	while(!is_undefined(area_key)){
		var area = bomb_areas[? area_key];
		if(is_array(area) && array_length(area) >= 4
		&& point_in_rectangle(_x, _y, area[0], area[1], area[2], area[3])){
			return true;
		}
		area_key = ds_map_find_next(bomb_areas, area_key);
	}

	return false;
}

function find_living_player_teammate(team, excluded_player = noone) {
	var player_count = instance_number(oPlayer);
	for (var player_index = 0; player_index < player_count; player_index++) {
		var player = instance_find(oPlayer, player_index);
		if (instance_exists(player)
		&& player != excluded_player
		&& player.stats.Team == team
		&& player.stats.Health_points > 0) {
			return player;
		}
	}
	return noone;
}

function create_remote_player(pid, x_pos, y_pos) {
    var player = instance_create_layer(x_pos, y_pos, "LivingO", oPlayer);
    player.network_id = pid;
    player.is_local = false;
    player.is_remote = true;
    player.target_x = x_pos;
    player.target_y = y_pos;
    apply_remote_player_network_state(player, pid);

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

function sync_object_create(x_pos, y_pos, create_data) {
    with (oNetworkManager) {
        if (!is_server) return noone;
        
        var inst = instance_create_layer(x_pos, y_pos, "ItemsO", create_data.obj_index);
		inst.creating_network_item = true;
        inst.network_id = compute_item_network_id();
        inst.image_index = create_data.img_index;
        inst.scope_attachment = create_data.scope;
        inst.barrel_attachment = create_data.barrel;
        inst.grip_attachment = create_data.grip;
        inst.suppressor_attachment = create_data.suppressor;
        inst.ClipAmmo = create_data.clip_ammo;
        inst.Ammo = create_data.ammo;
        inst.Durability = create_data.durability;
		inst.Amount = create_data.amount;
        
        var data = ds_map_create();
        ds_map_set(data, "obj_index", inst.object_index);
        ds_map_set(data, "x", x_pos);
        ds_map_set(data, "y", y_pos);
        ds_map_set(data, "image_index", inst.image_index);
		ds_map_set(data, "scope", inst.scope_attachment);
		ds_map_set(data, "barrel", inst.barrel_attachment);
		ds_map_set(data, "grip", inst.grip_attachment);
		ds_map_set(data, "suppressor", inst.suppressor_attachment);
		ds_map_set(data, "clip_ammo", inst.ClipAmmo);
		ds_map_set(data, "ammo", inst.Ammo);
		ds_map_set(data, "durability", inst.Durability);
		ds_map_set(data, "amount", inst.Amount);
        ds_map_set(item_registry, inst.network_id, data);
				
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u8, 0);       // create
        buffer_write(send_buffer, buffer_u16, inst.network_id); // net_id
        buffer_write(send_buffer, buffer_u16, inst.object_index); // object_index
        buffer_write(send_buffer, buffer_f16, x_pos);
        buffer_write(send_buffer, buffer_f16, y_pos);
        buffer_write(send_buffer, buffer_u8,  inst.image_index);
        buffer_write(send_buffer, buffer_u8,  inst.scope_attachment);
        buffer_write(send_buffer, buffer_u8,  inst.barrel_attachment);
        buffer_write(send_buffer, buffer_u8,  inst.grip_attachment);
        buffer_write(send_buffer, buffer_u8,  inst.suppressor_attachment);
        buffer_write(send_buffer, buffer_s16,  inst.ClipAmmo);
        buffer_write(send_buffer, buffer_s16,  inst.Ammo);
        buffer_write(send_buffer, buffer_f16,  inst.Durability);
		buffer_write(send_buffer, buffer_u16, inst.Amount);
        
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
       // if (is_undefined(inst_id.network_id)) {
      //      instance_destroy(inst_id);
       //     return;
       // }
        
        var net_id = inst_id.network_id;
		var obj_ind = inst_id.object_index;
        
        if (ds_map_exists(item_registry, net_id)) {
            var data = ds_map_find_value(item_registry, net_id);
            ds_map_destroy(data);
            ds_map_delete(item_registry, net_id);
        }
		
        if (net_id >= 0) {
            ds_stack_push(free_item_ids, net_id);
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
			instance_destroy(inst_id);
        }
    }
}

function request_item_drop(ID, PositionX, PositionY, ObjectAmmo = -1, ObjectClipAmmo = -1, ObjectDurability = -1,ObjectAmount = 1, OWSA = -1, OWBA = -1, OWGA = -1, OWsuppressorA = -1){
    // V singleplayeru rovnou dropni item
    if (!IS_NET) {
        ItemDrop(ID, PositionX, PositionY,
            ObjectAmmo, ObjectClipAmmo, ObjectDurability,
            ObjectAmount, OWSA, OWBA, OWGA, OWsuppressorA);
        return;
    }else{
	    with (oNetworkManager) {
	        if (is_server) {
	            // Servere prostě to udělej rovnou
	            ItemDrop(ID, PositionX, PositionY,
	                ObjectAmmo, ObjectClipAmmo, ObjectDurability,
	                ObjectAmount, OWSA, OWBA, OWGA, OWsuppressorA);
	        } else {
	            // Kliente pošli request o dropnutí itemu
	            buffer_seek(send_buffer, buffer_seek_start, 0);
	            buffer_write(send_buffer, buffer_u8,  PACKET.OBJECT_SYNC);
	            buffer_write(send_buffer, buffer_u32, send_sequence++);
	            buffer_write(send_buffer, buffer_u8,  0); // creatnutí itemu

	            buffer_write(send_buffer, buffer_u8,  ID);
				buffer_write(send_buffer, buffer_u16, oItems);
	            buffer_write(send_buffer, buffer_f16, PositionX);
	            buffer_write(send_buffer, buffer_f16, PositionY);
	            buffer_write(send_buffer, buffer_u8,  OWSA);
	            buffer_write(send_buffer, buffer_u8,  OWBA);
	            buffer_write(send_buffer, buffer_u8,  OWGA);
	            buffer_write(send_buffer, buffer_u8,  OWsuppressorA);
	            buffer_write(send_buffer, buffer_s16, ObjectClipAmmo);
	            buffer_write(send_buffer, buffer_s16, ObjectAmmo);
	            buffer_write(send_buffer, buffer_f16, ObjectDurability);
				buffer_write(send_buffer, buffer_u16, ObjectAmount);

	            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
	        }
	    }
	}
}

