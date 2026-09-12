event_inherited();

Visible = true;
Type = MATERIAL.METAL;
image_index = choose(0, 1);
image_speed = 0;
image_angle = random(360);
stats = {
	Item_id: image_index == 1 ? Item.nuclear_explosion : Item.base_explosion,
	Damage: 0,
	Object_index: -1,
	Owner_name: "",
	Object: noone,
	Health_points: 100 * (image_index + 1),
};

//haze = haze_circle_add(x, y, sprite_width*1.5);

stats.Damage = global.ItemIndex[#stats.Item_id, ItemStat.Damage];