/// @description Insert description here
// You can write your code in this editor
gpu_set_tex_filter(true);
if(Visible == true){
	if(oPlayer.ToggleInfraVision == true && InfraVisionIntensity >= 1.25){
		shader_set(shd_InfraVision);
		shader_set_uniform_f(shader_get_uniform(shd_InfraVision, "u_intensity"), InfraVisionIntensity);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
		shader_reset();
	}else{
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}

	draw_text(x, y - 70, healing); 
	
	if(State != States.Death){
		
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

		var armour_sprite_index = 1;
		if(image_index == 0 || image_index == 5){
			armour_sprite_index = 0;	
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
	}
}

gpu_set_tex_filter(false);