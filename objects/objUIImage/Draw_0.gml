/// @description Insert description here
// You can write your code in this editor
if(hover == true){
	if (zui_get_hover()) {
		if (pressed)
			draw_set_color(c_black);
		else
			draw_set_color(global.GoldColor); 
	} else {
		draw_set_color(c_white);
	}
}else{
	draw_set_color(c_white);	
}

if(healthbar == false){
	draw_sprite_stretched_ext(sprite, sprite_image_index, 0, 0, sprite_width_size, sprite_height_size, draw_get_color(), sprite_alpha);
}else{
	draw_sprite_ext(spr_HealthBar, 0, 0, 0, global.GUIMultiplier * 1, 1 * global.GUIMultiplier, 0, c_white, 1);	
	draw_sprite_ext(spr_HealthBar, sprite_image_index, 0, 0, (global.player_stats_struct.Xp/global.player_stats_struct.Max_xp) * 1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1);
}	