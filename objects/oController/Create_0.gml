draw_set_valign(1);
window_set_fullscreen(true);

play_unranked_callback = function(){
	if!(instance_exists(oPlayUnrankedTab)){
		with(zui_main()){
			var window_id;
			
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
			var window_id;
			
			with(objUIWindow){
				zui_destroy();
			}
			
			with (zui_create(zui_get_width() * 0.59, zui_get_height() * 0.5, oPlayRankedTab, -1)) {
				window_id = id;
			}
		}
	}
}


with (zui_main()) {
	var window_id;
 
	/*with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oPlayerRankedTab, -1)) {
		window_id = id;
	}*/
	
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
		caption = "Exit";
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
		};*/
	}
	
	/*
 
	with (zui_create(zui_get_width() * 0.5, zui_get_height() - 50, objUILabel)) {
		caption = "Scale";
		color = $ffffff;
	}*/
}

