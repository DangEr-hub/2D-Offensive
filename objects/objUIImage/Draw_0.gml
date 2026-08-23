/// @description Insert description here
// You can write your code in this editor
if(drawable == true){
	if(clickable == true){
		if(hover == true){
			if (zui_get_hover()) {
				if (pressed)
					draw_set_color(c_black);
				else{
					draw_set_color(MAIN_COLOR); 
				}
			} else {
				draw_set_color(c_white);
			}
		}else{
			draw_set_color(c_white);	
		}
	}else{
		draw_set_color(c_white);
	}

	if(healthbar == true){
		draw_sprite_ext(spr_HealthBar, 0, 0, 0, global.GUIMultiplier, global.GUIMultiplier, sprite_image_angle, c_white, alpha * alpha_value);
		draw_sprite_ext(spr_HealthBar, sprite_image_index, 0, 0, (global.player_stats.Xp/global.player_stats.Max_xp) * global.GUIMultiplier, global.GUIMultiplier, sprite_image_angle, c_white, alpha * alpha_value);
	}else if(circular_bar == true){
		draw_circular_bar(
			zui_get_width() * .5,
			zui_get_height() * .5,
			bar_radius,
			bar_value,
			bar_max_value,
			bar_color,
			bar_background_color,
			bar_thickness,
			bar_alpha * alpha * alpha_value
		);
	}else{
		if(buy_menu == false){
			draw_sprite_stretched_ext(sprite, sprite_image_index, 0, 0, sprite_width_size, sprite_height_size, draw_get_color(), alpha * alpha_value);
		}else{
			var r = 54;
			var g = 54;
			var b = 54;
			shader_set(shd_LightGray);
			if (zui_get_hover()) {
			    shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
			} else {
			    shader_set_uniform_f(oDraw.BlendColor, r/255, g/255, b/255, 1.0);	
			}
			draw_sprite_stretched_ext(sprite, sprite_image_index, 0, 0, sprite_width_size, sprite_height_size, draw_get_color(), alpha * alpha_value);
			shader_reset();	
		}
	}
}
