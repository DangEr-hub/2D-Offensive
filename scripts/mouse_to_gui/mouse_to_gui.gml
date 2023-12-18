// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function mouse_to_gui(xpos1, ypos1, xpos2, ypos2){
	return device_mouse_x_to_gui(0) >= xpos1 && device_mouse_x_to_gui(0) <= xpos2 && device_mouse_y_to_gui(0) >= ypos1 && device_mouse_y_to_gui(0) <= ypos2;
}