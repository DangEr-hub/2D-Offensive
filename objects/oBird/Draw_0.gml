if(state == 1){
	draw_sprite_ext(sprite_index, image_index, x, y + SHADOW_DIST, image_xscale, image_yscale, image_angle, c_black, .25);
}
draw_self();
draw_text(x, y - 50, speed);
draw_text(x, y - 100, network_id);

