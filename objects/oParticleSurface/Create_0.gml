/// @description Insert description here
// You can write your code in this editor
randomize();
if(PercentChance(90)){
	global.Weather = "sun";
}else{
	global.Weather = choose("rain", "snow");	
}	
ParticleSurface = -1;