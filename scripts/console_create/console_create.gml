/// @description  console_create()
function console_create() {
	global.console = ds_map_create();

	global.console[? "active"] = false;
	global.console[? "sep"] = "ddddddd";
	global.console[? "cursor"] = 0;
	global.console[? "close"] = false;
	global.console[? "history"] = ds_list_create();
	global.console[? "input_history"] = ds_list_create();
	global.console[? "input_select"] = 0;
	global.console[? "select"] = 0;
	global.console[? "preset"] = false;
	global.console[? "dir"] = -1;
	global.console[? "string"] = "";
	global.console[? "string_pos"] = 1;
	global.console[? "selection_anchor_line"] = -2; // -1 = vstup, 0+ = historie
	global.console[? "selection_focus_line"] = -2;
	global.console[? "selection_anchor_pos"] = 1;
	global.console[? "selection_focus_pos"] = 1;
	global.console[? "selection_dragging"] = false;
	global.console[? "text"] = noone;
	global.console[? "suggestions"] = noone;
	global.console[? "terminal_mode"] = false;
	global.console[? "backspace_hold"] = 0;
	global.console[? "left_hold"] = 0;
	global.console[? "right_hold"] = 0;

	return global.console;





}
