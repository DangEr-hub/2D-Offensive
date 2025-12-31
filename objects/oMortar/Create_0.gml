event_inherited();
occluder.Destroy();
oLightRenderer.lighting.RefreshStaticOccluders();
Type = MATERIAL.METAL;
image_speed = 0;
image_index = 0;
shoot_timer = -1;
shoot_time = 2 * game_get_speed(gamespeed_fps);

stats = {
	Item_id: Item.base_explosion,
	Damage: global.ItemIndex[#Item.base_explosion, ItemStat.Damage],
	Object_index: global.local_player.object_index,
	Owner_name: global.local_player.Name,
	Object: global.local_player,
	Health_points: 100
};