//Draws the legs on the player
if(Visible == true && instance_exists(Object)){
	draw_sprite_ext(spr_PlayerLegs,image_index,Object.x,Object.y,image_xscale,image_yscale,image_angle,c_white,1);
}