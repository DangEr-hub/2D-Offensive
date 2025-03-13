function is_player_nearby_area(area) {
    var player = instance_nearest((area[0] + area[2]) / 2, (area[1] + area[3]) / 2, oPlayer);
    var distance = DEACTIVATE_MARGIN + 1;
	
    if (player != noone) {
        var player_x = player.x;
        var player_y = player.y;
        
        var left_border = area[0] - distance;
        var right_border = area[2] + distance;
        var top_border = area[1] - distance;
        var bottom_border = area[3] + distance;
        
        if (player_x >= left_border && player_x <= right_border && player_y >= top_border && player_y <= bottom_border) {
            return true;
        }
    }
    
    return false;
}

function is_place_free(xx, yy) {
    var spawn_radius = 64;
    var collision_free = true;

    for (var dx = -spawn_radius; dx <= spawn_radius; dx += 1) {
        for (var dy = -spawn_radius; dy <= spawn_radius; dy += 1) {
            if (place_meeting(xx + dx, yy + dy, oParentTile)) {
                collision_free = false;
                break;
            }
        }
        if (!collision_free) break;
    }

    return collision_free;
}

function spawn_enemies(map_index) {
    var spawn_areas = global.MapProperties[# map_index, MapProperty.SpawnAreas];
    var area_keys = ds_map_keys_to_array(spawn_areas);
    var num_areas = array_length(area_keys);

    // Get the maximum number of enemies for this map
    var max_enemies = global.MapProperties[# map_index, MapProperty.MaxEnemies];
    var enemies_to_spawn = max_enemies;

    for (var j = 0; j < num_areas; j += 1) {
        var area_key = area_keys[j];
        var area = spawn_areas[? area_key];
        var area_max_enemies = area[4]; // The fifth element is the max number of enemies for this area

        //if(is_player_nearby_area(area)){
	        var enemies_in_area = min(area_max_enemies, enemies_to_spawn);
	        enemies_to_spawn -= enemies_in_area;

	        for (var i = 0; i < enemies_in_area; i += 1) {
	            var spawn_x = 0;
				var spawn_y = 0;
	            var attempts = 0;
	            var max_attempts = 100; // Limit the number of attempts to find a valid point

	            repeat (max_attempts) {
	                // Generate a random point within the chosen area
	                spawn_x = irandom_range(area[0], area[2]);
	                spawn_y = irandom_range(area[1], area[3]);

	                // Check if the point is valid
	                if (is_place_free(spawn_x, spawn_y)) {
	                    break;
	                }
	                attempts += 1;
	            }

	            if (attempts < max_attempts) {
	                // Spawn the enemy at the valid point
	                instance_create_layer(spawn_x, spawn_y, "LivingO", oEnemy);
	            } else {
					return false;
	            }
	        }
		//}

        // If no more enemies need to be spawned, break out of the loop
        if (enemies_to_spawn <= 0) {
            break;
        }
    }
}

function draw_spawn_areas(map_index) {
    var spawn_areas = global.MapProperties[# map_index, MapProperty.SpawnAreas];
    var area_keys = ds_map_keys_to_array(spawn_areas);
    var num_areas = array_length(area_keys);

    // Set the drawing color and alpha
    draw_set_color(DEBUG_COLOR);
    draw_set_alpha(.1);

    // Draw each area as a rectangle
    for (var j = 0; j < num_areas; j += 1) {
        var area_key = area_keys[j];
        var area = spawn_areas[? area_key];

        var x1 = area[0];
        var y1 = area[1];
        var x2 = area[2];
        var y2 = area[3];

        draw_rectangle(x1, y1, x2, y2, false);
    }

    // Reset the drawing color and alpha
    draw_set_color(c_white);
    draw_set_alpha(1);
}
