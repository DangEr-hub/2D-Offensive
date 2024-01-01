zui_set_size(1440, 810);

test_callback = function (_id) {
	//ui_show_popup(string(_id));
}

new_game_callback = function (){
	room_goto(rm_Test);	
}

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Play ranked game";
	draggable = 1;
}

with (zui_create(12, 38, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(120, 32);

	caption = "Jsem gay";
	callback = other.test_callback;
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
	callback = other.test_callback;
}

with (zui_create(12, 82, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(376, 80);

	caption = "Button 4";
	callback = other.test_callback;
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

for(i=0;i<10;i++){
	with (zui_create(12, 256 + (i*64), objUIImage)) {
		zui_set_anchor(0, 0);
		sprite = sprWindowPanel;
	}
}

with (zui_create(zui_get_width() * 0.5, zui_get_height() - 16, objUILabel)) {
	other.position_label = id;
}

