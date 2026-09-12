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
function console_draw(c,h,b1,b2,t1,t2,a,w,x_position = undefined) {
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
	    l = string_height("W");
	    p = 36; // Padding
		ws = is_undefined(x_position) ? surface_get_width(application_surface) * .15 : x_position;
		o = 4;
		gsw = string_width("> ");
		sw = string_width(string_copy(c[? "string"],1,c[? "string_pos"]-1));
    
	    /* Console alpha */
	    draw_set_alpha(a);
		
		/* Console outline */
		draw_set_color(c_black);
		draw_rectangle(ws - o,80 - o,w + o,(h+(p*2.5))+l + o,false);
    
	    /* Command history window */
	    draw_set_color(b1);
		draw_rectangle(ws,80,w,(h+p*2),false);
    
	    /* Command history */
	    var ch,list = c[? "history"];
		draw_set_alpha(1);
	    draw_set_color(t1);
	    for (ch=0;ch<round(h/l - 1);ch++) {
    
	        var cmd = list[| ch];
	        if !is_undefined(cmd) {
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
					draw_text(ws,((h+p*2.5)+l)+(l*s),sugs[| s]);
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
	    draw_set_color(t2);
	   draw_text(ws+gsw/2,h+(p*2.25),string_hash_to_newline(c[? "string"]));
    
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
