/// oNetworkManager - Step
if (is_server) {
    // časování broadcastu (např. 20 Hz)
    var accum = 0;
    accum += delta_time / 1000000; // sekundy
    if (accum >= 1/20) {
		var my_pid = 0;
        var srv = find_player_by_network_id(my_pid); // pid=0
        if (instance_exists(srv)) {
            var data = ds_map_find_value(player_positions, my_pid);
            if (is_undefined(data)) {
                data = ds_map_create();
                ds_map_add(player_positions, my_pid, data);
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
        send_game_state_to_all(); // ← tohle je klíčové :contentReference[oaicite:0]{index=0}
        accum = 0;
    }

    // timeouts + disconnecty
    check_client_timeouts(); // už máš implementované :contentReference[oaicite:1]{index=1}
}

/// oNetworkManager - Step
if (!is_server && is_connected) {
    // posílej svůj stav ~30 Hz (už máš send_rate v create)
    send_timer += delta_time / 1000000;
    if (send_timer >= send_rate) {
        send_player_update();    // pošle x,y,RotationAngle,XSpeed,YSpeed,state :contentReference[oaicite:3]{index=3}
        send_timer = 0;
    }

    var hb = 0;
    hb += delta_time / 1000000;
    if (hb >= 0.5) {
        send_heartbeat();
        hb = 0;
    }
}
