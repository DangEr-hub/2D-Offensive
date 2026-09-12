/* oNetworkManager - Step */
if (instance_exists(global.local_player)) {
	item_use_resync_timer += delta_time / 1000000;
	var current_item_use_id = global.Inventory[# global.local_player.item_use_position, Index.slot_id];
	if (global.local_player.Healing && global.local_player.HealingItemId != Item.None) {
		current_item_use_id = global.local_player.HealingItemId;
	}
	var item_use_changed = current_item_use_id != last_item_use_id;
	if (item_use_changed || item_use_resync_timer >= item_use_resync_interval) {
		last_item_use_id = current_item_use_id;
		item_use_resync_timer = 0;

		if (is_server) {
			var local_data = ds_map_find_value(player_states, global.local_player.network_id);
			if (is_undefined(local_data)) {
				local_data = ds_map_create();
				ds_map_add(player_states, global.local_player.network_id, local_data);
			}
			ds_map_set(local_data, "item_use_id", current_item_use_id);
			server_item_use_broadcast(global.local_player.network_id, current_item_use_id);
		} else if (is_connected) {
			send_item_use_update_client(current_item_use_id);
		}
	}
}

if (is_server) {
	server_update_health_regeneration();
	server_update_defusing();

	stats_sync_timer += delta_time / 1000000;
	if(stats_sync_timer >= stats_sync_interval){
		send_stats_broadcast();
		stats_sync_timer = 0;
	}

	molotov_sync_timer += delta_time / 1000000;
	if(molotov_sync_timer >= molotov_sync_interval){
		server_molotov_state_broadcast();
		molotov_sync_timer = 0;
	}

    // ~20 Hz broadcast
    accum_server += delta_time / 1000000;
    if (accum_server >= 1/20) {
        var srv = find_instance_by_network_id(oPlayer, 0);
        if (instance_exists(srv)) {
            var data = ds_map_find_value(player_states, 0);
            if (is_undefined(data)) {
                data = ds_map_create();
                ds_map_add(player_states, 0, data);
            }
			with (srv) {
                ds_map_set(data, "x", x);
                ds_map_set(data, "y", y);
                ds_map_set(data, "dir", RotationAngle);
				ds_map_set(data, "hp", stats.Health_points);
				
				var bit_states = 0;
				if (global.GodMode) { bit_states |= PLAYER_FLAGS.GODMODE; }
				if(Moving){ bit_states |= PLAYER_FLAGS.MOVING; }
				if(Reloading){ bit_states |= PLAYER_FLAGS.RELOADING; }
				if(Flashed){ bit_states |= PLAYER_FLAGS.FLASHED; }
				if(moving_state == STATES_PLAYER.prone_state){ bit_states |= PLAYER_FLAGS.PRONE; }
				if(EquippedGrenadeTimer > -1){ bit_states |= PLAYER_FLAGS.THROWING_GRENADE; }
				if(planting){ bit_states |= PLAYER_FLAGS.PLANTING; }
				if(defusing){ bit_states |= PLAYER_FLAGS.DEFUSING; }
				if(Healing){ bit_states |= PLAYER_FLAGS.HEALING; }
				if(walking){ bit_states |= PLAYER_FLAGS.WALKING; }
				if(running){ bit_states |= PLAYER_FLAGS.RUNNING; }
				ds_map_set(data, "state",  bit_states);
				ds_map_set(data, "defuse_has_kit", find_item(Item.DefuseKit) != -1);
				var previous_defusing_target = ds_map_find_value(data, "defusing_target");
				if (!is_undefined(previous_defusing_target) && previous_defusing_target != defusing_target) {
					ds_map_set(data, "defusing_time", 0);
				}
				ds_map_set(data, "defusing_target", defusing_target);
				ds_map_set(data, "moving_state", moving_state);
				ds_map_set(data, "Team", stats.Team);
				ds_map_set(data, "weapon_id", global.Inventory[# WeaponID, Index.slot_id]);
				ds_map_set(data, "weapon_scope", global.Inventory[# WeaponID, Index.slot_scope]);
				ds_map_set(data, "weapon_barrel", global.Inventory[# WeaponID, Index.slot_barrel]);
				ds_map_set(data, "weapon_grip", global.Inventory[# WeaponID, Index.slot_grip]);
				ds_map_set(data, "weapon_suppressor", global.Inventory[# WeaponID, Index.slot_suppressor]);
				ds_map_set(data, "weapon_ammo", global.Inventory[# WeaponID, Index.slot_ammo]);
				ds_map_set(data, "weapon_clip_ammo", global.Inventory[# WeaponID, Index.slot_clip_ammo]);
				server_update_reload_state(0, bit_states);
            }
            ds_map_set(data, "timestamp", current_time);
        }
        send_tick_broadcast();
        server_cleanup_projectiles();
		
		/// Player equipments update
		if(equipment_sync){
			send_equipment_broadcast();	
			equipment_sync = false;
		}
		
		/// Player weapons update
		if(weapon_sync){
			send_weapon_broadcast();
			weapon_sync = false;
		}
		
		///// Item position update
        ds_list_clear(item_pos_buffer);

        with (oItems) {
            if (needs_sync) {
                ds_list_add(other.item_pos_buffer, id);
                needs_sync = false;
            }
        }

        if (ds_list_size(item_pos_buffer) > 0) {
            send_object_pos_sync_broadcast();
        }
		
        accum_server = 0;
    }

    check_client_timeouts();
}

if (!is_server && is_connected) {
	if (current_time - last_server_packet_time > server_timeout_threshold) {
		handle_server_disconnect();
		exit;
	}

    // player update ~30 Hz
    send_timer += delta_time / 1000000;
    if (send_timer >= send_rate) {
        send_tick_update_client();
        send_timer = 0;
    }

    // heartbeat ~2 Hz
    hb_client += delta_time / 1000000;
    if (hb_client >= 0.5) {
        send_heartbeat();
        hb_client = 0;
    }
	
    // latency checks ~1 Hz (configurable)
    ping_timer += delta_time / 1000000;
    if (ping_timer >= ping_interval) {
        send_ping_request();
        ping_timer = 0;
    }
	
	if(equipment_sync){
	    send_equipment_update_client();
	    equipment_sync = false; // Reset flag after sending
	}
	
	if(weapon_sync){
	    send_weapon_update_client();
	    weapon_sync = false; // Reset flag after sending
	}
}

