if(global.DrawParticles == true){
	if!(surface_exists(ParticleSurface)){
		ParticleSurface = surface_create(room_width, room_height);
		surface_set_target(ParticleSurface);
		draw_clear_alpha(0, 0);
		surface_reset_target();
	}
	if(surface_exists(ParticleSurface)){
	    draw_surface(ParticleSurface, 0, 0);
	}
}else{
	if(surface_exists(ParticleSurface)){
		surface_set_target(ParticleSurface);
		draw_clear_alpha(0, 0);
		surface_reset_target();
		surface_free(ParticleSurface);
	}
}



