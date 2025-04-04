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
		prob_win = global.rating_struct.Expected_results[i];
		information_sum += rd_weight(rd_enemy[i]) * prob_win * (1 - prob_win);
	}
	
	return information_sum;
}

function set_current_enemy(){
	if(global.rating_struct.Enemy_ep[global.rating_struct.Current_game] == -1){
		global.rating_struct.Enemy_ep[global.rating_struct.Current_game] = get_enemy_ep(global.rating_struct.Player_ep, global.rating_struct.Player_rd);
		global.rating_struct.Enemy_rd[global.rating_struct.Current_game] = get_enemy_rd(global.rating_struct.Player_rd);
	}
}

function ini_player_struct_create(){
	var player_struct = {
		"Previous_ep": convert_to_eggy_scale(MIN_EP),
		"Playing_time_per_round": array_create(MAX_ROUNDS, 0),
		"Predictive_volatility": PLAYER_STARTING_VOLATILITY,
		"Game_volatility": array_create(TRACKING_PERIOD, PLAYER_STARTING_VOLATILITY),
		"Player_ep": convert_to_eggy_scale(MIN_EP), // Eggy scale
		"Current_game": 0,
		"Current_round": 0,
		"Rounds_win": 0,
		"Rounds_lost": 0,
		"Played_games": 0,
		"Winned_rounds": array_create(TRACKING_PERIOD, 0),
		"Won_games": 0,
		"Lost_games": 0,
		"Tied_games": 0,
		"Player_rd": convert_to_eggy_scale(RD_START, true), // Eggy scale
		"Kills_per_round": array_create(MAX_ROUNDS, 0),
		"Headshots_per_round": array_create(MAX_ROUNDS, 0),
		"Recent_results": array_create(TRACKING_PERIOD, -1),
		"Expected_results": array_create(TRACKING_PERIOD, -1),
		"Enemy_ep": array_create(TRACKING_PERIOD, -1),
		"Enemy_rd": array_create(TRACKING_PERIOD, 0)
	}
	
	return player_struct;
}

function set_map_rounds(Map){
	global.MapID = Map;
	if(global.map_rounds[Map][2] == -1){
		global.map_rounds[Map][2] = global.rating_struct.Enemy_ep[global.rating_struct.Current_game];
	}
	if(global.map_rounds[Map][0] != -1){
		global.rating_struct.Rounds_win = global.map_rounds[Map][0];
		global.rating_struct.Rounds_lost = global.map_rounds[Map][1];
	}
}

function clear_player_statistics(total_rounds){
	global.rating_struct.Rounds_win = 0;
	global.rating_struct.Rounds_lost = 0;
	global.rating_struct.Current_round = 0;
	for(var i=0;i<total_rounds;i++){
		global.rating_struct.Headshots_per_round[i] = 0;
		global.rating_struct.Kills_per_round[i] = 0;
		global.rating_struct.Playing_time_per_round[i] = 0;
	}
}

function clear_tracking_period(){
	for(var i=0;i<TRACKING_PERIOD;i++){
		global.rating_struct.Recent_results[i] = -1;
		global.rating_struct.Expected_results[i] = -1;
		global.rating_struct.Enemy_ep[i] = -1;
		global.rating_struct.Enemy_rd[i] = -1;
	}
}

function calculate_volatility(local_volatility_array, predictive_volatility, local_volatility_weights_array){	
	local_volatility = average(local_volatility_array, true, true, local_volatility_weights_array);
	return sqrt(power(local_volatility, 2) + power(predictive_volatility, 2));
}

