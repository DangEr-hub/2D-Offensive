#region Player variables
var blur_intensity = 0;
var vignette_level = 0.75;
var sniper_scope_active = false;
if(instance_exists(oPlayer)){
	sniper_scope_active = global.local_player.ScopeIn && global.local_player.player_has_scope == 0;
	if(global.local_player.ToggleNightVision == true || global.local_player.ToggleInfraVision == true) {
	    if(!surface_exists(nightvision_surface)){
	        nightvision_surface = surface_create(global.GuiW, global.GuiH);
	    }
	}
	aberration_level = global.aberration_level;
	saturation_level = global.saturation_level;
	if(global.local_player.stats.Health_points <= round(global.player_stats.Max_health/2) && global.local_player.stats.Health_points > 0){
		aberration_level = clamp(global.local_player.stats.Health_points/500, 0.01, 0.05);
		saturation_level = min(0 + global.local_player.stats.Health_points/100, global.saturation_level);
	}
	
	var vignette_aimpunch = 0;
	var vignette_explosion = 0;
	if(global.local_player.near_explosion_timer > -1){
		aberration_level = 0.02;
		vignette_explosion = 0.5;
	}
	
	if(global.local_player.AimPunchTimer > -1 || global.local_player.near_explosion_timer > -1 || global.local_player.in_water == true){
		vignette_aimpunch = 0.25;
		blur_intensity = 0.05;
	}
	var hp_ratio = clamp(global.local_player.stats.Health_points / global.player_stats.Max_health, 0, 1);
	var vignette_hp = lerp(1.05, 0, hp_ratio);
	vignette_level = 0.75 + vignette_explosion + vignette_aimpunch + vignette_hp;
}
#endregion

