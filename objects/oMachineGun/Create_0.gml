

Floor = instance_create_depth(x, y, depth + 10, oMachineGunFloor);
stats = {
	"Slot_scope": Item.None,
	"Slot_barrel": Item.None,
	"Slot_grip": Item.None,
	"Slot_suppressor": Item.None,
	"Ammo": global.ItemIndex[#Item.basic_machine_gun, ItemStat.MaxAmmo],
	"Clip_ammo": global.ItemIndex[#Item.basic_machine_gun, ItemStat.ClipAmmo],
	"Id": Item.basic_machine_gun,
	"Object": noone
};
Floor.stats = stats;
operator_pid = -1;
image_speed = 0;
