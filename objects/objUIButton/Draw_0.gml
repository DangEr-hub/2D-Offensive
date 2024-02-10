if (zui_get_hover()) {
	if (pressed)
		draw_set_color(c_black);
	else
		draw_set_color(MAIN_COLOR); 
} else {
	draw_set_color($ffffff);
}

draw_sprite_stretched_ext(sprButton, 0, -6, -6, __width + 12, __height + 12, draw_get_color(), alpha * alpha_value);

draw_set_alpha(alpha * alpha_value);
draw_set_font(set_font("Menu_small"));
draw_text_outlined(x + __width * 0.5 - string_width(caption)/2, y + __height * 0.5, caption, c_white, c_black, alpha * alpha_value);
draw_set_alpha(1);