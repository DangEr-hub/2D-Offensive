/// @description oItems Post-create event
/* oItems alarm[0] */
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
		if(creating_network_item == false){
			network_id = compute_item_network_id();
		}
		with(oNetworkManager){
		    var data;
			if (ds_map_exists(item_registry, other.network_id)) {
				data = ds_map_find_value(item_registry, other.network_id);
			} else {
				data = ds_map_create();
			}
		    ds_map_set(data, "obj_index", other.object_index);
		    ds_map_set(data, "x", other.x);
		    ds_map_set(data, "y", other.y);
		    ds_map_set(data, "image_index", other.image_index);
			ds_map_set(data, "scope", other.scope_attachment);
			ds_map_set(data, "barrel", other.barrel_attachment);
			ds_map_set(data, "grip", other.grip_attachment);
			ds_map_set(data, "suppressor", other.suppressor_attachment);
			ds_map_set(data, "clip_ammo", other.ClipAmmo);
			ds_map_set(data, "ammo", other.Ammo);
			ds_map_set(data, "durability", other.Durability);
			ds_map_set(data, "amount", other.Amount);
		    ds_map_set(item_registry, other.network_id, data);
		}
	}
}
