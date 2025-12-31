// Draw the sprite
if(Breakable == true){
	draw_sprite_general(spr, index, xx, yy, size, size, x, y, image_xscale, image_yscale, rotation, current_color, current_color, current_color, current_color, alpha);
}else{
	gpu_set_tex_filter(true);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);
	gpu_set_tex_filter(false);
}