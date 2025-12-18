/* oNetworkManager clean up event */
if (ds_exists(item_registry, ds_type_map)) {
    var key = ds_map_find_first(item_registry);
    var count = ds_map_size(item_registry);
    for (var i = 0; i < count; i++) {
        var data = ds_map_find_value(item_registry, key);
        ds_map_destroy(data);
        key = ds_map_find_next(item_registry, key);
    }
    ds_map_destroy(item_registry);
}

ds_list_destroy(item_pos_buffer);
if(free_item_ids != -1){
	ds_stack_destroy(free_item_ids);
}

ds_map_destroy(bird_registry);

if (oNetworkManager.is_server) {
    // Server shutdown
    if (server_socket >= 0) {
        // Notify all clients
        var socket_key = ds_map_find_first(clients);
        for (var i = 0; i < ds_map_size(clients); i++) {
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, PACKET.DISCONNECT);
            buffer_write(send_buffer, buffer_u32, send_sequence++);
            sent_server_udp(server_socket, socket_key, send_buffer);
            socket_key = ds_map_find_next(clients, socket_key);
        }
            
        network_destroy(server_socket);
        server_socket = -1;
    }
} else {
    // Client disconnect
	if(global.Inventory[# OtherSlot.Primary, Index.slot_id] != Item.None){
		request_item_drop(
			global.Inventory[# OtherSlot.Primary, Index.slot_id],
			global.local_player.x,
			global.local_player.y,
			global.Inventory[# OtherSlot.Primary, Index.slot_ammo],
			global.Inventory[# OtherSlot.Primary, Index.slot_clip_ammo],
			global.Inventory[# OtherSlot.Primary, Index.slot_durability],
			global.Inventory[# OtherSlot.Primary, Index.SlotAmount],
			-1,
			-1,
			-1,
			-1,
		);
	}
	if(global.Inventory[# OtherSlot.Primary, Index.slot_id] != Item.None){
	request_item_drop(
		global.Inventory[# OtherSlot.Secondary, Index.slot_id],
		global.local_player.x,
		global.local_player.y,
		global.Inventory[# OtherSlot.Secondary, Index.slot_ammo],
		global.Inventory[# OtherSlot.Secondary, Index.slot_clip_ammo],
		global.Inventory[# OtherSlot.Secondary, Index.slot_durability],
		global.Inventory[# OtherSlot.Secondary, Index.SlotAmount],
		-1,
		-1,
		-1,
		-1,
	);
	}
	if(global.Inventory[# OtherSlot.Primary, Index.slot_id] != Item.None){
	request_item_drop(
		global.Inventory[# OtherSlot.Helmet, Index.slot_id],
		global.local_player.x,
		global.local_player.y,
		global.Inventory[# OtherSlot.Helmet, Index.slot_ammo],
		global.Inventory[# OtherSlot.Helmet, Index.slot_clip_ammo],
		global.Inventory[# OtherSlot.Helmet, Index.slot_durability],
		global.Inventory[# OtherSlot.Helmet, Index.SlotAmount],
		-1,
		-1,
		-1,
		-1,
	);
	}
	if(global.Inventory[# OtherSlot.Primary, Index.slot_id] != Item.None){
	request_item_drop(
		global.Inventory[# OtherSlot.Armour, Index.slot_id],
		global.local_player.x,
		global.local_player.y,
		global.Inventory[# OtherSlot.Armour, Index.slot_ammo],
		global.Inventory[# OtherSlot.Armour, Index.slot_clip_ammo],
		global.Inventory[# OtherSlot.Armour, Index.slot_durability],
		global.Inventory[# OtherSlot.Armour, Index.SlotAmount],
		-1,
		-1,
		-1,
		-1,
	);
	}
    disconnect_from_server();
}












