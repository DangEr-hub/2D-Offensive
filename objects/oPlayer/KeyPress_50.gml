/// @description Insert description here
// You can write your code in this editor
if(WeaponNumber != 1 && equip_timer == -1 && player_can_shoot == true){
	WeaponNumber = 1;
	if(global.ItemIndex[#global.weapon_id[min(max(1 - WeaponID, 0), 2)], ItemStat.EquipTime] > 0){
		equip_timer = global.ItemIndex[#global.weapon_id[min(max(1 - WeaponID, 0), 2)], ItemStat.EquipTime];
	}else{
		switch_weapon_number();	
	}
}