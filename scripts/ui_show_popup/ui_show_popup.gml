function ui_show_popup(_caption, popup_caption, button_caption_positive, button_caption_negative, popup_width, popup_height, popup_callback_positive, popup_callback_negative) 
	{
		popup_height = max(popup_height, 128);
	with (objZUIMain) {
		var _black = zui_create(0, 0, objUIBlack, -1000);

		with (zui_create(__width * 0.5, __height * 0.5, objUIWindow, -1001)) {
			zui_set_size(popup_width, popup_height);
			black = _black;
  
			with (zui_create(0, 0, objUIWindowCaption)) {
				caption = popup_caption;
				draggable = 1;
			}
  
			with (zui_create(zui_get_width() * 0.5 - string_width(_caption)/2, zui_get_height() * 0.5 - 8, objUILabel)) {
				caption = _caption;
			}
			
			var button_width = 96;
			var button_height = 28;
			if(button_caption_positive != -1){
				var position_x = zui_get_width() * .25;
				if(button_caption_negative == -1){
					position_x = zui_get_width() * .5;	
				}
				with (zui_create(position_x, zui_get_height() - 24, objUIButton)) {
					zui_set_size(button_width, button_height);
				
					caption = button_caption_positive;
				
					if(popup_callback_positive == -1){
						callback = function () {
							with (zui_get_parent()) {
								with (black){
									zui_destroy();
								}

								zui_destroy();
							}
						};
					}else{
						callback = popup_callback_positive;
					}
				}
			}
			
			if(button_caption_negative != -1){
				var position_x = zui_get_width() * .75;
				if(button_caption_positive == -1){
					position_x = zui_get_width() * .5;	
				}
				with (zui_create(position_x, zui_get_height() - 24, objUIButton)) {
					zui_set_size(button_width, button_height);
				
					caption = button_caption_negative;
				
					if(popup_callback_negative == -1){
						callback = function () {
							with (zui_get_parent()) {
								with (black){
									zui_destroy();
								}

								zui_destroy();
							}
						};
					}else{
						callback = popup_callback_negative;
					}
				}
			}
		}
	}
}
