event_inherited();
ds_map_destroy(damage_hits);
if(cam_light != undefined){
	cam_light.Destroy();
	cam_light = undefined;
}
