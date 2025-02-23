if(instance_exists(oPlayer) && (oPlayer.ToggleNightVision || oPlayer.ToggleInfraVision)) {
    if(!surface_exists(NightVisionSurface)){
        NightVisionSurface = surface_create(global.GuiW, global.GuiH);
    }
} else {
    if(surface_exists(NightVisionSurface)){
        surface_free(NightVisionSurface);
    }
}

var blur_intensity = 0;
var vignette_level = 1.05;
if(instance_exists(oPlayer)){
	aberration_level = global.aberration_level;
	saturation_level = global.saturation_level;
	if(oPlayer.stats.Health_points <= ceil(global.player_stats_struct.Max_health/2)){
		aberration_level = clamp(oPlayer.stats.Health_points/500, 0.01, 0.05);
		saturation_level = min(0 + oPlayer.stats.Health_points/100, global.saturation_level);
	}
	
	var vignette_aimpunch = 0;
	var vignette_explosion = 0;
	if(oPlayer.near_explosion == true){
		aberration_level = 0.02;
		vignette_explosion = 0.5;
	}
	
	if(oPlayer.AimPunchTimer > -1 || oPlayer.near_explosion == true){
		vignette_aimpunch = 0.25;
		blur_intensity = 0.05;
	}
	var hp_ratio = clamp(oPlayer.stats.Health_points / global.player_stats_struct.Max_health, 0, 1);
	var vignette_hp = lerp(1.1, 0, hp_ratio);
	vignette_level = 1.05 + vignette_explosion + vignette_aimpunch + vignette_hp;
}

if(global.BloomShader == true){
	if(!surface_exists(Surface1)){
	    Surface1 = surface_create(global.GuiW, global.GuiH);
	    bloom_texture = surface_get_texture(Surface1);
	    surface_set_target(Surface1);
	    draw_clear_alpha(0, 0);
	    draw_texture_flush();
	    surface_reset_target();
	}

	if(!surface_exists(Surface2)){
	    Surface2 = surface_create(global.GuiW, global.GuiH);
	    bloom_texture = surface_get_texture(Surface1);
	    surface_set_target(Surface1);
	    draw_clear_alpha(0, 0);
	    draw_texture_flush();
	    surface_reset_target();
	}
	
	surface_set_target(Surface1);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	surface_set_target(Surface2);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
}
if(instance_exists(oPlayer)){	
	if(oPlayer.player_has_scope != 0 ||(oPlayer.player_has_scope == 0 && oPlayer.ScopeIn == false)){

		if(global.BloomShader == true){
			// Bloom luminescence
			shader_set(shader_bloom_lum);
			shader_set_uniform_f(u_bloom_threshold, bloom_threshold);
			shader_set_uniform_f(u_bloom_range, bloom_range);
			surface_set_target(Surface1);
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

			surface_set_target(Surface2);
			draw_surface(Surface1, 0, 0);
			surface_reset_target();

			shader_set_uniform_f(u_blur_vector, 0, 1);
			surface_set_target(Surface1);
			draw_surface(Surface2, 0, 0);
			surface_reset_target();    
			gpu_set_tex_filter(false);	
			shader_reset();

			// Bloom blend effect
			shader_set(shader_bloom_blend);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "vignette_strength"), vignette_level);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "size"), 16, 16, blur_intensity);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "aberration_strength"), aberration_level);
			shader_set_uniform_f(shader_get_uniform(shader_bloom_blend, "color_saturation"), saturation_level);
				
			shader_set_uniform_f(u_bloom_intensity, bloom_intensity);
			shader_set_uniform_f(u_bloom_darken, bloom_darken);
			shader_set_uniform_f(u_bloom_saturation, bloom_saturation);
			texture_set_stage(u_bloom_texture, bloom_texture);
		}

		// Draw to the NightVisionSurface if night vision is toggled on
		if(oPlayer.ToggleNightVision || oPlayer.ToggleInfraVision) {
		    surface_set_target(NightVisionSurface);
		}
		    
		draw_surface_stretched(application_surface, 0, 0, global.GuiW, global.GuiH);
		
        
		if(global.BloomShader == true){
			// Bloom surface effect
			gpu_set_blendmode(bm_add);
			draw_surface_stretched(Surface1, 0, 0, global.GuiW, global.GuiH);
			gpu_set_blendmode(bm_normal);
			shader_reset();
		}
		
		if(oPlayer.ToggleNightVision || oPlayer.ToggleInfraVision) {
		    surface_reset_target();
		}

		// If night vision is toggled on, draw the NightVisionSurface with the shader
		if(oPlayer.ToggleNightVision) {
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
		    draw_surface_stretched(NightVisionSurface, 0, 0, global.GuiW, global.GuiH);
		    shader_reset();
		}else if(oPlayer.ToggleInfraVision){
		    shader_set(shd_InfraVisionSurface);
			shader_set_uniform_f(shader_get_uniform(shd_InfraVisionSurface, "u_resolution"),
				surface_get_width(application_surface),
				surface_get_height(application_surface)
			);
		    draw_surface_stretched(NightVisionSurface, 0, 0, global.GuiW, global.GuiH);
		    shader_reset();			
		}
			
		// Cleanup surfaces
		if((oPlayer.ToggleNightVision == false || oPlayer.ToggleInfraVision) && surface_exists(NightVisionSurface)){
			surface_free(NightVisionSurface);
		}
		
		if(global.BloomShader == false){
			surface_free(Surface1);	
			surface_free(Surface2);
		}
	}
}