if(alpha_value < 1){
	alpha_value += ALPHA_SPEED;
}


if (mouse_check_button_pressed(mb_left)) {
    if(zui_get_hover()){
		pressed = 1;
        active = true;
        keyboard_string = text;
    } else {
		if(is_callable(callback)){
			callback(text);	
		}
        active = false;
    }
}

if(mouse_check_button_released(mb_left)){
	if(zui_get_hover()){
		pressed = 0;	
	}
}

if (active == true) {
    if (string_length(keyboard_string) > max_string_length) {
        keyboard_string = string_copy(keyboard_string, 1, max_string_length);
    }

    text = keyboard_string;
	
	if(keyboard_check_pressed(vk_enter)){
		if(is_callable(callback)){
			callback(text);	
		}
	}
}

