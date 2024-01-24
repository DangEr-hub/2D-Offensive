function ini_player_struct_create(){
	var player_struct = {
		"Game_volatility": PLAYER_STARTING_VOLATILITY,
		"Local_volatility": PLAYER_STARTING_VOLATILITY,
		"Elo": convert_to_eggy_scale(PLAYER_STARTING_ELO), ///Eggy scale
		"Tracking_game": 0,
		"Current_round": 0,
		"Rounds_win": 0,
		"Rounds_lost": 0,
		"Played_games": 0,
		"Recent_games": array_create(TRACKING_GAMES/2, -1),
		"Expected_games": array_create(TRACKING_GAMES/2, -1),
		"Playing_time_per_round": array_create(MAX_ROUNDS, -1),
		"Kills_per_round": array_create(MAX_ROUNDS, -1),
		"Headshots_per_round": array_create(MAX_ROUNDS, -1),
		"Enemy_elo": array_create(TRACKING_GAMES/2, -1),
	}
	
	return player_struct;
}

function clear_player_statistics(total_rounds){
	global.player_elo_struct.Rounds_win = 0;
	global.player_elo_struct.Rounds_lost = 0;
	global.player_elo_struct.Current_round = 0;
	for(var i=0;i<total_rounds;i++){
		global.player_elo_struct.Headshots_per_round[i] = -1;
		global.player_elo_struct.Kills_per_round[i] = -1;
		global.player_elo_struct.Playing_time_per_round[i] = -1;
	}
}

function update_eggy_rating_system(game_result, enemy_elo, map){
	global.player_elo_struct.Played_games ++;
	global.player_elo_struct.Local_volatility = calculate_local_volatility(global.player_elo_struct.Headshots_per_round, global.player_elo_struct.Kills_per_round, global.player_elo_struct.Playing_time_per_round);
	global.player_elo_struct.Game_volatility = calculate_volatility(global.player_elo_struct.Recent_games, global.player_elo_struct.Expected_games);
	global.player_elo_struct.Recent_games = array_shift_left(global.player_elo_struct.Recent_games, game_result);


	var total_kills = sum(global.player_elo_struct.Kills_per_round);
	var total_headshots = sum(global.player_elo_struct.Headshots_per_round);
	var elo_bonus = get_elo_current(
		calculate_probability(global.player_elo_struct.Elo, enemy_elo),
		game_result, 
		global.player_elo_struct.Game_volatility, 
		global.player_elo_struct.Local_volatility, 
		total_kills, 
		total_headshots, 
		global.player_elo_struct.Elo, 
		map,
		enemy_elo
	);
	show_debug_message(elo_bonus);
	global.player_elo_struct.Tracking_game ++;
	
	if(global.player_elo_struct.Played_games % (TRACKING_GAMES/2) == 0 || global.player_elo_struct.Played_games == 1){
		global.player_elo_struct.Tracking_game = 0;
		update_player_expected_games();	
	}
	
	global.player_elo_struct.Elo += elo_bonus;
	global.player_elo_struct.Elo = max(global.player_elo_struct.Elo, 0);
}

function get_enemy_elo(player_elo){
	return max(random_range(player_elo * .75, player_elo * 1.5), 0);	
}

function update_player_expected_games(){
	for(var i=0;i<TRACKING_GAMES/2;i++){
		global.player_elo_struct.Enemy_elo[i] = get_enemy_elo(global.player_elo_struct.Elo);
		global.player_elo_struct.Expected_games[i] = calculate_probability(global.player_elo_struct.Elo, global.player_elo_struct.Enemy_elo[i]);
	}
}

function convert_to_eggy_scale(elo) {
    var elo_offset = 100;
    var max_elo = 1900;
    var min_elo = 0;
    var normalized_elo = (elo - min_elo + elo_offset) / (max_elo - min_elo + elo_offset);
    var power_variable = 2;
    var eggy_scale = power(normalized_elo, 1 / power_variable);
    return abs(eggy_scale * max_elo);
}

function convert_back(eggy_elo) {
    var elo_offset = 100;
    var max_elo = 1900;
    var min_elo = 0;
    var power_variable = 2;
    var normalized_eggy = eggy_elo / max_elo;
    var normalized_elo = power(normalized_eggy, power_variable);
    return abs(normalized_elo * (max_elo - min_elo + elo_offset) - elo_offset + min_elo);
}

function calculate_probability(player_elo, enemy_elo) {
    var exponent = (enemy_elo - player_elo) / 400;
    return 1 / (1 + power(2, exponent));
}

