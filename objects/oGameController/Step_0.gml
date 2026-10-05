if(round_ended == false && oDraw.PauseMenu == false && (oDraw.RespawnMenu == false || instance_exists(oSpectateControl))){
	playing_time ++;
}

if(round_ended == true && !round_result_processed && (oDraw.RespawnMenu == false || instance_exists(oSpectateControl))){
	round_result_processed = true;
	if(instance_exists(oSpectateControl)){
		if(!global.sudo){
			with(oSpectateControl) instance_destroy();
		}
		with(objZUIMain) zui_destroy();
		oDraw.spectating = false;
		oDraw.spectate_target = noone;
		oDraw.RespawnMenu = false;
		oDraw.BackGround = -1;
		oDraw.alarm[0] = -1;
	}
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
		}
		global.game_struct.Playing_time_per_round[global.game_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
		var game_result = calculate_game_result(global.game_struct.Rounds_win, global.game_struct.Rounds_lost);
		update_eggy_rating_system(game_result, global.MapID);
	}		
	if(!IS_NET){
		global.map_rounds[global.MapID][0] = global.game_struct.Rounds_win;
		global.map_rounds[global.MapID][1] = global.game_struct.Rounds_lost;
		save_game();
	}
}
if(round_result_processed && next_round_requested && !oDraw.GameEndMenu){
	with(objZUIMain) zui_destroy();
	room_restart();
}
