draw_sprite_ext(sprWindowCaption, 0, 0, 0, __width/sprite_get_width(sprWindowCaption), __height/sprite_get_height(sprWindowCaption), 0, $ffffff, alpha * alpha_value);

draw_set_alpha(alpha);
draw_set_font(set_font("GUI_small"));
var translated_caption = tr(string_replace_all(caption, " ", "_"));
if(translated_caption == "") translated_caption = caption;
draw_text_outlined(x + __width * 0.5 - string_width(translated_caption)/2, y + __height * 0.5, translated_caption, MAIN_COLOR, c_black, 1);
