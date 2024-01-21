draw_sprite_ext(sprWindowCaption, 0, 0, 0, __width/sprite_get_width(sprWindowCaption), __height/sprite_get_height(sprWindowCaption), 0, $ffffff, alpha * objZUIMain.Alpha);

draw_set_alpha(alpha);
draw_set_font(set_font("Menu_small"));
draw_text_outlined(x + __width * 0.5 - string_width(caption)/2, y + __height * 0.5, caption, global.GoldColor, c_black, 1);
