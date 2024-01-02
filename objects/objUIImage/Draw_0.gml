/// @description Insert description here
// You can write your code in this editor
if (zui_get_hover()) {
	if (pressed)
		draw_set_color(c_black);
	else
		draw_set_color(global.GoldColor); 
} else {
	draw_set_color($ffffff);
}

draw_sprite_stretched_ext(sprite, sprite_image_index, -6, -6, sprite_width_size, sprite_height_size, draw_get_color(), sprite_alpha);

//draw_sprite_stretched_ext(sprButton, 0, -6, -6, __width + 12, __height + 12, draw_get_color(), global.GUIHUDAlpha * 2);

//draw_sprite_stretched_ext(sprite, sprite_image_index, -1, -1, sprite_width_size, sprite_height_size, draw_get_color(), sprite_alpha);