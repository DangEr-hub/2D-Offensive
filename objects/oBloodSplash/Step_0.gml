var shrink = max(0, 1 - sizeChange / image_xscale);
image_xscale *= shrink;
image_yscale *= shrink;
if(!is_gui){
	alphaChange = random_range(0.05, 0.1);
}
if (movSpd > 0){
    image_alpha -= alphaChange;
}
movSpd = approach(movSpd, 0, fric);
if (image_xscale <= 0 || image_alpha <= 0.2 || (is_gui && movSpd <= 0)){
    instance_destroy();
	exit;
}
if(instance_exists(oParticleSurface)){
	if(is_gui){
		if(surface_exists(oParticleSurface.gui_particle_surf)){
			surface_set_target(oParticleSurface.gui_particle_surf);
			gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
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
			gpu_set_blendmode(bm_normal);
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

