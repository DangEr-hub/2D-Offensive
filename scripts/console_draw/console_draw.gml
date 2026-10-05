/// @description  console_draw(console,height,bg_color1,bg_color2,text_color1,text_color2,alpha)
/// @param console
/// @param height
/// @param bg_color1
/// @param bg_color2
/// @param text_color1
/// @param text_color2
/// @param alpha
/// @param width
/// @param [x_position]
/// @param [terminal_mode]
function console_selection_clear(c) {
	c[? "selection_anchor_line"] = -2;
	c[? "selection_focus_line"] = -2;
	c[? "selection_dragging"] = false;
}

function console_selection_bounds(c, line_index, text_length) {
	var anchor_line = c[? "selection_anchor_line"];
	var focus_line = c[? "selection_focus_line"];
	var anchor_pos = c[? "selection_anchor_pos"];
	var focus_pos = c[? "selection_focus_pos"];
	if(anchor_line == line_index && focus_line == line_index){
		return [clamp(min(anchor_pos, focus_pos), 1, text_length + 1),
			clamp(max(anchor_pos, focus_pos), 1, text_length + 1)];
	}
	if(anchor_line < 0 || focus_line < 0 || line_index < min(anchor_line, focus_line)
	|| line_index > max(anchor_line, focus_line)) return [0, 0];
	if(line_index == max(anchor_line, focus_line)){
		return [clamp(anchor_line == line_index ? anchor_pos : focus_pos, 1, text_length + 1), text_length + 1];
	}
	if(line_index == min(anchor_line, focus_line)){
		return [1, clamp(anchor_line == line_index ? anchor_pos : focus_pos, 1, text_length + 1)];
	}
	return [1, text_length + 1];
}

function console_selection_position(line_text, text_x, pointer_x) {
	var previous_width = 0;
	for(var char_index = 1; char_index <= string_length(line_text); char_index++){
		var next_width = string_width(string_copy(line_text, 1, char_index));
		if(pointer_x < text_x + (previous_width + next_width) * 0.5) return char_index;
		previous_width = next_width;
	}
	return string_length(line_text) + 1;
}

