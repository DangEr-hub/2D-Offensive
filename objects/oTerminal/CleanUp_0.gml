if(instance_exists(global.local_player)){
	global.local_player.terminal_opened = false;
}

if(variable_global_exists("my_console")
&& ds_exists(global.my_console, ds_type_map)
&& global.my_console[? "active"]){
	console_toggle(global.my_console);
}
