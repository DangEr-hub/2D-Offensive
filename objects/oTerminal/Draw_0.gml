event_inherited();

var console_height = min(global.ConsoleHeight * global.gui_scale, terminal_height - 128);
console_draw(
	global.my_console,
	console_height,
	make_color_rgb(24, 24, 24),
	make_color_rgb(70, 0, 28),
	make_color_rgb(225, 225, 225),
	make_color_rgb(215, 10, 83),
	1,
	terminal_width - terminal_padding,
	terminal_padding
);
