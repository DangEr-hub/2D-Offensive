/// @description Insert description here
// You can write your code in this editor
for(var i=0;i<ds_grid_width(global.ItemIndex);i++){
	if(global.ItemIndex[#i, ItemStat.ShootingMode] != 0){
		ds_list_destroy(global.ItemIndex[#i, ItemStat.ShootingMode]);	
	}
}