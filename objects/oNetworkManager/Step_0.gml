/* oNetworkManager - Step */
if (is_server) {
    // ~20 Hz broadcast
    accum_server += delta_time / 1000000;
    if (accum_server >= 1/20) {
        var srv = find_player_by_network_id(0);
        if (instance_exists(srv)) {
            var data = ds_map_find_value(player_positions, 0);
            if (is_undefined(data)) {
                data = ds_map_create();
                ds_map_add(player_positions, 0, data);
            }
            with (srv) {
                ds_map_set(data, "x", x);
                ds_map_set(data, "y", y);
                ds_map_set(data, "dir", RotationAngle);
                ds_map_set(data, "vx", XSpeed);
                ds_map_set(data, "vy", YSpeed);
            }
            ds_map_set(data, "timestamp", current_time);
        }
        send_game_state_to_all();
        accum_server = 0;
    }

    check_client_timeouts();
}

if (!is_server && is_connected) {
    // player update ~30 Hz
    send_timer += delta_time / 1000000;
    if (send_timer >= send_rate) {
        send_player_update();
        send_timer = 0;
    }

    // heartbeat ~2 Hz
    hb_client += delta_time / 1000000;
    if (hb_client >= 0.5) {
        send_heartbeat();
        hb_client = 0;
    }
}
