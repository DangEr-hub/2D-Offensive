global.__zui_mx = device_mouse_x_to_gui(0);
global.__zui_my = device_mouse_y_to_gui(0);

if(window_get_fullscreen() == false){
	global.__zui_my = device_mouse_y_to_gui(0) * 1.02;
}

zui_update_begin();
zui_update();
