if (IS_NET && network_authority && network_id >= 0 && instance_exists(oNetworkManager)) {
	if (oNetworkManager.free_airplane_ids != -1 && ds_exists(oNetworkManager.free_airplane_ids, ds_type_stack)) {
		ds_stack_push(oNetworkManager.free_airplane_ids, network_id);
	}
}

sprite_explode(30, 10, 10, 5, 5, 10, 5, 0, 0, 1, c_white, 0, -1, image_index);
