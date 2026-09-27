

Floor = instance_create_depth(x, y, depth + 10, oMachineGunFloor);
stats = {
	"Slot_scope": ITEM.None,
	"Slot_barrel": ITEM.None,
	"Slot_grip": ITEM.None,
	"Slot_suppressor": ITEM.None,
	"Ammo": global.ItemIndex[#ITEM.basic_machine_gun, ITEMSTATS.MaxAmmo],
	"Clip_ammo": global.ItemIndex[#ITEM.basic_machine_gun, ITEMSTATS.ClipAmmo],
	"Id": ITEM.basic_machine_gun,
	"Object": noone
};
Floor.stats = stats;
operator_pid = -1;
image_speed = 0;
