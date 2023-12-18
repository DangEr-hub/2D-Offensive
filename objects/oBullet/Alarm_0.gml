if(global.DrawBulletImpact == true){
	if(instance_exists(oParticleSurface)){
		if(surface_exists(oParticleSurface.ParticleSurface)){
			surface_set_target(oParticleSurface.ParticleSurface);
			draw_self();
			surface_reset_target();
			instance_destroy(self);
		}else{
			instance_destroy(self);
		}
	}
}else{
	instance_destroy(self);
}