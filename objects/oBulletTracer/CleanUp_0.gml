//if (is_local == true){
//	sync_object_destroy(id);
//}
if(infra_vision_light != undefined){
	infra_vision_light.Destroy();
	infra_vision_light = undefined;
}
LightObject.Destroy();
LightObject = undefined;
if(!is_undefined(HitList) && ds_exists(HitList, ds_type_list)){
	ds_list_destroy(HitList);
}
