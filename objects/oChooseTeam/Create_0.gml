event_inherited();
zui_set_size(400 * global.gui_scale, 210 * global.gui_scale);
chosen_team = TEAM.NONE;
request_timer = 0;
return_to_respawn = instance_exists(oDraw) && oDraw.RespawnMenu;

close_team_menu = function() {
	if (chosen_team != TEAM.NONE) return;
	if (instance_exists(oDraw)) {
		oDraw.team_menu_dismissed = true;
		if (return_to_respawn && instance_exists(global.local_player)
		&& global.local_player.stats.Team != TEAM.NONE) oDraw.team_menu_return_respawn = true;
		if (instance_exists(global.local_player) && global.local_player.stats.Team == TEAM.NONE) {
			oDraw.RespawnMenu = false;
			oDraw.GameEndMenu = false;
			global.local_player.visible = false;
			oDraw.spectating = true;
			oDraw.spectate_target = noone;
			with (oBot) {
				if (oDraw.spectate_target == noone && stats.Team != TEAM.NONE && stats.Health_points > 0) oDraw.spectate_target = id;
			}
			if (!instance_exists(oDraw.spectate_target)) {
				with (oPlayer) {
					if (!is_local && oDraw.spectate_target == noone && stats.Health_points > 0) oDraw.spectate_target = id;
				}
			}
			with (zui_main()) {
				oDraw.team_menu_button = zui_create(zui_get_width() * .5, zui_get_height() * .82, objUIButton, -999);
			}
			with (oDraw.team_menu_button) {
				zui_set_anchor(.5, 0);
				zui_set_size(160 * global.gui_scale, 28 * global.gui_scale);
				caption = "Choose team";
				callback = function() {
					open_choose_team_menu();
					var menu_button_id = oDraw.team_menu_button;
					oDraw.team_menu_button = noone;
					with (menu_button_id) zui_destroy();
				};
			}
		}
	}
	with (objUIBlack) zui_destroy();
	zui_destroy();
};

select_team = function(selected_team) {
	if (chosen_team != TEAM.NONE || !instance_exists(global.local_player)) return;
	chosen_team = selected_team;
	if (IS_NET) {
		if (oNetworkManager.is_server) {
			server_set_player_team(oNetworkManager.my_pid, selected_team);
		} else {
			send_team_select_client(selected_team);
		}
	} else {
		var previous_team = global.local_player.stats.Team;
		global.player_stats.Player_team = selected_team;
		global.local_player.stats.Team = selected_team;
		if (previous_team != TEAM.NONE && previous_team != selected_team) {
			var previous_wins = global.game_struct.Rounds_win;
			global.game_struct.Rounds_win = global.game_struct.Rounds_lost;
			global.game_struct.Rounds_lost = previous_wins;
		}
		if (room == rm_Desert && previous_team == TEAM.NONE) {
			with (oBot) {
				stats.Team = stats.Team == TEAM.NONE ? selected_team
					: (selected_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE);
				sprite_index = get_player_team_sprite(stats.Team);
				has_defuse_kit = stats.Team == TEAM.POLICE && has_defuse_kit;
			}
		}
		initialize_bot_database(global.MapID);
		if (selected_team == TEAM.POLICE && instance_exists(oGameController) && !instance_exists(oBomb)) {
			global.bomb_time = 500 * game_get_speed(gamespeed_fps);
			var bomb_areas = global.MapProperties[# global.MapID, MAP_STAT.BombAreas];
			var area_keys = ds_map_keys_to_array(bomb_areas);
			if (array_length(area_keys) > 0) {
				var area = bomb_areas[? area_keys[irandom(array_length(area_keys) - 1)]];
				var bomb = instance_create_layer(random_range(area[0], area[2]), random_range(area[1], area[3]), "ItemsO", oBomb);
				bomb.image_angle = irandom(359);
			}
		}
		save_game();
	}
};

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Choose team";
	draggable = 1;
}

draw_set_font(set_font("GUI_small"));

button_width = 136 * global.gui_scale;
button_height = 32 * global.gui_scale;
var button_gap = 16 * global.gui_scale;
var button_left = (zui_get_width() - button_width - button_gap) * .5;
var button_y = 80 * global.gui_scale;

with (zui_create(button_left, button_y, objUIButton)) {
	zui_set_size(oChooseTeam.button_width, oChooseTeam.button_height);
	caption = "Police";
	callback = function() { with (oChooseTeam) select_team(TEAM.POLICE); };
}
with (zui_create(button_left + button_width + button_gap, button_y, objUIButton)) {
	zui_set_size(oChooseTeam.button_width, oChooseTeam.button_height);
	caption = "Terrorists";
	callback = function() { with (oChooseTeam) select_team(TEAM.TERRORIST); };
}

with (zui_create(zui_get_width() * .5, button_y + button_height + 30 * global.gui_scale, objUIButton)) {
	zui_set_anchor(.5, 0);
	zui_set_size(oChooseTeam.button_width, oChooseTeam.button_height);
	caption = "Exit";
	callback = function() { with (oChooseTeam) close_team_menu(); };
}
