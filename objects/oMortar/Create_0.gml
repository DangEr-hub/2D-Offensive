image_speed = 0;
image_index = 0;
shoot_timer = -1;
shoot_time = 2 * game_get_speed(gamespeed_fps);

var tile = instance_create_layer(x, y, "SolidO", oParentTile);
tile.Type = MATERIAL.METAL;
tile.image_xscale = 0.5;
tile.image_yscale = 0.5;

stats = {
	Item_id: Item.base_explosion,
	Damage: global.ItemIndex[#Item.base_explosion, ItemStat.Damage],
	Object_index: global.local_player.object_index,
	Owner_name: global.local_player.Name,
	Object: global.local_player,
	Health_points: 100
};