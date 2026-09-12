
var bomb_areas = global.MapProperties[# global.MapID, MAP_STAT.BombAreas];

if (ds_exists(bomb_areas, ds_type_map)) {
	var old_color = draw_get_color();
	var old_alpha = draw_get_alpha();
	var area_key = ds_map_find_first(bomb_areas);

	while (!is_undefined(area_key)) {
		var area = bomb_areas[? area_key];

		if (is_array(area) && array_length(area) >= 4) {
			draw_set_color(c_red);
			draw_set_alpha(0.05);
			draw_rectangle(area[0], area[1], area[2], area[3], false);

			draw_set_alpha(0.75);
			draw_rectangle(area[0], area[1], area[2], area[3], true);
		}

		area_key = ds_map_find_next(bomb_areas, area_key);
	}

	draw_set_color(old_color);
	draw_set_alpha(old_alpha);
}

var hostage_areas = global.MapProperties[# global.MapID, MAP_STAT.HostageAreas];

if (ds_exists(hostage_areas, ds_type_map)) {
	var old_color = draw_get_color();
	var old_alpha = draw_get_alpha();
	var area_key = ds_map_find_first(hostage_areas);

	while (!is_undefined(area_key)) {
		var area = hostage_areas[? area_key];

		if (is_array(area) && array_length(area) >= 4) {
			draw_set_color(c_lime);
			draw_set_alpha(0.1);
			draw_rectangle(area[0], area[1], area[2], area[3], false);

			draw_set_alpha(0.75);
			draw_rectangle(area[0], area[1], area[2], area[3], true);
		}

		area_key = ds_map_find_next(hostage_areas, area_key);
	}

	draw_set_color(old_color);
	draw_set_alpha(old_alpha);
}