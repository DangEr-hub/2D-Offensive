//draw_text(x, y - 70, ExplosionTimer);

if(stats.Speed > .1){
	//draw_sprite_ext(spr_Shadow, 0, x, y, 16/sprite_get_width(spr_Shadow), 
	//16/sprite_get_height(spr_Shadow), 0, c_white, 1);	
	draw_sprite_ext(sprite_index, image_index, x, y, 
	image_xscale, image_yscale, image_angle, c_black, .5);
}
//draw_text(x, y - 35, Object);
draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

