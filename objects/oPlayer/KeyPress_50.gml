/// @description Equip secondary weapon
// You can write your code in this editor
if(is_local == true){
	if(WeaponNumber != 1 && equip_timer == -1 && shooting == false){
		WeaponNumber = 1;
		if(global.ItemIndex[#global.Inventory[# OtherSlot.Secondary, Index.slot_id], ItemStat.EquipTime] > 0){
			equip_timer = global.ItemIndex[#global.Inventory[# OtherSlot.Secondary, Index.slot_id], ItemStat.EquipTime];
		}else{
			switch_weapon_number();	
		}
	}
}