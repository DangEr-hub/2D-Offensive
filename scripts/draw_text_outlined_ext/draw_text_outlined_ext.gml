/// @description draw_text_outlined_ext(x, y, string, colour, outline_colour, distance)
/// @param x
/// @param  y
/// @param  string
/// @param  colour
/// @param  outline_colour
/// @param  distance
/// @param  sep
/// @param  w
function draw_text_outlined_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
	draw_set_halign(fa_left);
	var xx = argument0;
	var yy = argument1;
	var str = argument2;
	var separate = argument6;
	var width = argument7;
	draw_set_colour(argument4);
	draw_text_ext(xx-argument5, yy, string_hash_to_newline(str), separate, width);
	draw_text_ext(xx+argument5, yy, string_hash_to_newline(str), separate, width);
	draw_text_ext(xx, yy-argument5, string_hash_to_newline(str), separate, width);
	draw_text_ext(xx, yy+argument5, string_hash_to_newline(str), separate, width);
	draw_set_colour(argument3);
	draw_text_ext(xx, yy, string_hash_to_newline(str), separate, width);
	draw_set_colour(c_white);



}
