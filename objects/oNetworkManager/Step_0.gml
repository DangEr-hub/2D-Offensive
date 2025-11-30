/* oNetworkManager - Step */
if (is_server) {
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
				ds_map_set(data, "health", stats.Health_points);
				
				var bit_states = 0;
				if (global.GodMode) { bit_states |= PLAYER_FLAGS.GODMODE; }
				if(Moving){ bit_states |= PLAYER_FLAGS.MOVING; }
				if(Reloading){ bit_states |= PLAYER_FLAGS.RELOADING; }
				if(Flashed){ bit_states |= PLAYER_FLAGS.FLASHED; }
				ds_map_set(data, "state",  bit_states);
            }
            ds_map_set(data, "timestamp", current_time);
        }
        send_tick_broadcast();
		
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
	
	if(equipment_sync){
	    send_equipment_update_client();
	    equipment_sync = false; // Reset flag after sending
	}
	
	if(weapon_sync){
	    send_weapon_update_client();
	    weapon_sync = false; // Reset flag after sending
	}
}

