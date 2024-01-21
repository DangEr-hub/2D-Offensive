event_inherited();
pause_width_tab = 512 * global.GUIMultiplier;
pause_height_tab = 512 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(pause_width_tab, pause_height_tab);

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Paused";
	draggable = 1;
}

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	save_game();
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit game?", "Exit", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_main_menu_callback_positive, -1);	
};

button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .5, zui_get_height() * .1, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .1 + button_height*1.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}

with (zui_create(zui_get_width() * 0.5, zui_get_height() * .8, objUISlider)) {
	zui_set_anchor(0.5, 0);
	zui_set_width(256);

	minimum = 0;
	maximum = 100;
	value = global.sound_gain;
	type = "Volume";
	
	callback = function(_id, _value){
		audio_master_gain(value/100);
	};
}

draw_set_font(set_font("Console"));
with (zui_create(zui_get_width() * 0.5, zui_get_height() * .8 - string_height("a"), objUILabel)) {
	color = c_white;
	caption = "Volume gain";
}
	/*
with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*1.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(button_width);
	zui_set_height(button_height);
	caption = "Play ranked";
	callback = oController.play_ranked_callback;
}
	
with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*3, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(button_width);
	zui_set_height(button_height);
	caption = "Statistics";
	callback = oController.statistics_callback;
}
	
with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*4.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(button_width);
	zui_set_height(button_height);
	caption = "Weapons";
}
	
with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*6, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(button_width);
	zui_set_height(button_height);
	caption = "Options";
	callback = oController.exit_callback;
}
	
with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*7.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(button_width);
	zui_set_height(button_height);
	caption = "Keyboard input";
	callback = oController.exit_callback;
}
	
with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*9, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(button_width);
	zui_set_height(button_height);
	caption = "Exit";
	callback = oController.exit_callback;
}

with (zui_create(zui_get_width() * 0.5, zui_get_height() - 80, objUISlider)) {
	zui_set_anchor(0.5, 0);
	zui_set_width(256);

	minimum = 50;
	maximum = 100;
	value = 100;

	/*_window_id = window_id;
	callback = function (_id, _value) {
		with (_window_id)
			zui_set_scale(_value / 100, _value / 100);
	};
}

