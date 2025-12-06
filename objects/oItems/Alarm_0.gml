/// @description Post-create event
ItemDeclare();
if(LightObject == undefined || LightObject == -1){
	LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
	LightObject.castShadows = false;
	LightObject.xscale = .5;
	LightObject.yscale = .5;
	LightObject.blend = global.ItemIndex[#image_index, ItemStat.ItemColor];
}

if (IS_NET) {
	if(oNetworkManager.is_server){  
		with(oNetworkManager){
		    var data = ds_map_create();
		    ds_map_set(data, "object_index", object_index);
		    ds_map_set(data, "x", x);
		    ds_map_set(data, "y", y);
		    ds_map_set(data, "image_index", image_index);
			ds_map_set(data, "scope", scope_attachment);
			ds_map_set(data, "barrel", barrel_attachment);
			ds_map_set(data, "grip", grip_attachment);
			ds_map_set(data, "suppressor", suppressor_attachment);
			ds_map_set(data, "clip_ammo", ClipAmmo);
			ds_map_set(data, "ammo", Ammo);
			ds_map_set(data, "durability", Durability);
		    ds_map_set(oNetworkManager.item_registry, network_id, data);
		}
	}
}