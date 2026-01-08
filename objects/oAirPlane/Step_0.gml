part_pos = [local_to_world(32, 139), local_to_world(32, 116)];

part_particles_create(global.ParticleSystem, part_pos[0][0], part_pos[0][1], oParticleSystem.fire_particle, 2);
part_particles_create(global.ParticleSystem, part_pos[1][0], part_pos[1][1], oParticleSystem.fire_particle, 2);
part_particles_create(global.ParticleSystem, part_pos[0][0], part_pos[0][1], oParticleSystem.FlameParticle, 2);
part_particles_create(global.ParticleSystem, part_pos[1][0], part_pos[1][1], oParticleSystem.FlameParticle, 2);

if(fog_timer > -1){ fog_timer --; }

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

var s_width = sprite_get_width(sprite_index);
if(x <= oDraw.ViewX - s_width*3 || x >= oDraw.ViewX + oDraw.ViewW + s_width*3 || 
y <= oDraw.ViewY - s_width*3 || y >= oDraw.ViewY + oDraw.ViewH + s_width*3 ||
x <= 0 - s_width || x >= room_width + s_width || y <= 0 - s_width || y >= room_height + s_width){
	instance_destroy(id);	
}

if(stats.Health_points <= 0){
	explosion_create(10, [x, y], stats.Damage, true, id, stats.Item_id);
}











