event_inherited();
//draw_text(x, y - 20, "hard_mode " + string(global.hard_mode));
//draw_text(x, y - 40, "kick_back_timer " + string(kick_back_timer));
//draw_text(x, y - 60, "def " + string(global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.Defense]));
draw_text(x, y - 110, "rd " + string(global.rating_struct.Player_rd));



if(Visible == true){
	var armour_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
	if (IS_NET && !is_local) {
	    armour_id = network_armour_id;
	}

	var armour_sprite_index = 0;
	if (image_index == TEXTURES.no_weapon) {
	    armour_sprite_index = 0;
	} else if (image_index == TEXTURES.pistol) {
	    armour_sprite_index = 1;
	} else if (image_index == TEXTURES.assault_rifle) {
	    armour_sprite_index = 2;
	} else if (image_index == TEXTURES.flashed_weapon) {
	    armour_sprite_index = 3;
	} else if (image_index == TEXTURES.flashed_no_weapon) {
	    armour_sprite_index = 4;
	} else if (image_index == TEXTURES.reload) {
	    armour_sprite_index = 7;
	} else if (image_index >= TEXTURES.prone && image_index < TEXTURES.grenade_throw) {
	    armour_sprite_index = 5;
	} else if (image_index == TEXTURES.knife_attack) {
	    armour_sprite_index = 9;
	}

	if (image_index == TEXTURES.flashed_prone 
	    || image_index == TEXTURES.flashed_prone_second 
	    || image_index == TEXTURES.flashed_prone_third)
	{
	    armour_sprite_index = 6;
	}

	if (image_index == TEXTURES.reload_prone 
	    || image_index == TEXTURES.reload_prone_second 
	    || image_index == TEXTURES.reload_prone_third)
	{
	    armour_sprite_index = 8;
	}

	if (image_index == TEXTURES.knife_prone 
	    || image_index == TEXTURES.knife_prone_second
	    || image_index == TEXTURES.knife_prone_third)
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
	if((image_index >= TEXTURES.prone && image_index < TEXTURES.knife_attack) || image_index == TEXTURES.death){
		helmet_sprite_index = 6;	
	}
	
	var helmet_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
	if(IS_NET && is_local == false){
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
		  
	if(stats.Health_points > 0){
		
		#region Draw usable item
		if(is_local == true){
			if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
				var item_offset_x = 35;
				var item_offset_y = 40;
					if!(throwing_grenade()){
						item_offset_x = 40;
						item_offset_y = -10;
					}
				if(moving_state == STATES_PLAYER.prone_state){
					item_offset_x = 110;
					item_offset_y = 35;
					if!(throwing_grenade()){
						item_offset_x = 100;
						item_offset_y = -3;
					}
				}
				var rotated_x = x + lengthdir_x(item_offset_x, RotationAngle) - lengthdir_y(item_offset_y, RotationAngle);
				var rotated_y = y + lengthdir_y(item_offset_x, RotationAngle) + lengthdir_x(item_offset_y, RotationAngle);
			    draw_sprite_ext(spr_Items, global.Inventory[# item_use_position, Index.slot_id], rotated_x, rotated_y, 1, 1, RotationAngle, c_white, 1); 
			}
		}else if(is_remote && network_item_use_id != Item.None){
			var remote_item_offset_x = 35;
			var remote_item_offset_y = 40;
			if!(throwing_grenade()){
				remote_item_offset_x = 40;
				remote_item_offset_y = -10;
			}
			if(moving_state == STATES_PLAYER.prone_state){
				remote_item_offset_x = 110;
				remote_item_offset_y = 35;
				if!(throwing_grenade()){
					remote_item_offset_x = 100;
					remote_item_offset_y = -3;
				}
			}
			var remote_item_x = x + lengthdir_x(remote_item_offset_x, RotationAngle) - lengthdir_y(remote_item_offset_y, RotationAngle);
			var remote_item_y = y + lengthdir_y(remote_item_offset_x, RotationAngle) + lengthdir_x(remote_item_offset_y, RotationAngle);
		    draw_sprite_ext(spr_Items, network_item_use_id, remote_item_x, remote_item_y, 1, 1, RotationAngle, c_white, 1);
		}
		#endregion
	
		#region Draw muzzle flash
		if(is_local || !IS_NET){
			if(CanShoot == false && ShootTimer >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer]/1.5 && Healing == false && stats.Health_points > 0){
				draw_sprite_ext(spr_MuzzleFlash, 0, FlashLightX, FlashLightY, 1, 1, RotationAngle, c_white, 1);
			}
		}
	
		if(is_remote){
			if(network_shoot_timer > -1 && Healing == false && stats.Health_points > 0){
				draw_sprite_ext(spr_MuzzleFlash, 0, FlashLightX, FlashLightY, 1, 1, RotationAngle, c_white, 1);
			}
		}
		#endregion
	
		#region Draw suppressor attachment on equipped weapon
		var suppressor_id = Item.None;
		var should_draw_suppressor = false;

		if(is_remote){
			suppressor_id = network_suppressor;
			should_draw_suppressor = (network_weapon_id != Item.None && network_item_use_id == Item.None);
		}else if(WeaponID <= OtherSlot.Secondary){
			suppressor_id = global.Inventory[# WeaponID, Index.slot_suppressor];
			should_draw_suppressor = (global.Inventory[# item_use_position, Index.slot_id] == Item.None);
		}

		if(should_draw_suppressor && suppressor_id != Item.None){
			draw_sprite_ext(
				spr_Items,
				suppressor_id,
				Weapon.x + lengthdir_x(WeaponDistance*.925, RotationAngle),
				Weapon.y + lengthdir_y(WeaponDistance*.925, RotationAngle),
				.5,
				.5,
				RotationAngle,
				c_white,
				1
			);
		}
		#endregion
	
	}
	
}
