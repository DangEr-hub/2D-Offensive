// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function struct_merge_data(current_struct, saved_struct) {
    if (saved_struct == undefined) return current_struct;
    
    var keys = variable_struct_get_names(saved_struct);
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        if (variable_struct_exists(current_struct, key)) {
            current_struct[$ key] = saved_struct[$ key];
        }
    }
    return current_struct;
}

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
	ini_write_real("Vars", "admin_hud", global.draw_advanced_hud);
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
	ini_write_real("Vars", "anti_aliasing", global.anti_aliasing);
	ini_write_real("Vars", "crosshair_scale", global.crosshair_scale);
	ini_write_real("Vars", "sv_cheats", global.sv_cheats);
	ini_write_string("Network", "server_ip", global.saved_server_ip);
	
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
	ini_write_string("Inventory", "Inventory", ds_grid_write(global.Inventory));
	ini_write_string("Inventory", "Mouse", ds_grid_write(global.MouseSlot));
	ini_write_string("Inventory", "UnlockedItems", ds_list_write(global.unlocked_items));
	ini_close();
	#endregion
	
	#region Save player ep stats
	if(file_exists("rating.json")){
		file_delete("rating.json");
	}
	var json_string = json_stringify(global.game_struct);
	var file = file_text_open_write("rating.json");
	file_text_write_string(file, json_string);
	file_text_close(file);
	#endregion
	
	#region Save upgrades
	if(file_exists("upgrades.json")){
		file_delete("upgrades.json");
	}
	json_string = json_stringify(global.built_upgrades);
	file = file_text_open_write("upgrades.json");
	file_text_write_string(file, json_string);
	file_text_close(file);
	#endregion
	
	#region Save player stats
	if(file_exists("player_stats.json")){
		file_delete("player_stats.json");
	}
	json_string = json_stringify(global.player_stats);
	file = file_text_open_write("player_stats.json");
	file_text_write_string(file, json_string);
	file_text_close(file);
	#endregion
}

