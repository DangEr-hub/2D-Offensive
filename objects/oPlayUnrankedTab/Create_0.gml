zui_set_size(1440, 810);

map_name_array = ["Dust", "Cache", "Nuke", "Mirage"];
map_image_sprite_height = 64 * global.GUIMultiplier;
map_image_sprite_width = 128 * global.GUIMultiplier;
map_image_position_x = 32;
map_image_position_y = 64;
map_image_gap = map_image_sprite_width * 1.1;


new_game_callback = function (){
	room_goto(rm_Test);	
}

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Play unranked game";
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
	
	with (zui_create(map_image_position_x + (map_image_sprite_width)/2 + i*map_image_gap, map_image_position_y + map_image_sprite_height * 1.1, objUILabel)) {
		caption = other.map_name_array[other.i];
	}
}

with (zui_create(12, 38, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(120, 32);

	caption = "Jsem gay";
	//callback = other.test_callback;
}

with (zui_create(140, 38, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(120, 32);

	caption = "Play";
	callback = other.new_game_callback;
}

with (zui_create(268, 38, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(120, 32);

	caption = "Button 3";
	//callback = other.test_callback;
}

with (zui_create(12, 82, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(376, 80);

	caption = "Button 4";
	//callback = other.test_callback;
}

with (zui_create(12, 170, objUICheckbox)) {
	zui_set_anchor(0, 0);
}

with (zui_create(36, 170, objUICheckbox)) {
	zui_set_anchor(0, 0);
	value = 1;
}

with (zui_create(60, 170, objUISlider)) {
	zui_set_anchor(0, 0);
	zui_set_width(128);

	minimum = 4;
	maximum = 8;
	value = 6;
}

with (zui_create(196, 170, objUISlider)) {
	zui_set_anchor(0, 0);
	zui_set_width(192);
	minimum = 0;
	maximum = 100;
	value = 80;
}

with (zui_create(zui_get_width() * 0.5, zui_get_height() - 16, objUILabel)) {
	other.position_label = id;
}

