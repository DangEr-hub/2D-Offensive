/// @description Insert description here
// You can write your code in this editor
//draw_text(x, y - 70, network_id);
if(zmaxspeed > .1){
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, .25);
}
draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);