// Step Event of oCamera
if(instance_exists(oPlayer)){
	var PlayerVelocity = sqrt(power(oPlayer.XSpeed, 2) + power(oPlayer.YSpeed, 2)) * game_get_speed(gamespeed_fps);
	var rotation_increment = 0;
	var max_rotation = 0;
	if (oDraw.PauseMenu == false && oDraw.RespawnMenu == false) {
	    if (oPlayer.player_can_shoot == true && !global.my_console[? "active"]) {
			PlayerVelocity = sqrt(power(oPlayer.XSpeed, 2) + power(oPlayer.YSpeed, 2)) * game_get_speed(gamespeed_fps);
			rotation_increment = PlayerVelocity/5000;
			max_rotation = PlayerVelocity/750;
			if(oPlayer.moving_state == player_states.none_state || oPlayer.moving_state == player_states.prone_state){
			if (keyboard_check(ord("A"))) {
			    if (rotation_target > -max_rotation && rotation_direction == 1) {
			        rotation_target -= rotation_increment;
			        if (rotation_target <= -max_rotation) {
			            rotation_direction = -1;
			        }
			    } else {
			        rotation_target += rotation_increment;
			        if (rotation_target >= max_rotation) {
			            rotation_direction = 1;
			        }
			    }
			} else if (keyboard_check(ord("D"))) {
			    if (rotation_target < max_rotation && rotation_direction == 1) {
			        rotation_target += rotation_increment;
			        if (rotation_target >= max_rotation) {
			            rotation_direction = -1;
			        }
			    } else {
			        rotation_target -= rotation_increment;
			        if (rotation_target <= -max_rotation) {
			            rotation_direction = 1;
			        }
			    }
			} else if (keyboard_check(ord("W"))) {
			    if (rotation_target > -max_rotation && rotation_direction == 1) {
			        rotation_target -= rotation_increment;
			        if (rotation_target <= -max_rotation) {
			            rotation_direction = -1;
			        }
			    } else {
			        rotation_target += rotation_increment;
			        if (rotation_target >= max_rotation) {
			            rotation_direction = 1;
			        }
			    }
			} else if (keyboard_check(ord("S"))) {
			    if (rotation_target < max_rotation && rotation_direction == 1) {
			        rotation_target += rotation_increment;
			        if (rotation_target >= max_rotation) {
			            rotation_direction = -1;
			        }
			    } else {
			        rotation_target -= rotation_increment;
			        if (rotation_target <= -max_rotation) {
			            rotation_direction = 1;
			        }
			    }
            } 
			}
			
			if(oPlayer.Moving == false){
				rotation_target = 0;
            }

	        // Smooth rotation transition
	        rotation_angle = lerp(rotation_angle, rotation_target, Speed);
	        var target_x = Object.x;
	        var target_y = Object.y;

			camera_set_view_angle(view_camera[0], camera_get_view_angle(view_camera[0]) + rotation_angle);
	        camera_set_xy(target_x, target_y, mouse_x, mouse_y, Speed);
        } else {
            rotation_target = 0;
            rotation_angle = 0;
            camera_set_view_angle(view_camera[0], 0);
        }
    } else {
        rotation_target = 0;
        rotation_angle = 0;
        camera_set_view_angle(view_camera[0], 0);
    }
}


