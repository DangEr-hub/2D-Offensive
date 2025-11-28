/// @func server_add_player_kill(attacker_pid, reward, is_headshot, victim_is_bot)
/// @desc Uloží na SERVERU kill, money a headshoty pro daného hráče.
///       attacker_pid = PID hráče (network_id)
///       reward      = kolik dostane money
///       is_headshot = true/false
///       victim_is_bot = true/false (když chceš rozlišovat pro summary)
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