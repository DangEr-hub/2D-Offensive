if(variable_global_exists("my_console") && ds_exists(global.my_console, ds_type_map)){
	var terminal_console = global.my_console;
	if(terminal_console[? "active"]){
		console_toggle(terminal_console);
	}

	terminal_console[? "terminal_mode"] = false;
	terminal_console[? "string"] = "";
	terminal_console[? "string_pos"] = 1;
	terminal_console[? "select"] = 0;
	terminal_console[? "dir"] = -1;
	terminal_console[? "backspace_hold"] = 0;
	terminal_console[? "left_hold"] = 0;
	terminal_console[? "right_hold"] = 0;
	keyboard_string = "";

	if(ds_exists(terminal_console[? "history"], ds_type_list)){
		ds_list_clear(terminal_console[? "history"]);
	}
	if(ds_exists(terminal_console[? "input_history"], ds_type_list)){
		ds_list_clear(terminal_console[? "input_history"]);
	}
	terminal_console[? "input_select"] = 0;
	if(ds_exists(terminal_console[? "text"], ds_type_list)){
		ds_list_clear(terminal_console[? "text"]);
	}
	if(ds_exists(terminal_console[? "suggestions"], ds_type_list)){
		ds_list_clear(terminal_console[? "suggestions"]);
	}
	console_preset(terminal_console);
}

if(instance_exists(global.local_player)){
	global.local_player.player_can_shoot = true;
}
