/// @description Insert description here
// You can write your code in this editor
playing_time ++;

if(global.player_elo_struct.Played_games % (TRACKING_GAMES/2) == 0){
	update_player_expected_games();	
}

if(round_end == true){
	global.player_elo_struct.Kills_per_round[current_round] = kills;
	global.player_elo_struct.Headshots_per_round[current_round] = head_shots;
	global.player_elo_struct.Playing_time_per_round = playing_time;
	room_restart();
}
