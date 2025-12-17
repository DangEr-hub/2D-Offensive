/// @description Insert description here
// You can write your code in this editor

var cam_x = camera_get_view_x(CAMERA);
var cam_y = camera_get_view_y(CAMERA);
var cam_width = camera_get_view_width(CAMERA);
var cam_height = camera_get_view_height(CAMERA);
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

		var Fog = instance_create_layer(xx, yy, "OtherO", oFog);

		with(Fog){
			moving_x = .5;
			moving_y = .5;
			smoke_effect_create(
				random_range(75, 125),
				random(360),
				.5,
				random_range(.1, .5),
				random_range(5, 7.5),
				random_range(.5, .9),
				random_range(.1, .75),
				5 * game_get_speed(gamespeed_fps),
				true
			);
		}
	}
}else if(global.Weather == 2){
	if(percent_chance(100)){
		if(instance_exists(oParticleSystem)){
			part_emitter_region(global.ParticleSystem, oParticleSystem.weather_emitter, cam_x, cam_x + cam_width, cam_y, cam_y + cam_height, ps_shape_rectangle, ps_distr_linear);
			part_emitter_burst(global.ParticleSystem, oParticleSystem.weather_emitter, oParticleSystem.snow_particle, 1);
		}
	}
}


if(global.MapID == MapIndex.Desert){
	if(instance_exists(oParticleSystem)){
		part_particles_create(global.ParticleSystem, cam_x + random(cam_width), cam_y + random(cam_height), oParticleSystem.dust_particle, 1);
	}
}else if(global.MapID == MapIndex.RainForest){
	if(percent_chance(10)){
		if(instance_exists(oParticleSystem)){
			part_particles_create(global.ParticleSystem, cam_x + random(cam_width), cam_y + random(cam_height), oParticleSystem.leaf_particle, 1);
		}
	}
}
