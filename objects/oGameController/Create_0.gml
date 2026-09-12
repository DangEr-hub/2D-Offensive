set_current_enemy();
get_accuracy = function(AllShots, HitShots){
	var accuracy = 0;
	if(AllShots != 0){
		accuracy = HitShots/AllShots;
	}
	
	return accuracy;
};

hit_shots = 0;
all_shots = 0;
player_win = false;
headshots = 0;
kills = 0;
assists = 0;
current_round = 0;
playing_time = 0;
round_ended = false;
round_start_money = global.player_stats.Money;

/// @description Round economy controller

hostage_rescued = false;
bomb_defused = false;
global.bomb_time = 5 * game_get_speed(gamespeed_fps);
if(!IS_NET){
	if(global.player_stats.Player_team == TEAM.POLICE && !instance_exists(oBomb)){
		global.bomb_time = 200 * game_get_speed(gamespeed_fps);
		var bomb_areas = global.MapProperties[# global.MapID, MAP_STAT.BombAreas];
		var area_keys = ds_map_keys_to_array(bomb_areas);
		var area = bomb_areas[? area_keys[irandom(array_length(area_keys) - 1)]];
		var bomb = instance_create_layer(
			random_range(area[0], area[2]),
			random_range(area[1], area[3]),
			"ItemsO",
			oBomb
		);
		bomb.image_angle = irandom(359);
	}
}


resolve_round = function(winning_team) {
	if (IS_NET && !oNetworkManager.is_server) return false;

	var losing_team = winning_team == TEAM.POLICE
		? TEAM.TERRORIST
		: TEAM.POLICE;
	var winning_streak_index = winning_team - TEAM.POLICE;
	var losing_streak_index = losing_team - TEAM.POLICE;

	global.game_struct.Loss_streak[winning_streak_index] = 0;
	global.game_struct.Loss_streak[losing_streak_index]++;
	
	global.game_struct.Win_streak[winning_streak_index]++;
	global.game_struct.Win_streak[losing_streak_index] = 0;
	
	var bonus = 0;
	if(winning_team == TEAM.TERRORIST){
		bonus = (50 * global.bomb_planted);
	}
	
	if(winning_team == TEAM.POLICE){
		if(hostage_rescued == true || bomb_defused == true){
			bonus =	55;
		}
	}

	hostage_rescued = false;
	bomb_defused = false;

	var win_reward = ROUND_WIN_REWARD + bonus - (max(global.game_struct.Win_streak[winning_streak_index] - 1, 0) * ROUND_WIN_STREAK_DEBUFF);
	var loss_reward = ROUND_LOSS_REWARD + (max(global.game_struct.Loss_streak[losing_streak_index] - 1, 0) * ROUND_LOSS_STREAK_BONUS);

	if (!IS_NET) {
		var local_player = global.local_player;
		if (instance_exists(local_player)) {
			global.player_stats.Money += local_player.stats.Team == winning_team
				? win_reward
				: loss_reward;
		}

		for(var bot_index = 0; bot_index < array_length(global.BotMatchStats); bot_index++){
			var bot_stats = global.BotMatchStats[bot_index];
			bot_stats.Money += bot_stats.Team == winning_team
				? win_reward
				: loss_reward;
		}

		return true;
	}

	var pid = ds_map_find_first(oNetworkManager.player_states);
	var player_count = ds_map_size(oNetworkManager.player_states);

	for (var i = 0; i < player_count; i++) {
		var player_data = ds_map_find_value(oNetworkManager.player_states, pid);
		var player_team = ds_map_find_value(player_data, "Team");
		var player_stats = ds_map_find_value(oNetworkManager.player_stats, pid);

		if (is_undefined(player_stats)) {
			player_stats = ds_map_create();
			ds_map_set(player_stats, "Kills", 0);
			ds_map_set(player_stats, "Assists", 0);
			ds_map_set(player_stats, "Deaths", 0);
			ds_map_set(player_stats, "Money", ROUND_STARTING_MONEY);
			ds_map_set(oNetworkManager.player_stats, pid, player_stats);
		}

		if (!is_undefined(player_team)) {
			var current_money = ds_map_exists(player_stats, "Money")
				? ds_map_find_value(player_stats, "Money")
				: ROUND_STARTING_MONEY;
			var reward = player_team == winning_team ? win_reward : loss_reward;
			ds_map_set(player_stats, "Money", current_money + reward);

			if (pid == oNetworkManager.my_pid) {
				global.player_stats.Money = current_money + reward;
			}
		}

		pid = ds_map_find_next(oNetworkManager.player_states, pid);
	}

	return true;
};






