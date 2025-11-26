/// HAHA
if((window_get_width() != 1920 && window_get_height() != 1080)){
	global.__zui_mx = device_mouse_x_to_gui(0);
	global.__zui_my = device_mouse_y_to_gui(0);
}else{
	var w = window_get_width();
	var h = window_get_height();
	var design_w = 1920;
	var design_h = 1080;

	var sw = w / design_w;
	var sh = h / design_h;

	// jednotný scale
	gui_scale = min(sw, sh);

	// centrování GUI v okně
	gui_offx = (w - design_w * gui_scale) * 0.5;
	gui_offy = (h - design_h * gui_scale) * 0.5;

	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);

	global.__zui_mx = (mx - gui_offx) / gui_scale;
	global.__zui_my = (my - gui_offy) / gui_scale;
}
zui_update_begin();
zui_update();