function console_draw(c,h,b1,b2,t1,t2,a,w,x_position = undefined,terminal_mode = false) {
	c[? "terminal_mode"] = terminal_mode;
	gpu_set_tex_filter(false);
	/*var c,h,b1,b2,t1,t2,a;

	c = argument0;
	h = argument1;
	b1 = argument2;
	b2 = argument3;
	t1 = argument4;
	t2 = argument5;
	a = argument6;*/

	/* If enabled */
	if c[? "active"] {
		draw_set_font(set_font("Console"));
		draw_set_halign(fa_left);
	    l = string_height("W");
		yy = 48;
	    p = 36; // Padding
		ws = is_undefined(x_position) ? surface_get_width(application_surface) * .075 : x_position;
		o = 4;
		gsw = string_width("> ");
		var input_x = ws + gsw/2;
		var input_y = h + p*2.25;
		var list = c[? "history"];
		var visible_rows = min(round(h/l - 1), ds_list_size(list));
		var display_string = c[? "string"];
		if(terminal_mode){
			var terminal_instance = instance_find(oTerminal, 0);
			if(instance_exists(terminal_instance) && terminal_instance.sudo_login_stage == 2){
				display_string = string_repeat("*", string_length(display_string));
			}
		}
		var mouse_pos_x = terminal_mode ? zui_get_mouse_x() / zui_get_scale_x() : device_mouse_x_to_gui(0);
		var mouse_pos_y = terminal_mode ? zui_get_mouse_y() / zui_get_scale_y() : device_mouse_y_to_gui(0);
		if(mouse_check_button_pressed(mb_left)){
			if(mouse_pos_x >= ws && mouse_pos_x <= w && mouse_pos_y >= h+p*2 && mouse_pos_y <= h+p*2.5+l){
				var input_pos = console_selection_position(display_string, input_x, mouse_pos_x);
				c[? "selection_anchor_line"] = -1;
				c[? "selection_focus_line"] = -1;
				c[? "selection_anchor_pos"] = input_pos;
				c[? "selection_focus_pos"] = input_pos;
				c[? "string_pos"] = input_pos;
				c[? "selection_dragging"] = true;
			}else{
				console_selection_clear(c);
				if(mouse_pos_x >= ws && mouse_pos_x <= w){
					for(var hit_row = 0; hit_row < visible_rows; hit_row++){
						var hit_y = h+p*1.5-hit_row*l;
						if(mouse_pos_y >= hit_y-l*0.5 && mouse_pos_y < hit_y+l*0.5){
							var hit_pos = console_selection_position(string(list[| hit_row]), ws, mouse_pos_x);
							c[? "selection_anchor_line"] = hit_row;
							c[? "selection_focus_line"] = hit_row;
							c[? "selection_anchor_pos"] = hit_pos;
							c[? "selection_focus_pos"] = hit_pos;
							c[? "selection_dragging"] = true;
							break;
						}
					}
				}
			}
		}
		if(c[? "selection_dragging"]){
			if(mouse_check_button(mb_left)){
				if(c[? "selection_anchor_line"] == -1){
					c[? "selection_focus_pos"] = console_selection_position(display_string, input_x, mouse_pos_x);
					c[? "string_pos"] = c[? "selection_focus_pos"];
				}else if(visible_rows > 0){
					var drag_row = clamp(round((h+p*1.5-mouse_pos_y)/l), 0, visible_rows-1);
					c[? "selection_focus_line"] = drag_row;
					c[? "selection_focus_pos"] = console_selection_position(string(list[| drag_row]), ws, mouse_pos_x);
				}
			}else{
				c[? "selection_dragging"] = false;
			}
		}
		sw = string_width(string_copy(display_string,1,c[? "string_pos"]-1));
    
	    /* Console alpha */
	    draw_set_alpha(a);
		
		/* Console outline */
		draw_set_color(c_black);
		draw_rectangle(ws - o,yy - o,w + o,(h+(p*2.5))+l + o,false);
    
	    /* Command history window */
	    draw_set_color(b1);
		draw_rectangle(ws,yy,w,(h+p*2),false);
    
	    /* Command history */
	    var ch;
		draw_set_alpha(1);
	    draw_set_color(t1);
		draw_set_valign(fa_middle);
	    for (ch=0;ch<round(h/l - 1);ch++) {
    
	        var cmd = list[| ch];
	        if !is_undefined(cmd) {
				var history_y = h+p*1.5-(ch*l);
				var history_selection = console_selection_bounds(c, ch, string_length(cmd));
				if(history_selection[1] > history_selection[0]){
					var highlight_left = min(w, ws + string_width(string_copy(cmd, 1, history_selection[0]-1)));
					var highlight_right = min(w, ws + string_width(string_copy(cmd, 1, history_selection[1]-1)));
					draw_set_color(make_color_rgb(70, 115, 190));
					draw_set_alpha(0.65);
					if(highlight_right > highlight_left) draw_rectangle(highlight_left, history_y-l*0.5,
						highlight_right, history_y+l*0.5, false);
					draw_set_color(t1);
					draw_set_alpha(1);
				}
				draw_text(ws,h+p*1.5-(ch*l),string_hash_to_newline(cmd));
	        }
    
	    }
    
	    /* Suggestions */
		draw_set_alpha(a);
	    draw_set_halign(fa_left);
	    draw_set_valign(fa_top);
	    if ds_exists(c[? "suggestions"],ds_type_list)
	    && ds_list_size(c[? "suggestions"]) > 0 {
	        var s,sugs = c[? "suggestions"];
	        draw_set_color(b1);
			draw_rectangle(ws,h+p*2,w,(h+(p*1.5))+l+(l*ds_list_size(sugs))+p,false);
	        draw_set_color(t1);
			draw_set_alpha(1);
	        for(s=0;s<ds_list_size(sugs);s++) {
	            if !is_undefined(sugs[| s]) {
					var suggestion_y = ((h+p*2.5)+l)+(l*s);
					if(c[? "dir"] == 1 && c[? "select"] == s){
						draw_set_color(b2);
						draw_rectangle(ws, suggestion_y, w, suggestion_y + l, false);
						draw_set_color(t2);
					}
					draw_text(ws, suggestion_y, sugs[| s]);
					draw_set_color(t1);
	            }
	        }
	    }
    
	    /* Submit window */
	    draw_set_color(b2);
	    draw_set_alpha(a);
		draw_rectangle(ws,(h+p*2),w,(h+(p*2.5))+l,false);
    
	    /* Greater than symbol */
	    draw_set_color(t1);
	    draw_set_alpha(1);
		draw_text(ws,h+(p*2.25),"> ");
    
	    /* Draw input */
		var input_selection = console_selection_bounds(c, -1, string_length(display_string));
		if(input_selection[1] > input_selection[0]){
			var input_highlight_left = min(w, input_x + string_width(string_copy(display_string, 1, input_selection[0]-1)));
			var input_highlight_right = min(w, input_x + string_width(string_copy(display_string, 1, input_selection[1]-1)));
			draw_set_color(make_color_rgb(70, 115, 190));
			draw_set_alpha(0.65);
			if(input_highlight_right > input_highlight_left) draw_rectangle(input_highlight_left, input_y,
				input_highlight_right, input_y+l, false);
			draw_set_alpha(1);
		}
	    draw_set_color(t2);
	   draw_text(ws+gsw/2,h+(p*2.25),string_hash_to_newline(display_string));
    
	    /* Cursor alpha */
	    c[? "cursor"] += 0.1;
	    if c[? "cursor"] <= 1 then draw_set_alpha(1);
	    if c[? "cursor"] > 1 && c[? "cursor"] <= 2 then draw_set_alpha(0);
	    if c[? "cursor"] > 2 {
	        draw_set_alpha(1);
	        c[? "cursor"] = 0;
	    }
    
	    /* Draw cursor */
		draw_text(ws+gsw/2+sw,h+(p*2.25),"|");

	    /* Reset alpha */
	    draw_set_alpha(1);
	    draw_set_valign(fa_middle);
	}







}
