/// @description Drawing
///Draw Player
gpu_set_tex_filter(true);
if(ToggleInfraVision == true){
	shader_set(shd_InfraVision);
	shader_set_uniform_f(shader_get_uniform(shd_InfraVision, "u_intensity"), 2.0);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	shader_reset();
}else{
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
}
draw_text(x, y - 50, "player rating" + string(convert_back(global.player_elo_struct.Elo))); ///Eggy scale
draw_text(x, y - 130, "player local volatility" + string(global.player_elo_struct.Local_volatility));
draw_text(x, y - 180, "player game volatility" + string(global.player_elo_struct.Game_volatility));
draw_text(x, y - 250, "player played games" + string(global.player_elo_struct.Played_games));
//draw_text(x, y - 300, "enemy rd" + string(enemy_elo_struct.rd));
//draw_text(x, y - 350, "player volatility" + string(global.player_elo_struct.volatility));
//draw_text(x, y - 35, application_surface_is_enabled());

if(HP > 0){
	if (equipped_item("Grenade")) {
	    var distance = sqrt(power(45, 2) + power(15, 2));
	    var rotated_dx = lengthdir_x(distance, RotationAngle - darctan2(-15, 45));
	    var rotated_dy = lengthdir_y(distance, RotationAngle - darctan2(-15, 45));
	    draw_sprite_ext(spr_Items, global.Inventory[# ItemUsePosition, InventoryIndex.SlotID], x + rotated_dx, y + rotated_dy, 1, 1, grenade_angle, c_white, 1); 
	}

	
	#region Field of view
	var cx = Weapon.FlashLightX;
	var cy = Weapon.FlashLightY;
	var ax = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) - global.FieldOfView);
	var ay = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) - global.FieldOfView);
	var bx = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) + global.FieldOfView);
	var by = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) + global.FieldOfView);	
	draw_set_alpha(.1);
	draw_set_color(global.GoldColor);
	draw_triangle(ax, ay, bx, by, cx, cy, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	#endregion
	
	if(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_suppressor] != Item.None && !equipped_item("Grenade")){
		draw_sprite_ext(
			spr_Items,
			global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_suppressor],
			Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),
			Weapon.y + lengthdir_y(WeaponDistance, RotationAngle),
			.5,
			.5,
			RotationAngle,
			c_white, 
			1
		);
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

gpu_set_tex_filter(false);