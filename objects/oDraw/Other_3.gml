/// @description Insert description here
// You can write your code in this editor
if(player_has_machine_gun()){
	for(var i = INDEX.slot_scope; i <= INDEX.slot_suppressor; i++){
		global.Inventory[# OtherSlot.Primary, i] = ITEM.None;
	}
	global.Inventory[# OtherSlot.Primary, INDEX.slot_id] = ITEM.None;
	global.Inventory[# OtherSlot.Primary, INDEX.slot_ammo] = ITEM.None;
	global.Inventory[# OtherSlot.Primary, INDEX.slot_clip_ammo] = ITEM.None;
}
for(var i=0;i<ds_grid_width(global.ItemIndex);i++){
	if(global.ItemIndex[#i, ITEMSTATS.ShootingMode] != 0){
		ds_list_destroy(global.ItemIndex[#i, ITEMSTATS.ShootingMode]);	
	}
}