function load_game(){
	

	global.draw_damage = true;
	global.aberration_level = 0;
	global.saturation_level = 1.8;
	global.TimeSpeed = 15;
	global.GodMode = 0;
	global.MapID = MAP.Desert;
	global.CrosshairAlpha = 1;
	global.DynamicCrosshair = 0;
	global.PlayerInaccuracy = 1;
	global.EnemyCanMove = 1;
	global.DrawBulletImpact = 0;
	global.ViewShake = 1;
	global.draw_advanced_hud = 0;
	global.crosshair_scale = 1;
	global.DrawParticles = 1;
	global.crosshair_color = c_white;
	global.draw_other_models = 0;
	global.sound_gain = 100;
	global.BloomShader = 1;
	global.enemy_visibility = 0;
	global.GUIMultiplier = 2;
	global.window_width = 1920;
	global.window_height = 1080;
	global.anti_aliasing = 0;
	global.draw_hud = true;
	global.sv_cheats = false;
	global.saved_server_ip = "127.0.0.1";
	global.clear_particles_timer = 10 * game_get_speed(gamespeed_fps);
	
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
		global.draw_advanced_hud = ini_read_real("Vars", "admin_hud", global.draw_advanced_hud);
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
		global.anti_aliasing = ini_read_real("Vars", "anti_aliasing", global.anti_aliasing);
		global.crosshair_color = ini_read_real("Vars", "crosshair_scale", global.crosshair_scale);
		global.sv_cheats = ini_read_real("Vars", "sv_cheats", global.sv_cheats);
		global.saved_server_ip = ini_read_string("Network", "server_ip", global.saved_server_ip);
		window_set_fullscreen(ini_read_real("Vars", "windowed", true));
		
		global.map_rounds = array_create(MAP.Total);
		for (var i = 0; i < MAP.Total; i++) {
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
		while(ds_list_size(global.KeyBinds) < KEY.Total){
			var missing_index = ds_list_size(global.KeyBinds);
			ds_list_add(global.KeyBinds, global.DefaultKeyBinds[| missing_index]);
		}
		ini_close();
	}
	#endregion
	
	#region Load inventory
	if(file_exists("save_inventory.ini")){
	    ini_open("save_inventory.ini");
	    ds_grid_read(global.Inventory, ini_read_string("Inventory", "Inventory", Item.None));
	    ds_grid_read(global.MouseSlot, ini_read_string("Inventory", "Mouse", Item.None));
		var unlocked = ds_list_create();
		ds_list_read(unlocked, ini_read_string("Inventory", "UnlockedItems", Item.None));

		for(var i = 0; i < ds_list_size(unlocked); i++){
			var item_id = unlocked[| i];
			global.ItemIndex[# item_id, ItemStat.is_locked] = false;
		}

		ds_list_destroy(unlocked);
	    ini_close();	
	}
	#endregion
	
	#region Load player ep stats
	if (file_exists("rating.json")) {
	    var file = file_text_open_read("rating.json");
	    var json_string = file_text_read_string(file);
	    file_text_close(file);
	    global.game_struct = json_parse(json_string);
		set_current_enemy();
	}
	#endregion
	
	#region Load upgrades
	if (file_exists("upgrades.json")) {
	    var file = file_text_open_read("upgrades.json");
	    var json_string = file_text_read_string(file);
	    file_text_close(file);
	    global.built_upgrades = json_parse(json_string);
		for (var i = 0; i < Item.Total; i++) {
		        if (global.ItemIndex[# i, ItemStat.Type] == "Weapon") {
		            var upgs = global.built_upgrades[$ string(i)];
		            if (upgs == undefined) continue;
            
		            // Aplikujeme upgrady pouze pokud jsou ve structu nastaveny na true
		            if (upgs.ammo)        global.ItemIndex[# i, ItemStat.MaxAmmo]          = round(global.ItemIndex[# i, ItemStat.BaseMaxAmmo] * AMMO_UPG);
		            if (upgs.reload)      global.ItemIndex[# i, ItemStat.ReloadSpeed]      = global.ItemIndex[# i, ItemStat.BaseReloadSpeed] * RELOAD_UPG;
		            if (upgs.equip)       global.ItemIndex[# i, ItemStat.EquipTime]        = global.ItemIndex[# i, ItemStat.BaseEquipTime] * EQUIP_UPG;
		            if (upgs.movement)    global.ItemIndex[# i, ItemStat.MovingSpdMul]     = min(global.ItemIndex[# i, ItemStat.BaseMovingSpdMul] * MV_UPG, 1);
		            if (upgs.penetration) global.ItemIndex[# i, ItemStat.PenetrationPower]  = min(global.ItemIndex[# i, ItemStat.BasePenetrationPower] * PEN_UPG, 1);
		            if (upgs.damage)      global.ItemIndex[# i, ItemStat.Damage]           = global.ItemIndex[# i, ItemStat.BaseDamage] * DMG_UPG;
		        }
		    }
	}
	#endregion
	
	#region Load player stats
	if (file_exists("player_stats.json")) {
	    var file = file_text_open_read("player_stats.json");
	    var json_string = file_text_read_string(file);
	    file_text_close(file);
		var loaded_stats = json_parse(json_string);
	    struct_merge_data(global.player_stats, loaded_stats);
		
	    global.player_stats.Get_KD = function() {
	        return (global.player_stats.Deaths != 0) ? (global.player_stats.Kills / global.player_stats.Deaths) : 0;
	    }
		global.player_stats.Get_headshot_percentage = function() {
			return (global.player_stats.Kills != 0) ? (global.player_stats.Headshots / global.player_stats.Kills) * 100 : 0;
		}
		global.player_stats.Get_accuracy = function() {
			return (global.player_stats.All_shots > 0)
				? clamp(global.player_stats.Hit_shots / global.player_stats.All_shots * 100, 0, 100)
				: 0;
		}
	}
	#endregion
	
}