function get_elo_current(probability_of_winning, game_result, volatility, game_volatility, player_kills, player_headshots, player_elo_scale, map, enemy_elo_scale, base_k=4) {
    var kill_weight = 1;//0.2;
    var headshot_weight = 1;//0.3;
    var average_kills = get_average_kills(map);
    var average_headshots = get_average_headshots(player_elo_scale, average_kills * 0.1, average_kills, convert_to_eggy_scale(GLOBAL_MASTER_ELO)); ///Eggy scale
    var kill_ratio = get_performance_ratio(player_kills, average_kills);
    var headshot_ratio = get_performance_ratio(player_headshots, average_headshots);
    var kill_bonus = kill_ratio * kill_weight;
    var headshot_bonus = headshot_ratio * headshot_weight;
	var elo_ratio = enemy_elo_scale/(player_elo_scale + 1);
    var total_bonus = kill_bonus + headshot_bonus;
    var K = base_k * (1 + volatility) * (1 + game_volatility);
	show_debug_message("K" + string(K));
	show_debug_message("volatility" + string(volatility));
	show_debug_message("game_volatility" + string(game_volatility));
    return K * ((game_result + total_bonus - probability_of_winning) * elo_ratio);
}

function calculate_volatility(player_recent_results, player_recent_expected) {
	var valid_entries = 0;
    var sum_abs_diff = 0;
    var n = array_length(player_recent_results);
    
    for (var i = 0; i < n; i++) {
        if (player_recent_results[i] == -1 || player_recent_expected[i] == -1) {
            continue;
        }
        var diff = player_recent_results[i] - player_recent_expected[i];
        sum_abs_diff += abs(diff);
        valid_entries++;
    }
	
    var volatility = valid_entries > 0 ? sum_abs_diff / valid_entries : PLAYER_STARTING_VOLATILITY;
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

/// @desc Estimate the average number of headshots for a given Elo using an exponential model
function get_average_headshots(player_elo, base_headshots, max_headshots, max_elo) {
    var normalized_elo = player_elo / max_elo;
    var growth_factor = (exp(normalized_elo * 10) - 1) / (exp(10) - 1);
    var average_headshots = base_headshots + growth_factor * (max_headshots - base_headshots);
    return average_headshots;
}

/// @desc Calculate the expected results for games against multiple enemies
function calculate_expected_results(player_elo, enemy_elos) {
    var expected_results = [];
    for (var i = 0; i < array_length(enemy_elos); i++) {
		expected_results[i] = calculate_probability(player_elo, enemy_elos[i]);
    }
    return expected_results;
}

/// @desc Calculate local volatility
function calculate_local_volatility(headshots_per_round, kills_per_round, playing_time_per_round) {
    var sum_headshot_variances = 0;
    var sum_kill_variances = 0;
    var sum_playing_time_variances = 0;
    var valid_headshots = 0;
    var valid_kills = 0;
    var valid_playing_times = 0;

    // Calculate variance for headshots
    for (var i = 0; i < array_length(headshots_per_round); i++) {
        if (headshots_per_round[i] != -1) {
            var diff_headshots = headshots_per_round[i] - average(headshots_per_round);
            sum_headshot_variances += diff_headshots * diff_headshots;
            valid_headshots++;
        }
    }

    // Calculate variance for kills
    for (var i = 0; i < array_length(kills_per_round); i++) {
        if (kills_per_round[i] != -1) {
            var diff_kills = kills_per_round[i] - average(kills_per_round);
            sum_kill_variances += diff_kills * diff_kills;
            valid_kills++;
        }
    }

    // Calculate variance for playing time
    for (var i = 0; i < array_length(playing_time_per_round); i++) {
        if (playing_time_per_round[i] != -1) {
            var diff_playing_time = playing_time_per_round[i] - average(playing_time_per_round);
            sum_playing_time_variances += diff_playing_time * diff_playing_time;
            valid_playing_times++;
        }
    }

    // Calculate volatilities
    var headshot_volatility = valid_headshots > 0 ? sqrt(sum_headshot_variances / valid_headshots) : PLAYER_STARTING_VOLATILITY;
    var kill_volatility = valid_kills > 0 ? sqrt(sum_kill_variances / valid_kills) : PLAYER_STARTING_VOLATILITY;
    var playing_time_volatility = valid_playing_times > 0 ? (sqrt(sum_playing_time_variances / valid_playing_times)/1000) : PLAYER_STARTING_VOLATILITY;

    return (headshot_volatility + kill_volatility + playing_time_volatility) / 3;
}


/// @desc Calculate the game result from 0 to 1 based on scores
function calculate_game_result(player_win_rounds, enemy_win_rounds) {
    var max_rounds_difference = MAX_ROUNDS/2;
    var rounds_difference = player_win_rounds - enemy_win_rounds;
    var game_result = (max_rounds_difference / 10) + ((2 * max_rounds_difference / 100) * rounds_difference);
    return max(0, min(game_result, 1));
}

function round_end(round_result){
	if(global.ranked_game == true){
		oEggyEloRatingSystem.round_ended = true;
		if(round_result == "Win"){
			oEggyEloRatingSystem.player_win = true;
		}else{
			oEggyEloRatingSystem.player_win = false;
		}
	}else{
		return false;
	}
}

function RankStats(RankID, LessMod, BoostMod, RankName, MinElo){
	global.RankIndex[#RankID, RankStat.LessModifier] = LessMod;
	global.RankIndex[#RankID, RankStat.BoostModifier] = BoostMod;
	global.RankIndex[#RankID, RankStat.Name] = RankName;
	global.RankIndex[#RankID, RankStat.Elo] = MinElo;
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
		LessModifier, BoostModifier, Name, Elo, Total
	}
	
	global.RankIndex = ds_grid_create(RankType.Total, RankStat.Total);
	ds_grid_clear(global.RankIndex, 0);
	
	RankStats(RankType.Unranked, 1.05, 0.9, "Unranked", PLAYER_STARTING_ELO);
	RankStats(RankType.SilverI, 1.05, 0.9, "Silver I", SILVERI_ELO);	
	RankStats(RankType.SilverII, 1.04, 0.91, "Silver II", SILVERII_ELO);
	RankStats(RankType.SilverIII, 1, 0.92, "Silver III", SILVERIII_ELO);
	RankStats(RankType.SilverIV, 0.95, 0.93, "Silver IV", SILVERIV_ELO);
	RankStats(RankType.SilverV, 0.92, 0.94, "Silver V", SILVERV_ELO);
	RankStats(RankType.SilverMaster, 0.9, 1, "Silver master", SILVER_MASTER_ELO);
	RankStats(RankType.GoldI, 0.88, 1.01, "Gold I", GOLDI_ELO);
	RankStats(RankType.GoldII, 0.85, 1.03, "Gold II", GOLDII_ELO);
	RankStats(RankType.GoldIII, 0.83, 1.05, "Gold III", GOLDIII_ELO);
	RankStats(RankType.GoldIV, 0.8, 1.07, "Gold IV", GOLDIV_ELO);
	RankStats(RankType.GoldMaster, 0.79, 1.11, "Gold master", GOLD_MASTER_ELO);
	RankStats(RankType.DiamondI, 0.75, 1.14, "Diamond I", DIAMONDI_ELO);
	RankStats(RankType.DiamondII, 0.73, 1.15, "Diamond II", DIAMONDII_ELO);
	RankStats(RankType.DiamondIII, 0.71, 1.18, "Diamond III", DIAMONDIII_ELO);
	RankStats(RankType.DiamondMaster, 0.69, 1.2, "Diamond master", DIAMOND_MASTER_ELO);
	RankStats(RankType.AssaultEliteI, 0.65, 1.21, "Assault elite I", ASSAULT_ELITEI_ELO);
	RankStats(RankType.AssaultEliteII, 0.63, 1.22, "Assault elite II", ASSAULT_ELITEII_ELO);
	RankStats(RankType.AssaultMaster, 0.59, 1.23, "Assault master", ASSAULT_MASTER_ELO);
	RankStats(RankType.VersatileMaster, 0.54, 1.25, "Versatile master", VERSATILE_MASTER_ELO);
	RankStats(RankType.ExperiencedVersatileMaster, 0.5, 1.3, "Experienced versatile master", EXPERIENCED_VERSATILE_MASTER_ELO);
	RankStats(RankType.SupremeMaster, 0.48, 1.35, "Supreme master", SUPREME_MASTER_ELO);
	RankStats(RankType.GlobalMaster, 0.45, 1.75, "Global master", GLOBAL_MASTER_ELO);
}

function get_rank(Object = noone){
	var highest_rank = -1;
	var object_elo = -1;
	if(Object != noone){
		if(Object.object_index == oPlayer){
			object_elo = convert_back(global.player_elo_struct.Elo);
		}else if(Object.object_index == oEnemy){
			object_elo = convert_back(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);	
		}
	}else{
		object_elo = convert_back(global.player_elo_struct.Elo);
	}
	
    for(var i = 0; i < RankType.Total; i++){
        if(object_elo >= global.RankIndex[#i, RankStat.Elo]){
            highest_rank = i;
        }
    }
    
    return highest_rank;
}

function get_rank_boost(elo){
	var highest_rank = -1;
	for(var i = 0; i < RankType.Total; i++){
        if(elo >= global.RankIndex[#i, RankStat.Elo]){
            highest_rank = i;
        }
    }
    
    return global.RankIndex[#highest_rank, RankStat.BoostModifier];
}

function get_rank_less(elo){
	var highest_rank = -1;
	for(var i = 0; i < RankType.Total; i++){
        if(elo >= global.RankIndex[#i, RankStat.Elo]){
            highest_rank = i;
        }
    }
    
    return global.RankIndex[#highest_rank, RankStat.LessModifier];
}