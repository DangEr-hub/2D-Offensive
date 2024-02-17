// Draw the sprite
if(Breakable == true){
	draw_sprite_general(spr, index, xx, yy, size, size, x, y, image_xscale, image_yscale, rotation, current_color, current_color, current_color, current_color, alpha);
}else{
	draw_self();
}