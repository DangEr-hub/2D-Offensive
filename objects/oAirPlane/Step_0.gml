part_pos = [local_to_world(32, 139), local_to_world(32, 116)];
speed = base_spd * global.time_step;

if (network_visual_only) {
	x = lerp(x, network_target_x, INTERPOLATION_SPD);
	y = lerp(y, network_target_y, INTERPOLATION_SPD);
	direction = network_target_direction;
	image_angle = lerp(image_angle, network_target_direction, INTERPOLATION_SPD);
}

part_particles_create(global.ParticleSystem, part_pos[0][0], part_pos[0][1], oParticleSystem.fire_particle, 2);
part_particles_create(global.ParticleSystem, part_pos[1][0], part_pos[1][1], oParticleSystem.fire_particle, 2);
part_particles_create(global.ParticleSystem, part_pos[0][0], part_pos[0][1], oParticleSystem.FlameParticle, 2);
part_particles_create(global.ParticleSystem, part_pos[1][0], part_pos[1][1], oParticleSystem.FlameParticle, 2);

if(fog_timer > -1){ fog_timer -= global.time_step; }

if(fog_timer == -1){
	var Fog = create_fog(part_pos[0][0], part_pos[0][1], 15, random(360), 0.25, random_range(.5, 1), 
		5, .5, 
		.25, 2 * game_get_speed(gamespeed_fps),
		[lengthdir_x(5, image_angle - 180), lengthdir_y(5, image_angle - 180), true]
	);
	create_fog(part_pos[1][0], part_pos[1][1], 15, random(360), 0.25, random_range(.5, 1), 
		5, .5, 
		.25, 2 * game_get_speed(gamespeed_fps),
		[lengthdir_x(5, image_angle - 180), lengthdir_y(5, image_angle - 180), true]
	);	
	fog_timer = 5;
}

if (network_authority && IS_NET && oNetworkManager.is_server) {
	network_sync_timer -= global.time_step;
	if (network_sync_timer <= 0) {
		server_process_airplane_update(id);
		network_sync_timer = 10;
	}
}

if (network_authority) {
	var s_width = sprite_get_width(sprite_index);
	if(x <= oDraw.ViewX - s_width*3 || x >= oDraw.ViewX + oDraw.ViewW + s_width*3 ||
	y <= oDraw.ViewY - s_width*3 || y >= oDraw.ViewY + oDraw.ViewH + s_width*3 ||
	x <= 0 - s_width || x >= room_width + s_width || y <= 0 - s_width || y >= room_height + s_width){
		if (IS_NET && oNetworkManager.is_server) {
			server_process_airplane_destroy(id, false);
		}
		instance_destroy(id);
	}
}

if(network_authority && stats.Health_points <= 0){
	if (IS_NET && oNetworkManager.is_server) {
		server_process_airplane_destroy(id, true);
	}
	explosion_create(10, [x, y], stats.Damage, true, id, stats.Item_id);
}











