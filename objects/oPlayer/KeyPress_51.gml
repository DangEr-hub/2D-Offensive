/// @description Insert description here
// You can write your code in this editor
if(WeaponNumber != 2 && equip_timer == -1 && shooting == false){
	WeaponNumber = 2;
	if(global.ItemIndex[#global.Inventory[# OtherSlot.Knife, Index.slot_id], ItemStat.EquipTime] > 0){
		equip_timer = global.ItemIndex[#global.Inventory[# OtherSlot.Knife, Index.slot_id], ItemStat.EquipTime];
	}else{
		switch_weapon_number();	
	}
}