function update_eggy_rating_system(game_result, map){
	var enemy_ep = global.rating_struct.Enemy_ep[global.rating_struct.Current_game];
	var enemy_rd = global.rating_struct.Enemy_rd[global.rating_struct.Current_game];
	var winned_rounds = global.rating_struct.Rounds_win;
	var expected_result = calculate_probability(global.rating_struct.Player_ep, enemy_ep, global.rating_struct.Player_rd, enemy_rd);
	var game_volatility = calculate_game_volatility(global.rating_struct.Headshots_per_round, global.rating_struct.Kills_per_round);
	
	global.rating_struct.Recent_results = array_shift_left(global.rating_struct.Recent_results, game_result);
	global.rating_struct.Expected_results = array_shift_left(global.rating_struct.Expected_results, expected_result);	
	global.rating_struct.Game_volatility = array_shift_left(global.rating_struct.Game_volatility, game_volatility);
	global.rating_struct.Winned_rounds = array_shift_left(global.rating_struct.Winned_rounds, winned_rounds);
	
	if (global.rating_struct.Current_game > 0 && global.rating_struct.Current_game % TRACKING_PERIOD == 0){
		global.rating_struct.Predictive_volatility = calculate_predictive_volatility(global.rating_struct.Recent_results, global.rating_struct.Expected_results);
		var played_rounds = array_create(TRACKING_PERIOD, global.rating_struct.Winned_rounds + MAX_ROUNDS - global.rating_struct.Winned_rounds);
		var volatility = calculate_volatility(
												global.rating_struct.Game_volatility, 
												global.rating_struct.Predictive_volatility, 
												played_rounds
											);	
		global.rating_struct.Player_rd = calculate_new_rd(global.rating_struct.Player_rd, volatility, global.rating_struct.Enemy_rd);
		global.rating_struct.Current_game = 0;
		clear_tracking_period();
	}else{
		global.rating_struct.Current_game ++;
	}

	global.rating_struct.Played_games ++;
	
	if(game_result < 0.5){
		global.rating_struct.Lost_games ++;
	}else if(game_result == 0.5){
		global.rating_struct.Tied_games ++;
	}else{
		global.rating_struct.Won_games ++;
	}

	var hs_sum = sum(global.rating_struct.Headshots_per_round);
	var kills_sum = sum(global.rating_struct.Kills_per_round);
	var ep_change = calculate_ep_change(
		expected_result,
		game_result, 
		kills_sum, 
		hs_sum, 
		global.rating_struct.Player_ep, 
		global.rating_struct.Player_rd,
		enemy_ep,
		enemy_rd,
		map	
	);
	
	global.rating_struct.Previous_ep = global.rating_struct.Player_ep;
	global.rating_struct.Player_ep += ep_change;
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
    var uncertainty_factor = 1 / (1 + rd);
    var sigmoid_component = 1 / (1 + exp(-ep_diff * 0.5));
    return sigmoid_component * uncertainty_factor * 0.5;
}

function calculate_team_rd(rd){	
	return average(rd) + 0.5 * std(rd);
}

