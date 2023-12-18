/// @description Insert description here
// You can write your code in this editor
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

if(Bounce == true){
	if(place_meeting(x, y, oParentTile)){
		move_bounce_all(true);
	}
}