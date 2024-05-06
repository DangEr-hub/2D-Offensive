Floor = instance_create_layer(x, y, "ItemsO", oMachineGunFloor);
stats = {
	"Slot_scope": Item.None,
	"Slot_barrel": Item.None,
	"Slot_grip": Item.None,
	"Slot_suppressor": Item.None,
	"Ammo": global.ItemIndex[#Item.basic_machine_gun, ItemStat.Ammo],
	"Clip_ammo": global.ItemIndex[#Item.basic_machine_gun, ItemStat.ClipAmmo],
	"Id": Item.basic_machine_gun,
	"Object": noone
};
Floor.stats = stats;
image_speed = 0;