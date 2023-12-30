if(instance_exists(oPlayer)){
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
		//Camera(Object.x, Object.y, oCrosshair.MousePositionX, oCrosshair.MousePositionY, Speed);		
		Camera(Object.x, Object.y, mouse_x, mouse_y, Speed);			
	}
}else{
	Camera(room_width/2, room_height/2, mouse_x, mouse_y, Speed);	
	//Camera(room_width/2, room_height/2, mouse_x, mouse_y, Speed);	
}