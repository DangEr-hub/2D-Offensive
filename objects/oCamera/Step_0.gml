if(instance_exists(oPlayer) && oDraw.PauseMenu == false && oDraw.RespawnMenu == false){
	if (oPlayer.player_can_shoot == true) {
		var xx = (device_mouse_x_to_gui(0) * oDraw.ViewW / global.GuiW) + oDraw.ViewX;
		var yy = (device_mouse_y_to_gui(0) * oDraw.ViewH / global.GuiH) + oDraw.ViewY;
		camera_set_xy(Object.x, Object.y, mouse_x, mouse_y, Speed);			
	}
}