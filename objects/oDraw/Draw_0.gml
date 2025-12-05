if(global.draw_other_models == true){
	draw_spawn_areas(global.MapID);
}

if(PauseMenu == true || RespawnMenu == true){
	if (BackGround > -1) {
		draw_sprite_ext(BackGround, 0, camera_get_view_x(CAMERA), camera_get_view_y(CAMERA), global.CameraWidth/sprite_get_width(BackGround), global.CameraHeight/sprite_get_height(BackGround), 0, c_white, 1);
	}	
}
