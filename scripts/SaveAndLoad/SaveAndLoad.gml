// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function save_game(){
	
	#region Save game
	if(file_exists("save_game.ini")){
		file_delete("save_game.ini");
	}
	ini_open("save_game.ini");
	ini_write_real("Vars", "aberration_level", global.aberration_level);
	ini_write_real("Vars", "saturation_level", global.saturation_level);
	ini_write_real("Vars", "time_speed", global.TimeSpeed);
	ini_write_real("Vars", "godmode", global.GodMode);
	ini_write_real("Vars", "map_id", global.MapID);
	ini_write_real("Vars", "crosshair_alpha", global.CrosshairAlpha);
	ini_write_real("Vars", "dynamic_crosshair", global.DynamicCrosshair);
	ini_write_real("Vars", "player_inaccuracy", global.PlayerInaccuracy);
	ini_write_real("Vars", "enemy_can_move", global.EnemyCanMove);
	ini_write_real("Vars", "draw_bullet_impact", global.DrawBulletImpact);
	ini_write_real("Vars", "camera_crosshair_shake", global.ViewShake);
	ini_write_real("Vars", "admin_hud", global.AdminHUD);
	ini_write_real("Vars", "draw_particles", global.DrawParticles);
	ini_write_real("Vars", "crosshair_color", global.crosshair_color);
	ini_write_real("Vars", "draw_other_models", global.draw_other_models);
	ini_write_real("Vars", "sound_gain", global.sound_gain);
	ini_write_real("Vars", "toggle_bloom_shader", global.BloomShader);
	ini_write_real("Vars", "enemy_visibility", global.enemy_visibility);
	ini_write_real("Vars", "gui_scale", global.GUIMultiplier);
	ini_write_real("Vars", "window_width", global.window_width);
	ini_write_real("Vars", "window_height", global.window_height);
	ini_write_real("Vars", "windowed", window_get_fullscreen());
	ini_write_real("Vars", "clear_particles_timer", global.clear_particles_timer);
	
	for (var i = 0; i < array_length(global.map_rounds); i++) {
	    for (var j = 0; j < array_length(global.map_rounds[i]); j++) {
	        var key = "map_rounds_" + string(i) + "_" + string(j);
	        ini_write_real("Map_rounds", key, global.map_rounds[i][j]);
	    }
	}
	ini_close();
	#endregion
	
	#region Save keyboard input
	if(file_exists("save_keyboard_input.ini")){
		file_delete("save_keyboard_input.ini");	
	}
	ini_open("save_keyboard_input.ini");
	ini_write_real("keyboard_inputs", "ds_list_key_binds_size", ds_list_size(global.KeyBinds));
	for (var i = 0; i < ds_list_size(global.KeyBinds); i++){
		ini_write_string("keyboard_inputs", "ds_list_key_bind_" + string(i), string(global.KeyBinds[| i]));
	}	
	ini_close();
	#endregion
	
	#region Save inventory
	if(file_exists("save_inventory,ini")){
		file_delete("save_inventory.ini");
	}
	ini_open("save_inventory.ini");
	ini_write_string("Inventory", "0", ds_grid_write(global.Inventory));
	ini_write_string("Inventory", "2", ds_grid_write(global.MouseSlot));
	ini_close();
	#endregion
	
	#region Save player ep stats
	if(file_exists("player_rating_stats.json")){
		file_delete("player_rating_stats.json");
	}
	var json_string = json_stringify(global.rating_struct);
	var file = file_text_open_write("player_rating_stats.json");
	file_text_write_string(file, json_string);
	file_text_close(file);
	#endregion
	
	#region Save player stats
	if(file_exists("player_stats.json")){
		file_delete("player_stats.json");
	}
	json_string = json_stringify(global.player_stats_struct);
	file = file_text_open_write("player_stats.json");
	file_text_write_string(file, json_string);
	file_text_close(file);
	#endregion
}

