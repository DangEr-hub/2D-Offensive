/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_white);
if(clickable == true){
	if(hover == true){
		if (zui_get_hover()) {
			if (pressed)
				draw_set_color(c_black);
			else
				draw_set_color(MAIN_COLOR); 
		} else {
			draw_set_color(c_white);
		}
	}else{
		draw_set_color(c_white);	
	}
}

if(healthbar == false){
	draw_sprite_stretched_ext(sprite, sprite_image_index, 0, 0, sprite_width_size, sprite_height_size, draw_get_color(), alpha * alpha_value);
}else{
	draw_sprite_ext(spr_HealthBar, 0, 0, 0, global.GUIMultiplier * 1, 1 * global.GUIMultiplier, sprite_image_angle, c_white, alpha * alpha_value);	
	draw_sprite_ext(spr_HealthBar, sprite_image_index, 0, 0, (global.player_stats_struct.Xp/global.player_stats_struct.Max_xp) * 1 * global.GUIMultiplier, 1 * global.GUIMultiplier, sprite_image_angle, c_white, alpha * alpha_value);
}	