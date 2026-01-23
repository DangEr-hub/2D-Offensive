if (zui_get_hover()) {
	if (pressed)
		draw_set_color(c_black);
	else
		draw_set_color(MAIN_COLOR); 
} else {
	draw_set_color(c_white);
}

draw_sprite_stretched_ext(sprButton, 0, -1, -1, __width, __height, draw_get_color(), alpha * alpha_value);
draw_set_valign(1);
draw_set_font(set_font("GUI_small"));
draw_text_outlined(x + 5, y + zui_get_height()/2, text, c_white, c_black, 1);

if (active) {
    draw_set_color(c_white);
    var cursor_offset_x = 7;
    var cursor_offset_y = 7;
	var prefix = string_copy(text, 1, cursor_pos);
    var cursor_x = x + cursor_offset_x + string_width(prefix) - 1;
	var blink_rate = 500;
    var time = current_time;
    if (floor(time / blink_rate) % 2 == 0) {
        draw_line_width(cursor_x, y + cursor_offset_y - 1, cursor_x, y - cursor_offset_y - 2 + zui_get_height(), 2);
    }
}

//draw_text(x + 100, y, cursor_pos);