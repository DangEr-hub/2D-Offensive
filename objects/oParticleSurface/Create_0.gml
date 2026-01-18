/// @description Insert description here
// You can write your code in this editor
alarm[0] = global.clear_particles_timer;
audio_stop_sound(snd_Rain);
if(percent_chance(90)){
	global.Weather = 0;
}else{
	global.Weather = choose(1, 2);	
}	

ParticleSurface = -1;
gui_particle_surf = -1;