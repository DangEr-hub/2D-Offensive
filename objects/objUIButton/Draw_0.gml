if (zui_get_hover()) {
	if (pressed)
		draw_set_color(c_black);
	else
		draw_set_color(MAIN_COLOR); 
} else {
	draw_set_color($ffffff);
}

draw_sprite_stretched_ext(sprButton, 0, -6, -6, __width + 12, __height + 12, draw_get_color(), alpha * alpha_value);

draw_set_font(font);
draw_set_alpha(alpha * alpha_value);

draw_text_outlined(0 + __width * 0.5 - string_width(caption)/2, 0 + __height * 0.5 + caption_offset_y, caption, caption_color, c_black, 1);
draw_set_alpha(1);