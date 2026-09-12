function rd_weight(rd){
	return 1 / (1 + rd);
}

function eggy_weight(ep_diff, rd_player, rd_enemy) {
    var alpha = 1 / (1 + exp(-ep_diff / 10));
    return alpha * rd_weight(rd_player) + (1 - alpha) * rd_weight(rd_enemy);
}

function calculate_probability(player_ep, enemy_ep, rd_player, rd_enemy) {
	var ep_diff = player_ep - enemy_ep;
    var weight = -eggy_weight(ep_diff, rd_player, rd_enemy);
    var rd_diff = rd_player - rd_enemy;
    var offset = RD_OFFSET;
    var scale = 1;

    if ((abs(rd_diff) <= offset && rd_player < offset) || rd_enemy < offset) {
        scale = (ep_diff > 0) ? 0.75 : 1.0;
    } else if (rd_diff < 0) {
        scale = (ep_diff > 0) ? 1.5 : 1.0;
    }

    return 1 / (1 + power(exp(1), weight * ep_diff * scale));
}

function calculate_games_information(rd_enemy){
	var information_sum = 0;
	for(var i = 0; i < TRACKING_PERIOD; i ++){
		prob_win = global.game_struct.Expected_results[i];
		information_sum += rd_weight(rd_enemy[i]) * prob_win * (1 - prob_win);
	}
	
	return information_sum;
}

function set_current_enemy(){
	for(var i = 0; i < TRACKING_PERIOD; i++){
		if(global.game_struct.Enemy_ep[i] == -1){
			global.game_struct.Enemy_ep[i] = get_enemy_ep(global.game_struct.Player_ep, global.game_struct.Player_rd);
			global.game_struct.Enemy_rd[i] = get_enemy_rd(global.game_struct.Player_rd);
		}else if(global.game_struct.Enemy_rd[i] < 0){
			global.game_struct.Enemy_rd[i] = get_enemy_rd(global.game_struct.Player_rd);
		}
	}
}

function game_struct_create(){
	var return_struct = {
		"Previous_ep": convert_to_eggy_scale(MIN_EP),
		"Playing_time_per_round": array_create(MAX_ROUNDS, 0),
		"Predictive_volatility": PLAYER_STARTING_VOLATILITY,
		"Game_volatility": array_create(TRACKING_PERIOD, PLAYER_STARTING_VOLATILITY),
		"Player_ep": convert_to_eggy_scale(MIN_EP), // Eggy scale
		"Current_game": 0,
		"Current_round": 0,
		"Rounds_win": 0,
		"Rounds_lost": 0,
		"Match_kills": 0,
		"Match_assists": 0,
		"Match_deaths": 0,
		"Played_games": 0,
		"Winned_rounds": array_create(TRACKING_PERIOD, 0),
		"Lost_rounds": array_create(TRACKING_PERIOD, 0),
		"Won_games": 0,
		"Lost_games": 0,
		"Tied_games": 0,
		"Player_rd": convert_to_eggy_scale(RD_START, true), // Eggy scale
		"Kills_per_round": array_create(MAX_ROUNDS, 0),
		"Headshots_per_round": array_create(MAX_ROUNDS, 0),
		"Recent_results": array_create(TRACKING_PERIOD, -1),
		"Expected_results": array_create(TRACKING_PERIOD, -1),
		"Enemy_ep": array_create(TRACKING_PERIOD, -1),
		"Enemy_rd": array_create(TRACKING_PERIOD, 0),
		"Win_streak": array_create(2, 0),
		"Loss_streak": array_create(2, 0)
	}

	for(var i = 0; i < TRACKING_PERIOD; i++){
		return_struct.Enemy_ep[i] = get_enemy_ep(return_struct.Player_ep, return_struct.Player_rd);
		return_struct.Enemy_rd[i] = get_enemy_rd(return_struct.Player_rd);
	}
	
	return return_struct;
}

function map_init(Map){
	if(global.player_stats.Player_team == TEAM.NONE){
		global.player_stats.Player_team = choose(TEAM.POLICE, TEAM.TERRORIST);
	}
	global.game_struct.Match_kills = 0;
	global.game_struct.Match_assists = 0;
	global.game_struct.Match_deaths = 0;
	global.MapID = Map;
	initialize_bot_database(Map);
	if(global.map_rounds[Map][2] == -1){
		global.map_rounds[Map][2] = global.game_struct.Enemy_ep[global.game_struct.Current_game];
	}
	if(global.map_rounds[Map][0] != -1){
		global.game_struct.Rounds_win = global.map_rounds[Map][0];
		global.game_struct.Rounds_lost = global.map_rounds[Map][1];
	}
}

