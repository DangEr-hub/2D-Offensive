/* Room start - oNetworkManager */
if (layer_get_id("LivingO") == -1) exit;

last_item_use_id = -1;
item_use_resync_timer = 0;

if (is_server) {
	create_local_player(my_pid);
	if (instance_exists(global.local_player)) {
		var host_team = global.local_player.stats.Team;
		var enemy_team = host_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE;
		team_round_wins[host_team] = global.game_struct.Rounds_win;
		team_round_wins[enemy_team] = global.game_struct.Rounds_lost;
	}
	send_weather_broadcast();
	free_item_ids = ds_stack_create();
	for (var i = 511; i >= 0; i--) {
		ds_stack_push(free_item_ids, i);
	}
	free_bird_ids = ds_stack_create();
	for (var i = 63; i >= 0; i--) {
		ds_stack_push(free_bird_ids, i);
	}
	free_grenade_ids = ds_stack_create();
	for (var i = 511; i >= 0; i--) {
		ds_stack_push(free_grenade_ids, i);
	}
	free_airplane_ids = ds_stack_create();
	for (var i = 255; i >= 0; i--) {
		ds_stack_push(free_airplane_ids, i);
	}
} else if (is_connected == true) {
	create_local_player(my_pid);
	with (global.local_player) {
		equip_network_propagate();
		weapon_network_propagate();
	}
	with (oItems) { instance_destroy(); } ///Smaz vsechny itemy, resi se pres server
	send_request_init(); // Pozadej server o dulezite veci (itemy, hraci a jejich zbrane, armoury...)
}
