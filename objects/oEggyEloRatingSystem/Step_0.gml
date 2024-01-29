if(round_ended == false){
	playing_time ++;
}

if(round_ended == true && oDraw.RespawnMenu == false){
	oDraw.RespawnMenu = true;
	if(player_win == true){
		oDraw.RoundEndMenu = true;
		global.player_elo_struct.Rounds_win ++;
	}else{
		global.player_elo_struct.Rounds_lost ++;	
	}
	if(global.player_elo_struct.Rounds_win < MAX_ROUNDS/2 && global.player_elo_struct.Rounds_lost < MAX_ROUNDS/2){
		global.player_elo_struct.Kills_per_round[global.player_elo_struct.Current_round] = kills;
		global.player_elo_struct.Headshots_per_round[global.player_elo_struct.Current_round] = headshots;
		global.player_elo_struct.Playing_time_per_round[global.player_elo_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
		global.player_elo_struct.Current_round ++;
	}else{
		///Game end calculating elo
		oDraw.GameEndMenu = true;
		global.player_elo_struct.Kills_per_round[global.player_elo_struct.Current_round] = kills;
		global.player_elo_struct.Headshots_per_round[global.player_elo_struct.Current_round] = headshots;
		var total_rounds = global.player_elo_struct.Rounds_win + global.player_elo_struct.Rounds_lost;
		var game_result = calculate_game_result(global.player_elo_struct.Rounds_win, global.player_elo_struct.Rounds_lost);
		update_eggy_rating_system(game_result, global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game], global.MapID);
		clear_player_statistics(total_rounds);
	}		
}
