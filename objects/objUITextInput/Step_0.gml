if(alpha_value < 1){
	alpha_value += ALPHA_SPEED;
}


if (mouse_check_button_pressed(mb_left)) {
    if(zui_get_hover()){
		pressed = 1;
        active = true;
		cursor_pos = string_length(text);
    } else {
		if(is_callable(callback)){
			callback(text);	
		}
        active = false;
		cursor_pos = string_length(text);
    }
}

if(mouse_check_button_released(mb_left)){
	if(zui_get_hover()){
		pressed = 0;	
	}
}

if(keyboard_check_pressed(vk_left)){
	cursor_pos = max(cursor_pos - 1, 0);
}

if(keyboard_check_pressed(vk_right)){
	cursor_pos = min(cursor_pos + 1, string_length(text));
}

if (active == true) {
    var ch = keyboard_lastchar;

    if(ch != ""){
        var code = ord(ch);

        if(code >= 32 && code != 127 && array_length(chars) < max_string_length){
            array_insert(chars, cursor_pos, ch);
            cursor_pos++;
        }

        keyboard_lastchar = "";
    }
	
	
	if(keyboard_check(vk_backspace) || keyboard_check(vk_delete)){
	    if(cursor_pos > 0 && del_timer == -1){
	        array_delete(chars, cursor_pos - 1, 1);
	        cursor_pos--;
			del_timer = 10;
	    }
	}
	

	
	if(keyboard_check_pressed(vk_enter)){
		if(is_callable(callback)){
			callback(text);	
		}
	}
}

if(del_timer > -1){
	del_timer --;
}

text = "";
for(var i = 0;i < array_length(chars); i ++){
	text += chars[i];	
}

