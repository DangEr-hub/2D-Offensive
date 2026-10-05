if(emitting_time == -1){
	exit;
}

// Multiplayer clients advance only the visual timers; the server supplies each ray.
if(IS_NET && instance_exists(oNetworkManager) && !oNetworkManager.is_server){
	if(!active) exit;
	if(laser_timer > -1) laser_timer--;
	if(emitting_timer > -1){
		if(emitting_timer > 0) l_dist = min(len, l_dist + l_spd);
		emitting_timer--;
	}
	if(emitting_timer == 0){
		laser_timer = laser_time;
		l_dist = 1;
		l_n = 0;
		l_points = [];
		l_stops = [];
	}
	
	exit;
}

var laser_state_changed = active != laser_last_active;
laser_last_active = active;
if(!active){
	emitting_timer = -1;
	laser_timer = round(laser_time);
	l_dist = 1;
	l_n = 0;
	l_points = [];
	l_stops = [];
	laser_hit = noone;
	ds_map_clear(damage_hits);
	if(IS_NET && laser_state_changed) server_send_laser_state(id);
	exit;
}


if(laser_timer == 0){ 
	laser_state_changed = true;
	emitting_timer = emitting_time;
	var listener_target = get_audio_listener_target();
	if(instance_exists(listener_target) && point_distance(x, y, listener_target.x, listener_target.y) <= 384){
		play_sound(x, y, snd_Laser);
	}
	l_n = irandom_range(10, 30);
	l_points = [];
	l_stops = [];
	var ang_range = random_range(5, 10);
	var angle_step = ang_range * 2 / (l_n - 1);
	for(var i = 0; i < l_n; i ++){
		var ray_angle = image_angle - ang_range + angle_step * i;
		if(i > 0 && i < l_n - 1) ray_angle += random_range(-angle_step * .3, angle_step * .3);
		var end_x = x + lengthdir_x(len, ray_angle);
		var end_y = y + lengthdir_y(len, ray_angle);
		var wall_hit = find_collision_point(x, y, end_x, end_y, oParentTile);
		array_push(l_points, ray_angle);
		array_push(l_stops, array_length(wall_hit) > 0
			? max(0, point_distance(x, y, wall_hit[0], wall_hit[1]) - 1)
			: len);
	}
}

if(laser_timer > -1){ laser_timer --; }

if(emitting_timer > -1){ 
	if(emitting_timer > 0){
		///Emit laser
		l_dist = min(len, l_dist + l_spd);
	}
	emitting_timer --;
}

