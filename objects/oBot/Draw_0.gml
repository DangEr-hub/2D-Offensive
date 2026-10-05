/// @description Insert description here
// You can write your code in this editor
event_inherited();
//draw_set_font(fnt_ConsoleSmall);
//draw_text(x, y - 50, "attachments " + string(attachments));
//draw_text(x, y - 75, "eq level " + string(equipment_level));
//draw_text(x, y - 200, "ava " + string(check_if_available(ChasingObject)));
if(stats.Health_points <= 0){
	exit;
}
if(Visible == true){
	if(State != STATES.MACHINE_GUN) with(Weapon){
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
	
	if(State != STATES.MACHINE_GUN && WeaponID[WeaponPositionID] != ITEM.None && Weapon.Visible
	&& EquippedGrenadeTimer == -1 && EquippedLandMineTimer == -1){
		draw_weapon_attachments(
			Weapon, WeaponDistance,
			attachments[WeaponPositionID][ATTACHMENTS.suppressor],
			attachments[WeaponPositionID][ATTACHMENTS.barrel],
			attachments[WeaponPositionID][ATTACHMENTS.scope]
		);
	}
	if(instance_exists(Weapon) && has_attachment(ITEM.laser, ATTACHMENTS.barrel, id, WeaponPositionID)){
		var laser_pos = local_to_world(56, 16, Weapon.image_angle, Weapon);
		var laser_dx = crosshair_x - laser_pos[0];
		var laser_dy = crosshair_y - laser_pos[1];
		var laser_length = max(1, point_distance(laser_pos[0], laser_pos[1], crosshair_x, crosshair_y));
		var offset_x = -laser_dy / laser_length;
		var offset_y = laser_dx / laser_length;
		draw_set_color(c_red);
		for(var glow_offset = 3; glow_offset >= 1; glow_offset--){
			draw_set_alpha(0.08 * (4 - glow_offset));
			draw_line(laser_pos[0] + offset_x * glow_offset, laser_pos[1] + offset_y * glow_offset,
				crosshair_x + offset_x * glow_offset, crosshair_y + offset_y * glow_offset);
			draw_line(laser_pos[0] - offset_x * glow_offset, laser_pos[1] - offset_y * glow_offset,
				crosshair_x - offset_x * glow_offset, crosshair_y - offset_y * glow_offset);
		}
		draw_set_alpha(1);
		draw_line(laser_pos[0], laser_pos[1], crosshair_x, crosshair_y);
		draw_set_color(c_white);
	}
		
	if (EquippedGrenadeTimer > -1) {
		var distance = sqrt(power(45, 2) + power(15, 2));
		var rotated_dx = lengthdir_x(distance, RotationAngle - darctan2(-15, 45));
		var rotated_dy = lengthdir_y(distance, RotationAngle - darctan2(-15, 45));
		draw_sprite_ext(spr_Grenades, EquippedGrenade, x + rotated_dx, y + rotated_dy, .5, .5, grenade_angle, c_white, 1); 
	}
	
	if (EquippedLandMineTimer > -1) {
		var distance = sqrt(power(45, 2) + power(15, 2));
		var rotated_dx = lengthdir_x(distance, RotationAngle - darctan2(-15, 45));
		var rotated_dy = lengthdir_y(distance, RotationAngle - darctan2(-15, 45));
		draw_sprite_ext(spr_LandMine, EquippedLandMine, x + rotated_dx, y + rotated_dy, .5, .5, LandMineAngle, c_white, 1); 
	}
}
