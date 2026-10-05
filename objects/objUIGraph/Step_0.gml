if(alpha_value < 1){
	alpha_value += ALPHA_SPEED;
}

if(mouse_check_button_pressed(mb_left)){
	var mouse_x_graph = global.__zui_mx - (__dx - __ax * __sx);
	var mouse_y_graph = global.__zui_my - (__dy - __ay * __sy);
	var margin_x = g_width * background_margin * __sx;
	var margin_y = g_height * background_margin * __sy;

	if(mouse_x_graph < -margin_x || mouse_x_graph > (g_width * __sx + margin_x)
	|| mouse_y_graph < -margin_y || mouse_y_graph > (g_height * __sy + margin_y)){
		zui_destroy();
	}
}

