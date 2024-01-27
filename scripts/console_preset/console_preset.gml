/// @description  console_preset(console)
function console_preset(argument0) {
	var r = (global.crosshair_color >> 16) & 0xFF;
	var g = (global.crosshair_color >> 8) & 0xFF;
	var b = global.crosshair_color & 0xFF;
	var c=argument0, Windowed;
	if(!window_get_fullscreen()){ Windowed = false;}else{Windowed = true;}
	console_add(c,"op_game_restart");
	console_add(c,"op_game_end");
	console_add(c, "set_dynamic_crosshair " + string(global.DynamicCrosshair));
	console_add(c, "set_crosshair_alpha " + string(global.CrosshairAlpha));
	console_add(c, "give_id");
	console_add(c, "draw_bullet_impact " + string(global.DrawBulletImpact));
	console_add(c, "draw_admin_hud " + string(global.AdminHUD));
	console_add(c, "set_hitbox_alpha " + string(global.HitBoxAlpha));
	console_add(c,"op_room_restart");
	console_add(c, "op_godmode " + string(global.GodMode));
	console_add(c, "set_window_fullscreen " + string(Windowed));
	console_add(c, "hostage " + string(global.Hostage));
	console_add(c, "enemy_can_move " + string(global.EnemyCanMove));
	console_add(c, "set_console_height " + string(global.ConsoleHeight));
	console_add(c, "set_console_width " + string(global.ConsoleWidth));
	console_add(c, "set_gui_scale " + string(global.GUIMultiplier));
	console_add(c, "set_fov_angle " + string(global.FieldOfView));
	console_add(c, "toggle_bloom_shader " + string(global.BloomShader));
	console_add(c, "set_time_speed " + string(global.TimeSpeed));
	console_add(c, "set_time ");
	console_add(c, "set_camera_crosshair_shake " + string(global.ViewShake));
	console_add(c, "set_player_inaccuracy " + string(global.PlayerInaccuracy));
	console_add(c, "clear_particles");
	console_add(c, "draw_particles " + string(global.DrawParticles));
	console_add(c, "set_weather");
	console_add(c, "set_crosshair_color " + string(r) + string(g) + string(b));
	console_add(c, "draw_other_models " + string(global.draw_other_models));
	console_add(c, "set_window_size " + string(global.window_width) + " " + string(global.window_height));
	console_add(c, "set_player_eggy_points " + string(convert_back(global.player_elo_struct.Elo)));
	console_add(c, "set_enemy_visibility " + string(global.enemy_visibility));
	console_add(c, "set_enemy_eggy_points " + string(convert_back(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])));
	c[? "preset"] = true;





}
