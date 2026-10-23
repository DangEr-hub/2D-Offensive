event_inherited();
if (chosen_team == TEAM.NONE || !instance_exists(global.local_player)) exit;

if (global.local_player.stats.Team == chosen_team) {
	if (IS_NET && oNetworkManager.round_resolved && instance_exists(oGameController)) {
		oGameController.player_win = oNetworkManager.last_round_winner == chosen_team;
	}
	global.local_player.player_can_shoot = global.local_player.stats.Health_points > 0;
	global.local_player.visible = global.local_player.stats.Health_points > 0;
	oDraw.spectating = false;
	oDraw.spectate_target = noone;
	if (return_to_respawn) oDraw.team_menu_return_respawn = true;
	with (objUIBlack) zui_destroy();
	zui_destroy();
	exit;
}

if (IS_NET && !oNetworkManager.is_server) {
	request_timer++;
	if (request_timer >= 30) {
		request_timer = 0;
		send_team_select_client(chosen_team);
	}
}