function clear_player_statistics(total_rounds){
	global.game_struct.Rounds_win = 0;
	global.game_struct.Rounds_lost = 0;
	global.game_struct.Current_round = 0;
	global.game_struct.Win_streak = array_create(2, 0);
	global.game_struct.Loss_streak = array_create(2, 0);
	global.player_stats.Player_team = TEAM.NONE;
	global.BotMatchStats = [];
	for(var i=0;i<total_rounds;i++){
		global.game_struct.Headshots_per_round[i] = 0;
		global.game_struct.Kills_per_round[i] = 0;
		global.game_struct.Playing_time_per_round[i] = 0;
	}
}

function reset_player_door_keys(){
	global.player_stats.Gold = false;
	global.player_stats.Magenta = false;
	global.player_stats.Red = false;
	global.player_stats.Aqua = false;
	global.player_stats.Green = false;
	global.player_stats.Gray = false;
	global.player_stats.White = false;
}

function reset_singleplayer_game(){
	global.game_struct.Rounds_win = 0;
	global.game_struct.Rounds_lost = 0;
	global.game_struct.Current_round = 0;
	global.game_struct.Match_kills = 0;
	global.game_struct.Match_assists = 0;
	global.game_struct.Match_deaths = 0;
	global.player_stats.Player_team = TEAM.NONE;
	global.player_stats.Money = ROUND_STARTING_MONEY;
	ds_grid_clear(global.Inventory, 0);
	ds_grid_clear(global.MouseSlot, 0);
	global.player_stats.Weight = 0;
	reset_player_door_keys();

	for(var i = 0; i < MAX_ROUNDS; i++){
		global.game_struct.Headshots_per_round[i] = 0;
		global.game_struct.Kills_per_round[i] = 0;
		global.game_struct.Playing_time_per_round[i] = 0;
	}

	for(var map = 0; map < MAP.Total; map++){
		for(var value = 0; value < array_length(global.map_rounds[map]); value++){
			global.map_rounds[map][value] = -1;
		}
	}

	global.game_struct.Loss_streak = array_create(2, 0);
	global.game_struct.Win_streak = array_create(2, 0);
	global.BotMatchStats = [];
	global.bomb_planted = false;
	global.bomb_timer = 0;
	global.bomb_planter_pid = -1;
	global.ranked_game = false;

	save_game();
}

function clear_tracking_period(){
	for(var i=0;i<TRACKING_PERIOD;i++){
		global.game_struct.Recent_results[i] = -1;
		global.game_struct.Expected_results[i] = -1;
		global.game_struct.Enemy_ep[i] = -1;
		global.game_struct.Enemy_rd[i] = -1;
	}
}

function calculate_volatility(local_volatility_array, predictive_volatility, local_volatility_weights_array){	
	local_volatility = average(local_volatility_array, true, true, local_volatility_weights_array);
	return sqrt(local_volatility + power(predictive_volatility, 2));
}

