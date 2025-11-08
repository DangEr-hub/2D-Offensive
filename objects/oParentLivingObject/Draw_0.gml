event_inherited();
if(Visible == true){
	
	if(global.local_player.ToggleInfraVision == true){
		shader_set(shd_InfraVision);
		shader_set_uniform_f(shader_get_uniform(shd_InfraVision, "u_intensity"), InfraVisionIntensity);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
		shader_reset();
	}else{
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, RotationAngle, image_blend, image_alpha);
	}
}