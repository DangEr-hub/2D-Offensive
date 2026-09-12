event_inherited();

if(keyboard_check_pressed(vk_escape) && global.my_console[? "active"]){
	console_toggle(global.my_console);
}

if(!instance_exists(global.local_player) || !global.my_console[? "active"]){
	if(instance_exists(global.local_player)){
		global.local_player.terminal_opened = false;
	}
	zui_destroy();
}