function update_eggy_rating_system(game_result, map){
	var enemy_ep = global.game_struct.Enemy_ep[global.game_struct.Current_game];
	var enemy_rd = global.game_struct.Enemy_rd[global.game_struct.Current_game];
	var winned_rounds = global.game_struct.Rounds_win;
	var lost_rounds = global.game_struct.Rounds_lost;
	var expected_result = calculate_probability(global.game_struct.Player_ep, enemy_ep, global.game_struct.Player_rd, enemy_rd);
	var game_volatility = calculate_game_volatility(
														global.game_struct.Headshots_per_round, 
														global.game_struct.Kills_per_round,
														winned_rounds + lost_rounds
													);
	
	global.game_struct.Recent_results = array_shift_left(global.game_struct.Recent_results, game_result);
	global.game_struct.Expected_results = array_shift_left(global.game_struct.Expected_results, expected_result);	
	global.game_struct.Game_volatility = array_shift_left(global.game_struct.Game_volatility, game_volatility);
	global.game_struct.Winned_rounds = array_shift_left(global.game_struct.Winned_rounds, winned_rounds);
	global.game_struct.Lost_rounds = array_shift_left(global.game_struct.Lost_rounds, lost_rounds);
	var tracking_period_completed = false;
	
	if (global.game_struct.Current_game > 0 && (global.game_struct.Current_game + 1) % TRACKING_PERIOD == 0){
		global.game_struct.Predictive_volatility = calculate_predictive_volatility(global.game_struct.Recent_results, global.game_struct.Expected_results);
		var played_rounds = array_create(TRACKING_PERIOD, -1);
		
		for(var i=0;i<array_length(played_rounds);i++){
			played_rounds[i] = global.game_struct.Winned_rounds[i] + global.game_struct.Lost_rounds[i];
		}
		var volatility = calculate_volatility(
												global.game_struct.Game_volatility, 
												global.game_struct.Predictive_volatility, 
												played_rounds
											);	
		global.game_struct.Player_rd = calculate_new_rd(global.game_struct.Player_rd, volatility, global.game_struct.Enemy_rd);
		global.game_struct.Current_game = 0;
		clear_tracking_period();
		tracking_period_completed = true;
	}else{
		global.game_struct.Current_game ++;
	}

	global.game_struct.Played_games ++;
	
	if(game_result < 0.5){
		global.game_struct.Lost_games ++;
	}else if(game_result == 0.5){
		global.game_struct.Tied_games ++;
	}else{
		global.game_struct.Won_games ++;
	}

	var hs_sum = sum(global.game_struct.Headshots_per_round);
	var kills_sum = sum(global.game_struct.Kills_per_round);
	var ep_change = calculate_ep_change(
		expected_result,
		game_result, 
		kills_sum, 
		hs_sum, 
		global.game_struct.Player_ep, 
		global.game_struct.Player_rd,
		enemy_ep,
		enemy_rd,
		map	
	);
	
	global.game_struct.Previous_ep = global.game_struct.Player_ep;
	global.game_struct.Player_ep += ep_change;
	global.game_struct.Player_ep = max(global.game_struct.Player_ep, 0);

	if(tracking_period_completed){
		set_current_enemy();
	}
}

function get_enemy_ep(player_ep, player_rd){
	return max(random_range(max(player_ep - player_rd*2, 0), player_ep + player_rd*2), 0);	
}

function get_enemy_rd(player_rd){
	return max(random_range(player_rd * .5, (player_rd * 2.0)), 0);	
}

function convert_to_eggy_scale(ep, rd = false) {
	if(rd == false){
		return (ep - MIN_EP) / ES_MODIFIER;
	}
	
	return (ep / ES_MODIFIER);
}

function convert_back(eggy_ep, rd = false) {
	if(rd == false){
		return (eggy_ep * ES_MODIFIER + MIN_EP);
	}
	
	return (eggy_ep * ES_MODIFIER);
}

function std(array){
	var avg = average(array);
	var sum_array = 0;
	var n = array_length(array);
	if (n <= 1) return 0;
	
	for(var i = 0;i<n;i++){
		sum_array += power(array[i] - avg, 2);
	}
	
	return sqrt(sum_array/(n-1));
}

function calculate_new_rd(old_rd, volatility, enemy_rds){
	var _rd = sqrt(power(old_rd, 2) + power(volatility, 2));
	games_information = calculate_games_information(enemy_rds);
	
	var new_rd = 1/sqrt(1/power(_rd, 2) + games_information);
	
	return new_rd;
}

function calculate_team_ep(enemy_ep, enemy_rd){
	var ep_sum = 0;
	var rd_sum = 0
	
	for(var i = 0; i < array_length(enemy_ep); i ++){
		ep_sum += (enemy_ep[i]/power(enemy_rd[i], 2));	
		rd_sum += (1/power(enemy_rd[i], 2));	
	}
	
	var ep_opponent = ep_sum/rd_sum;
	return ep_opponent;
}

function ep_diff_modifier(rd, ep_diff) {
    var uncertainty_factor = rd_weight(rd);
    var sigmoid_component = 1 / (1 + exp(-ep_diff * 0.5));
    return sigmoid_component * uncertainty_factor * 0.5;
}

function calculate_team_rd(rd){	
	return average(rd) + 0.5 * std(rd);
}

