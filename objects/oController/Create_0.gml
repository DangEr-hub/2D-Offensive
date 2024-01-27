application_surface_draw_enable(true);
draw_set_valign(1);
window_set_fullscreen(true);

if!(instance_exists(oConsole)){
	instance_create_layer(x, y, "OtherO", oConsole);
}

popup_exit_callback_positive = function () {
	game_end();
}
				
exit_callback = function(){
	ui_show_popup("Are you sure?", "Exit", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);
}

play_unranked_callback = function(){
	if!(instance_exists(oPlayUnrankedTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oPlayUnrankedTab, -1)) {
				window_id = id;
			}
		}
	}
}

play_ranked_callback = function(){
	if!(instance_exists(oPlayRankedTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oPlayRankedTab, -1)) {
				window_id = id;
			}
		}
	}
};

statistics_callback = function(){
	if!(instance_exists(oStatisticsTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oStatisticsTab, -1)) {
				window_id = id;
			}
		}
	}
};

settings_callback = function(){
	if!(instance_exists(oSettings)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oSettings, -1)) {
				window_id = id;
			}
		}
	}
};


with (zui_main()) {
	var window_id = noone;
	var button_width = 128 * global.GUIMultiplier;
	var button_height = 32 * global.GUIMultiplier;
	with(zui_create(zui_get_width() * .1, zui_get_height() * .1, objUIButton)){
		zui_set_anchor(0.5, 0);
		zui_set_width(button_width);
		zui_set_height(button_height);
		caption = "Play unranked";
		callback = oController.play_unranked_callback;
	}
	
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
		caption = "Settings";
		callback = oController.settings_callback;
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
}

