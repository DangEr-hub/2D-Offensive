/// @description  console_preset(console)
function console_preset(argument0) {
	var r = (global.crosshair_color >> 16) & 0xFF;
	var g = (global.crosshair_color >> 8) & 0xFF;
	var b = global.crosshair_color & 0xFF;
	var c=argument0, Windowed;
	if(!window_get_fullscreen()){ Windowed = false;}else{Windowed = true;}
	console_add(c,"op_game_restart");
	console_add(c,"op_game_end");
	console_add(c, "set_dynamic_crosshair {0,1} " + string(global.DynamicCrosshair));
	console_add(c, "set_crosshair_alpha <0;1> " + string(global.CrosshairAlpha));
	console_add(c, "give_id");
	console_add(c, "draw_bullet_impact {0,1} " + string(global.DrawBulletImpact));
	console_add(c, "draw_advanced_hud {0,1} " + string(global.draw_advanced_hud));
	console_add(c, "set_hitbox_alpha <0;1> " + string(global.HitBoxAlpha));
	console_add(c,"op_room_restart");
	console_add(c, "op_godmode {0,1} " + string(global.GodMode));
	console_add(c, "set_window_fullscreen {0,1} " + string(Windowed));
	console_add(c, "hostage " + string(global.Hostage));
	console_add(c, "enemy_can_move {0,1} " + string(global.EnemyCanMove));
	console_add(c, "set_console_height " + string(global.ConsoleHeight));
	console_add(c, "set_console_width " + string(global.ConsoleWidth));
	console_add(c, "set_gui_scale <1;2> " + string(global.GUIMultiplier));
	console_add(c, "set_fov_angle <0;360> " + string(global.FieldOfView));
	console_add(c, "toggle_bloom_shader {0,1} " + string(global.BloomShader));
	console_add(c, "set_time_speed " + string(global.TimeSpeed));
	console_add(c, "set_time ");
	console_add(c, "set_buy_time ");
	console_add(c, "toggle_camera_crosshair_shake {0,1} " + string(global.ViewShake));
	console_add(c, "set_player_inaccuracy " + string(global.PlayerInaccuracy));
	console_add(c, "clear_particles {0,1} ");
	console_add(c, "draw_particles {0,1} " + string(global.DrawParticles));
	console_add(c, "set_weather {0,1,2} ");
	console_add(c, "set_crosshair_color " + string(r) + string(g) + string(b));
	console_add(c, "draw_other_models {0,1} " + string(global.draw_other_models));
	console_add(c, "draw_damage {0,1} " + string(global.draw_damage));
	console_add(c, "set_window_size " + string(global.window_width) + " " + string(global.window_height));
	console_add(c, "set_player_eggy_points (ES) " + string(global.rating_struct.Player_ep));
	console_add(c, "set_enemy_visibility {0,1} " + string(global.enemy_visibility));
	console_add(c, "set_enemy_eggy_points " + string(convert_back(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
	console_add(c, "set_player_played_games " + string(global.rating_struct.Played_games));
	console_add(c, "set_saturation_level " + string(global.saturation_level));
	console_add(c, "set_chromatic_aberration_level " + string(global.aberration_level));
	console_add(c, "set_clear_particles_timer " + string(global.clear_particles_timer));
	console_add(c, "set_player_money " + string(global.player_stats_struct.Money));
	console_add(c, "get_latency ");
	console_add(c, "unlock_all_items {0,1} ");
	console_add(c, "set_crosshair_scale " + string(global.crosshair_scale));
	c[? "preset"] = true;





}