function calculate_ep_change(prob_win, game_result, your_kills, your_hs, A_ep, A_rd, B_ep, B_rd, map, team_kills = -1, team_hs = -1) {
	
   #region Statistics modifier
	var kill_weight = 0.05;
    var headshot_weight = 0.1;	
	
	//Pseudo-výpočet průměrných killů pro singleplayer
	var average_kills = get_average_kills(map);
	if(is_array(team_kills)){
		average_kills = average(team_kills);	
	}
	
	//Pseudo-výpočet průměrných headshotů pro singleplayer
	var average_hs = get_average_headshots(A_ep, average_kills * .1, average_kills, convert_to_eggy_scale(GLOBAL_MASTER_EP)); // Průměrně minimálně 10% killů jsou headshoty
	if(is_array(team_hs)){
		average_hs = average(team_hs);	
	}

    var kill_ratio = your_kills/average_kills;
    var headshot_ratio = your_hs/average_hs;
    var kill_modifier = kill_ratio * kill_weight;
    var headshot_modifier = headshot_ratio * headshot_weight;
    var statistics_modifier = kill_modifier + headshot_modifier;
	#endregion
	
	#region EP difference modifier
	var B_eggy_points = B_ep;
	var B_rating_d = B_rd;
	var A_eggy_points = A_ep;
	var A_rating_d = A_rd;
	
	// Pokud je A stats.Team, vypočti jejich EP na základě jejich RD
	if(is_array(A_ep) && is_array(A_rd)){
		A_eggy_points = calculate_team_ep(A_ep, A_rd);
	}
	
	// Pokud je B stats.Team, vypočti jejich EP na základě jejich RD
	if(is_array(B_ep) && is_array(B_rd)){
		B_eggy_points = calculate_team_ep(B_ep, B_rd);
		B_rating_d = calculate_team_rd(B_rd);
	}
	
	var ep_difference = B_eggy_points - A_eggy_points;
	var ep_modifier_diff = ep_diff_modifier(B_rating_d, ep_difference);
	#endregion
	
	#region Game result modifier	
	var result_sign = (game_result >= 0.5) ? 1 : -1;
	var result_effect = (game_result < 0.5)
	    ? prob_win       // čím větší šance byla → tím větší trest za prohru
	    : (1 - prob_win); // čím menší šance → tím větší odměna za výhru
	var game_result_change = result_sign * result_effect;
	#endregion
	
	#region RD modifier
	// Čím větší RD, tím větší odměna/penalizace, protože systém nemá tušení, kde hráč patří
	var rd_modifier = A_rating_d;
	#endregion
	
	var base_modifier = 1 + ep_modifier_diff + statistics_modifier;
	if(game_result < 0.5){
		base_modifier = 1 / (1 + ep_modifier_diff + statistics_modifier);
	}

if(!is_real(rd_modifier)){
    show_debug_message("rd_modifier is invalid: " + string(rd_modifier));
    show_debug_message("A_rd: " + string(A_rd));
    return 0;
}

    return game_result_change * base_modifier * rd_modifier;
}

function calculate_predictive_volatility(player_recent_results, player_recent_expected) {
	var valid_entries = 0;
    var sum_abs_diff = 0;
    var n = array_length(player_recent_results);
    
    for (var i = 0; i < n; i++) {
        if (player_recent_results[i] == -1 || player_recent_expected[i] == -1) {
            continue;
        }
        var diff = player_recent_results[i] - player_recent_expected[i];
        sum_abs_diff += power(diff, 2);
        valid_entries++;
    }
	
    var volatility = valid_entries > 0 ? sqrt(sum_abs_diff / valid_entries) : PLAYER_STARTING_VOLATILITY;
    return volatility;
}

/// @desc Calculate the performance ratio of a player compared to the average
function get_performance_ratio(player_stat, average_stat) {
    if (average_stat > 0) {
        return player_stat / average_stat;
    } else {
        return 1;
    }
}

/// @desc Get average kills based on the map
function get_average_kills(map) {
    var average_kills;
    if (map == MAP.Desert) {
        average_kills = 10 * MAX_ROUNDS;
    } else if (map == MAP.RainForest) {
        average_kills = 17 * MAX_ROUNDS;
    } else {
        average_kills = 10 * MAX_ROUNDS;
    }
    return average_kills;
}

/// @desc Estimate the average number of headshots for a given Ep using an exponential model
function get_average_headshots(player_ep, base_headshots, max_headshots, max_ep) {
    var normalized_ep = player_ep / max_ep;
    var growth_factor = (exp(normalized_ep * 10) - 1) / (exp(10) - 1);
    var average_headshots = base_headshots + growth_factor * (max_headshots - base_headshots);
    return average_headshots;
}

