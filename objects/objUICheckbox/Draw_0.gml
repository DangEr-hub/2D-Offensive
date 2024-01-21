if (zui_get_hover()) {
	if (pressed)
		draw_set_color($cccccc);
	else
		draw_set_color($eeeeee); 
} else {
	draw_set_color($ffffff);
}

draw_sprite_stretched_ext(sprCheckBox, 0, -1, -1, __width, __height, draw_get_color(), alpha * objZUIMain.Alpha);

if (value){
	draw_sprite_stretched_ext(sprCheckBox, 1, -1, -1, __width, __height, draw_get_color(), alpha * objZUIMain.Alpha);
}
