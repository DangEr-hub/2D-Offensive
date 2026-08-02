/// @description Equip shield
// You can write your code in this editor
if(is_local == true){
	if(WeaponNumber != 3 && equip_timer == -1 && shooting == false){
		WeaponNumber = 3;
		if(global.ItemIndex[#global.Inventory[# OtherSlot.Shield, Index.slot_id], ItemStat.EquipTime] > 0){
			equip_time = 0;
			equip_timer = global.ItemIndex[#global.Inventory[# OtherSlot.Shield, Index.slot_id], ItemStat.EquipTime];
			equip_time_max = equip_timer;
		}else{
			switch_weapon_number();	
		}
	}
}