if(instance_exists(oPlayer)){	

		if(global.BloomShader == true){
			if(!surface_exists(bloom_surface1)){
			    bloom_surface1 = surface_create(global.GuiW, global.GuiH);
			}

			if(!surface_exists(bloom_surface2)){
			    bloom_surface2 = surface_create(global.GuiW, global.GuiH);
			}
	
			surface_set_target(bloom_surface1);
			draw_clear_alpha(c_black, 0);
			surface_reset_target();
			surface_set_target(bloom_surface2);
			draw_clear_alpha(c_black, 0);
			surface_reset_target(); 
			
			// Bloom luminescence
			shader_set(shader_bloom_lum);
			shader_set_uniform_f(u_bloom_threshold, bloom_threshold);
			shader_set_uniform_f(u_bloom_range, bloom_range);
			surface_set_target(bloom_surface1);
			draw_surface(application_surface, 0, 0);
			surface_reset_target();
			shader_reset();

			// Bloom blur effects
			gpu_set_texfilter(true);
			shader_set(shader_blur);
			shader_set_uniform_f(u_blur_steps, blur_steps);
			shader_set_uniform_f(u_sigma, sigma);	
			shader_set_uniform_f(u_blur_vector, 1, 0);	
			shader_set_uniform_f(u_texel_size, texel_w, texel_h);	

			surface_set_target(bloom_surface2);
			draw_surface(bloom_surface1, 0, 0);
			surface_reset_target();

			shader_set_uniform_f(u_blur_vector, 0, 1);
			surface_set_target(bloom_surface1);
			draw_surface(bloom_surface2, 0, 0);
			surface_reset_target();    
			gpu_set_tex_filter(false);	
			shader_reset();

			// Bloom blend effect
			shader_set(shader_bloom_blend);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);

			if (global.local_player.in_water == true) {
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_time"), current_time / 1000.0);
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_strength"), lerp(0, 0.01, (global.local_player.in_water_timer + 1) / game_get_speed(gamespeed_fps)));
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_speed"), 2.5);
			} else {
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_strength"), 0.0);
			}
				
			shader_set_uniform_f(u_bloom_intensity, bloom_intensity);
			shader_set_uniform_f(u_bloom_darken, bloom_darken);
			shader_set_uniform_f(u_bloom_saturation, bloom_saturation);
			texture_set_stage(u_bloom_texture, surface_get_texture(bloom_surface1)); //je jedno jestli bloom_surface1 nebo bloom_surface2
		}


		// Vykreslení night vision surface
		if(global.local_player.ToggleNightVision == true || global.local_player.ToggleInfraVision == true) {
		    surface_set_target(nightvision_surface);
		}
		    
		haze_source_surface = -1;
		if(global.local_player.ToggleNightVision == true || global.local_player.ToggleInfraVision == true) {
		    surface_reset_target();
		}

		if(instance_exists(obj_hazeC) && !sniper_scope_active){
			var haze_active = obj_hazeC.coverScreen;

			if(!haze_active){
				for(var haze_i = 0; haze_i < ds_list_size(obj_hazeC.hazePoints); haze_i++){
					var haze_point = obj_hazeC.hazePoints[| haze_i];
					if(haze_point[2] > 1){
						haze_active = true;
						break;
					}
				}
			}

			if(!haze_active){
				for(var haze_i = 0; haze_i < ds_list_size(obj_hazeC.hazeAreas); haze_i++){
					var haze_area = obj_hazeC.hazeAreas[| haze_i];
					if(haze_area[2] > 1 && haze_area[3] > 1){
						haze_active = true;
						break;
					}
				}
			}

			if(haze_active){
				if(!surface_exists(post_surface)){
					post_surface = surface_create(global.GuiW, global.GuiH);
				}else if(surface_get_width(post_surface) != global.GuiW || surface_get_height(post_surface) != global.GuiH){
					surface_resize(post_surface, global.GuiW, global.GuiH);
				}

				if(!surface_exists(haze_final_surface)){
					haze_final_surface = surface_create(global.GuiW, global.GuiH);
				}else if(surface_get_width(haze_final_surface) != global.GuiW || surface_get_height(haze_final_surface) != global.GuiH){
					surface_resize(haze_final_surface, global.GuiW, global.GuiH);
				}

				surface_set_target(post_surface);
				draw_clear_alpha(c_black, 0);
				draw_surface_stretched(application_surface, 0, 0, global.GuiW, global.GuiH);

				if(global.BloomShader == true){
					gpu_set_blendmode(bm_add);
					draw_surface_stretched(bloom_surface1, 0, 0, global.GuiW, global.GuiH);
					gpu_set_blendmode(bm_normal);
				}

				surface_reset_target();

				if(global.local_player.ToggleNightVision){
					surface_set_target(haze_final_surface);
					draw_clear_alpha(c_black, 0);
					shader_set(shd_NightVision);
					shader_set_uniform_f(shader_get_uniform(shd_NightVision, "u_resolution"), surface_get_width(post_surface), surface_get_height(post_surface));
					shader_set_uniform_f(shader_get_uniform(shd_NightVision, "intensity_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.NightVisionIntensityPower]);
					shader_set_uniform_f(shader_get_uniform(shd_NightVision, "noise_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.NightVisionNoisePower]);
					draw_surface_stretched(post_surface, 0, 0, global.GuiW, global.GuiH);
					shader_reset();
					surface_reset_target();
					haze_source_surface = haze_final_surface;
				}else if(global.local_player.ToggleInfraVision){
					surface_set_target(haze_final_surface);
					draw_clear_alpha(c_black, 0);
					shader_set(shd_InfraVisionSurface);
					shader_set_uniform_f(shader_get_uniform(shd_InfraVisionSurface, "u_resolution"), surface_get_width(post_surface), surface_get_height(post_surface));
					draw_surface_stretched(post_surface, 0, 0, global.GuiW, global.GuiH);
					shader_reset();
					surface_reset_target();
					haze_source_surface = haze_final_surface;
				}else{
					haze_source_surface = post_surface;
				}
			}
		}

		if(global.local_player.ToggleNightVision == true || global.local_player.ToggleInfraVision == true) {
		    surface_set_target(nightvision_surface);
		}

		if(global.BloomShader == true){
			shader_set(shader_bloom_blend);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);

			if (global.local_player.in_water == true) {
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_time"), current_time / 1000.0);
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_strength"), lerp(0, 0.01, (global.local_player.in_water_timer + 1) / game_get_speed(gamespeed_fps)));
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_speed"), 2.5);
			} else {
			    shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_strength"), 0.0);
			}

			shader_set_uniform_f(u_bloom_intensity, bloom_intensity);
			shader_set_uniform_f(u_bloom_darken, bloom_darken);
			shader_set_uniform_f(u_bloom_saturation, bloom_saturation);
			texture_set_stage(u_bloom_texture, surface_get_texture(bloom_surface1));
		}

		draw_surface_stretched(application_surface, 0, 0, global.GuiW, global.GuiH);
		
        
		if(global.BloomShader == true){
			
			#region Bloom add effect
			// Bloom surface effect
			gpu_set_blendmode(bm_add);
			draw_surface_stretched(bloom_surface1, 0, 0, global.GuiW, global.GuiH); //je jedno jestli bloom_sruface1 nebo bloom_surface2
			gpu_set_blendmode(bm_normal);
			shader_reset();
			#endregion
			
		}
		
		if(global.local_player.ToggleNightVision == true || global.local_player.ToggleInfraVision == true) {
		    surface_reset_target();
		}

		if(global.local_player.ToggleNightVision) {
			
			#region Night vision effect
		    shader_set(shd_NightVision);
			shader_set_uniform_f(shader_get_uniform(shd_NightVision, "u_resolution"),
				surface_get_width(application_surface),
				surface_get_height(application_surface)
			);
			shader_set_uniform_f(
				shader_get_uniform(shd_NightVision, "intensity_strength"), 
				global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.NightVisionIntensityPower]
			);
			shader_set_uniform_f(
				shader_get_uniform(shd_NightVision, "noise_strength"), 
				global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.NightVisionNoisePower]
			);
		    draw_surface_stretched(nightvision_surface, 0, 0, global.GuiW, global.GuiH);
		    shader_reset();
			#endregion
			
		}else if(global.local_player.ToggleInfraVision){
			
			#region Infra vision effect
		    shader_set(shd_InfraVisionSurface);
			shader_set_uniform_f(shader_get_uniform(shd_InfraVisionSurface, "u_resolution"),
				surface_get_width(application_surface),
				surface_get_height(application_surface)
			);
		    draw_surface_stretched(nightvision_surface, 0, 0, global.GuiW, global.GuiH);
		    shader_reset();		
			#endregion
			
		}

		#region Sniper scope source
		if(global.local_player.ScopeIn && global.local_player.player_has_scope == 0){
			if(!surface_exists(final_surface)){
				final_surface = surface_create(global.GuiW, global.GuiH);
			}else if(surface_get_width(final_surface) != global.GuiW || surface_get_height(final_surface) != global.GuiH){
				surface_resize(final_surface, global.GuiW, global.GuiH);
			}

			surface_set_target(final_surface);
			draw_clear_alpha(c_black, 0);

			if(global.local_player.ToggleNightVision){
				shader_set(shd_NightVision);
				shader_set_uniform_f(shader_get_uniform(shd_NightVision, "u_resolution"), global.GuiW, global.GuiH);
				shader_set_uniform_f(shader_get_uniform(shd_NightVision, "intensity_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.NightVisionIntensityPower]);
				shader_set_uniform_f(shader_get_uniform(shd_NightVision, "noise_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.NightVisionNoisePower]);
				draw_surface_stretched(nightvision_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();
			}else if(global.local_player.ToggleInfraVision){
				shader_set(shd_InfraVisionSurface);
				shader_set_uniform_f(shader_get_uniform(shd_InfraVisionSurface, "u_resolution"), global.GuiW, global.GuiH);
				draw_surface_stretched(nightvision_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();
			}else{
				if(global.BloomShader == true){
					shader_set(shader_bloom_blend);
					shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
					shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
					shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
					shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);
					if(global.local_player.in_water){
						shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_time"), current_time / 1000);
						shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_strength"), lerp(0, .01, (global.local_player.in_water_timer + 1) / game_get_speed(gamespeed_fps)));
						shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_speed"), 2.5);
					}else{
						shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "water_strength"), 0);
					}
					shader_set_uniform_f(u_bloom_intensity, bloom_intensity);
					shader_set_uniform_f(u_bloom_darken, bloom_darken);
					shader_set_uniform_f(u_bloom_saturation, bloom_saturation);
					texture_set_stage(u_bloom_texture, surface_get_texture(bloom_surface1));
				}

				draw_surface_stretched(application_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();

				if(global.BloomShader == true){
					gpu_set_blendmode(bm_add);
					draw_surface_stretched(bloom_surface1, 0, 0, global.GuiW, global.GuiH);
					gpu_set_blendmode(bm_normal);
				}
			}

			surface_reset_target();
		}
		#endregion
		
}


if(instance_exists(oPlayer)){
	if (global.local_player.in_water == true) {
	    var alpha = 0.25 * (global.local_player.in_water_timer + 1) / game_get_speed(gamespeed_fps);
    
	    draw_set_alpha(alpha);
	    draw_set_color(c_aqua);
	    draw_rectangle(0, 0, global.GuiW, global.GuiH, false);
	    draw_set_alpha(1);
	}
}

