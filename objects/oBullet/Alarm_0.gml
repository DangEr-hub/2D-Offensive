if(global.draw_other_models == true){
	if(instance_exists(oParticleSurface)){
		if(surface_exists(oParticleSurface.ParticleSurface)){
			surface_set_target(oParticleSurface.ParticleSurface);
			draw_set_color(c_aqua);
			draw_circle(x, y, 1, false);
			draw_set_color(c_white);
			draw_sprite(spr_Bullet, 1, x, y);
			surface_reset_target();
		}
	}
}

if(global.DrawBulletImpact == true){
	if(instance_exists(oParticleSurface)){
		if(surface_exists(oParticleSurface.ParticleSurface)){
			surface_set_target(oParticleSurface.ParticleSurface);
			draw_self();
			surface_reset_target();
		}
	}
}

instance_destroy(id);