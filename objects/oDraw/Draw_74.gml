#region Player variables
var blur_intensity = 0;
var vignette_level = 0.75;
if(instance_exists(oPlayer)){
	if(global.local_player.ToggleNightVision == true || global.local_player.ToggleInfraVision == true) {
	    if(!surface_exists(nightvision_surface)){
	        nightvision_surface = surface_create(global.GuiW, global.GuiH);
	    }
	}
	aberration_level = global.aberration_level;
	saturation_level = global.saturation_level;
	if(global.local_player.stats.Health_points <= ceil(global.player_stats_struct.Max_health/2) && global.local_player.stats.Health_points > 0){
		aberration_level = clamp(global.local_player.stats.Health_points/500, 0.01, 0.05);
		saturation_level = min(0 + global.local_player.stats.Health_points/100, global.saturation_level);
	}
	
	var vignette_aimpunch = 0;
	var vignette_explosion = 0;
	if(global.local_player.near_explosion == true){
		aberration_level = 0.02;
		vignette_explosion = 0.5;
	}
	
	if(global.local_player.AimPunchTimer > -1 || global.local_player.near_explosion == true || global.local_player.in_water == true){
		vignette_aimpunch = 0.25;
		blur_intensity = 0.05;
	}
	var hp_ratio = clamp(global.local_player.stats.Health_points / global.player_stats_struct.Max_health, 0, 1);
	var vignette_hp = lerp(1.05, 0, hp_ratio);
	vignette_level = 0.75 + vignette_explosion + vignette_aimpunch + vignette_hp;
}
#endregion

if(instance_exists(oPlayer)){	
	if(global.local_player.player_has_scope != 0 ||(global.local_player.player_has_scope == 0 && global.local_player.ScopeIn == false)){

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
		
	}
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

