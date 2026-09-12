event_inherited();
pause_width_tab = 384 * global.gui_scale;
pause_height_tab = 384 * global.gui_scale;

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
	if(!IS_NET && instance_exists(oGameController)){
		global.player_stats.Money = oGameController.round_start_money;
	}
	save_game();
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit the game?", "Exit", "Yes", "No", 256 * global.gui_scale, 128 * global.gui_scale, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	if(!IS_NET && instance_exists(oGameController)){
		global.player_stats.Money = oGameController.round_start_money;
	}
	save_game();
	audio_stop_all();
	with (oNetworkManager) instance_destroy();
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 256 * global.gui_scale, 128 * global.gui_scale, popup_main_menu_callback_positive, -1);	
};

button_width = 128 * global.gui_scale;
button_height = 32 * global.gui_scale;
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
	caption = "Settings";
	callback = function(){
		open_ingame_settings();
	};
}

with(zui_create(zui_get_width() * .5, button_start_y + button_spacing*2, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, button_start_y + button_spacing*3, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}

with (zui_create(zui_get_width() * 0.5, zui_get_height() * .8, objUISlider)) {
	zui_set_anchor(0.5, 0);
	zui_set_width(256 * global.gui_scale);

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
