/// @description  console_toggle(console)
/// @param console
function console_toggle(argument0) {
	c = argument0;
	keyboard_string = "";

	if !c[? "active"]{
	    var sfc_w = surface_get_width(application_surface);
	    var sfc_h = surface_get_height(application_surface);
	    var sfc = surface_create(sfc_w,sfc_h);
	    surface_set_target(sfc);
	    gpu_set_colourwriteenable(false,false,false,true);
	    draw_clear(c_black);
	    draw_rectangle_colour(0,0,sfc_w,sfc_h,c_black,c_black,c_black,c_black,false);
	    gpu_set_colourwriteenable(true,true,true,false);
	    draw_surface(application_surface,0,0);
	    var bg = sprite_create_from_surface(sfc,0,0,sfc_w,sfc_h,false,false, 0, 0);
	    surface_reset_target();
	    gpu_set_colourwriteenable(true,true,true,true);
	    surface_free(sfc);
	    c[? "bg"] = bg;
	    c[? "active"] = true;
	}else{
	    c[? "active"] = false;
	    c[? "select"] = 0;
	    c[? "string"] = "";
	    c[? "string_pos"] = 1;
	}





}
