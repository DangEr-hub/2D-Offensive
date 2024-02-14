/// @description Drawing
//draw_text(x, y - 500, string(window_get_width()) + " " + string(window_get_height()));
//draw_text(x, y - 150, string(surface_get_width(application_surface)) + " " + string(surface_get_height(application_surface)));
//draw_text(x, y - 50, string(display_get_gui_width()) + string(display_get_gui_height()));
event_inherited();
if(stats.Health_points > 0){
	if (equipped_usable_item()) {
	    var distance = sqrt(power(45, 2) + power(15, 2));
	    var rotated_dx = lengthdir_x(distance, RotationAngle - darctan2(-15, 45));
	    var rotated_dy = lengthdir_y(distance, RotationAngle - darctan2(-15, 45));
	    draw_sprite_ext(spr_Items, global.Inventory[# ItemUsePosition, InventoryIndex.SlotID], x + rotated_dx, y + rotated_dy, 1, 1, grenade_angle, c_white, 1); 
	}
	
	if!(WeaponID >= 2){
		if(global.weapon_attachments[WeaponID][weapon_attachments.weapon_suppressor] != Item.None && !equipped_usable_item()){
			draw_sprite_ext(
				spr_Items,
				global.weapon_attachments[WeaponID][weapon_attachments.weapon_suppressor],
				Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),
				Weapon.y + lengthdir_y(WeaponDistance, RotationAngle),
				.5,
				.5,
				RotationAngle,
				c_white, 
				1
			);
		}
	}
	
	var armour_sprite_index = 1;
	if(image_index == 0 || image_index == 5){
		armour_sprite_index = 0;	
	}else if(image_index >= player_textures.prone){
		armour_sprite_index = 2;
	}

	if(global.ArmourID[0] == Item.KevlarVest){
		draw_sprite_ext(spr_KevlarVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}else if(global.ArmourID[0] == Item.MilitaryVest){
		draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}else if(global.ArmourID[0] == Item.SpecOpsVest){
		draw_sprite_ext(spr_SpecOpsVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}

	
	
	
	var helmet_sprite_index = 0;
	if(image_index >= player_textures.prone){
		helmet_sprite_index = 6;	
	}

	if(global.ArmourID[1] == Item.KevlarHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);	
	}else if(global.ArmourID[1] == Item.MilitaryHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 1, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.ArmourID[1] == Item.SpecOpsHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 2, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.ArmourID[1] == Item.MilitaryNightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 3, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.ArmourID[1] == Item.BasicNightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 4, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(global.ArmourID[1] == Item.InfraredVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 5, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}
	
}