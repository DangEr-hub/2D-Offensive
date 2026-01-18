/// @description Insert description here
// You can write your code in this editor
event_inherited();
//draw_set_font(fnt_ConsoleSmall);
//draw_text(x, y - 50, "state " + string(State));
//draw_text(x, y - 75, "alarm0 " + string(alarm[0]));
//draw_text(x, y - 200, "ava " + string(check_if_available(ChasingObject)));
if(stats.Health_points <= 0){
	exit;
}
if(Visible == true){
	var armour_sprite_index = 0;
	if(image_index == TEXTURES.no_weapon){
		armour_sprite_index = 0;	
	}else if(image_index == TEXTURES.pistol){
		armour_sprite_index = 1;
	}else if(image_index == TEXTURES.assault_rifle){
		armour_sprite_index = 2;
	}else if(image_index == TEXTURES.flashed_weapon){
		armour_sprite_index = 3;
	}else if(image_index == TEXTURES.flashed_no_weapon){
		armour_sprite_index = 4;
	}else if(image_index == TEXTURES.reload || image_index == TEXTURES.knife_attack){
		armour_sprite_index = 7;
	}else if(image_index >= TEXTURES.prone){
		armour_sprite_index = 5;
	}
	
	if(image_index == TEXTURES.flashed_prone || image_index == TEXTURES.flashed_prone_second || image_index == TEXTURES.flashed_prone_third){
		armour_sprite_index = 6;
	}
	
	if(image_index == TEXTURES.reload_prone || image_index == TEXTURES.reload_prone_second || image_index == TEXTURES.reload_prone_third){
		armour_sprite_index = 8;
	}
	
	if(image_index == TEXTURES.knife_prone || image_index == TEXTURES.knife_prone_second || image_index == TEXTURES.knife_prone_third){
		armour_sprite_index = 8;
	}

	if(ArmourID == Item.KevlarVest){
		draw_sprite_ext(spr_KevlarVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}else if(ArmourID == Item.MilitaryVest){
		draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}else if(ArmourID == Item.SpecOpsVest){
		draw_sprite_ext(spr_SpecOpsVest, armour_sprite_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}

	if(HelmetID == Item.KevlarHelm){
		draw_sprite_ext(spr_Helmet, 0, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);	
	}else if(HelmetID == Item.MilitaryHelm){
		draw_sprite_ext(spr_Helmet, 1, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(HelmetID == Item.SpecOpsHelm){
		draw_sprite_ext(spr_Helmet, 2, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(HelmetID == Item.MilitaryNightVision){
		draw_sprite_ext(spr_Helmet, 3, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(HelmetID == Item.BasicNightVision){
		draw_sprite_ext(spr_Helmet, 4, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}else if(HelmetID == Item.InfraredVision){
		draw_sprite_ext(spr_Helmet, 5, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);		
	}
	
	if(has_suppressor && EquippedGrenadeTimer == -1 && EquippedLandMineTimer == -1){
		draw_sprite_ext(
			spr_Items,
			attachments[WeaponPositionID, ATTACHMENTS.slot_suppressor],
			Weapon.x + lengthdir_x(WeaponDistance*.975, RotationAngle),
			Weapon.y + lengthdir_y(WeaponDistance*.975, RotationAngle),
			.5,
			.5,
			RotationAngle,
			c_white, 
			1
		);
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