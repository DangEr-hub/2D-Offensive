alarm[0] = random_range(2 * game_get_speed(gamespeed_fps), 5 * game_get_speed(gamespeed_fps));
if(is_place_free(x, y)){
	if(state == "Flying"){
		sprite_index = spr_BirdWalking;
		image_index = 0;
		state = "Walking";
		speed = 0;
		alarm[0] = random_range(5 * game_get_speed(gamespeed_fps), 7 * game_get_speed(gamespeed_fps));
		depth = 100;
	}else{
		sprite_index = spr_BirdFlying;
		image_index = 0;
		state = "Flying";
		direction = random(360);
		image_angle = direction;
		speed = random_range(4, 5);
		image_speed = clamp(speed * 0.5, 0.7, 1);
		depth = -100;
	}
}















