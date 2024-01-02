// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function statistics_hit(Type, Damage){
	switch(Type){
		case "HP":
			HP -= Damage;
			if(HPTimer == -1){
				HPTimer = game_get_speed(gamespeed_fps)*.5;
			}
		break;
		
		case "Stamina":
		StaminaDamage = Damage;
		Stamina -= StaminaDamage;
		Stamina = max(Stamina, 0);
		if(StaminaTimer == -1){
			StaminaTimer = game_get_speed(gamespeed_fps)*.5;	
		}
		break;
	}
}