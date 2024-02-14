// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function mouse_to_gui(xpos1, ypos1, xpos2, ypos2){
	var window_multiplier = 1;
	if(window_get_fullscreen() == false){
		window_multiplier = 1.02;	
	}
	return device_mouse_x_to_gui(0) >= xpos1 && device_mouse_x_to_gui(0) <= xpos2 && device_mouse_y_to_gui(0) * window_multiplier >= ypos1 && device_mouse_y_to_gui(0) * window_multiplier <= ypos2;
}