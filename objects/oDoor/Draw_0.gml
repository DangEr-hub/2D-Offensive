draw_self();
event_inherited();
draw_text(x, y, main_angle);

var light_x = x + lengthdir_x(48 * image_xscale, image_angle);
var light_y = y + lengthdir_y(48 * image_xscale, image_angle);
var previous_color = draw_get_color();
var indicator_color = opened ? c_lime : c_red;

if(door_light != undefined){
	door_light.x = light_x;
	door_light.y = light_y;
	door_light.blend = indicator_color;
}

draw_set_color(indicator_color);
draw_set_alpha(.5);
draw_circle(light_x, light_y, 3, false);
draw_set_color(previous_color);
draw_set_alpha(1);