function load_game(){
	
	#region Load game
	if(file_exists("save_game.ini")){
		ini_open("save_game.ini");
		global.aberration_level = ini_read_real("Vars", "aberration_level", global.aberration_level);
		global.saturation_level = ini_read_real("Vars", "saturation_level", global.saturation_level);
		global.TimeSpeed = ini_read_real("Vars", "time_speed", global.TimeSpeed);
		global.GodMode = ini_read_real("Vars", "godmode", global.GodMode);
		global.MapID = ini_read_real("Vars", "map_id", global.MapID);	
		global.CrosshairAlpha = ini_read_real("Vars", "crosshair_alpha", global.CrosshairAlpha);
		global.DynamicCrosshair = ini_read_real("Vars", "dynamic_crosshair", global.DynamicCrosshair);
		global.PlayerInaccuracy = ini_read_real("Vars", "player_inaccuracy", global.PlayerInaccuracy);
		global.EnemyCanMove = ini_read_real("Vars", "enemy_can_move", global.EnemyCanMove);
		global.DrawBulletImpact = ini_read_real("Vars", "draw_bullet_impact", global.DrawBulletImpact);
		global.ViewShake = ini_read_real("Vars", "camera_crosshair_shake", global.ViewShake);
		global.AdminHUD = ini_read_real("Vars", "admin_hud", global.AdminHUD);
		global.DrawParticles = ini_read_real("Vars", "draw_particles", global.DrawParticles);
		global.crosshair_color = ini_read_real("Vars", "crosshair_color", global.crosshair_color);
		global.draw_other_models = ini_read_real("Vars", "draw_other_models", global.draw_other_models);
		global.sound_gain = ini_read_real("Vars", "sound_gain", global.sound_gain);
		global.BloomShader = ini_read_real("Vars", "toggle_bloom_shader", global.BloomShader);
		global.enemy_visibility = ini_read_real("Vars", "enemy_visibility", global.enemy_visibility);
		global.GUIMultiplier = ini_read_real("Vars", "gui_scale", global.GUIMultiplier);
		global.window_width = ini_read_real("Vars", "window_width", global.window_width);
		global.window_height = ini_read_real("Vars", "window_height", global.window_height);
		global.clear_particles_timer = ini_read_real("Vars", "clear_particles_timer", global.clear_particles_timer);
		window_set_fullscreen(ini_read_real("Vars", "windowed", true));
		
		//if(window_get_fullscreen() == false){	
		//}
		
		global.map_rounds = array_create(MapIndex.Total);
		for (var i = 0; i < MapIndex.Total; i++) {
		    global.map_rounds[i] = array_create(3);
		    for (var j = 0; j < 3; j++) {
		        var key = "map_rounds_" + string(i) + "_" + string(j);
		        global.map_rounds[i][j] = ini_read_real("Map_rounds", key, -1);
		    }
		}
		ini_close();
	}
	
	#endregion
	
	#region Load keyboard input
	if(file_exists("save_keyboard_input.ini")){
		ini_open("save_keyboard_input.ini");
		ds_list_clear(global.KeyBinds);
		var list_size = ini_read_real("keyboard_inputs", "ds_list_key_binds_size", 0);
		for (var i = 0; i < list_size; i++){
		    var item_value = ini_read_string("keyboard_inputs", "ds_list_key_bind_" + string(i), "");
		    ds_list_add(global.KeyBinds, item_value);
		}		
		ini_close();
	}
	#endregion
	
	#region Load inventory
	if(file_exists("save_inventory.ini")){
	    ini_open("save_inventory.ini");
	    ds_grid_read(global.Inventory, ini_read_string("Inventory", "0", "None"));
	    ds_grid_read(global.MouseSlot, ini_read_string("Inventory", "2", "None"));
	    ini_close();	
	}
	#endregion
	
	#region Load player ep stats
	if (file_exists("player_rating_stats.json")) {
	    var file = file_text_open_read("player_rating_stats.json");
	    var json_string = file_text_read_string(file);
	    file_text_close(file);
	    global.rating_struct = json_parse(json_string);
	}
	#endregion
	
	#region Load player stats
	if (file_exists("player_stats.json")) {
	    var file = file_text_open_read("player_stats.json");
	    var json_string = file_text_read_string(file);
	    file_text_close(file);
	    global.player_stats_struct = json_parse(json_string);
		
	    global.player_stats_struct.Get_KD = function() {
	        return (global.player_stats_struct.Deaths != 0) ? (global.player_stats_struct.Kills / global.player_stats_struct.Deaths) : 0;
	    }
		global.player_stats_struct.Get_headshot_percentage = function() {
			return (global.player_stats_struct.Kills != 0) ? (global.player_stats_struct.Headshots / global.player_stats_struct.Kills) * 100 : 0;
		}
		global.player_stats_struct.Get_accuracy = function() {
			return (global.player_stats_struct.All_shots != 0) ? global.player_stats_struct.Hit_shots / global.player_stats_struct.All_shots * 100 : 0;
		}
	}
	#endregion
	
}