// Step Event of oCamera
if(instance_exists(oPlayer)){
	if (oDraw.PauseMenu == false && oDraw.RespawnMenu == false) {
	    if (oPlayer.player_can_shoot == true && !global.my_console[? "active"]) {
	        camera_set_xy(Object.x, Object.y, mouse_x, mouse_y, Speed);
        }
    }
}


