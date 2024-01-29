if (zui_get_hover()) {
	if (pressed)
		draw_set_color($cccccc);
	else
		draw_set_color($eeeeee); 
} else {
	draw_set_color($ffffff);
}

draw_sprite_stretched_ext(sprButton, 0, -1, -1, max(__width, 24), max(__height, 24), draw_get_color(), alpha * alpha_value);

if (value){
	draw_sprite_stretched_ext(sprButton, 1, -1, -1, max(__width, 24), max(__height, 24), draw_get_color(), alpha * alpha_value);
}
