application_surface_draw_enable(true);
draw_set_valign(1);

alarm[0] = 10;
surf_horizontal = -1;
surf_vertical = -1;


if!(instance_exists(oConsole)){
	instance_create_layer(x, y, "OtherO", oConsole);
}

popup_exit_callback_positive = function () {
	game_end();
}
				
exit_callback = function(){
	ui_show_popup("Are you sure?", "Exit", "Yes", "No", 288 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);
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

cases_callback = function(){
	if!(instance_exists(oCasesTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oCasesTab, -1)) {
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
			
			with (zui_create(zui_get_width() * .59, zui_get_height() * 0.5, oStatisticsTab, -1)) {
				window_id = id;
			}
		}
	}
};

settings_callback = function(){
	if!(instance_exists(oSettingsTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oSettingsTab, -1)) {
				window_id = id;
			}
		}
	}
};

keyboard_callback = function(){
	if!(instance_exists(oKeyboardTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oKeyboardTab, -1)) {
				window_id = id;
			}
		}
	}
};

sources_callback = function(){
	if!(instance_exists(oSourcesTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oSourcesTab, -1)) {
				window_id = id;
			}
		}
	}
};

weapons_callback = function(){
	if!(instance_exists(oWeaponsTab)){
		with(zui_main()){
			var window_id = noone;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oWeaponsTab, -1)) {
				window_id = id;
			}
		}
	}
};

draw_set_font(set_font("GUI_medium"));
title_w = string_width("2D offensive");


with (zui_main()) {
	var window_id = noone;
	var button_width = max(128 * global.GUIMultiplier, 192);
	var button_height = 32 * global.GUIMultiplier;
	
	
	with (zui_create(zui_get_width() * .1 - oController.title_w/2, zui_get_height() * .05, objUILabel)) {
		color = MAIN_COLOR;
		caption = "2D Offensive";
		font = set_font("GUI_medium");
	}


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
		callback = oController.weapons_callback;
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
		caption = "Keyboard settings";
		callback = oController.keyboard_callback;
	}
	
	with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*9, objUIButton)){
		zui_set_anchor(0.5, 0);
		zui_set_width(button_width);
		zui_set_height(button_height);
		caption = "Sources";
		//spr[1] = Item.AKM;
		callback = oController.sources_callback;
	}
	
	with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*10.5, objUIButton)){
		zui_set_anchor(0.5, 0);
		zui_set_width(button_width);
		zui_set_height(button_height);
		caption = "Cases";
		callback = oController.cases_callback;
	}
	
	with(zui_create(zui_get_width() * .1, zui_get_height() * .1 + button_height*12, objUIButton)){
		zui_set_anchor(0.5, 0);
		zui_set_width(button_width);
		zui_set_height(button_height);
		caption = "Exit";
		callback = oController.exit_callback;
	}
}

