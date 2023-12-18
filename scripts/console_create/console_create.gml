/// @description  console_create()
function console_create() {
	global.console = ds_map_create();

	global.console[? "active"] = false;
	global.console[? "sep"] = "ddddddd";
	global.console[? "cursor"] = 0;
	global.console[? "close"] = false;
	global.console[? "history"] = ds_list_create();
	global.console[? "select"] = 0;
	global.console[? "preset"] = false;
	global.console[? "dir"] = -1;
	global.console[? "string"] = "";
	global.console[? "string_pos"] = 1;
	global.console[? "text"] = noone;
	global.console[? "suggestions"] = noone;

	return global.console;





}
