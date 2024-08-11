/// @description Equip primary weapon
// You can write your code in this editor
if(WeaponNumber != 0 && equip_timer == -1 && shooting == false){
	WeaponNumber = 0;
	if(global.ItemIndex[#global.Inventory[# OtherSlot.Primary, Index.slot_id], ItemStat.EquipTime] > 0){
		//equip_time = 0;
		equip_timer = global.ItemIndex[#global.Inventory[# OtherSlot.Primary, Index.slot_id], ItemStat.EquipTime];
	}else{
		switch_weapon_number();
	}
}