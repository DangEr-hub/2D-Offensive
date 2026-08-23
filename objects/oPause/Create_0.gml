event_inherited();
pause_width_tab = 384 * global.GUIMultiplier;
pause_height_tab = 384 * global.GUIMultiplier;

draw_set_font(set_font("GUI_small"));
zui_set_size(pause_width_tab, pause_height_tab);

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Paused";
	draggable = 1;
}

continue_callback = function(){
	oDraw.PauseMenu = false;
	unpause(oDraw);
	with(oPause){
		zui_destroy();
	}
};

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	save_game();
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit the game?", "Exit", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	save_game();
	audio_stop_all();
	with (oNetworkManager) instance_destroy();
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_main_menu_callback_positive, -1);	
};

button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;
button_spacing = round(button_height * 1.25);
button_start_y = round(zui_get_height() * .2);
with(zui_create(zui_get_width() * .5, button_start_y, objUIButton, -999)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Continue";
	callback = other.continue_callback;
}

with(zui_create(zui_get_width() * .5, button_start_y + button_spacing, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Statistics";
	callback = function(){
		with(zui_main()){
			var _black = zui_create(0, 0, objUIBlack, -1000);
			with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oStatistics, -1000)) {
				black = _black;
				alpha = global.GUIHUDAlpha * 2.25; alpha_value = 0;
				window_id = id;
			}
		}
	};
}

with(zui_create(zui_get_width() * .5, button_start_y + button_spacing*2, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Settings";
	callback = function(){
		open_ingame_settings();
	};
}

with(zui_create(zui_get_width() * .5, button_start_y + button_spacing*3, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, button_start_y + button_spacing*4, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}

with (zui_create(zui_get_width() * 0.5, zui_get_height() * .8, objUISlider)) {
	zui_set_anchor(0.5, 0);
	zui_set_width(256 * global.GUIMultiplier);

	minimum = 0;
	maximum = 100;
	value = global.sound_gain;
	type = "Volume";
	
	callback = function(_value){
		audio_master_gain(_value/100);
	};
}

draw_set_font(set_font("Console"));
with (zui_create(zui_get_width() * 0.5 - string_width("Volume gain")/2, zui_get_height() * .8 - string_height("a"), objUILabel)) {
	color = c_white;
	caption = "Volume gain";
}
