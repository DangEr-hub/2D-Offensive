event_inherited();
light = undefined;
if(instance_exists(oLightRenderer)){
	light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
	light.castShadows = false;
	light.xscale = 1;
	light.yscale = 1;
	light.alpha = 1;
	light.blend = c_blue;
}







