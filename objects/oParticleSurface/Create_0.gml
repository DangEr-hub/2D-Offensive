/// @description Insert description here
// You can write your code in this editor
randomize();
if(percent_chance(90)){
	global.Weather = "sun";
}else{
	global.Weather = choose("rain", "snow");	
}	
ParticleSurface = -1;