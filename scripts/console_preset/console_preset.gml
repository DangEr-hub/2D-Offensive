/// @description  console_preset(console)
function console_preset(argument0) {
	var r = (global.crosshair_color >> 16) & 0xFF;
	var g = (global.crosshair_color >> 8) & 0xFF;
	var b = global.crosshair_color & 0xFF;
	var c=argument0, Windowed;
	var cheat = " (sv_cheats)";
	if(!window_get_fullscreen()){ Windowed = false;}else{Windowed = true;}
	console_add(c, "sv_cheats {0,1} " + string(global.sv_cheats));
	console_add(c,"op_game_restart" + cheat);
	console_add(c,"op_game_end");
	console_add(c, "set_dynamic_crosshair {0,1} " + string(global.DynamicCrosshair));
	console_add(c, "set_crosshair_alpha <0;1> " + string(global.CrosshairAlpha));
	console_add(c, "give_id <item_id>" + cheat);
	console_add(c, "draw_bullet_impact {0,1} " + string(global.DrawBulletImpact) + cheat);
	console_add(c, "draw_advanced_hud {0,1} " + string(global.draw_advanced_hud) + cheat);
	console_add(c, "set_hitbox_alpha <0;1> " + string(global.HitBoxAlpha) + cheat);
	console_add(c,"op_room_restart" + cheat);
	console_add(c, "change_team {0,1} (restart) " + string(global.player_stats.Player_team) + cheat);
	console_add(c, "op_godmode {0,1} " + string(global.GodMode) + cheat);
	console_add(c, "set_window_fullscreen {0,1} " + string(Windowed));
	console_add(c, "hostage " + string(global.Hostage) + cheat);
	console_add(c, "enemy_can_move {0,1} " + string(global.EnemyCanMove) + cheat);
	console_add(c, "set_console_height " + string(global.ConsoleHeight));
	console_add(c, "set_console_width " + string(global.ConsoleWidth));
	console_add(c, "set_gui_scale <1;2> " + string(global.GUIMultiplier));
	console_add(c, "set_fov_angle <0;360> " + string(global.FieldOfView) + cheat);
	console_add(c, "toggle_bloom_shader {0,1} " + string(global.BloomShader));
	console_add(c, "set_time_speed " + string(global.TimeSpeed) + cheat);
	console_add(c, "set_time <minutes>" + cheat);
	console_add(c, "set_buy_time <seconds>" + cheat);
	console_add(c, "toggle_camera_crosshair_shake {0,1} " + string(global.ViewShake) + cheat);
	console_add(c, "set_player_inaccuracy " + string(global.PlayerInaccuracy) + cheat);
	console_add(c, "clear_particles {0,1} ");
	console_add(c, "draw_particles {0,1} " + string(global.DrawParticles));
	console_add(c, "set_weather {0,1,2}" + cheat);
	console_add(c, "set_crosshair_color " + string(r) + string(g) + string(b));
	console_add(c, "draw_other_models {0,1} " + string(global.draw_other_models) + cheat);
	console_add(c, "draw_damage {0,1} " + string(global.draw_damage) + cheat);
	console_add(c, "set_window_size " + string(global.window_width) + " " + string(global.window_height));
	console_add(c, "set_player_eggy_points (ES) " + string(global.game_struct.Player_ep) + cheat);
	console_add(c, "set_enemy_visibility {0,1} " + string(global.enemy_visibility) + cheat);
	console_add(c, "set_enemy_eggy_points " + string(convert_back(global.game_struct.Enemy_ep[global.game_struct.Current_game])) + cheat);
	console_add(c, "set_player_played_games " + string(global.game_struct.Played_games) + cheat);
	console_add(c, "set_saturation_level " + string(global.saturation_level));
	console_add(c, "set_chromatic_aberration_level " + string(global.aberration_level));
	console_add(c, "set_clear_particles_timer " + string(global.clear_particles_timer));
	console_add(c, "set_player_money " + string(global.player_stats.Money) + cheat);
	console_add(c, "get_latency");
	console_add(c, "unlock_all_items {0,1}" + cheat);
	console_add(c, "set_crosshair_scale " + string(global.crosshair_scale));
	console_add(c, "draw_hud {0,1} " + string(global.draw_hud));
	c[? "preset"] = true;





}
