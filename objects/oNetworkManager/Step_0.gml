/* oNetworkManager - Step */
if (is_server) {
    // ~20 Hz broadcast
    accum_server += delta_time / 1000000;
    if (accum_server >= 1/20) {
        var srv = find_player_by_network_id(0);
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
				
				var bit_states = 0;
				if (global.GodMode) { bit_states |= PLAYER_FLAGS.GODMODE; }
				ds_map_set(data, "state",  bit_states);
            }
            ds_map_set(data, "timestamp", current_time);
        }
        send_player_state_to_all();
		
		if(equipment_changed){
			send_equipment_to_all();	
			equipment_changed = false;
		}
		
        accum_server = 0;
    }

    check_client_timeouts();
}

if (!is_server && is_connected) {
    // player update ~30 Hz
    send_timer += delta_time / 1000000;
    if (send_timer >= send_rate) {
        send_player_state_update_client();
        send_timer = 0;
    }

    // heartbeat ~2 Hz
    hb_client += delta_time / 1000000;
    if (hb_client >= 0.5) {
        send_heartbeat();
        hb_client = 0;
    }
	
	if(equipment_changed){
	    send_equipment_update_client();
	    equipment_changed = false; // Reset flag after sending
	}
}

