global.__zui_mx = device_mouse_x_to_gui(0);
global.__zui_my = device_mouse_y_to_gui(0);

var scale_x = display_get_gui_width() / window_get_width();
var scale_y = display_get_gui_height() / window_get_height();

global.__zui_mx *= scale_x;
global.__zui_my *= scale_y;

zui_update_begin();
zui_update();
