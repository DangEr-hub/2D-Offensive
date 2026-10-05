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
	
	if(global.local_player.AimPunchTimer > -1 || global.local_player.near_explosion_timer > -1){
		vignette_aimpunch = 0.25;
	}
	if(global.local_player.near_explosion_timer > -1){
		blur_intensity = 0.05;
	}
	var hp_ratio = clamp(global.local_player.stats.Health_points / global.player_stats.Max_health, 0, 1);
	var vignette_hp = lerp(1.05, 0, hp_ratio);
	vignette_level = 0.75 + vignette_explosion + vignette_aimpunch + vignette_hp;
}
#endregion

if(instance_exists(oPlayer)){	
		var shader_bloom_intensity = global.bloom_shader ? bloom_intensity : 0;
		var shader_bloom_darken = global.bloom_shader ? bloom_darken : 1;
		var shader_bloom_saturation = global.bloom_shader ? bloom_saturation : 1;
		var shader_bloom_neighbor_strength = global.bloom_shader ? bloom_neighbor_strength : 0;

		if(!surface_exists(bloom_surface1)){
			bloom_surface1 = surface_create(global.GuiW, global.GuiH);
		}else if(surface_get_width(bloom_surface1) != global.GuiW || surface_get_height(bloom_surface1) != global.GuiH){
			surface_resize(bloom_surface1, global.GuiW, global.GuiH);
		}

		if(!surface_exists(bloom_surface2)){
			bloom_surface2 = surface_create(global.GuiW, global.GuiH);
		}else if(surface_get_width(bloom_surface2) != global.GuiW || surface_get_height(bloom_surface2) != global.GuiH){
			surface_resize(bloom_surface2, global.GuiW, global.GuiH);
		}
	
		surface_set_target(bloom_surface1);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
		surface_set_target(bloom_surface2);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();

		if(global.bloom_shader == true){
			
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
			shader_set_uniform_f(u_texel_size, 1 / global.GuiW, 1 / global.GuiH);

			surface_set_target(bloom_surface2);
			draw_surface(bloom_surface1, 0, 0);
			surface_reset_target();

			shader_set_uniform_f(u_blur_vector, 0, 1);
			surface_set_target(bloom_surface1);
			draw_surface(bloom_surface2, 0, 0);
			surface_reset_target();    
			gpu_set_tex_filter(false);	
			shader_reset();

		}

		var scene_surface = application_surface;
		if(global.local_player.AimPunchTimer > -1){
			// Bloom už má hotový výsledek v bloom_surface1; druhou surface použijeme pro rozmazání scény.
			if(!surface_exists(post_surface)){
				post_surface = surface_create(global.GuiW, global.GuiH);
			}else if(surface_get_width(post_surface) != global.GuiW || surface_get_height(post_surface) != global.GuiH){
				surface_resize(post_surface, global.GuiW, global.GuiH);
			}

			var blur_draw_color = draw_get_color();
			var blur_draw_alpha = draw_get_alpha();
			draw_set_color(c_white);
			draw_set_alpha(1);
			// Zapiš výstup shaderů přímo; běžné míchání by v každém průchodu znovu ztmavilo průhledné pixely.
			gpu_set_blendmode_ext(bm_one, bm_zero);

			shader_set(shd_Blur1Pass);
			shader_set_uniform_f(usize, global.GuiW, global.GuiH, 3);
			surface_set_target(bloom_surface2);
			draw_clear_alpha(c_black, 0);
			draw_surface_stretched(application_surface, 0, 0, global.GuiW, global.GuiH);
			surface_reset_target();
			shader_reset();

			shader_set(shd_Blur2Pass);
			shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "texel_size"), 1 / global.GuiW, 1 / global.GuiH);
			shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_radius"), 1.5);
			shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_vector"), 1, 0);
			surface_set_target(post_surface);
			draw_clear_alpha(c_black, 0);
			draw_surface(bloom_surface2, 0, 0);
			surface_reset_target();

			shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_vector"), 0, 1);
			surface_set_target(bloom_surface2);
			draw_clear_alpha(c_black, 0);
			draw_surface(post_surface, 0, 0);
			surface_reset_target();
			shader_reset();
			gpu_set_blendmode(bm_normal);
			draw_set_color(blur_draw_color);
			draw_set_alpha(blur_draw_alpha);
			scene_surface = bloom_surface2;
		}

		// This shader also handles vignette, aberration, blur and saturation.
		shader_set(shader_bloom_blend);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);

		shader_set_uniform_f(u_bloom_intensity, shader_bloom_intensity);
		shader_set_uniform_f(u_bloom_darken, shader_bloom_darken);
		shader_set_uniform_f(u_bloom_saturation, shader_bloom_saturation);
		shader_set_uniform_f(u_bloom_texel_size, 1 / global.GuiW, 1 / global.GuiH);
		shader_set_uniform_f(u_bloom_neighbor_strength, shader_bloom_neighbor_strength);
		shader_set_uniform_f(u_bloom_neighbor_radius, bloom_neighbor_radius);
		shader_set_uniform_f(u_bloom_blend_threshold, bloom_threshold);
		shader_set_uniform_f(u_bloom_blend_range, bloom_range);
		texture_set_stage(u_bloom_texture, surface_get_texture(bloom_surface1));


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
				draw_surface_stretched(scene_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();
				if(global.bloom_shader){
					gpu_set_blendmode(bm_add);
					draw_set_alpha(bloom_intensity);
					draw_surface_stretched(bloom_surface1, 0, 0, global.GuiW, global.GuiH);
					draw_set_alpha(1);
					gpu_set_blendmode(bm_normal);
				}

				surface_reset_target();

				if(global.local_player.ToggleNightVision){
					surface_set_target(haze_final_surface);
					draw_clear_alpha(c_black, 0);
					shader_set(shd_NightVision);
					shader_set_uniform_f(shader_get_uniform(shd_NightVision, "u_resolution"), surface_get_width(post_surface), surface_get_height(post_surface));
					shader_set_uniform_f(shader_get_uniform(shd_NightVision, "intensity_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, INDEX.slot_id], ITEMSTATS.NightVisionIntensityPower]);
					shader_set_uniform_f(shader_get_uniform(shd_NightVision, "noise_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, INDEX.slot_id], ITEMSTATS.NightVisionNoisePower]);
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

		shader_set(shader_bloom_blend);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
		shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);

		shader_set_uniform_f(u_bloom_intensity, shader_bloom_intensity);
		shader_set_uniform_f(u_bloom_darken, shader_bloom_darken);
		shader_set_uniform_f(u_bloom_saturation, shader_bloom_saturation);
		shader_set_uniform_f(u_bloom_texel_size, 1 / global.GuiW, 1 / global.GuiH);
		shader_set_uniform_f(u_bloom_neighbor_strength, shader_bloom_neighbor_strength);
		shader_set_uniform_f(u_bloom_neighbor_radius, bloom_neighbor_radius);
		shader_set_uniform_f(u_bloom_blend_threshold, bloom_threshold);
		shader_set_uniform_f(u_bloom_blend_range, bloom_range);
		texture_set_stage(u_bloom_texture, surface_get_texture(bloom_surface1));

		draw_surface_stretched(scene_surface, 0, 0, global.GuiW, global.GuiH);
		shader_reset();
		if(global.bloom_shader){
			gpu_set_blendmode(bm_add);
			draw_set_alpha(bloom_intensity);
			draw_surface_stretched(bloom_surface1, 0, 0, global.GuiW, global.GuiH);
			draw_set_alpha(1);
			gpu_set_blendmode(bm_normal);
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
				global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, INDEX.slot_id], ITEMSTATS.NightVisionIntensityPower]
			);
			shader_set_uniform_f(
				shader_get_uniform(shd_NightVision, "noise_strength"), 
				global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, INDEX.slot_id], ITEMSTATS.NightVisionNoisePower]
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
				shader_set_uniform_f(shader_get_uniform(shd_NightVision, "intensity_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, INDEX.slot_id], ITEMSTATS.NightVisionIntensityPower]);
				shader_set_uniform_f(shader_get_uniform(shd_NightVision, "noise_strength"), global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, INDEX.slot_id], ITEMSTATS.NightVisionNoisePower]);
				draw_surface_stretched(nightvision_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();
			}else if(global.local_player.ToggleInfraVision){
				shader_set(shd_InfraVisionSurface);
				shader_set_uniform_f(shader_get_uniform(shd_InfraVisionSurface, "u_resolution"), global.GuiW, global.GuiH);
				draw_surface_stretched(nightvision_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();
			}else{
				shader_set(shader_bloom_blend);
				shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
				shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
				shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
				shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);
				shader_set_uniform_f(u_bloom_intensity, shader_bloom_intensity);
				shader_set_uniform_f(u_bloom_darken, shader_bloom_darken);
				shader_set_uniform_f(u_bloom_saturation, shader_bloom_saturation);
				shader_set_uniform_f(u_bloom_texel_size, 1 / global.GuiW, 1 / global.GuiH);
				shader_set_uniform_f(u_bloom_neighbor_strength, shader_bloom_neighbor_strength);
				shader_set_uniform_f(u_bloom_neighbor_radius, bloom_neighbor_radius);
				shader_set_uniform_f(u_bloom_blend_threshold, bloom_threshold);
				shader_set_uniform_f(u_bloom_blend_range, bloom_range);
				texture_set_stage(u_bloom_texture, surface_get_texture(bloom_surface1));

				draw_surface_stretched(scene_surface, 0, 0, global.GuiW, global.GuiH);
				shader_reset();
				if(global.bloom_shader){
					gpu_set_blendmode(bm_add);
					draw_set_alpha(bloom_intensity);
					draw_surface_stretched(bloom_surface1, 0, 0, global.GuiW, global.GuiH);
					draw_set_alpha(1);
					gpu_set_blendmode(bm_normal);
				}
			}

			surface_reset_target();
		}
		#endregion
		
}
