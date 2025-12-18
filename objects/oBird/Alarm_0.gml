if(is_local){
	alarm[0] = random_range(2 * game_get_speed(gamespeed_fps), 5 * game_get_speed(gamespeed_fps));
	if(is_place_free(x, y)){
		if(state == 1){
			sprite_index = spr_BirdWalking;
			image_index = 0;
			state = 0;
			speed = 0;
			image_speed = 0.25;
			alarm[0] = random_range(5 * game_get_speed(gamespeed_fps), 7 * game_get_speed(gamespeed_fps));
			depth = 100;
		}else{
			sprite_index = spr_BirdFlying;
			image_index = 0;
			state = 1;
			direction = random(360);
			image_angle = direction;
			speed = random_range(4, 5);
			image_speed = 0.75;
			depth = -100;
		}
	}

	if(IS_NET && oNetworkManager.is_server){
		server_process_bird_change(id, 2);
	}

}















