/// @description Insert description here
// You can write your code in this editor

alarm[0] = global.clear_particles_timer;
if(percent_chance(90)){
	global.Weather = "sun";
}else{
	global.Weather = choose("rain", "snow");	
}	
ParticleSurface = -1;