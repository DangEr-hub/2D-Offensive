var ref_w = 192;
var ref_h = 64;

// 2. Vypočítáme poměr (scale) aktuálního tlačítka vůči referenci
var ratio_x = __width / ref_w;
var ratio_y = __height / ref_h;

var final_scale = min(ratio_x, ratio_y) * 2;

if (zui_get_hover()) {
    draw_set_color(pressed ? c_black : MAIN_COLOR); 
} else {
    draw_set_color(color);
}

draw_sprite_stretched_ext(sprButton, 0, -6, -6, __width + 12, __height + 12, draw_get_color(), alpha * alpha_value);

draw_set_font(font);
draw_set_alpha(alpha * alpha_value);

if(spr[1] == Item.None) {
	var tw = string_width(caption)/2;
	if(string_width(caption) >= __width * .9){
		tw = __width/2.1;	
	}
    draw_text_outlined_ext(__width * 0.5 - tw, __height * 0.5 + caption_offset_y, caption, caption_color, c_black, 1, string_height("a"), __width);
} else {
    var draw_w = spr[2] * final_scale;
    var draw_h = spr[3] * final_scale;
    var draw_x = __width/2;
    var draw_y = __height/2;
	
	var sc = final_scale;
	if(__width <= 64 && __height <= 32){
		sc = final_scale * 2;
	}
    draw_sprite_ext(spr[0], spr[1], draw_x, draw_y, sc, sc, 0, c_white, alpha * alpha_value);
}
draw_set_alpha(1);