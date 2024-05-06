/// @description Insert description here
// You can write your code in this editor
if(player_has_machine_gun()){
	for(var i = 0;i<weapon_attachments.Total;i++){
		global.weapon_attachments[0][i] = Item.None;
	}
	global.weapon_id[0] = Item.None;
	global.ClipAmmo[0] = 0;
	global.Ammo[0] = 0;
	global.MaxAmmo[0] = 0;
}
for(var i=0;i<ds_grid_width(global.ItemIndex);i++){
	if(global.ItemIndex[#i, ItemStat.ShootingMode] != 0){
		ds_list_destroy(global.ItemIndex[#i, ItemStat.ShootingMode]);	
	}
}