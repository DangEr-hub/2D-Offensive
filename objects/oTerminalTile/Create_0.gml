event_inherited();
terminal_light = undefined;
if(instance_exists(oLightRenderer)){
	var light_x = x + lengthdir_x(48 * image_xscale, image_angle);
	var light_y = y + lengthdir_y(48 * image_xscale, image_angle);
	terminal_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, light_x, light_y);
	terminal_light.castShadows = false;
	terminal_light.xscale = 0.25;
	terminal_light.yscale = 0.25;
	terminal_light.alpha = 1.0;
	terminal_light.blend = c_aqua;
}