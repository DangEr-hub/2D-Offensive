/// @description draw_menu_tab(x1, y1, x2, middle_height, title_height, end_height, title_color, middle_color, end_color, alpha)
/// @param x1
/// @param  y1
/// @param  width
/// @param  mth
/// @param  tth
/// @param  eth
/// @param  ttc
/// @param  mtc
/// @param  etc
/// @param  a
/// @param  outline
/// @param  tc
/// @param  t_text
function draw_menu_tab(){
    var x1 = argument[0];
    var y1 = argument[1];
	var width = argument[2];
	var title_height = argument[4];
	var middle_height = argument[3];
	var end_height = argument[5];
    var x2 = argument[0] + width;
    var y2 = y1 + title_height + middle_height + end_height;
	var outline = argument[10];
	var title_text = argument[12];
	var alpha = argument[9];
    
    // Draw outline
    draw_set_alpha(alpha);
    draw_set_color(c_black); // Set the color of the outline
    draw_rectangle(x1 - outline, y1 - outline, x2 + outline, y2 + outline, false);
    
    // Draw first rectangle
    draw_set_alpha(1.5*alpha);
    draw_set_color(argument[6]);
    draw_rectangle(x1, y1, x2, y1 + title_height, false);
	
	// Draw title
	draw_set_alpha(1.5*alpha);
	if(title_height >= 128){
		draw_set_font(set_font("Title"));
	}else{
		draw_set_font(set_font("Console"));
	}
	draw_text_outlined(x1 + width/2 - string_width(title_text)/2, y1 + title_height/2, title_text, argument[11], c_black, 1);
	draw_set_font(set_font("Console"));
    
    // Draw second rectangle
    draw_set_alpha(alpha);
    draw_set_color(argument[7]);
    draw_rectangle(x1, y1 + title_height, 
    x2, y1 + title_height + middle_height, false);
    
    // Draw third rectangle
    draw_set_alpha(1.5*alpha);
    draw_set_color(argument[8]);
    draw_rectangle(x1, y1 + title_height + middle_height, 
    x2, y2, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1);
}