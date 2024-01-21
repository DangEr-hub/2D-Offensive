if(PauseMenu == true && RespawnMenu == false){
	if(Alpha >= 0 && Alpha < 1){
		Alpha += .01;
	}	
	if (BackGround != -1) {
		shader_set(shd_Blur);
		shader_set_uniform_f(usize, 32, 32, 0.1);
	    draw_sprite_ext(BackGround, 0, camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), global.CameraWidth/sprite_get_width(BackGround), global.CameraHeight/sprite_get_height(BackGround), 0, c_white, 1);
	    shader_reset();		
	}	
}