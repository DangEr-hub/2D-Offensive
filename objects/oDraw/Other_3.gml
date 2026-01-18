/// @description Insert description here
// You can write your code in this editor
if(player_has_machine_gun()){
	for(var i = 0;i<WPN_ATTACHMENTS.Total;i++){
		global.weapon_attachments[0][i] = Item.None;
	}
	global.Inventory[# OtherSlot.Primary, Index.slot_id] = Item.None;
	global.Inventory[# OtherSlot.Primary, Index.slot_ammo] = Item.None;
	global.Inventory[# OtherSlot.Primary, Index.slot_clip_ammo] = Item.None;
}
for(var i=0;i<ds_grid_width(global.ItemIndex);i++){
	if(global.ItemIndex[#i, ItemStat.ShootingMode] != 0){
		ds_list_destroy(global.ItemIndex[#i, ItemStat.ShootingMode]);	
	}
}