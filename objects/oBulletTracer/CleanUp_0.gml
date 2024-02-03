event_inherited();
if(infra_vision_light != undefined){
	infra_vision_light.Destroy();
	infra_vision_light = undefined;
}
LightObject.Destroy();
LightObject = undefined;
ds_list_destroy(HitList);

