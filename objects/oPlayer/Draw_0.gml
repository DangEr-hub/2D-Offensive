/// @description Drawing
draw_text(x, y + 70, global.player_stats_struct.Weight);
event_inherited();
if(stats.Health_points > 0){
	var armour_sprite_index = 0;
	if(image_index == player_textures.no_weapon){
		armour_sprite_index = 0;	
	}else if(image_index == player_textures.pistol){
		armour_sprite_index = 1;
	}else if(image_index == player_textures.assault_rifle){
		armour_sprite_index = 2;
	}else if(image_index == player_textures.flashed_weapon){
		armour_sprite_index = 3;
	}else if(image_index == player_textures.flashed_no_weapon){
		armour_sprite_index = 4;
	}else if(image_index == player_textures.reload || image_index == player_textures.knife){
		armour_sprite_index = 7;
	}else if(image_index >= player_textures.prone){
		armour_sprite_index = 5;
	}
	
	if(image_index == player_textures.flashed_prone || image_index == player_textures.flashed_prone_second || image_index == player_textures.flashed_prone_third){
		armour_sprite_index = 6;
	}
	
	if(image_index == player_textures.reload_prone || image_index == player_textures.reload_prone_second || image_index == player_textures.reload_prone_third){
		armour_sprite_index = 8;
	}

	if(image_index == player_textures.knife_prone || image_index == player_textures.knife_prone_second || image_index == player_textures.knife_prone_third){
		armour_sprite_index = 8;
	}

	if(global.Inventory[# OtherSlot.Armour, Index.slot_id] == Item.KevlarVest){
		draw_sprite_ext(spr_KevlarVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}else if(global.Inventory[# OtherSlot.Armour, Index.slot_id] == Item.MilitaryVest){
		draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}else if(global.Inventory[# OtherSlot.Armour, Index.slot_id] == Item.SpecOpsVest){
		draw_sprite_ext(spr_SpecOpsVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}

	
	
	
	var helmet_sprite_index = 0;
	if(image_index >= player_textures.prone){
		helmet_sprite_index = 6;	
	}

	if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.KevlarHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);	
	}else if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.MilitaryHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 1, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.SpecOpsHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 2, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.MilitaryNightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 3, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.BasicNightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 4, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.InfraredVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 5, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}
		  
	#region Draw usable item
	if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
		var item_offset_x = 40;
		var item_offset_y = -10;
		if(moving_state == player_states.prone_state){
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