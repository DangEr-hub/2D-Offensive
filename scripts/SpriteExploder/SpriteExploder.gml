function sprite_explode(MaxL, MinL, MaxS, MinS, MaxPS, MinPS, Spin, FadeO, FadeA, FadeTC, EndColor, ColorFadeSpeed, Implode, Index){


	/* Get sprite width and height
	This is used to run through the for loop
	and get each peice of the sprite
	*/
	ww = sprite_get_width(sprite_index);
	hh = sprite_get_height(sprite_index);


	/* Get sprite offset
	This is used to make sure that the particles being
	created are ALWAYS aligned with the the sprite
	*/
	xoff = sprite_get_xoffset(sprite_index);
	yoff = sprite_get_yoffset(sprite_index);


	// Create the particle
	for (i = 0; i < ww; i += MaxPS) {
	    for (j = 0; j < hh; j += MaxPS) {
	        particle = instance_create_depth((x - xoff) + i, (y - yoff) + j, oParticleSurface.depth, oParticle);  // Create the particle
			particle.Breakable = true;
	        particle.spr = sprite_index;                                                    // Set the sprite
	        particle.size = irandom_range(MaxPS, MinPS);                            // Give it a random size inside a range
	        particle.max_life = MaxL;                                                  // Setup life variables
	        particle.min_life = MinL;                                                  // Determines how long the particle is alive
	        particle.min_speed = MaxS;                                                 // Setup speed variable
	        particle.max_speed = MinS;                                                 // Determines how fast the particle moves
	        particle.spin = Spin;                                                      // Rotate the sprite
	        particle.fade = FadeO;                                                      // TRUE OR FALSE! to fade or not to fade, that is the question.
	        particle.fade_amt = FadeA;                                                  // How fast to fade the particle
	        particle.fade_to_color = FadeTC;                                             // TRUE OR FALSE! fade to a different color
	        particle.end_color = EndColor;                                                // What color do you want to fade to?
	        particle.color_fader = ColorFadeSpeed;                                              // How fast do you want to fade
	        particle.implode = Implode;													// TRUE OR FALSE! 
			particle.index = Index;
	        particle.center_x = x;                                                          // Center of sprite
	        particle.center_y = y;                                                          // Center of sprite
	        particle.xx = i;                                                                // X
	        particle.yy = j;                                                                // Y
	    }
	}
}
	