// Step Event of oCamera
if(global.local_player != -1 && instance_exists(oDraw)){
	if (oDraw.PauseMenu == false && oDraw.RespawnMenu == false) {
	    if (global.local_player.player_can_shoot == true && !global.my_console[? "active"]) {
	        camera_set_xy(global.local_player.x, global.local_player.y, mouse_x, mouse_y, Speed);
        }
    }
}