function calculate_ep_change(prob_win, game_result, your_kills, your_hs, A_ep, A_rd, B_ep, B_rd, map, team_kills = -1, team_hs = -1) {
	
   #region Statistics modifier
	var kill_weight = 0.1;
    var headshot_weight = 0.25;	
	
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
	
	// Pokud je A team, vypočti jejich EP na základě jejich RD
	if(is_array(A_ep) && is_array(A_rd)){
		A_eggy_points = calculate_team_ep(A_ep, A_rd);
	}
	
	// Pokud je B team, vypočti jejich EP na základě jejich RD
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
    if (map == MapIndex.Desert) {
        average_kills = 10 * MAX_ROUNDS;
    } else if (map == MapIndex.RainForest) {
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
function calculate_game_volatility(headshots_per_round, kills_per_round) {
    var sum_headshot_variances = 0;
    var sum_kill_variances = 0;
    var valid_headshots = 0;
    var valid_kills = 0;

    // Calculate variance for headshots
	var avg_hs = average(headshots_per_round);
    for (var i = 0; i < array_length(headshots_per_round); i++) {
        if (headshots_per_round[i] != -1) {
            var diff_headshots = headshots_per_round[i] - avg_hs;
            sum_headshot_variances += power(diff_headshots, 2);
            valid_headshots++;
        }
    }

    // Calculate variance for kills
	var avg_kills = average(kills_per_round);
    for (var i = 0; i < array_length(kills_per_round); i++) {
        if (kills_per_round[i] != -1) {
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

function round_end(round_result){
	save_game();
	oEggyEloRatingSystem.round_ended = true;
	if(global.ranked_game == true){
		if(round_result == "Win"){
			oEggyEloRatingSystem.player_win = true;
		}else{
			global.player_stats_struct.Deaths ++;
			oEggyEloRatingSystem.player_win = false;
		}
	}else{
		oDraw.RespawnMenu = true;
	}
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
	
	RankStats(RankType.Unranked, 1.5, 0.8, "Unranked", MIN_EP);
	RankStats(RankType.SilverI, 1.5, 0.8, "Silver I", SILVERI_EP);	
	RankStats(RankType.SilverII, 1.45, 0.87, "Silver II", SILVERII_EP);
	RankStats(RankType.SilverIII, 1.25, 0.9, "Silver III", SILVERIII_EP);
	RankStats(RankType.SilverIV, 1.2, 0.93, "Silver IV", SILVERIV_EP);
	RankStats(RankType.SilverV, 1.1, 0.94, "Silver V", SILVERV_EP);
	RankStats(RankType.SilverMaster, 1.07, 1, "Silver master", SILVER_MASTER_EP);
	RankStats(RankType.GoldI, 1, 1.01, "Gold I", GOLDI_EP);
	RankStats(RankType.GoldII, 0.95, 1.03, "Gold II", GOLDII_EP);
	RankStats(RankType.GoldIII, 0.93, 1.05, "Gold III", GOLDIII_EP);
	RankStats(RankType.GoldIV, 0.85, 1.07, "Gold IV", GOLDIV_EP);
	RankStats(RankType.GoldMaster, 0.83, 1.11, "Gold master", GOLD_MASTER_EP);
	RankStats(RankType.DiamondI, 0.8, 1.14, "Diamond I", DIAMONDI_EP);
	RankStats(RankType.DiamondII, 0.77, 1.15, "Diamond II", DIAMONDII_EP);
	RankStats(RankType.DiamondIII, 0.73, 1.18, "Diamond III", DIAMONDIII_EP);
	RankStats(RankType.DiamondMaster, 0.7, 1.2, "Diamond master", DIAMOND_MASTER_EP);
	RankStats(RankType.AssaultEliteI, 0.69, 1.21, "Assault elite I", ASSAULT_ELITEI_EP);
	RankStats(RankType.AssaultEliteII, 0.67, 1.22, "Assault elite II", ASSAULT_ELITEII_EP);
	RankStats(RankType.AssaultMaster, 0.63, 1.23, "Assault master", ASSAULT_MASTER_EP);
	RankStats(RankType.VersatileMaster, 0.61, 1.25, "Versatile master", VERSATILE_MASTER_EP);
	RankStats(RankType.ExperiencedVersatileMaster, 0.59, 1.3, "Experienced versatile master", EXPERIENCED_VERSATILE_MASTER_EP);
	RankStats(RankType.SupremeMaster, 0.53, 1.35, "Supreme master", SUPREME_MASTER_EP);
	RankStats(RankType.GlobalMaster, 0.5, 1.75, "Global master", GLOBAL_MASTER_EP);
}

function get_rank(Ep){
	var highest_rank = -1;	
    for(var i = 0; i < RankType.Total; i++){
        if(convert_back(Ep) >= global.RankIndex[#i, RankStat.Ep]){
            highest_rank = i;
        }
    }
    
    return highest_rank;
}

function get_rank_boost(ep){
	var highest_rank = -1;
	for(var i = 0; i < RankType.Total; i++){
        if(ep >= global.RankIndex[#i, RankStat.Ep]){
            highest_rank = i;
        }
    }
    
    return global.RankIndex[#highest_rank, RankStat.BoostModifier];
}

function get_rank_less(ep){
	var highest_rank = -1;
	for(var i = 0; i < RankType.Total; i++){
        if(ep >= global.RankIndex[#i, RankStat.Ep]){
            highest_rank = i;
        }
    }
    
    return global.RankIndex[#highest_rank, RankStat.LessModifier];
}
