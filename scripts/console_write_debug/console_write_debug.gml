function console_write_debug(_text){

    var line = string(_text);

    ds_list_insert(global.console[? "history"], 0, line);
	
	set_font("Console");
	var max_lines = global.ConsoleHeight * global.GUIMultiplier / string_height("W");

	if (ds_list_size(global.console[? "history"]) > max_lines){
	    ds_list_delete(global.console[? "history"], ds_list_size(global.console[? "history"]) - 1);
	}

}
