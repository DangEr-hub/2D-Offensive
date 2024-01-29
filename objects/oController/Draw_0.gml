/*if (!surface_exists(surf_horizontal)) {
    surf_horizontal = surface_create(room_width, room_height);
}
if (!surface_exists(surf_vertical)) {
    surf_vertical = surface_create(room_width, room_height);
}
shader_set(shd_Blur2Pass);
var texelWidth = 1.0 / sprite_get_width(spr_menu_background);
var texelHeight = 1.0 / sprite_get_height(spr_menu_background);

shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "texel_size"), texelWidth, texelHeight);
shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_radius"), 1.5);
shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_vector"), 1.0, 0.0);
surface_set_target(surf_horizontal);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(spr_menu_background, 0, 0, 0, room_width/sprite_get_width(spr_menu_background), room_height/sprite_get_height(spr_menu_background), 0, c_white, 1);
surface_reset_target();
shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_vector"), 0.0, 1.0);
surface_set_target(surf_vertical);
draw_clear_alpha(c_black, 0);
draw_surface(surf_horizontal, 0, 0);
surface_reset_target();
shader_reset();
draw_surface(surf_vertical, 0, 0);*/

draw_blur_2d(spr_menu_background, 0, 0, 0, room_width/sprite_get_width(spr_menu_background), room_height/sprite_get_height(spr_menu_background), 0, c_white, 1, 1.5);