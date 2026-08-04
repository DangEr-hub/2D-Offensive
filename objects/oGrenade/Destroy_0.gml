if(IS_NET && network_authority && instance_exists(oNetworkManager) && network_id >= 0){
	if(ds_exists(oNetworkManager.grenade_registry, ds_type_map) && ds_map_exists(oNetworkManager.grenade_registry, network_id)){
		ds_map_delete(oNetworkManager.grenade_registry, network_id);
	}
	if(oNetworkManager.free_grenade_ids != -1 && ds_exists(oNetworkManager.free_grenade_ids, ds_type_stack)){
		ds_stack_push(oNetworkManager.free_grenade_ids, network_id);
	}
}

sprite_explode(30, 10, 10, 5, 5, 10, 5, 0, 0, 1, c_white, 0, -1, image_index);
