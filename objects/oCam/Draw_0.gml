var light_x = x;
var light_y = y;
var indicator_color = active ? (alarm_triggered == false ? c_lime : c_orange) : c_red;

draw_self();
draw_set_color(indicator_color);
draw_circle(light_x, light_y, 2, false);

if(cam_light != undefined){
	cam_light.x = light_x;
	cam_light.y = light_y;
	cam_light.blend = indicator_color;
}


if(active == true){
	draw_set_alpha(.05);
	draw_set_color(indicator_color);
	draw_triangle(x, y, lx1, ly1, lx2, ly2, false);
	draw_set_alpha(1);
}