/// @description Insert description here
// You can write your code in this editor

var cam_x = camera_get_view_x(CAMERA);
var cam_y = camera_get_view_y(CAMERA);
var cam_width = camera_get_view_width(CAMERA);
var cam_height = camera_get_view_height(CAMERA);
if(global.Weather == "rain"){
	if(instance_exists(oParticleSystem)){
		part_emitter_region(global.ParticleSystem, oParticleSystem.rain_emitter, cam_x, cam_x + cam_width, cam_y, cam_y + cam_height, ps_shape_rectangle, ps_distr_linear);
		part_emitter_burst(global.ParticleSystem, oParticleSystem.rain_emitter, oParticleSystem.rain_particle, 5);
	}
}else if(global.Weather == "snow"){
	if(percent_chance(100)){
		if(instance_exists(oParticleSystem)){
			part_emitter_region(global.ParticleSystem, oParticleSystem.rain_emitter, cam_x, cam_x + cam_width, cam_y, cam_y + cam_height, ps_shape_rectangle, ps_distr_linear);
			part_emitter_burst(global.ParticleSystem, oParticleSystem.rain_emitter, oParticleSystem.snow_particle, 1);
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
