event_inherited();
draw_text(x, y - 20, "kbe " + string(in_water_timer));
//draw_text(x, y - 40, "am " + string(AimPunchMultiplier));
//draw_text(x, y - 60, "def " + string(global.ItemIndex[# global.Inventory[# WeaponID, INDEX.slot_id], ITEMSTATS.Defense]));
//draw_text(x, y - 110, "rd " + string(global.game_struct.Player_rd));


if(Visible == true){
	
	with(Weapon){
		var owner_can_draw = instance_exists(Owner) && Owner.stats.Health_points > 0;

		if(Visible == true && owner_can_draw){
			draw_self();
		}

		if(owner_can_draw && Owner.object_index == oBot && Owner.Visible == true){
			if(Owner.CanShoot == false
			&& Owner.ShootTimer >= global.ItemIndex[# Owner.WeaponID[Owner.WeaponPositionID], ITEMSTATS.ShootTimer] / 1.5
			&& Owner.healing == false){
				draw_sprite_ext(
					spr_MuzzleFlash,
					0,
					Owner.Weapon.x + lengthdir_x(Owner.WeaponDistance, Owner.RotationAngle),
					Owner.Weapon.y + lengthdir_y(Owner.WeaponDistance, Owner.RotationAngle),
					1,
					1,
					Owner.RotationAngle,
					c_white,
					1
				);
			}
		}
	}
	
	var armour_id = global.Inventory[# OtherSlot.Armour, INDEX.slot_id];
	if (IS_NET && !is_local) {
	    armour_id = network_armour_id;
	}
	if (stats.Health_points <= 0) armour_id = ITEM.None;

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

	if (armour_id == ITEM.KevlarVest) {
	    draw_sprite_ext(spr_KevlarVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
	else if (armour_id == ITEM.MilitaryVest) {
	    draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
	else if (armour_id == ITEM.SpecOpsVest) {
	    draw_sprite_ext(spr_SpecOpsVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
	
	
	var helmet_sprite_index = 0;
	if((image_index >= TEXTURES.prone && image_index < TEXTURES.knife_attack) || image_index == TEXTURES.death){
		helmet_sprite_index = 5;	
	}
	
	var helmet_id = global.Inventory[# OtherSlot.Helmet, INDEX.slot_id];
	if(IS_NET && is_local == false){
		helmet_id = network_helmet_id;
	}
	if (stats.Health_points <= 0) helmet_id = ITEM.None;

	if(helmet_id == ITEM.KevlarHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);	
	}else if(helmet_id == ITEM.MilitaryHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 1, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == ITEM.SpecOpsHelm){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 2, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == ITEM.NightVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 3, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(helmet_id == ITEM.InfraredVision){
		draw_sprite_ext(spr_Helmet, helmet_sprite_index + 4, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}
		  
	if(stats.Health_points > 0){
		
		#region Draw usable item
		if(is_local == true){
			var local_item_use_id = global.Inventory[# item_use_position, INDEX.slot_id];
			if (Healing && HealingItemId != ITEM.None) local_item_use_id = HealingItemId;
			if(local_item_use_id != ITEM.None){
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
			    draw_sprite_ext(spr_Items, local_item_use_id, rotated_x, rotated_y, 1, 1, RotationAngle, c_white, 1);
			}
		}else if(is_remote && network_item_use_id != ITEM.None){
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
			if(CanShoot == false && ShootTimer >= global.ItemIndex[#global.Inventory[# WeaponID, INDEX.slot_id], ITEMSTATS.ShootTimer]/1.5 && Healing == false && stats.Health_points > 0){
				draw_sprite_ext(spr_MuzzleFlash, 0, FlashLightX, FlashLightY, 1, 1, RotationAngle, c_white, 1);
			}
		}
	
		if(is_remote){
			if(network_shoot_timer > -1 && Healing == false && stats.Health_points > 0){
				draw_sprite_ext(spr_MuzzleFlash, 0, FlashLightX, FlashLightY, 1, 1, RotationAngle, c_white, 1);
			}
		}
		#endregion
	
		#region Draw attachments on equipped weapon
		var suppressor_id = ITEM.None;
		var barrel_id = ITEM.None;
		var scope_id = ITEM.None;
		var should_draw_attachments = false;

		if(is_remote){
			barrel_id = network_barrel;
			suppressor_id = network_suppressor;
			scope_id = network_scope;
			should_draw_attachments = (network_weapon_id != ITEM.None && network_item_use_id == ITEM.None);
		}else if(WeaponID <= OtherSlot.Secondary){
			suppressor_id = global.Inventory[# WeaponID, INDEX.slot_suppressor];
			barrel_id = global.Inventory[# WeaponID, INDEX.slot_barrel];
			scope_id = global.Inventory[# WeaponID, INDEX.slot_scope];
			should_draw_attachments = (global.Inventory[# item_use_position, INDEX.slot_id] == ITEM.None);
		}

		if(should_draw_attachments && Weapon.Visible){
			draw_weapon_attachments(Weapon, WeaponDistance, suppressor_id, barrel_id, scope_id);
		}

		#endregion
	
	}
	
}
