event_inherited();
image_speed = 0;
opened = false;
main_angle = image_angle;
alarm[0] = 1;

door_light = undefined;
if(instance_exists(oLightRenderer)){
	var light_x = x + lengthdir_x(48 * image_xscale, image_angle);
	var light_y = y + lengthdir_y(48 * image_xscale, image_angle);
	door_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, light_x, light_y);
	door_light.castShadows = false;
	door_light.xscale = 0.15;
	door_light.yscale = 0.15;
	door_light.alpha = 0.75;
	door_light.blend = c_red;
}
