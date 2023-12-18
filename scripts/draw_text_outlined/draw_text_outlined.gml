/// @description draw_text_outlined(x, y, string, colour, outline_colour, distance)
/// @param x
/// @param  y
/// @param  string
/// @param  colour
/// @param  outline_colour
/// @param  distance
function draw_text_outlined(argument0, argument1, argument2, argument3, argument4, argument5) {
	draw_set_halign(fa_left);
	var xx = argument0;
	var yy = argument1;
	var str = argument2;
	draw_set_colour(argument4);
	draw_text(xx-argument5, yy, string_hash_to_newline(str));
	draw_text(xx+argument5, yy, string_hash_to_newline(str));
	draw_text(xx, yy-argument5, string_hash_to_newline(str));
	draw_text(xx, yy+argument5, string_hash_to_newline(str));
	draw_set_colour(argument3);
	draw_text(xx, yy, string_hash_to_newline(str));
	draw_set_colour(c_white);



}
