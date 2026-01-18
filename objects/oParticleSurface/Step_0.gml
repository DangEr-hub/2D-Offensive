/// @description Insert description here
// You can write your code in this editor

var cam_x = camera_get_view_x(CAM);
var cam_y = camera_get_view_y(CAM);
var cam_width = camera_get_view_width(CAM);
var cam_height = camera_get_view_height(CAM);
if(global.Weather == 1){
	if!(audio_is_playing(snd_Rain)){
		audio_play_sound(snd_Rain, 0, true);
	}
	if(instance_exists(oParticleSystem)){
		particle_create(
			2,
			0,
			0,
			spr_RainSplash,
			0,                  
			0,
			0,
			0,                 
			false,
			false, 
			0,
			random_range(cam_x, cam_x + cam_width),
			random_range(cam_y, cam_y + cam_height),
			random_range(0.1, 0.25), 
			-1
		);
	}
	if(percent_chance(1)){
		var m = 64;
		var s = irandom(3);
		var xx, yy;

		if (s == 0) { xx = cam_x - m;               yy = random_range(cam_y, cam_y + cam_height); }
		else if (s == 1) { xx = cam_x + cam_width + m; yy = random_range(cam_y, cam_y + cam_height); }
		else if (s == 2) { xx = random_range(cam_x, cam_x + cam_width); yy = cam_y - m; }
		else { xx = random_range(cam_x, cam_x + cam_width); yy = cam_y + cam_height + m; }
	}
}else if(global.Weather == 2){
	if(percent_chance(100)){
		if(instance_exists(oParticleSystem)){
			part_emitter_region(global.ParticleSystem, oParticleSystem.weather_emitter, cam_x, cam_x + cam_width, cam_y, cam_y + cam_height, ps_shape_rectangle, ps_distr_linear);
			part_emitter_burst(global.ParticleSystem, oParticleSystem.weather_emitter, oParticleSystem.snow_particle, 1);
		}
	}
}


if(global.MapID == MAP.Desert){
	if(instance_exists(oParticleSystem)){
		part_particles_create(global.ParticleSystem, cam_x + random(cam_width), cam_y + random(cam_height), oParticleSystem.dust_particle, 1);
	}
}else if(global.MapID == MAP.RainForest){
	if(percent_chance(5)){
		if(instance_exists(oParticleSystem)){
			part_particles_create(global.ParticleSystem, cam_x + random(cam_width), cam_y + random(cam_height), oParticleSystem.leaf_particle, 1);
		}
	}
}