/// @desc Calculate local volatility
function calculate_game_volatility(headshots_per_round, kills_per_round, played_rounds) {
    var sum_headshot_variances = 0;
    var sum_kill_variances = 0;
    var valid_headshots = 0;
    var valid_kills = 0;

    // Calculate variance for headshots
	var hs = array_create(played_rounds, 0);
	array_copy(hs, 0, headshots_per_round, 0, played_rounds);
	var avg_hs = average(hs);
    for (var i = 0; i < array_length(headshots_per_round); i++) {
        if (i < played_rounds) {
            var diff_headshots = headshots_per_round[i] - avg_hs;
            sum_headshot_variances += power(diff_headshots, 2);
            valid_headshots++;
        }
    }

    // Calculate variance for kills
	var kills = array_create(played_rounds, 0);
	array_copy(kills, 0, kills_per_round, 0, played_rounds);
	var avg_kills = average(kills);
    for (var i = 0; i < array_length(kills_per_round); i++) {
        if (i < played_rounds) {
            var diff_kills = kills_per_round[i] - avg_kills;
            sum_kill_variances += power(diff_kills, 2);
            valid_kills++;
        }
    }

    // Calculate volatilities
    var headshot_volatility = valid_headshots > 0 ? sqrt(sum_headshot_variances / (valid_headshots - 1)) : PLAYER_STARTING_VOLATILITY;
    var kill_volatility = valid_kills > 0 ? sqrt(sum_kill_variances / (valid_kills - 1)) : PLAYER_STARTING_VOLATILITY;

    return (headshot_volatility + kill_volatility) / 2;
}

/// @desc Calculate the game result from 0 to 1 based on scores
function calculate_game_result(player_win_rounds, enemy_win_rounds) {
    var rounds_difference = player_win_rounds - enemy_win_rounds;	
	var game_result = 0.5 + (rounds_difference/(MAX_ROUNDS + 2));
	return game_result;
}

function round_end(round_result, winning_team = -1){
	with(oMortarMenu){
		zui_destroy();
	}

	var local_player = global.local_player;
	if ((winning_team != TEAM.POLICE && winning_team != TEAM.TERRORIST) && instance_exists(local_player)) {
		winning_team = round_result == "Win"
			? local_player.stats.Team
			: (local_player.stats.Team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE);
	}

	if (IS_NET) {
		if (!oNetworkManager.is_server) return false;
		if (winning_team != TEAM.POLICE && winning_team != TEAM.TERRORIST) return false;
		if (oNetworkManager.round_resolved) return false;

		reset_player_door_keys();
		oNetworkManager.round_resolved = true;
		oNetworkManager.team_round_wins[winning_team]++;

		if (instance_exists(local_player)) {
			global.game_struct.Rounds_win = oNetworkManager.team_round_wins[local_player.stats.Team];
			var local_enemy_team = local_player.stats.Team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE;
			global.game_struct.Rounds_lost = oNetworkManager.team_round_wins[local_enemy_team];
		}

		if (instance_exists(oGameController)) {
			oGameController.resolve_round(winning_team);
		}

		if (instance_exists(oGameController) && instance_exists(local_player)) {
			oGameController.player_win = winning_team == local_player.stats.Team;
		}
		if (instance_exists(oDraw)) {
			oDraw.spectating = false;
			oDraw.spectate_target = noone;
			var game_ended = oNetworkManager.team_round_wins[winning_team] >= (MAX_ROUNDS / 2 + 1);
			oDraw.GameEndMenu = game_ended;
			oDraw.RespawnMenu = true;

			if (game_ended && !oNetworkManager.game_win_diamond_granted) {
				if (instance_exists(local_player) && local_player.stats.Team == winning_team) {
					global.player_stats.Diamonds += global.game_struct.Rounds_win*2;
					save_game();
				}
				oNetworkManager.game_win_diamond_granted = true;
			}
		}

		server_round_end_broadcast(winning_team);
		camera_set_view_angle(CAM, 0);
		return true;
	}

	reset_player_door_keys();

	if (instance_exists(oGameController)) {
		oGameController.resolve_round(winning_team);
	}

	save_game();
	oGameController.round_ended = true;
	if(global.ranked_game == true){
		if(round_result == "Win"){
			oGameController.player_win = true;
		}else{
			oGameController.player_win = false;
		}
	}else{
		oDraw.RespawnMenu = true;
	}
	camera_set_view_angle(CAM, 0);
	return true;
}

