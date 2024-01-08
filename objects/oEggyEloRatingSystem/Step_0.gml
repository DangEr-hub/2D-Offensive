/// @description Insert description here
// You can write your code in this editor
playing_time ++;

if(round_end == true){
		if(player_win == true){
			global.player_elo_struct.Rounds_win ++;
		}else{
			global.player_elo_struct.Rounds_lost ++;	
		}
		if(global.player_elo_struct.Rounds_win < MAX_ROUNDS/2 && global.player_elo_struct.Rounds_lost < MAX_ROUNDS/2){
			global.player_elo_struct.Kills_per_round[global.player_elo_struct.Current_round] = kills;
			global.player_elo_struct.Headshots_per_round[global.player_elo_struct.Current_round] = headshots;
			global.player_elo_struct.Playing_time_per_round[global.player_elo_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
			global.player_elo_struct.Current_round ++;
			room_restart();
		}else{
			///Game end calculating elo
			global.player_elo_struct.Kills_per_round[global.player_elo_struct.Current_round] = kills;
			global.player_elo_struct.Headshots_per_round[global.player_elo_struct.Current_round] = headshots;
			global.player_elo_struct.Playing_time_per_round[global.player_elo_struct.Current_round] = playing_time / game_get_speed(gamespeed_fps);
			var total_rounds = global.player_elo_struct.Rounds_win + global.player_elo_struct.Rounds_lost;
			var game_result = calculate_game_result(global.player_elo_struct.Rounds_win, global.player_elo_struct.Rounds_lost);
			update_eggy_rating_system(game_result, global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game], global.MapID);
			clear_player_statistics(total_rounds);
			room_restart();
		}		
}
