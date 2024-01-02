if (pressed) {
	pressed = 0;

	if (zui_get_hover()) {
		switch(value_type){
			case "hard_mode":
				global.hard_mode = !global.hard_mode;
				value = global.hard_mode;
			break;
		}
	}
}
