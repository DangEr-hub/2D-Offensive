/// @description Round economy controller

loss_streak = array_create(TEAM.TERRORIST + 1, 0);
last_rewarded_round = global.game_struct.Rounds_win + global.game_struct.Rounds_lost;

get_loss_reward = function(team) {
	var team_loss_streak = max(loss_streak[team], 1);
	return ROUND_LOSS_REWARD + (team_loss_streak - 1) * ROUND_LOSS_STREAK_BONUS;
};

get_or_create_network_stats = function(pid) {
	var player_stats = ds_map_find_value(oNetworkManager.player_stats, pid);
	if (is_undefined(player_stats)) {
		player_stats = ds_map_create();
		ds_map_set(player_stats, "Kills", 0);
		ds_map_set(player_stats, "Assists", 0);
		ds_map_set(player_stats, "Deaths", 0);
		ds_map_set(player_stats, "Money", ROUND_STARTING_MONEY);
		ds_map_add(oNetworkManager.player_stats, pid, player_stats);
	} else if (!ds_map_exists(player_stats, "Money")) {
		ds_map_set(player_stats, "Money", ROUND_STARTING_MONEY);
	}

	return player_stats;
};

award_network_players = function(winning_team, win_reward, loss_reward) {
	var pid = ds_map_find_first(oNetworkManager.player_states);
	var player_count = ds_map_size(oNetworkManager.player_states);
	for (var player_index = 0; player_index < player_count; player_index++) {
		var player_data = ds_map_find_value(oNetworkManager.player_states, pid);
		var player_team = ds_map_find_value(player_data, "Team");
		if (!is_undefined(player_team)) {
			var stats = get_or_create_network_stats(pid);
			var reward = player_team == winning_team ? win_reward : loss_reward;
			ds_map_set(stats, "Money", ds_map_find_value(stats, "Money") + reward);

			if (pid == oNetworkManager.my_pid) {
				global.player_stats.Money = ds_map_find_value(stats, "Money");
			}
		}

		pid = ds_map_find_next(oNetworkManager.player_states, pid);
	}
};

award_local_players = function(winning_team, win_reward, loss_reward) {
	if (instance_exists(global.local_player)) {
		global.player_stats.Money += global.local_player.stats.Team == winning_team
			? win_reward
			: loss_reward;
	}

	with (oBot) {
		stats.Money += stats.Team == winning_team ? win_reward : loss_reward;
	}
};

resolve_round = function(winning_team, round_number = global.game_struct.Rounds_win + global.game_struct.Rounds_lost) {
	if (winning_team != TEAM.POLICE && winning_team != TEAM.TERRORIST) return false;
	if (IS_NET && !oNetworkManager.is_server) return false;

	if (round_number <= last_rewarded_round) return false;
	last_rewarded_round = round_number;

	var losing_team = winning_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE;
	loss_streak[winning_team] = 0;
	loss_streak[losing_team]++;

	var win_reward = ROUND_WIN_REWARD;
	var loss_reward = get_loss_reward(losing_team);

	if (IS_NET) {
		award_network_players(winning_team, win_reward, loss_reward);
	} else {
		award_local_players(winning_team, win_reward, loss_reward);
	}

	return true;
};

global.player_stats.Money = ROUND_STARTING_MONEY;
with (oBot) {
	stats.Money = ROUND_STARTING_MONEY;
}

if (IS_NET && oNetworkManager.is_server) {
	var pid = ds_map_find_first(oNetworkManager.player_states);
	var player_count = ds_map_size(oNetworkManager.player_states);
	for (var player_index = 0; player_index < player_count; player_index++) {
		get_or_create_network_stats(pid);
		pid = ds_map_find_next(oNetworkManager.player_states, pid);
	}
}
