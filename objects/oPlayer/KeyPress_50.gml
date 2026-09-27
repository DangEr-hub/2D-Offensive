/// @description Equip secondary weapon
// You can write your code in this editor
if(is_local == true && moving_state != STATES_PLAYER.machine_gun_state){
	if(WeaponNumber != 1 && equip_timer == -1 && shooting == false){
		WeaponNumber = 1;
		if(global.ItemIndex[#global.Inventory[# OtherSlot.Secondary, INDEX.slot_id], ITEMSTATS.EquipTime] > 0){
			equip_time = 0;
			equip_timer = global.ItemIndex[#global.Inventory[# OtherSlot.Secondary, INDEX.slot_id], ITEMSTATS.EquipTime];
			equip_time_max = equip_timer;
		}else{
			switch_weapon_number();	
		}
	}
}
