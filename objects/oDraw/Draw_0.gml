if(global.draw_other_models == true){
	draw_spawn_areas(global.MapID);
}
if(PauseMenu == true || RespawnMenu == true){
	if (BackGround != -1) {
		shader_set(shd_Blur1Pass);
		shader_set_uniform_f(usize, 32, 32, 0.1);
		draw_sprite_ext(BackGround, 0, camera_get_view_x(CAMERA), camera_get_view_y(CAMERA), global.CameraWidth/sprite_get_width(BackGround), global.CameraHeight/sprite_get_height(BackGround), 0, c_white, 1);
		shader_reset();	
	}	
}