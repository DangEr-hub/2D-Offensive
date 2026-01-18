image_xscale -= sizeChange;
image_yscale  = image_xscale;
if(!is_gui){
	alphaChange = random_range(0.05, 0.1);
}
if (movSpd > 0){
    image_alpha -= alphaChange;
}
movSpd = approach(movSpd, 0, fric);
if (image_xscale <= 0 || image_alpha <= 0.2){
    instance_destroy();
}
if(instance_exists(oParticleSurface)){
	if(is_gui){
		if(surface_exists(oParticleSurface.gui_particle_surf)){
			surface_set_target(oParticleSurface.gui_particle_surf);
			draw_sprite_ext(
				sprite_index,
				image_index,
				gui_x,
				gui_y,
				image_xscale,
				image_yscale,
				image_angle,
				image_blend,
				image_alpha
			);
			surface_reset_target();
		}
	}else{
		if(surface_exists(oParticleSurface.ParticleSurface)){
			surface_set_target(oParticleSurface.ParticleSurface);
			draw_self();
			surface_reset_target();
		}
	}
}

