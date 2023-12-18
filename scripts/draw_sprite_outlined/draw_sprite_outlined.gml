// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_sprite_outlined_ext(sprite, subimg, x, y, outline_color, outline_width, xscale, yscale, angle, alpha) {
    // Save the current draw color
    var original_color = draw_get_color();
	
    draw_sprite_ext(sprite, subimg, x - outline_width, y, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x + outline_width, y, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x, y - outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x, y + outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x - outline_width, y - outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x + outline_width, y - outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x - outline_width, y + outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x + outline_width, y + outline_width, xscale, yscale, angle, outline_color, alpha);
	
    draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, angle, original_color, alpha);
}