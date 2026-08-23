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

function spawn_bots(map_index, spawn_friendly = false) {
    var area_stat = spawn_friendly ? MAP_STAT.FriendAreas : MAP_STAT.EnemyAreas;
    var maximum_stat = spawn_friendly ? MAP_STAT.MaxFriends : MAP_STAT.MaxEnemies;
    var spawn_areas = global.MapProperties[# map_index, area_stat];
    if(!ds_exists(spawn_areas, ds_type_map)) return false;

    var area_keys = ds_map_keys_to_array(spawn_areas);
    var num_areas = array_length(area_keys);

    var bots_to_spawn = global.MapProperties[# map_index, maximum_stat];
    var player_team = instance_exists(global.local_player) ? global.local_player.stats.Team : TEAM.POLICE;
    var spawned_team = spawn_friendly
        ? player_team
        : (player_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE);

    for (var j = 0; j < num_areas; j += 1) {
        var area_key = area_keys[j];
        var area = spawn_areas[? area_key];
        var area_max_bots = area[4];

        //if(is_player_nearby_area(area)){
	        var bots_in_area = min(area_max_bots, bots_to_spawn);
	        bots_to_spawn -= bots_in_area;

	        for (var i = 0; i < bots_in_area; i += 1) {
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
	                var bot = instance_create_layer(spawn_x, spawn_y, "LivingO", oBot);
				bot.stats.Team = spawned_team;
				bot.sprite_index = spawned_team == TEAM.TERRORIST
					? choose(spr_TerroristChar, spr_TerroristChar3, spr_TerroristChar2, spr_TerroristChar4)
					: choose(spr_PoliceChar, spr_PoliceChar2, spr_PoliceChar3);
	            } else {
					return false;
	            }
	        }
		//}

        // If no more enemies need to be spawned, break out of the loop
        if (bots_to_spawn <= 0) {
            break;
        }
    }

	return true;
}

function draw_spawn_areas(map_index, draw_friendly = false) {
    var area_stat = draw_friendly ? MAP_STAT.FriendAreas : MAP_STAT.EnemyAreas;
    var spawn_areas = global.MapProperties[# map_index, area_stat];
    if(!ds_exists(spawn_areas, ds_type_map)) return;
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