function RankStats(RankID, LessMod, BoostMod, RankName, MinElo){
	global.RankIndex[#RankID, RankStat.LessModifier] = LessMod;
	global.RankIndex[#RankID, RankStat.BoostModifier] = BoostMod;
	global.RankIndex[#RankID, RankStat.Name] = RankName;
	global.RankIndex[#RankID, RankStat.Ep] = MinElo;
}

function rank_database(){
	enum RankType{
		Unranked, 
		SilverI, SilverII, SilverIII, SilverIV, SilverV, SilverMaster,
		GoldI, GoldII, GoldIII, GoldIV, GoldMaster,
		DiamondI, DiamondII, DiamondIII, DiamondMaster,
		AssaultEliteI, AssaultEliteII, AssaultMaster,
		VersatileMaster, ExperiencedVersatileMaster, 
		SupremeMaster, GlobalMaster, Total
	}
	enum RankStat{
		LessModifier, BoostModifier, Name, Ep, Total
	}
	
	global.RankIndex = ds_grid_create(RankType.Total, RankStat.Total);
	ds_grid_clear(global.RankIndex, 0);

	RankStats(RankType.Unranked, 1.5, 0.7, "Unranked", SILVERI_EP);	
	RankStats(RankType.SilverI, 1.5, 0.7, "Silver I", SILVERI_EP);	
	RankStats(RankType.SilverII, 1.45, 0.73, "Silver II", SILVERII_EP);
	RankStats(RankType.SilverIII, 1.4, 0.75, "Silver III", SILVERIII_EP);
	RankStats(RankType.SilverIV, 1.35, 0.78, "Silver IV", SILVERIV_EP);
	RankStats(RankType.SilverV, 1.3, 0.8, "Silver V", SILVERV_EP);
	RankStats(RankType.SilverMaster, 1.25, 0.83, "Silver master", SILVER_MASTER_EP);
	RankStats(RankType.GoldI, 1.2, 0.85, "Gold I", GOLDI_EP);
	RankStats(RankType.GoldII, 1.1, 0.89, "Gold II", GOLDII_EP);
	RankStats(RankType.GoldIII, 1.05, 0.9, "Gold III", GOLDIII_EP);
	RankStats(RankType.GoldIV, 1.0, 0.92, "Gold IV", GOLDIV_EP);
	RankStats(RankType.GoldMaster, 0.95, 0.95, "Gold master", GOLD_MASTER_EP);
	RankStats(RankType.DiamondI, 0.85, 0.98, "Diamond I", DIAMONDI_EP);
	RankStats(RankType.DiamondII, 0.8, 1.02, "Diamond II", DIAMONDII_EP);
	RankStats(RankType.DiamondIII, 0.75, 1.05, "Diamond III", DIAMONDIII_EP);
	RankStats(RankType.DiamondMaster, 0.7, 1.08, "Diamond master", DIAMOND_MASTER_EP);
	RankStats(RankType.AssaultEliteI, 0.65, 1.1, "Assault elite I", ASSAULT_ELITEI_EP);
	RankStats(RankType.AssaultEliteII, 0.6, 1.12, "Assault elite II", ASSAULT_ELITEII_EP);
	RankStats(RankType.AssaultMaster, 0.57, 1.15, "Assault master", ASSAULT_MASTER_EP);
	RankStats(RankType.VersatileMaster, 0.53, 1.18, "Versatile master", VERSATILE_MASTER_EP);
	RankStats(RankType.ExperiencedVersatileMaster, 0.5, 1.25, "Experienced versatile master", EXPERIENCED_VERSATILE_MASTER_EP);
	RankStats(RankType.SupremeMaster, 0.45, 1.3, "Supreme master", SUPREME_MASTER_EP);
	RankStats(RankType.GlobalMaster, 0.4, 1.5, "Global master", GLOBAL_MASTER_EP);
}

function get_rank(ep){
	var highest_rank = -1;	
    for(var i = 0; i < RankType.Total; i++){
        if(convert_back(ep) >= global.RankIndex[#i, RankStat.Ep]){
            highest_rank = i;
        }
    }
    
    return highest_rank;
}

function get_rank_boost(ep){
	var highest_rank = -1;
	for(var i = 0; i < RankType.Total; i++){
        if(convert_back(ep) >= global.RankIndex[#i, RankStat.Ep]){
            highest_rank = i;
        }
    }
    
    return global.RankIndex[#highest_rank, RankStat.BoostModifier];
}

function get_rank_less(ep){
	var highest_rank = -1;
	for(var i = 0; i < RankType.Total; i++){
        if(convert_back(ep) >= global.RankIndex[#i, RankStat.Ep]){
            highest_rank = i;
        }
    }
    
    return global.RankIndex[#highest_rank, RankStat.LessModifier];
}
