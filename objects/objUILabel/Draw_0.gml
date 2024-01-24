draw_set_alpha(alpha * objZUIMain.Alpha);
draw_set_font(font);
draw_text_outlined(0, 0, caption, color, outline_color, 1);
if(icon_image_index != -1 && icon_sprite_index != -1){
	draw_sprite_ext(icon_sprite_index, icon_image_index, 0 - sprite_get_width(icon_sprite_index), 0, 1, 1, 0, c_white, 1);
}

