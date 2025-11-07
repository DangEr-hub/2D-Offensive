/// Helper functions for networking
function sent_server_udp(server_socket, socket_key, send_buffer){
	var parts = string_split(socket_key, ":");
	var ip = parts[0];
	var port = real(parts[1]);
	network_send_udp(server_socket, ip, port, send_buffer, buffer_tell(send_buffer));

}
/// @function create_local_player(pid)
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
        ds_map_add(player_data, "vx", 0);
        ds_map_add(player_data, "vy", 0);
        ds_map_add(player_data, "timestamp", current_time);
        ds_map_add(player_positions, pid, player_data);
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
    player.interpolation_enabled = true;
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

/// @function send_projectile_spawn(x_pos, y_pos, dir, spd)
function send_projectile_spawn(x_pos, y_pos, dir, spd) {
    with (oNetworkManager) {
        if ((!is_server && !is_connected) || (is_server && server_socket < 0)) return;
        
        var proj_id = irandom(65535); // Random unique ID
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PROJECTILE_SPAWN);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, proj_id);
        buffer_write(send_buffer, buffer_u16, my_pid);
        buffer_write(send_buffer, buffer_f32, x_pos);
        buffer_write(send_buffer, buffer_f32, y_pos);
        buffer_write(send_buffer, buffer_f32, dir);
        buffer_write(send_buffer, buffer_f32, spd);
        
        if (is_server) {
            // Broadcast to all clients
            var socket_key = ds_map_find_first(clients);
            for (var i = 0; i < ds_map_size(clients); i++) {
                sent_server_udp(server_socket, socket_key, send_buffer)
                socket_key = ds_map_find_next(clients, socket_key);
            }
        } else {
            // Send to server
            network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
        }
        
        return proj_id;
    }
}

/// @function handle_projectile_spawn(socket_id)
function handle_projectile_spawn(socket_id) {
    with (oNetworkManager) {
        var proj_id = buffer_read(receive_buffer, buffer_u16);
        var owner_id = buffer_read(receive_buffer, buffer_u16);
        var x_pos = buffer_read(receive_buffer, buffer_f32);
        var y_pos = buffer_read(receive_buffer, buffer_f32);
        var dir = buffer_read(receive_buffer, buffer_f32);
        var spd = buffer_read(receive_buffer, buffer_f32);
        
        // Create projectile on server
        var proj = instance_create_layer(x_pos, y_pos, "Instances", obj_projectile);
        proj.network_id = proj_id;
        proj.owner_id = owner_id;
        proj.direction = dir;
        proj.speed = spd;
        
        // Relay to other clients
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, PACKET.PROJECTILE_SPAWN);
        buffer_write(send_buffer, buffer_u32, send_sequence++);
        buffer_write(send_buffer, buffer_u16, proj_id);
        buffer_write(send_buffer, buffer_u16, owner_id);
        buffer_write(send_buffer, buffer_f32, x_pos);
        buffer_write(send_buffer, buffer_f32, y_pos);
        buffer_write(send_buffer, buffer_f32, dir);
        buffer_write(send_buffer, buffer_f32, spd);
        
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            if (socket_key != socket_id) { // Don't send back to sender
                sent_server_udp(server_socket, socket_key, send_buffer);
            }
            socket_key = ds_map_find_next(clients, socket_key);
        }
    }
}

/// @function interpolate_position(current, target, amount)
function interpolate_position(current, target, amount) {
    return lerp(current, target, amount);
}

/// @function get_network_latency()
/// Returns estimated latency in milliseconds (placeholder - implement proper ping/pong)
function get_network_latency() {
    return 50; // Default 50ms
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