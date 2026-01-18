/* oBird step event */
var margin = 32;
if(x >= (room_width + margin) || x <= (0 - margin) || y >= (room_height + margin) || y <= (0 - margin)){
    if (IS_NET && oNetworkManager.is_server) {
        server_process_bird_death(id, 0, false);
        exit;
    }

    instance_destroy();
}


#region Knife hit
if(instance_exists(global.local_player)){
	var knife_object = instance_nearest(x, y, oKnife);
	if (instance_exists(knife_object) && instance_exists(knife_object.stats.Object) && knife_object.stats.Object_index == oPlayer && state == 0) {
		if (knife_object.stats.Object.knife_attack_timer >= 5) {
			var hitbox_corners = get_hitbox_corners(knife_object, 25, 50, 20, knife_object.stats.Object.RotationAngle);

			// Get the min and max x and y coordinates from the hitbox corners to define the bounding box
			var min_x = min(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
			var max_x = max(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
			var min_y = min(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);
			var max_y = max(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);

			if (collision_rectangle(min_x, min_y, max_x, max_y, id, true, false)) {
				var damage = knife_object.stats.Damage;
				var BloodSplashNumber = ceil(damage / 5);
				var BloodParticleNumber = ceil(damage / 2);
				create_blood(BloodSplashNumber, x, y, c_red, BloodParticleNumber);

				play_sound(x, y, snd_BirdDeath, global.local_player);
				instance_destroy(id);
			}
		}
	}
}
#endregion

if (state == 0) { 
    var can_choose_target = true;

	// Jen server vybírá místo k pohybu
    if (IS_NET && !oNetworkManager.is_server && !is_local) {
        can_choose_target = false;
    }
	
    if (move_timer == -1 && can_choose_target == true) {
        move_timer = irandom_range(1, 2) * game_get_speed(gamespeed_fps);
        
        var tries = 10;
        repeat (tries) {
            move_pos[0] = x + random_range(-96, 96);
            move_pos[1] = y + random_range(-96, 96);
            
            if (!place_meeting(move_pos[0], move_pos[1], oParentTile)) {
                break; // Našli jsme volné místo
            }
        }
		
        if (IS_NET && oNetworkManager.is_server) {
            server_process_bird_change(id, 3);
        }
    }

    if (move_timer > -1) {
        if (distance_to_point(move_pos[0], move_pos[1]) > 8) {
            image_angle = point_direction(x, y, move_pos[0], move_pos[1]);

            // Kontrola, jestli není překážka na cestě
            if !(collision_line(x, y, move_pos[0], move_pos[1], oParentTile, true, false)) {
                move_towards_point(move_pos[0], move_pos[1], walk_spd);
            }
        }
        move_timer--;
    }

    image_speed = walk_spd * 0.4;
}