laser_hit = noone;
damage_age += global.time_step;
if(emitting_timer > 0){
	var last_length = min(l_dist, l_stops[l_n - 1]);
	lx1 = x + lengthdir_x(min(l_dist, l_stops[0]), l_points[0]);
	ly1 = y + lengthdir_y(min(l_dist, l_stops[0]), l_points[0]);
	lx2 = x + lengthdir_x(last_length, l_points[l_n - 1]);
	ly2 = y + lengthdir_y(last_length, l_points[l_n - 1]);

	// Clients only draw the laser; the server applies damage.
	if(!IS_NET || (instance_exists(oNetworkManager) && oNetworkManager.is_server)){
		var hitbox_list = ds_list_create();
		var hit_count = collision_rectangle_list(
			min(x, lx1, lx2), min(y, ly1, ly2),
			max(x, lx1, lx2), max(y, ly1, ly2),
			oHitBox, false, true, hitbox_list, false
		);
		for(var hit_index = 0; hit_index < hit_count; hit_index++){
			var hitbox = hitbox_list[| hit_index];
			if(!instance_exists(hitbox)) continue;
			var hit_object = hitbox.MainObject;
			if(!instance_exists(hit_object)) continue;
			if(hit_object.object_index != oPlayer && hit_object.object_index != oBot) continue;
			if(hit_object.stats.Health_points <= 0) continue;
			// Each body hitbox contributes damage, with its own repeat interval.
			var hit_key = string(hitbox.id);
			if(ds_map_exists(damage_hits, hit_key)){
				if(damage_age - damage_hits[? hit_key] < damage_interval) continue;
			}
			if(collision_triangle(x, y, lx1, ly1, lx2, ly2, hitbox) == noone) continue;

			// Check only the center and nearby rays; an approximate center is enough for effects.
			var center_x = (hitbox.bbox_left + hitbox.bbox_right) * .5;
			var center_y = (hitbox.bbox_top + hitbox.bbox_bottom) * .5;
			var impact = find_collision_point(x, y, center_x, center_y, hitbox);
			if(array_length(impact) > 0
			&& !point_in_triangle(impact[0], impact[1], x, y, lx1, ly1, lx2, ly2)) impact = [];
			if(array_length(impact) == 0){
				var target_angle = point_direction(x, y, center_x, center_y);
				var closest_ray = 0;
				var closest_difference = 360;
				for(var ray_index = 0; ray_index < l_n; ray_index++){
					var ray_difference = abs(angle_difference(target_angle, l_points[ray_index]));
					if(ray_difference < closest_difference){
						closest_difference = ray_difference;
						closest_ray = ray_index;
					}
				}
				for(var ray_offset = -1; ray_offset <= 1 && array_length(impact) == 0; ray_offset++){
					var nearby_ray = clamp(closest_ray + ray_offset, 0, l_n - 1);
					var ray_length = min(l_dist, l_stops[nearby_ray]);
					var ray_x = x + lengthdir_x(ray_length, l_points[nearby_ray]);
					var ray_y = y + lengthdir_y(ray_length, l_points[nearby_ray]);
					impact = find_collision_point(x, y, ray_x, ray_y, hitbox);
					if(array_length(impact) > 0
					&& !point_in_triangle(impact[0], impact[1], x, y, lx1, ly1, lx2, ly2)) impact = [];
				}
			}
			if(array_length(impact) == 0) impact = [center_x, center_y];
			if(collision_line(x, y, impact[0], impact[1], oParentTile, true, false) != noone) continue;
			laser_hit = hit_object;

			var armour_id = ITEM.None;
			var helmet_id = ITEM.None;
			var shield_id = ITEM.None;
			if(hit_object.object_index == oPlayer){
				armour_id = global.Inventory[# OtherSlot.Armour, INDEX.slot_id];
				helmet_id = global.Inventory[# OtherSlot.Helmet, INDEX.slot_id];
				shield_id = global.Inventory[# OtherSlot.Shield, INDEX.slot_id];
			}else{
				armour_id = hit_object.ArmourID;
				helmet_id = hit_object.HelmetID;
				shield_id = hit_object.ShieldID;
			}
			hit_living_object(hit_object, max(hitbox.image_index, HITBOX.BodyNoWeapon),
				id, armour_id, helmet_id, shield_id, impact[0], impact[1]);
			damage_hits[? hit_key] = damage_age;
		}
		ds_list_destroy(hitbox_list);

		var bird_list = ds_list_create();
		var bird_count = collision_rectangle_list(
			min(x, lx1, lx2), min(y, ly1, ly2),
			max(x, lx1, lx2), max(y, ly1, ly2),
			oBird, false, true, bird_list, false
		);
		for(var bird_index = 0; bird_index < bird_count; bird_index++){
			var bird = bird_list[| bird_index];
			if(!instance_exists(bird)) continue;
			if(collision_triangle(x, y, lx1, ly1, lx2, ly2, bird) == noone) continue;
			if(collision_line(x, y, bird.x, bird.y, oParentTile, true, false) != noone) continue;
			if(bird.state != 0) continue;

			if(IS_NET && bird.network_id >= 0){
				server_process_bird_death(bird, stats.Damage);
			}else{
				create_blood(round(stats.Damage / 5), bird.x, bird.y, c_red, round(stats.Damage / 2));
				play_sound(bird.x, bird.y, snd_BirdDeath);
				instance_destroy(bird);
			}
		}
		ds_list_destroy(bird_list);
	}
}else{
	// No stale hitbox IDs are retained between emissions.
	ds_map_clear(damage_hits);
}
// Start the pause once when emission ends; let it count down afterward.
if(emitting_timer == 0){ 
	laser_state_changed = true;
	laser_timer = round(laser_time);
	l_dist = 1; 
	l_n = 0;
	l_points = []; 
	l_stops = [];
}

if(IS_NET){
	laser_sync_timer += global.time_step;
	if(laser_state_changed || laser_sync_timer >= game_get_speed(gamespeed_fps)){
		server_send_laser_state(id);
		laser_sync_timer = 0;
	}
}
