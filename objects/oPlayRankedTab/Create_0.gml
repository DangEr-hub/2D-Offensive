event_inherited();
global.ranked_game = true;
play_unranked_tab_width = 720 * global.GUIMultiplier;
play_unranked_tab_height = 405 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(play_unranked_tab_width, play_unranked_tab_height);

unranked_description_string = "Commit to a full scale match\nwhich affects your eggy points.\nEnemies have eggy points in\ncorrelation with your eggy points.";
checkbox_gap = 8 * global.GUIMultiplier;
hard_mode_checkbox_width = 16 * global.GUIMultiplier;
hard_mode_checkbox_height = 16 * global.GUIMultiplier;
map_play_button_width = 64 * global.GUIMultiplier;
map_play_button_height = 16 * global.GUIMultiplier;
map_image_sprite_height = 64 * global.GUIMultiplier;
map_image_sprite_width = 128 * global.GUIMultiplier;
map_image_position_x = 32;
map_image_position_y = 64;
map_image_gap = map_image_sprite_width * 1.1;

if(global.MapID != -1){
	global.map_rounds[global.MapID][0] = global.rating_struct.Rounds_win;
	global.map_rounds[global.MapID][1] = global.rating_struct.Rounds_lost;
	global.rating_struct.Rounds_win = 0;
	global.rating_struct.Rounds_lost = 0;	
}

for(var j=0;j<MapIndex.Total;j++){
	map_name_array[j] = global.MapProperties[#j, MapProperty.Name];	
}


map_callbacks = [
    function() { 
		set_map_rounds(MapIndex.Desert);
		room_goto(rm_Desert);
	},
    function() { 
		set_map_rounds(MapIndex.RainForest);
		room_goto(rm_RainForest); 
	},
    function() { 
		set_map_rounds(MapIndex.City);
		room_goto(rm_Desert); 
	},
    function() { 
		set_map_rounds(MapIndex.Nuclear);
		room_goto(rm_Desert); 
	}
];

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Play ranked game";
	draggable = 1;
}

for(i=0;i<4;i++){
	with (zui_create(map_image_position_x + i*map_image_gap, map_image_position_y, objUIImage)){
		zui_set_anchor(0, 0);
		sprite = spr_MapImage;
		sprite_image_index = other.i;
		sprite_width_size = other.map_image_sprite_width;
		sprite_height_size = other.map_image_sprite_height;
	}
	
	with (zui_create(map_image_position_x + (map_image_sprite_width)/2 - string_width(map_name_array[i])/2 + i*map_image_gap, map_image_position_y + map_image_sprite_height * 1.1, objUILabel)) {
		color = c_dkgray;
		caption = other.map_name_array[other.i];
	}
	
	with (zui_create(map_image_position_x + (map_image_sprite_width)/2 - map_play_button_width/2 + i*map_image_gap, map_image_position_y + map_image_sprite_height * 1.25, objUIButton)) {
		zui_set_anchor(0, 0);
		zui_set_size(other.map_play_button_width, other.map_play_button_height);

		caption = "Play!";
		callback = other.map_callbacks[other.i];
	}
}

with (zui_create(play_unranked_tab_width * .85, 64, objUICheckbox)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.hard_mode_checkbox_width, other.hard_mode_checkbox_height);
	value = global.hard_mode;
	value_type = "hard_mode";
	callback = function(){
		value = !value;
		global.hard_mode = value;
	};
}

with (zui_create(play_unranked_tab_width * .85 + hard_mode_checkbox_width + checkbox_gap, 64 + hard_mode_checkbox_height/2, objUILabel)) {
	color = c_white;
	caption = "Hardmode";
}

with (zui_create(play_unranked_tab_width * .5, zui_get_height() - 16 - string_count_lines(unranked_description_string)*string_height("a"), objUILabel)) {
	color = c_white;
	caption = other.unranked_description_string;
}

