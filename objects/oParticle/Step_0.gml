/// @description Insert description here
// You can write your code in this editor
if(Breakable == false){
	speed *= fric;

	if(Stay == false){
		if(image_index >= image_number - 1 || speed <= 0){
			image_alpha -= 1/FadeAwayTimer;
		}
		if(image_alpha <= 0){
			instance_destroy(self);
		}
	}else{	
		if(image_index >= image_number - 1 || speed <= 0){
			if(instance_exists(oParticleSurface)){
				if(surface_exists(oParticleSurface.ParticleSurface)){
					surface_set_target(oParticleSurface.ParticleSurface);
					gpu_set_tex_filter(true);
					draw_self();
					gpu_set_tex_filter(false);
					surface_reset_target();
					instance_destroy(self);
				}
			}
		}
	
	}
}else{
	// runonce
	if (runonce == 0) {
	    // Give the particle motion
	    direction = random(360);
	    spd = random_range(max_speed,min_speed);
	    motion_set(direction,spd);
	    // Give the particle life within a range
	    life = irandom_range(max_life, min_life);
	    // Give the particle a random spin speed based off the one provided
	    spin_speed = irandom(spin);
	    // Give the particle a random fade speed based off the one provided
	    fading = random(fade_amt);
	    // Give the particle a random blend speed based off the one provided
	    fader = random(color_fader);
	    runonce = 1;
	}
	// Implode the sprite
	if (implode == 1) {
	    if (spd > 0) motion_set(direction,spd);     // Normal, explode outward
	    if (spd < 0) {
	        move_towards_point(center_x, center_y, -spd);                               // Move towards the center of the sprite
	        if (point_distance(x,y, center_x, center_y) < abs(spd)){
				if(instance_exists(oParticleSurface)){
					if(surface_exists(oParticleSurface.ParticleSurface)){
						surface_set_target(oParticleSurface.ParticleSurface);
						gpu_set_tex_filter(true);
						draw_sprite_general(spr, index, xx, yy, size, size, x, y, image_xscale, image_yscale, rotation, current_color, current_color, current_color, current_color, alpha);
						gpu_set_tex_filter(false);
						surface_reset_target();
						instance_destroy(self);
					}
				}
			}
	    }
	    spd = spd - current_speed_subtract;     // Make the speed slower and slower until negative
	    current_speed_subtract += speed_sub;    // Make the amount subtracted from the speed higher
	}


	// Life
	if (life <= 0) {
		if(instance_exists(oParticleSurface)){
			if(surface_exists(oParticleSurface.ParticleSurface)){
				surface_set_target(oParticleSurface.ParticleSurface);
				gpu_set_tex_filter(true);
				draw_sprite_general(spr, index, xx, yy, size, size, x, y, image_xscale, image_yscale, rotation, current_color, current_color, current_color, current_color, alpha);
				gpu_set_tex_filter(false);
				surface_reset_target();
				instance_destroy(self);
			}
		}
	} else {
	    life--;
	}

	// Rotate the particle
	rotation += spin_speed;

	// Fade the particle
	if (fade == 1) {
	    alpha -= fading;                    // take away from the alpha value
	    if (alpha <= 0){
			if(instance_exists(oParticleSurface)){
				if(surface_exists(oParticleSurface.ParticleSurface)){
					surface_set_target(oParticleSurface.ParticleSurface);
					gpu_set_tex_filter(true);
					draw_sprite_general(spr, index, xx, yy, size, size, x, y, image_xscale, image_yscale, rotation, current_color, current_color, current_color, current_color, alpha);
					gpu_set_tex_filter(false);
					surface_reset_target();
					instance_destroy(self);
				}
			}
		}
	}

	// Blend the Colors
	if (fade_to_color == 1) {
	    current_color = merge_color(c_white, end_color, current_color_fade);    // Make the color
	    current_color_fade += fader;                                            // Add to the blend amt
	    if (current_color_fade >= 1) current_color_fade = 1;                    // Cap the blend amount
	    if (current_color_fade <= 0) current_color_fade = 0;                    // Cap the blend amount
	}

}

if(Bounce == true){
	if(place_meeting(x, y, oParentTile)){
		move_bounce_all(true);
	}
}

if (sprite_index == spr_RainSplash){
    switch (RainPhase){
        // =====================
        // PADÁNÍ Z NEBE
        // =====================
        case 0:
            z_height -= fall_speed;

            // simulace vzdálení od kamery
            var sc = clamp(z_height / 30, 0.2, 1.25);
            image_xscale = sc;
            image_yscale = sc;
			image_blend = c_white;

            if (z_height <= 0)
            {
                RainPhase = 1;
                image_index = 1;
            }
        break;

        // =====================
        // SPLASH NA ZEMI
        // =====================
        case 1:
			image_index += .1;
			image_blend = c_white;
            if (image_index >= 4 || image_alpha <= 0){
				part_particles_create(global.ParticleSystem, x, y, oParticleSystem.rain_particle, 5);
                instance_destroy();
			}
        break;
    }
}
