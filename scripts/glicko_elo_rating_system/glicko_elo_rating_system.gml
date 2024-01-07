// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/*
#macro TAU 0.2
#macro PLAYER_STARTING_VOLATILITY 0.05
#macro PLAYER_STARTING_RD 350
#macro PLAYER_STARTING_ELO 0
#macro SILVERI_ELO 0
#macro SILVERII_ELO 20
#macro SILVERIII_ELO 40
#macro SILVERIV_ELO 100
#macro SILVERV_ELO 150
#macro SILVER_MASTER_ELO 200
#macro GOLDI_ELO 250
#macro GOLDII_ELO 300
#macro GOLDIII_ELO 350
#macro GOLDIV_ELO 450
#macro GOLD_MASTER_ELO 500
#macro DIAMONDI_ELO 550
#macro DIAMONDII_ELO 590
#macro DIAMONDIII_ELO 650
#macro DIAMOND_MASTER_ELO 700
#macro ASSAULT_ELITEI_ELO 800
#macro ASSAULT_ELITEII_ELO 850
#macro ASSAULT_MASTER_ELO 950
#macro VERSATILE_MASTER_ELO 1150
#macro EXPERIENCED_VERSATILE_MASTER_ELO 1400
#macro SUPREME_MASTER 1700
#macro GLOBAL_MASTER 1900

function ini_player_struct_create() {
    player_struct = {
        "rating": PLAYER_STARTING_ELO + 1500,
        "rd": PLAYER_STARTING_RD,
        "volatility": PLAYER_STARTING_VOLATILITY,
        "rank": "Silver I"/*global.RankIndex[# get_rank(oPlayer), RankStat.Name]
    };
    return player_struct;
}

function ini_enemy_struct_create(rating, rd, outcome) {
    enemy_struct = {
        "rating": rating,
        "rd": rd,
        "volatility": PLAYER_STARTING_VOLATILITY,
        "rank": "Silver I"/*global.RankIndex[# get_rank(oEnemy), RankStat.Name],
		"outcome": outcome
    };
    return enemy_struct;
}

#region Calculations
function calculate_v(player_mu, player_phi, opponents) {
    var sum = 0;
    for (var i = 0; i < ds_list_size(opponents); ++i) {
        var opp = ds_list_find_value(opponents, i);
        var opp_mu = convert_to_glicko2(opp.rating, opp.rd)[0];
        var opp_phi = convert_to_glicko2(opp.rating, opp.rd)[1];
        var g_phi = calculate_g(opp_phi);
        var e_mu = calculate_e(player_mu, opp_mu, opp_phi);
        sum += (g_phi * g_phi * e_mu * (1 - e_mu));
    }
    return 1 / sum;
}

function calculate_delta(player_mu, player_phi, v, opponents) {
    var sum = 0;
    for (var i = 0; i < ds_list_size(opponents); ++i) {
        var opp = ds_list_find_value(opponents, i);
        var opp_mu = convert_to_glicko2(opp.rating, opp.rd)[0];
        var opp_phi = convert_to_glicko2(opp.rating, opp.rd)[1];
        var g_phi = calculate_g(opp_phi);
        var e_mu = calculate_e(player_mu, opp_mu, opp_phi);
        var outcome = opp.outcome;
        sum += g_phi * (outcome - e_mu);
    }
    return v * sum;
}

function calculate_g(phi) {
    return 1 / sqrt(1 + 3 * phi * phi / pi / pi);
}

function calculate_e(mu, opp_mu, opp_phi) {
    return 1 / (1 + exp(-calculate_g(opp_phi) * (mu - opp_mu)));
}

#endregion

function convert_to_glicko2(rating, rd) {
	var glicko_multiplier = 173.7178;
    var mu = (rating - 1500) / glicko_multiplier;
    var phi = rd / glicko_multiplier;
    return [mu, phi];
}

function update_volatility(a, delta, phi, v, tau) {
    // Constants
    var epsilon = 0.000001;  // Convergence tolerance
    var A = a;
    var B;
    var k;
    
    // Step 1: Set the initial values of the iterative algorithm
    if (delta * delta > phi * phi + v) {
        B = log10(delta * delta - phi * phi - v);
    } else {
        k = 1;
        while (f(a - k * tau, delta, phi, v, a, tau) < 0) {
            k = k + 1;
        }
        B = a - k * tau;
    }
    
    // Step 2: Iteration
    var fA = f(A, delta, phi, v, a, tau);
    var fB = f(B, delta, phi, v, a, tau);
    var C, fC;
    while (abs(B - A) > epsilon) {
        C = A + (A - B) * fA / (fB - fA);
        fC = f(C, delta, phi, v, a, tau);
        if (fC * fB < 0) {
            A = B;
            fA = fB;
        } else {
            fA = fA / 2;
        }
        B = C;
        fB = fC;
    }
    return exp(A / 2);
}

function f(x, delta, phi, v, a, tau) {
    // Function used in the Illinois algorithm
    return exp(x) * (delta * delta - phi * phi - v - exp(x)) / (2 * (phi * phi + v + exp(x))^2) - (x - a) / (tau * tau);
}

function update_phi(phi, sigma) {
    return sqrt(phi * phi + sigma * sigma);
}

function update_rating(player_mu, player_phi, v, delta) {
    var new_phi = 1 / sqrt(1 / (player_phi * player_phi) + 1 / v);
    var new_mu = player_mu + new_phi * new_phi * delta;
    return [new_mu, new_phi];
}

function convert_back(mu, phi) {
    var rating = 173.7178 * mu + 1500;
    var rd = 173.7178 * phi;
    return [rating, rd];
}

function update_player_rating(player, opponent) {
    var player_mu = convert_to_glicko2(player.rating, player.rd)[0];
    var player_phi = convert_to_glicko2(player.rating, player.rd)[1];
    
    var opponents = ds_list_create();
    ds_list_add(opponents, opponent);
    
    // Calculate the new rating
    var v = calculate_v(player_mu, player_phi, opponents);
    var delta = calculate_delta(player_mu, player_phi, v, opponents);
    var new_volatility = update_volatility(player.volatility, delta, player_phi, v, TAU);  // Assuming tau (τ) is defined and known
    var pre_new_phi = update_phi(player_phi, new_volatility); // Pre-update rating deviation based on new volatility
    
    // Update rating and rating deviation based on game results
    var update_results = update_rating(player_mu, pre_new_phi, v, delta);
    var new_mu = update_results[0]; // Updated player rating on Glicko-2 scale
    var new_phi = update_results[1]; // Updated rating deviation on Glicko-2 scale
    
    // Convert updated rating and RD back to original scale
    var conversion_results = convert_back(new_mu, new_phi);
    var new_rating = conversion_results[0]; // Updated player rating on original scale
    var new_rd = conversion_results[1]; // Updated player RD on original scaleo

    // Update player's data
    global.player_elo_struct.rating = new_rating;
    global.player_elo_struct.rd = new_rd;
    global.player_elo_struct.volatility = new_volatility;
}
