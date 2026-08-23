if(molotov_particle_emitter_created && variable_global_exists("ParticleSystem") && part_system_exists(global.ParticleSystem)){
	part_emitter_destroy(global.ParticleSystem, molotov_particle_emitter);
	molotov_particle_emitter_created = false;
}

if(ds_exists(damage_hits, ds_type_map)){
	ds_map_destroy(damage_hits);
}

if(LightObject != noone){
	LightObject.Destroy();
	LightObject = noone;
}

event_inherited();
