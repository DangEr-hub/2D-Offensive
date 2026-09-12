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

function get_bot_spawn_count(map_index, spawn_friendly) {
	var area_stat = spawn_friendly ? MAP_STAT.FriendAreas : MAP_STAT.EnemyAreas;
	var maximum_stat = spawn_friendly ? MAP_STAT.MaxFriends : MAP_STAT.MaxEnemies;
	var spawn_areas = global.MapProperties[# map_index, area_stat];
	if(!ds_exists(spawn_areas, ds_type_map)) return 0;

	var bot_count = 0;
	var area_keys = ds_map_keys_to_array(spawn_areas);
	for(var i = 0; i < array_length(area_keys); i++){
		var area = spawn_areas[? area_keys[i]];
		bot_count += area[4];
	}

	return min(bot_count, global.MapProperties[# map_index, maximum_stat]);
}

function initialize_bot_database(map_index) {
	if(array_length(global.BotMatchStats) > 0) return;

	var names = [
		"John", "Joe", "Jorge de Guzman", "Lalo Salamanca", "Elvis",
		"Stuart", "Lewis", "Tommy Hilfiger", "Hector", "Cortez",
		"Rico", "Nico", "Leo", "Mike", "Victor", "Alex", "Roman",
		"Oscar", "Bruno", "Marco", "Leon", "Tobias", "Frank", "Diego", "Henry"
	];
	var player_team = global.player_stats.Player_team;
	var enemy_team = player_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE;
	var friendly_count = get_bot_spawn_count(map_index, true);
	var enemy_count = get_bot_spawn_count(map_index, false);
	var total_count = friendly_count + enemy_count;

	for(var i = 0; i < total_count; i++){
		var bot_name = "Bot " + string(i + 1);
		if(array_length(names) > 0){
			var name_index = irandom(array_length(names) - 1);
			bot_name = names[name_index];
			array_delete(names, name_index, 1);
		}

		var bot_stats = create_enemy(
			88, [random_range(170, 200), random_range(70, 120)], irandom_range(25, 50),
			bot_name,
			85
		);
		bot_stats.Max_health_points = bot_stats.Health_points;
		bot_stats.Max_stamina_points = bot_stats.Stamina_points;
		bot_stats.Kills = 0;
		bot_stats.Assists = 0;
		bot_stats.Deaths = 0;
		bot_stats.Money = ROUND_STARTING_MONEY;
		bot_stats.Team = i < friendly_count ? player_team : enemy_team;
		array_push(global.BotMatchStats, bot_stats);
	}
}

function get_bot_database_stats(team, team_position) {
	var current_position = 0;
	for(var i = 0; i < array_length(global.BotMatchStats); i++){
		var bot_stats = global.BotMatchStats[i];
		if(bot_stats.Team != team) continue;

		if(current_position == team_position) return bot_stats;
		current_position++;
	}

	return undefined;
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
	var team_bot_position = 0;

	if(!IS_NET){
		initialize_bot_database(map_index);
	}

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
				if(!IS_NET){
					var database_stats = get_bot_database_stats(spawned_team, team_bot_position);
					if(!is_undefined(database_stats)){
						bot.stats = database_stats;
						bot.stats.Health_points = bot.stats.Max_health_points;
						bot.stats.Damage_health_points = bot.stats.Max_health_points;
						bot.stats.Stamina_points = bot.stats.Max_stamina_points;
						bot.stats.Damage_stamina_points = bot.stats.Max_stamina_points;
						bot.stats.Room = room;
					}
				}
				bot.stats.Team = spawned_team;
				bot.has_defuse_kit = spawned_team == TEAM.POLICE && percent_chance(25);
				bot.sprite_index = spawned_team == TEAM.TERRORIST
					? choose(spr_TerroristChar, spr_TerroristChar3, spr_TerroristChar2, spr_TerroristChar4)
					: choose(spr_PoliceChar, spr_PoliceChar2, spr_PoliceChar3);
				team_bot_position++;
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
