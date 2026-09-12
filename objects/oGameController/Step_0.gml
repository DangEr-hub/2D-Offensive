if(round_ended == false && oDraw.PauseMenu == false && oDraw.RespawnMenu == false){
	playing_time ++;
}

if(round_ended == true && oDraw.RespawnMenu == false){
	oDraw.RespawnMenu = true;
	if(player_win == true){
		global.game_struct.Rounds_win ++;
	}else{
		global.game_struct.Rounds_lost ++;	
	}
	if(global.game_struct.Rounds_win < (MAX_ROUNDS/2 + 1) && global.game_struct.Rounds_lost < (MAX_ROUNDS/2 + 1)){
		global.game_struct.Playing_time_per_round[global.game_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
		global.game_struct.Current_round ++;
	}else{
		///Game end calculating ep
		oDraw.GameEndMenu = true;
		if(!IS_NET && player_win == true){
			global.player_stats.Diamonds += global.game_struct.Rounds_win*2;
			save_game();
		}
		global.game_struct.Playing_time_per_round[global.game_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
		var game_result = calculate_game_result(global.game_struct.Rounds_win, global.game_struct.Rounds_lost);
		update_eggy_rating_system(game_result, global.MapID);
	}		
}
