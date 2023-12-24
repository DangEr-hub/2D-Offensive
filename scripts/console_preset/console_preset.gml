/// @description  console_preset(console)
/// @param console
function console_preset(argument0) {
	var r = (global.CrosshairColor >> 16) & 0xFF;
	var g = (global.CrosshairColor >> 8) & 0xFF;
	var b = global.CrosshairColor & 0xFF;
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
	console_add(c, "window_set_fullscreen " + string(Windowed));
	console_add(c, "hostage " + string(global.Hostage));
	console_add(c, "rank_modifier " + string(global.RankMultiplier));
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
/*	console_add(c,"window_set_fullscreen " + string(Windowed));
	console_add(c,"draw_bullet_impact " + string(global.ShowBulletImpact));
	console_add(c,"net_graph " + string(global.AdminHUD));
	console_add(c,"no_recoil " + string(global.NoRecoil));
	console_add(c,"no_view_shake " + string(global.NoViewShake));
	console_add(c,"infinite_ammo " + string(global.InfiniteAmmo));
	console_add(c,"god " + string(global.God));
	console_add(c,"no_inaccuracy " + string(global.NoInaccuracy));
	console_add(c,"no_aimpunch " + string(global.NoAimPunch));
	console_add(c,"enemy_canmove " + string(global.EnemyCanMove));
	console_add(c,"draw_damage " + string(global.ShowDamage));
	console_add(c,"blackness_value " + string(global.Blackness_Value));
	console_add(c,"r_drawparticles " + string(global.DrawParticles));
	console_add(c,"r_drawtracers " + string(global.DrawTracers));
	console_add(c,"net_graph_position_x " + string(global.AdminHUDPositionX));
	console_add(c,"net_graph_position_y " + string(global.AdminHUDPositionY));
	console_add(c,"no_sway " + string(global.NoGunSway));
	console_add(c,"dynamic_crosshair " + string(global.DynamicCrosshair));
	console_add(c,"bullet_impact_type"+ " (0, 1) " + string(global.BulletImpactType));
	console_add(c,"airplane_chance " + string(global.AirPlaneChance) + "(" + string_format(global.AirPlaneChance*10, 0, 1) + "%)");
	console_add(c,"draw_headhitbox " + string(global.DrawHeadHitBox));
	console_add(c,"draw_ui " + string(global.DrawUI));
	console_add(c,"one_taps_sound " + string(global.OneTaps));
	console_add(c,"rain " + string(global.Rain));
	console_add(c,"snow " + string(global.Snow));
	console_add(c,"hp " + string(global.HP));
	console_add(c,"timer " + string(global.Timer));
	console_add(c,"buy_time " + string(global.BuyTimer));
	console_add(c,"money " + string(global.Money));
	console_add(c,"bullet_time " + string(global.SlowMotion));
	console_add(c, "gems " + string(global.Gems));
	console_add(c, "gun_declare");
	console_add(c,"enemy_canshoot " + string(global.EnemyCanShoot));
	console_add(c, "unlock_all_weapons");
	console_add(c, "skill_points " + string(global.SkillPoints));
	console_add(c, "r_drawblood " + string(global.DrawBlood));
	console_add(c, "player_solid_collision " + string(global.PlayerSolid));
	console_add(c, "draw_bloom_shader " + string(global.DrawBloom));
	console_add(c, "crosshair_alpha " + string(global.CrosshairAlpha));
	console_add(c, "crosshair_color " + string(global.CrosshairColor));
	console_add(c, "crosshair_scale " + string(global.CrosshairSize));
	console_add(c, "elo " + string(global.Elo));
	console_add(c, "player_min_speed " + string(global.MinSpeed*60));
	console_add(c, "player_max_speed " + string(global.MaxSpeed*60));
	console_add(c, "complex_recoil " + string(global.ComplexRecoil));
	console_add(c, "draw_bodyhitbox " + string(global.DrawBodyHitBox));
	console_add(c, "draw_solid_collision " + string(global.DrawSolidCollision));
	console_add(c, "temperature " + string(global.Temperature));
	console_add(c, "temperature_min" + string(global.TemperatureMin));
	console_add(c, "temperature_max" + string(global.TemperatureMax));
	console_add(c, "spawn_terrorist");
	console_add(c, "spawn_obstacle");
	console_add(c, "developer_mode");
	console_add(c, "enemy_unlimited_hp " + string(global.EnemyUnlimitedHP));
	console_add(c, "competetive_games " + string(global.CompetetiveGames));
	console_add(c, "max_hp " + string(global.MaxHP));
	console_add(c, "draw_gun_inaccuracy " + string(global.DrawGunInaccuracy));

*/
	c[? "preset"] = true;





}
