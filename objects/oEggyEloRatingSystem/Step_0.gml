if(round_ended == false && oDraw.PauseMenu == false && oDraw.RespawnMenu == false){
	playing_time ++;
}

if(round_ended == true && oDraw.RespawnMenu == false){
	oDraw.RespawnMenu = true;
	if(player_win == true){
		global.player_rating_struct.Rounds_win ++;
	}else{
		global.player_rating_struct.Rounds_lost ++;	
	}
	if(global.player_rating_struct.Rounds_win < (MAX_ROUNDS/2 + 1) && global.player_rating_struct.Rounds_lost < (MAX_ROUNDS/2 + 1)){
		global.player_rating_struct.Kills_per_round[global.player_rating_struct.Current_round] = kills;
		global.player_rating_struct.Headshots_per_round[global.player_rating_struct.Current_round] = headshots;
		global.player_rating_struct.Playing_time_per_round[global.player_rating_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
		global.player_rating_struct.Current_round ++;
	}else{
		///Game end calculating ep
		oDraw.GameEndMenu = true;
		global.player_rating_struct.Kills_per_round[global.player_rating_struct.Current_round] = kills;
		global.player_rating_struct.Headshots_per_round[global.player_rating_struct.Current_round] = headshots;
		global.player_rating_struct.Playing_time_per_round[global.player_rating_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
		var game_result = calculate_game_result(global.player_rating_struct.Rounds_win, global.player_rating_struct.Rounds_lost);
		update_eggy_rating_system(
			game_result, 
			global.MapID
		);
	}		
}
