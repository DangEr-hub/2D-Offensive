// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function save_game(){
	if(file_exists("save_game.ini")){
		file_delete("save_game.ini");
	}
	ini_open("save_game.ini");
	ini_write_real("Vars", "max_hp", global.MaxHP);
	ini_write_real("Vars", "max_stamina", global.MaxStamina);
	ini_write_real("Vars", "max_weight", global.MaxWeight);
	ini_write_real("Vars", "weight", global.Weight);
	ini_write_real("Vars", "xp", global.XP);
	ini_write_real("Vars", "max_xp", global.MaxXP);
	ini_write_real("Vars", "player_lvl", global.Lvl);
	ini_write_real("Vars", "skill_points", global.SkillPoints);
	ini_write_real("Vars", "money", global.Money);
	ini_write_real("Vars", "unskill_points", global.UnSkillPoints);
	ini_write_real("Vars", "time_speed", global.TimeSpeed);
	ini_write_real("Vars", "godmode", global.GodMode);
	ini_write_real("Vars", "map_id", global.MapID);
	ini_write_real("Vars", "weapon_id_0", global.weapon_id[0]);
	ini_write_real("Vars", "weapon_id_1", global.weapon_id[1]);		
	ini_write_real("Vars", "weapon_clip_ammo_0", global.ClipAmmo[0]);
	ini_write_real("Vars", "weapon_clip_ammo_1", global.ClipAmmo[1]);
	ini_write_real("Vars", "weapon_ammo_0", global.Ammo[0]);
	ini_write_real("Vars", "weapon_ammo_1", global.Ammo[1]);
	ini_write_real("Vars", "weapon_max_ammo_0", global.MaxAmmo[0]);
	ini_write_real("Vars", "weapon_max_ammo_1", global.MaxAmmo[1]);
	ini_write_real("Vars", "crosshair_alpha", global.CrosshairAlpha);
	ini_write_real("Vars", "dynamic_crosshair", global.DynamicCrosshair);
	ini_write_real("Vars", "player_inaccuracy", global.PlayerInaccuracy);
	ini_write_real("Vars", "armour_id", global.ArmourID[0]);
	ini_write_real("Vars", "helmet_id", global.ArmourID[1]);
	ini_write_real("Vars", "armour_durability", global.ArmourDurability[0]);
	ini_write_real("Vars", "helmet_durability", global.ArmourDurability[1]);
	ini_write_real("Vars", "enemy_can_move", global.EnemyCanMove);
	ini_write_real("Vars", "draw_bullet_impact", global.DrawBulletImpact);
	ini_write_real("Vars", "camera_crosshair_shake", global.ViewShake);
	ini_write_real("Vars", "admin_hud", global.AdminHUD);
	ini_write_real("Vars", "draw_particles", global.DrawParticles);
	ini_write_real("Vars", "crosshair_color", global.CrosshairColor);
	ini_write_real("Vars", "draw_other_models", global.draw_other_models);
	
	for (var i = 0; i < array_length_1d(global.weapon_attachments); i++) {
	    for (var j = 0; j < array_length_1d(global.weapon_attachments[i]); j++) {
	        var key = "weapon_attachment_" + string(i) + "_" + string(j);
	        ini_write_real("Attachments", key, global.weapon_attachments[i][j]);
	    }
	}

	ini_close();


	ini_close();
	
	if(file_exists("save_keyboard_input.ini")){
		file_delete("save_keyboard_input.ini");	
	}
	
	ini_open("save_keyboard_input.ini");
	ini_write_real("keyboard_inputs", "ds_list_key_binds_size", ds_list_size(global.KeyBinds));
	for (var i = 0; i < ds_list_size(global.KeyBinds); i++){
		ini_write_string("keyboard_inputs", "ds_list_key_bind_" + string(i), string(global.KeyBinds[| i]));
	}	
	ini_close();
	
	if(file_exists("save_inventory,ini")){
		file_delete("save_inventory.ini");
	}
	ini_open("save_inventory.ini");
	ini_write_string("Inventory", "0", ds_grid_write(global.Inventory));
	//ini_write_string("Inventory", "1", ds_grid_write(global.ItemIndex));
	ini_write_string("Inventory", "2", ds_grid_write(global.MouseSlot));
	ini_close();
}

