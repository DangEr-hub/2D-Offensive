/// @func server_add_player_kill(attacker_pid, reward, is_headshot, victim_is_bot)
/// @desc Uloží na SERVERU kill, money a headshoty pro daného hráče.
///       attacker_pid = PID hráče (network_id)
///       reward      = kolik dostane money
///       is_headshot = true/false
///       victim_is_bot = true/false (když chceš rozlišovat pro summary)
/*
function server_add_player_kill(attacker_pid, reward, is_headshot, victim_is_bot) {
    if (!IS_NET) return;

    with (oNetworkManager) {

        var stats = -1;
        if (ds_map_exists(player_stats_server, attacker_pid)) {
            stats = ds_map_find_value(player_stats_server, attacker_pid);
        } else {
            stats = ds_map_create();
            ds_map_add(stats, "Money",      0);
            ds_map_add(stats, "Kills",      0);
            ds_map_add(stats, "Headshots",  0);
            ds_map_add(stats, "BotsKilled", 0);
            ds_map_add(stats, "PlayersKilled", 0);
            ds_map_add(player_stats_server, attacker_pid, stats);
        }

        // Money
        ds_map_set(stats, "Money", ds_map_find_value(stats, "Money") + reward);

        // Kills
        ds_map_set(stats, "Kills", ds_map_find_value(stats, "Kills") + 1);

        // Headshot
        if (is_headshot) {
            ds_map_set(stats, "Headshots", ds_map_find_value(stats, "Headshots") + 1);
        }

        // Bot vs player kill
        var key_kill_type = victim_is_bot ? "BotsKilled" : "PlayersKilled";
        ds_map_set(stats, key_kill_type, ds_map_find_value(stats, key_kill_type) + 1);

        // Pokud je to zrovna hostův hráč, zrcadli do lokálních statistik
        if (attacker_pid == my_pid) {
            global.player_stats_struct.Money += reward;
            if (global.ranked_game) {
                global.player_stats_struct.Kills++;
                oRatingController.kills++;
                if (is_headshot) {
                    oRatingController.headshots++;
                }
            }
        }
    }
}

/// @description  collision_line_point(x1, y1, x2, y2, obj, prec, notme)
/// @param x1
/// @param  y1
/// @param  x2
/// @param  y2
/// @param  obj
/// @param  prec
/// @param  notme
function collision_line_point(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	var x1 = argument0;
	var y1 = argument1;
	var x2 = argument2;
	var y2 = argument3;
	var qi = argument4;
	var qp = argument5;
	var qn = argument6;
	var rr, rx, ry;
	rr = collision_line(x1, y1, x2, y2, qi, qp, qn);
	rx = x2;
	ry = y2;
	if (rr != noone) {
	    var p0 = 0;
	    var p1 = 1;
	    repeat (round(log2(point_distance(x1, y1, x2, y2))) + 1) {
	        var np = p0 + (p1 - p0) * 0.5;
	        var nx = x1 + (x2 - x1) * np;
	        var ny = y1 + (y2 - y1) * np;
	        var px = x1 + (x2 - x1) * p0;
	        var py = y1 + (y2 - y1) * p0;
	        var nr = collision_line(px, py, nx, ny, qi, qp, qn);
	        if (nr != noone) {
	            rr = nr;
	            rx = nx;
	            ry = ny;
	            p1 = np;
	        } else p0 = np;
	    }
	}
	var r;
	r[0] = rr;
	r[1] = rx;
	r[2] = ry;
	return r;



}
