var light_x = x + lengthdir_x(-12 * image_xscale, image_angle);
var light_y = y + lengthdir_y(-12 * image_xscale, image_angle);
var indicator_color = active ? c_lime : col;

draw_self();
draw_set_color(indicator_color);
draw_circle(light_x, light_y, 2, false);

//draw_text(x, y - 100, laser_time);
//draw_text(x, y - 50, laser_timer);

if(cam_light != undefined){
	cam_light.x = light_x;
	cam_light.y = light_y;
	cam_light.blend = indicator_color;
}

if(emitting_timer > 0){
	for(var i = 0; i < l_n; i ++){
		draw_set_color(col);
		var ray_length = min(l_dist, l_stops[i]);
		draw_line_width(x, y, x + lengthdir_x(ray_length, l_points[i]), y + lengthdir_y(ray_length, l_points[i]), 4);	
	}
}
