/// @description Insert description here
// You can write your code in this editor
alarm[0] = LIGHT_UPDATE;
if(instance_exists(oParticleSystem)){
	part_particles_create(global.ParticleSystem, x, y, oParticleSystem.LightParticle, 1);
}


