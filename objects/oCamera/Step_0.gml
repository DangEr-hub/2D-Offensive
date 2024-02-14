if(instance_exists(oPlayer) && oDraw.PauseMenu == false && oDraw.RespawnMenu == false){
	if (oPlayer.player_can_shoot == true) {
		with(oCrosshair){
			if(distance_to_point(mouse_x, mouse_y) < 4){
				MousePositionX = mouse_x + x_offset;
				MousePositionY = mouse_y + y_offset;
			}else{
				MousePositionX = x + x_offset;
				MousePositionY = y + y_offset;
			}
		}
		camera_set_xy(Object.x, Object.y, mouse_x, mouse_y, Speed);			
	}
}