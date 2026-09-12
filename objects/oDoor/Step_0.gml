event_inherited();

if(door_light != undefined){
	door_light.x = x + lengthdir_x(49 * image_xscale, image_angle);
	door_light.y = y + lengthdir_y(49 * image_xscale, image_angle);
	door_light.blend = opened ? c_lime : c_red;
}
