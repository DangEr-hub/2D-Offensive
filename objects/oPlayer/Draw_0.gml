if(is_local){ image_alpha = point_in_grenade_smoke(x, y) ? 0.75 : 1; }
event_inherited();
//draw_text(x, y - 20, "kbe " + string(in_water_timer));
//draw_text(x, y - 40, "am " + string(AimPunchMultiplier));
//draw_text(x, y - 60, "def " + string(global.ItemIndex[# global.Inventory[# WeaponID, INDEX.slot_id], ITEMSTATS.Defense]));
//draw_text(x, y - 110, "rd " + string(global.game_struct.Player_rd));


if(Visible == true){
	if(is_local && instance_exists(Weapon)){ Weapon.image_alpha = image_alpha; }
	
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
			    draw_sprite_ext(spr_Items, local_item_use_id, rotated_x, rotated_y, 1, 1, RotationAngle, c_white, image_alpha);
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
			draw_weapon_attachments(Weapon, WeaponDistance, suppressor_id, barrel_id, scope_id, image_alpha);
		}

		#endregion
	
	}
	
}
