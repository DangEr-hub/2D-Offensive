image_xscale -= sizeChange;
image_yscale  = image_xscale;
if (movSpd > 0){
    image_alpha -= random_range(0.05, 0.1);
}
movSpd = approach(movSpd, 0, fric);
if (image_xscale <= 0){
    instance_destroy();
}
if(instance_exists(oParticleSurface)){
	if(surface_exists(oParticleSurface.ParticleSurface)){
		surface_set_target(oParticleSurface.ParticleSurface);
		draw_self();
		surface_reset_target();
		//instance_destroy(self);
	}
}


