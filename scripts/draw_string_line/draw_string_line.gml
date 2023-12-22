// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// Function to draw colored numbers
function draw_string_line(x, y, text, number, color, text_last_string, text_color = c_white, outline_color = c_black, outline_distance = 1) {
    var number_sign = (number >= 0) ? "+" : "";
    draw_text_outlined(x, y, text, text_color, outline_color, outline_distance);
    draw_text_outlined(x + string_width(text), y, number_sign + string(number), color, outline_color, outline_distance);	
    draw_text_outlined(x + string_width(text) + string_width(number_sign + string(number)), y, text_last_string, color, outline_color, outline_distance);
}