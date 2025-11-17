event_inherited();
//draw_text(x, y - 70, network_id);
draw_text(x, y + 50, "network_armour_dur " + string(network_armour_dur));
//draw_text(x, y - 140, is_local);

if(is_local){
	draw_text(x, y - 50, "local armour dur " + string(global.Inventory[# OtherSlot.Armour, Index.slot_durability]));
}

if(stats.Health_points > 0){
	var armour_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
	if (instance_exists(oNetworkManager) && !is_local) {
	    armour_id = network_armour_id;
	}

	var armour_sprite_index = 0;
	if (image_index == player_textures.no_weapon) {
	    armour_sprite_index = 0;
	} else if (image_index == player_textures.pistol) {
	    armour_sprite_index = 1;
	} else if (image_index == player_textures.assault_rifle) {
	    armour_sprite_index = 2;
	} else if (image_index == player_textures.flashed_weapon) {
	    armour_sprite_index = 3;
	} else if (image_index == player_textures.flashed_no_weapon) {
	    armour_sprite_index = 4;
	} else if (image_index == player_textures.reload) {
	    armour_sprite_index = 7;
	} else if (image_index >= player_textures.prone && image_index < player_textures.knife) {
	    armour_sprite_index = 5;
	} else if (image_index == player_textures.knife) {
	    armour_sprite_index = 9;
	}

	if (image_index == player_textures.flashed_prone 
	    || image_index == player_textures.flashed_prone_second 
	    || image_index == player_textures.flashed_prone_third)
	{
	    armour_sprite_index = 6;
	}

	if (image_index == player_textures.reload_prone 
	    || image_index == player_textures.reload_prone_second 
	    || image_index == player_textures.reload_prone_third)
	{
	    armour_sprite_index = 8;
	}

	if (image_index == player_textures.knife_prone 
	    || image_index == player_textures.knife_prone_second 
	    || image_index == player_textures.knife_prone_third)
	{
	    armour_sprite_index = 8;
	}

	if (armour_id == Item.KevlarVest) {
	    draw_sprite_ext(spr_KevlarVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
	else if (armour_id == Item.MilitaryVest) {
	    draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
	else if (armour_id == Item.SpecOpsVest) {
	    draw_sprite_ext(spr_SpecOpsVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
	
	
	var helmet_sprite_index = 0;
	if(image_index >= player_textures.prone && image_index < player_textures.knife){
		helmet_sprite_index = 6;	
	}
	
	var helmet_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
	if(instance_exists(oNetworkManager) && is_local == false){
		helmet_id = network_helmet_id;
	}

	if(helmet_id == Item.KevlarHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);	
	}else if(helmet_id == Item.MilitaryHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 1, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == Item.SpecOpsHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 2, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == Item.MilitaryNightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 3, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == Item.BasicNightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 4, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == Item.InfraredVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 5, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}
		  
	#region Draw usable item
	if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
		var item_offset_x = 40;
		var item_offset_y = -10;
		if(moving_state == states_player.prone_state){
			item_offset_x = 100;
			item_offset_y = -3;
		}
		var rotated_x = x + lengthdir_x(item_offset_x, RotationAngle) - lengthdir_y(item_offset_y, RotationAngle);
		var rotated_y = y + lengthdir_y(item_offset_x, RotationAngle) + lengthdir_x(item_offset_y, RotationAngle);
	    draw_sprite_ext(spr_Items, global.Inventory[# item_use_position, Index.slot_id], rotated_x, rotated_y, 1, 1, RotationAngle, c_white, 1); 
	}
	#endregion
	
	#region Draw suppressor attachment on equipped weapon
	if(WeaponID <= OtherSlot.Secondary){
		if(global.Inventory[# WeaponID, Index.slot_suppressor] != Item.None && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
			draw_sprite_ext(
				spr_Items,
				global.Inventory[# WeaponID, Index.slot_suppressor],
				Weapon.x + lengthdir_x(WeaponDistance*.95, RotationAngle),
				Weapon.y + lengthdir_y(WeaponDistance*.95, RotationAngle),
				.5,
				.5,
				RotationAngle,
				c_white, 
				1
			);
		}
	}
	#endregion
	
}

#region Networking
/*
if (global.debug_network) {
    // Draw network ID
    draw_set_color(c_white);
    draw_text(x, y - 32, "ID: " + string(network_id));
    
    if (is_local) {
        draw_set_color(c_lime);
        draw_text(x, y - 48, "LOCAL");
    }
    
    if (is_remote) {
        draw_set_color(c_yellow);
        draw_text(x, y - 48, "REMOTE");
        
        // Draw interpolation target
        draw_set_alpha(0.3);
        draw_circle(target_x, target_y, 8, false);
        draw_set_alpha(1);
    }
}*/
#endregion