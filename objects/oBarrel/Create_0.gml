event_inherited();
randomize();
Type = "Metal";
image_index = choose(0, 1);
image_speed = 0;
stats = {
	Item_id: image_index == 1 ? Item.nuclear_explosion : Item.base_explosion,
	Damage: 0,
	Object_index: -1,
	Object_name: "",
	Object: noone,
	Health_points: 100 * (image_index + 1),
};

stats.Damage = global.ItemIndex[#stats.Item_id, ItemStat.Damage];