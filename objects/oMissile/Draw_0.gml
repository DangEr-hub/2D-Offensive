var draw_x = x;
var draw_y = y - z;
draw_x -= (image_xscale - 1) * sprite_xoffset;
draw_y -= (image_yscale - 1) * sprite_yoffset;
draw_sprite_ext(sprite_index, image_index, draw_x, draw_y + z, image_xscale, image_yscale, image_angle, c_black, .25);
draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);