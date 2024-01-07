/// @description Insert description here
// You can write your code in this 
global.player_elo_struct.Rounds_win = 5;
global.player_elo_struct.Rounds_lost = 0;
var total_rounds = global.player_elo_struct.Rounds_win + global.player_elo_struct.Rounds_lost;
global.player_elo_struct.Playing_time_per_round = array_create(total_rounds, game_get_speed(gamespeed_fps));
global.player_elo_struct.Headshots_per_round = array_create(total_rounds, 1);
global.player_elo_struct.Kills_per_round = array_create(total_rounds, 100);
update_eggy_rating_system(calculate_game_result(global.player_elo_struct.Rounds_win, global.player_elo_struct.Rounds_lost), convert_to_eggy_scale(SILVERI_ELO), global.MapID);
save_game();