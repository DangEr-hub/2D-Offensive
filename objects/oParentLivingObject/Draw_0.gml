event_inherited();
if(Visible == true){
	var body_width = sprite_get_width(sprite_index);
	var body_height = sprite_get_height(sprite_index);
	var sprite_origin_x = sprite_get_xoffset(sprite_index);
	var sprite_origin_y = sprite_get_yoffset(sprite_index);

	if(surface_exists(body_surface) && (surface_get_width(body_surface) != body_width || surface_get_height(body_surface) != body_height)){
		surface_free(body_surface);
		body_surface = -1;
	}
	if(!surface_exists(body_surface)){
		body_surface = surface_create(body_width, body_height);
	}

	surface_set_target(body_surface);
	draw_clear_alpha(c_black, 0);
	var local_player_exists = variable_global_exists("local_player") && instance_exists(global.local_player);
	if(local_player_exists && global.local_player.ToggleInfraVision == true){
		shader_set(shd_InfraVision);
		shader_set_uniform_f(shader_get_uniform(shd_InfraVision, "u_intensity"), InfraVisionIntensity);
		draw_sprite_ext(sprite_index, image_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		shader_reset();
	}else{
		draw_sprite_ext(sprite_index, image_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
	}

	var armour_sprite_index = 0;
	var helmet_sprite_index = 0;
	if(object_index == oPlayer){
		var armour_id = global.Inventory[# OtherSlot.Armour, INDEX.slot_id];
		if(IS_NET && !is_local) armour_id = network_armour_id;
		if(stats.Health_points <= 0) armour_id = ITEM.None;

		if(image_index == TEXTURES.no_weapon) armour_sprite_index = 0;
		else if(image_index == TEXTURES.pistol) armour_sprite_index = 1;
		else if(image_index == TEXTURES.assault_rifle) armour_sprite_index = 2;
		else if(image_index == TEXTURES.flashed_weapon) armour_sprite_index = 3;
		else if(image_index == TEXTURES.flashed_no_weapon) armour_sprite_index = 4;
		else if(image_index == TEXTURES.reload) armour_sprite_index = 7;
		else if(image_index >= TEXTURES.prone && image_index < TEXTURES.grenade_throw) armour_sprite_index = 5;
		else if(image_index == TEXTURES.knife_attack) armour_sprite_index = 9;

		if(armour_id == ITEM.KevlarVest){
			draw_sprite_ext(spr_KevlarVest, armour_sprite_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}else if(armour_id == ITEM.MilitaryVest){
			draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}

		if((image_index >= TEXTURES.prone && image_index < TEXTURES.grenade_throw) || image_index == TEXTURES.death){
			helmet_sprite_index = 4;
		}

		var helmet_id = global.Inventory[# OtherSlot.Helmet, INDEX.slot_id];
		if(IS_NET && !is_local) helmet_id = network_helmet_id;
		if(stats.Health_points <= 0) helmet_id = ITEM.None;

		if(helmet_id == ITEM.KevlarHelm){
			draw_sprite_ext(spr_Helmet, helmet_sprite_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}else if(helmet_id == ITEM.MilitaryHelm){
			draw_sprite_ext(spr_Helmet, helmet_sprite_index + 1, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}else if(helmet_id == ITEM.NightVision){
			draw_sprite_ext(spr_Helmet, helmet_sprite_index + 2, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}else if(helmet_id == ITEM.InfraredVision){
			draw_sprite_ext(spr_Helmet, helmet_sprite_index + 3, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}
	}else if(object_index == oBot){
		if(image_index == TEXTURES.no_weapon) armour_sprite_index = 0;
		else if(image_index == TEXTURES.pistol) armour_sprite_index = 1;
		else if(image_index == TEXTURES.assault_rifle) armour_sprite_index = 2;
		else if(image_index == TEXTURES.flashed_weapon) armour_sprite_index = 3;
		else if(image_index == TEXTURES.flashed_no_weapon) armour_sprite_index = 4;
		else if(image_index == TEXTURES.reload || image_index == TEXTURES.knife_attack) armour_sprite_index = 7;
		else if(image_index >= TEXTURES.prone) armour_sprite_index = 5;

		if(image_index == TEXTURES.flashed_prone || image_index == TEXTURES.flashed_prone_second || image_index == TEXTURES.flashed_prone_third) armour_sprite_index = 6;
		if(image_index == TEXTURES.reload_prone || image_index == TEXTURES.reload_prone_second || image_index == TEXTURES.reload_prone_third) armour_sprite_index = 8;
		if(image_index == TEXTURES.knife_prone || image_index == TEXTURES.knife_prone_second || image_index == TEXTURES.knife_prone_third) armour_sprite_index = 8;

		if(ArmourID == ITEM.KevlarVest){
			draw_sprite_ext(spr_KevlarVest, armour_sprite_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}else if(ArmourID == ITEM.MilitaryVest){
			draw_sprite_ext(spr_MilitaryVest, armour_sprite_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}

		helmet_sprite_index = -1;
		switch(HelmetID){
			case ITEM.KevlarHelm: helmet_sprite_index = 0; break;
			case ITEM.MilitaryHelm: helmet_sprite_index = 1; break;
			case ITEM.NightVision: helmet_sprite_index = 2; break;
			case ITEM.InfraredVision: helmet_sprite_index = 3; break;
		}
		if(helmet_sprite_index != -1){
			var helmet_index = helmet_sprite_index;
			if(State == STATES.Prone) helmet_index += 4;
			draw_sprite_ext(spr_Helmet, helmet_index, sprite_origin_x, sprite_origin_y, 1, 1, 0, image_blend, 1);
		}
	}
	if(array_length(body_blood_stains) > 0){
		var previous_blend = gpu_get_blendmode_ext_sepalpha();
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_zero, bm_one);
		for(var stain_index = 0; stain_index < array_length(body_blood_stains); stain_index++){
			var stain = body_blood_stains[stain_index];
			draw_sprite_ext(spr_BloodSplash, stain.frame, stain.pos_x, stain.pos_y,
				stain.scale, stain.scale, stain.angle, stain.blend, stain.alpha);
		}
		gpu_set_blendmode_ext_sepalpha(previous_blend[0], previous_blend[1], previous_blend[2], previous_blend[3]);
	}
	surface_reset_target();
	var surface_pos_x = x - body_visual_scale * (sprite_origin_x * dcos(RotationAngle) + sprite_origin_y * dsin(RotationAngle));
	var surface_pos_y = y + body_visual_scale * (sprite_origin_x * dsin(RotationAngle) - sprite_origin_y * dcos(RotationAngle));
	draw_surface_ext(body_surface, surface_pos_x, surface_pos_y, body_visual_scale, body_visual_scale, RotationAngle, c_white, image_alpha);
}
