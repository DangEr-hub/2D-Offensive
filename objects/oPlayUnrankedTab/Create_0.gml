event_inherited();
global.ranked_game = false;
play_unranked_tab_width = 720 * global.GUIMultiplier;
play_unranked_tab_height = 405 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(play_unranked_tab_width, play_unranked_tab_height);

unranked_description_string = "Commit to a full scale match\nwithout worrying to loose any eggy points.\nEnemies have randomized eggy points.";
checkbox_gap = 8 * global.GUIMultiplier;
hard_mode_checkbox_width = 16 * global.GUIMultiplier;
hard_mode_checkbox_height = 16 * global.GUIMultiplier;
map_play_button_width = 64 * global.GUIMultiplier;
map_play_button_height = 16 * global.GUIMultiplier;
map_name_array = ["Dust", "Cache"];
map_image_sprite_height = 64 * global.GUIMultiplier;
map_image_sprite_width = 128 * global.GUIMultiplier;
map_image_position_x = 32;
map_image_position_y = 64;
map_image_gap = map_image_sprite_width * 1.1;


map_callbacks = [
    function() { room_goto(rm_Desert); },
    function() { room_goto(rm_RainForest); },
];

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Play unranked game";
	draggable = 1;
}

for(i=0;i<array_length(map_callbacks);i++){
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
