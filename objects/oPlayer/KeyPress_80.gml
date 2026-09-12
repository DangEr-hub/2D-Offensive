// Terminal setup
if(!is_local || stats.Health_points <= 0 || terminal_opened || global.my_console[? "active"]){
	exit;
}

if(instance_exists(oDraw) && (oDraw.PauseMenu || oDraw.RespawnMenu || oDraw.GameEndMenu)){
	exit;
}

terminal_opened = true;
console_toggle(global.my_console);

with(zui_main()){
	zui_create(zui_get_width() * .5, zui_get_height() * .5, oTerminal, -2000);
}
