if(global.draw_other_models == true){
	draw_spawn_areas(global.MapID);
}

if(PauseMenu == true || RespawnMenu == true){
	if (BackGround > 0) {
		draw_sprite_ext(BackGround, 0, camera_get_view_x(CAM), camera_get_view_y(CAM), global.CameraWidth/sprite_get_width(BackGround), global.CameraHeight/sprite_get_height(BackGround), 0, c_white, 1);
	}	
}
