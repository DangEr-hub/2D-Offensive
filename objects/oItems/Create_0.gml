/* oItems Create event */
PushForce = 0;
scope_attachment = -1;
barrel_attachment = -1;
grip_attachment = -1;
suppressor_attachment = -1;
image_speed = 0;
image_angle = random(360);
Amount = 1;
z = 0;
zgravity = 4;
zmaxspeed = 20;
zspeed = zmaxspeed;
LightObject = undefined;
PushTimer = -1;
PushDirection = 0;
ClipAmmo = -1;
Ammo = -1;
Durability = -1;
alarm[0] = 1;
network_id = -1;

if (IS_NET) {
	target_x = x;
	target_y = y;
	if(oNetworkManager.is_server){
	    network_id = compute_item_network_id();   
	    var data = ds_map_create();
	    ds_map_set(data, "object_index", object_index);
	    ds_map_set(data, "x", x);
	    ds_map_set(data, "y", y);
	    ds_map_set(data, "image_index", image_index);
	    ds_map_set(oNetworkManager.item_registry, network_id, data);
	    last_x = x;
	    last_y = y;
	    needs_sync = false;
	}
}

