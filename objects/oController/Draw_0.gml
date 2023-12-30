/// @description Insert description here
// You can write your code in this editor
shader_set(shd_Blur);
shader_set_uniform_f(shader_get_uniform(shd_Blur, "size"), 128, 128, .5);
draw_sprite_ext(spr_menu_background, 0, 0, 0, room_width/sprite_get_width(spr_menu_background), room_height/sprite_get_height(spr_menu_background), 0, c_white, 1);
shader_reset();

