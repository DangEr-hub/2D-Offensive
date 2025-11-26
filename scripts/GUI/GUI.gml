function ui_scale_set_window_size(window_w, window_h){
    global.window_width = window_w;
    global.window_height = window_h;

    window_set_size(window_w, window_h);
	window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
}


function mouse_to_gui(xpos1, ypos1, xpos2, ypos2){
	var window_multiplier = 1;
	if(window_get_fullscreen() == false){
		window_multiplier = 1.02;	
	}
	return device_mouse_x_to_gui(0) >= xpos1 && device_mouse_x_to_gui(0) <= xpos2 && device_mouse_y_to_gui(0) * window_multiplier >= ypos1 && device_mouse_y_to_gui(0) * window_multiplier <= ypos2;
}