function load_game(){
	if(file_exists("save_game.ini")){
		ini_open("save_game.ini");
		global.MaxHP = ini_read_real("Vars", "max_hp", global.MaxHP);
		global.MaxStamina = ini_read_real("Vars", "max_stamina", global.MaxStamina);
		global.MaxWeight = ini_read_real("Vars", "MaxWeight", global.MaxWeight);
		global.Weight = ini_read_real("Vars", "max_weight", global.Weight);
		global.XP = ini_read_real("Vars", "xp", global.XP);
		global.MaxXP = ini_read_real("Vars", "max_xp", global.MaxXP);
		global.Lvl = ini_read_real("Vars", "player_lvl", global.Lvl);
		global.SkillPoints = ini_read_real("Vars", "skill_points", global.SkillPoints);
		global.Money = ini_read_real("Vars", "money", global.Money);
		global.UnSkillPoints = ini_read_real("Vars", "unskill_points", global.UnSkillPoints);	
		global.TimeSpeed = ini_read_real("Vars", "time_speed", global.TimeSpeed);
		global.GodMode = ini_read_real("Vars", "godmode", global.GodMode);
		global.MapID = ini_read_real("Vars", "map_id", global.MapID);	
		global.weapon_id[0] = ini_read_real("Vars", "weapon_id_0", global.weapon_id[0]);
		global.weapon_id[1] = ini_read_real("Vars", "weapon_id_1", global.weapon_id[1]);
		global.ClipAmmo[0] = ini_read_real("Vars", "weapon_clip_ammo_0", global.ClipAmmo[0]);
		global.ClipAmmo[1] = ini_read_real("Vars", "weapon_clip_ammo_1", global.ClipAmmo[1]);
		global.Ammo[0] = ini_read_real("Vars", "weapon_ammo_0", global.Ammo[0]);
		global.Ammo[1] = ini_read_real("Vars", "weapon_ammo_1", global.Ammo[1]);
		global.MaxAmmo[0] = ini_read_real("Vars", "weapon_max_ammo_0", global.MaxAmmo[0]);
		global.MaxAmmo[1] = ini_read_real("Vars", "weapon_max_ammo_1", global.MaxAmmo[1]);
		global.CrosshairAlpha = ini_read_real("Vars", "crosshair_alpha", global.CrosshairAlpha);
		global.DynamicCrosshair = ini_read_real("Vars", "dynamic_crosshair", global.DynamicCrosshair);
		global.PlayerInaccuracy = ini_read_real("Vars", "player_inaccuracy", global.PlayerInaccuracy);
		global.ArmourID[0] = ini_read_real("Vars", "armour_id", global.ArmourID[0]);
		global.ArmourID[1] = ini_read_real("Vars", "helmet_id", global.ArmourID[1]);
		global.ArmourDurability[0] = ini_read_real("Vars", "armour_durability", global.ArmourDurability[0]);
		global.ArmourDurability[1] = ini_read_real("Vars", "helmet_durability", global.ArmourDurability[1]);
		global.EnemyCanMove = ini_read_real("Vars", "enemy_can_move", global.EnemyCanMove);
		global.DrawBulletImpact = ini_read_real("Vars", "draw_bullet_impact", global.DrawBulletImpact);
		global.ViewShake = ini_read_real("Vars", "camera_crosshair_shake", global.ViewShake);
		global.AdminHUD = ini_read_real("Vars", "admin_hud", global.AdminHUD);
		global.DrawParticles = ini_read_real("Vars", "draw_particles", global.DrawParticles);
		global.CrosshairColor = ini_read_real("Vars", "crosshair_color", global.CrosshairColor);
		global.draw_other_models = ini_read_real("Vars", "draw_other_models", global.draw_other_models);

		global.weapon_attachments = array_create(2);
		for (var i = 0; i < 2; i++) {
		    global.weapon_attachments[i] = array_create(4);
		    for (var j = 0; j < 4; j++) {
		        var key = "weapon_attachment_" + string(i) + "_" + string(j);
		        global.weapon_attachments[i][j] = ini_read_real("Attachments", key, Item.None); // Default value is 0
		    }
		}

		ini_close();
	}
	
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
	
	if(file_exists("save_inventory.ini")){
	    ini_open("save_inventory.ini");
	    ds_grid_read(global.Inventory, ini_read_string("Inventory", "0", "None"));
	    //ds_grid_read(global.ItemIndex, ini_read_string("Inventory", "1", "None"));
	    ds_grid_read(global.MouseSlot, ini_read_string("Inventory", "2", "None"));
	    ini_close();	
	}
}