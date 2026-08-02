function item_swap(type, slot_type){
	if!(instance_exists(oInventory)){
		global.local_player.item_equip_timer = global.local_player.item_equip_time;
	}
	TempArray = array_create(Index.Total - 1, 0);
	TempArray[Index.slot_id] = global.Inventory[# slot_type, Index.slot_id];
	TempArray[Index.SlotAmount] = global.Inventory[# slot_type, Index.SlotAmount];
	TempArray[Index.slot_ammo] = global.Inventory[# slot_type, Index.slot_ammo];
	TempArray[Index.slot_clip_ammo] = global.Inventory[# slot_type, Index.slot_clip_ammo];
	TempArray[Index.slot_durability] = global.Inventory[# slot_type, Index.slot_durability];
	TempArray[Index.SlotShootingType] = global.Inventory[# slot_type, Index.SlotShootingType];
	TempArray[Index.slot_barrel] = global.Inventory[# slot_type, Index.slot_barrel];
	TempArray[Index.slot_grip] = global.Inventory[# slot_type, Index.slot_grip];
	TempArray[Index.slot_scope] = global.Inventory[# slot_type, Index.slot_scope];
	TempArray[Index.slot_suppressor] = global.Inventory[# slot_type, Index.slot_suppressor];
	
	if(type == "mouse"){
		
		global.Inventory[# slot_type, Index.slot_id] = global.MouseSlot[# 0, Index.slot_id];
		global.Inventory[# slot_type, Index.SlotAmount] = global.MouseSlot[# 0, Index.SlotAmount];
		global.Inventory[# slot_type, Index.slot_ammo] = global.MouseSlot[# 0, Index.slot_ammo];
		global.Inventory[# slot_type, Index.slot_clip_ammo] = global.MouseSlot[# 0, Index.slot_clip_ammo];
		global.Inventory[# slot_type, Index.slot_durability] = global.MouseSlot[# 0, Index.slot_durability];
		global.Inventory[# slot_type, Index.SlotShootingType] = global.MouseSlot[# 0, Index.SlotShootingType];
		global.Inventory[# slot_type, Index.slot_barrel] = global.MouseSlot[# 0, Index.slot_barrel];
		global.Inventory[# slot_type, Index.slot_grip] = global.MouseSlot[# 0, Index.slot_grip];
		global.Inventory[# slot_type, Index.slot_suppressor] = global.MouseSlot[# 0, Index.slot_suppressor];
		global.Inventory[# slot_type, Index.slot_scope] = global.MouseSlot[# 0, Index.slot_scope];	
	
		global.MouseSlot[# 0, Index.slot_id] = TempArray[Index.slot_id];
		global.MouseSlot[# 0, Index.SlotAmount] = TempArray[Index.SlotAmount];
		global.MouseSlot[# 0, Index.slot_ammo] = TempArray[Index.slot_ammo];
		global.MouseSlot[# 0, Index.slot_clip_ammo] = TempArray[Index.slot_clip_ammo];
		global.MouseSlot[# 0, Index.slot_durability] = TempArray[Index.slot_durability];
		global.MouseSlot[# 0, Index.SlotShootingType] = TempArray[Index.SlotShootingType];
		global.MouseSlot[# 0, Index.slot_barrel] = TempArray[Index.slot_barrel];
		global.MouseSlot[# 0, Index.slot_grip] = TempArray[Index.slot_grip];
		global.MouseSlot[# 0, Index.slot_suppressor] = TempArray[Index.slot_suppressor];
		global.MouseSlot[# 0, Index.slot_scope] = TempArray[Index.slot_scope];
		
	}else if(type == "item_use_position"){
		
		global.Inventory[# slot_type, Index.slot_id] = global.Inventory[# global.local_player.item_use_position, Index.slot_id];
		global.Inventory[# slot_type, Index.SlotAmount] = global.Inventory[# global.local_player.item_use_position, Index.SlotAmount];
		global.Inventory[# slot_type, Index.slot_ammo] = global.Inventory[# global.local_player.item_use_position, Index.slot_ammo];
		global.Inventory[# slot_type, Index.slot_clip_ammo] = global.Inventory[# global.local_player.item_use_position, Index.slot_clip_ammo];
		global.Inventory[# slot_type, Index.slot_durability] = global.Inventory[# global.local_player.item_use_position, Index.slot_durability];
		global.Inventory[# slot_type, Index.SlotShootingType] = global.Inventory[# global.local_player.item_use_position, Index.SlotShootingType];
		global.Inventory[# slot_type, Index.slot_barrel] = global.Inventory[# global.local_player.item_use_position, Index.slot_barrel];
		global.Inventory[# slot_type, Index.slot_grip] = global.Inventory[# global.local_player.item_use_position, Index.slot_grip];
		global.Inventory[# slot_type, Index.slot_suppressor] = global.Inventory[# global.local_player.item_use_position, Index.slot_suppressor];
		global.Inventory[# slot_type, Index.slot_scope] = global.Inventory[# global.local_player.item_use_position, Index.slot_scope];	
	
		global.Inventory[# global.local_player.item_use_position, Index.slot_id] = TempArray[Index.slot_id];
		global.Inventory[# global.local_player.item_use_position, Index.SlotAmount] = TempArray[Index.SlotAmount];
		global.Inventory[# global.local_player.item_use_position, Index.slot_ammo] = TempArray[Index.slot_ammo];
		global.Inventory[# global.local_player.item_use_position, Index.slot_clip_ammo] = TempArray[Index.slot_clip_ammo];
		global.Inventory[# global.local_player.item_use_position, Index.slot_durability] = TempArray[Index.slot_durability];
		global.Inventory[# global.local_player.item_use_position, Index.SlotShootingType] = TempArray[Index.SlotShootingType];
		global.Inventory[# global.local_player.item_use_position, Index.slot_barrel] = TempArray[Index.slot_barrel];
		global.Inventory[# global.local_player.item_use_position, Index.slot_grip] = TempArray[Index.slot_grip];
		global.Inventory[# global.local_player.item_use_position, Index.slot_suppressor] = TempArray[Index.slot_suppressor];
		global.Inventory[# global.local_player.item_use_position, Index.slot_scope] = TempArray[Index.slot_scope];
	}else if(type == "description_button"){
		
		for(var i=0;i<Index.Total;i++){
			global.Inventory[# slot_type, i] = 0;
		}
		
	}else if(type == "varslot"){
		// Uvnitř objektu oSlot jenom - VarSlot proměnná
		global.Inventory[# slot_type, Index.slot_id] = global.Inventory[# VarSlot, Index.slot_id];
		global.Inventory[# slot_type, Index.SlotAmount] = global.Inventory[# VarSlot, Index.SlotAmount];
		global.Inventory[# slot_type, Index.slot_ammo] = global.Inventory[# VarSlot, Index.slot_ammo];
		global.Inventory[# slot_type, Index.slot_clip_ammo] = global.Inventory[# VarSlot, Index.slot_clip_ammo];
		global.Inventory[# slot_type, Index.slot_durability] = global.Inventory[# VarSlot, Index.slot_durability];
		global.Inventory[# slot_type, Index.SlotShootingType] = global.Inventory[# VarSlot, Index.SlotShootingType];
		global.Inventory[# slot_type, Index.slot_barrel] = global.Inventory[# VarSlot, Index.slot_barrel];
		global.Inventory[# slot_type, Index.slot_grip] = global.Inventory[# VarSlot, Index.slot_grip];
		global.Inventory[# slot_type, Index.slot_suppressor] = global.Inventory[# VarSlot, Index.slot_suppressor];
		global.Inventory[# slot_type, Index.slot_scope] = global.Inventory[# VarSlot, Index.slot_scope];	
	
		global.Inventory[# VarSlot, Index.slot_id] = TempArray[Index.slot_id];
		global.Inventory[# VarSlot, Index.SlotAmount] = TempArray[Index.SlotAmount];
		global.Inventory[# VarSlot, Index.slot_ammo] = TempArray[Index.slot_ammo];
		global.Inventory[# VarSlot, Index.slot_clip_ammo] = TempArray[Index.slot_clip_ammo];
		global.Inventory[# VarSlot, Index.slot_durability] = TempArray[Index.slot_durability];
		global.Inventory[# VarSlot, Index.SlotShootingType] = TempArray[Index.SlotShootingType];
		global.Inventory[# VarSlot, Index.slot_barrel] = TempArray[Index.slot_barrel];
		global.Inventory[# VarSlot, Index.slot_grip] = TempArray[Index.slot_grip];
		global.Inventory[# VarSlot, Index.slot_suppressor] = TempArray[Index.slot_suppressor];
		global.Inventory[# VarSlot, Index.slot_scope] = TempArray[Index.slot_scope];
	}else if(type == "draw_varslot"){
		// Uvnitř description od itemu/zbraně/armouru
		global.Inventory[# slot_type, Index.slot_id] = global.Inventory[# oDraw.var_slot, Index.slot_id];
		global.Inventory[# slot_type, Index.SlotAmount] = global.Inventory[# oDraw.var_slot, Index.SlotAmount];
		global.Inventory[# slot_type, Index.slot_ammo] = global.Inventory[# oDraw.var_slot, Index.slot_ammo];
		global.Inventory[# slot_type, Index.slot_clip_ammo] = global.Inventory[# oDraw.var_slot, Index.slot_clip_ammo];
		global.Inventory[# slot_type, Index.slot_durability] = global.Inventory[# oDraw.var_slot, Index.slot_durability];
		global.Inventory[# slot_type, Index.SlotShootingType] = global.Inventory[# oDraw.var_slot, Index.SlotShootingType];
		global.Inventory[# slot_type, Index.slot_barrel] = global.Inventory[# oDraw.var_slot, Index.slot_barrel];
		global.Inventory[# slot_type, Index.slot_grip] = global.Inventory[# oDraw.var_slot, Index.slot_grip];
		global.Inventory[# slot_type, Index.slot_suppressor] = global.Inventory[# oDraw.var_slot, Index.slot_suppressor];
		global.Inventory[# slot_type, Index.slot_scope] = global.Inventory[# oDraw.var_slot, Index.slot_scope];	
	
		global.Inventory[# oDraw.var_slot, Index.slot_id] = TempArray[Index.slot_id];
		global.Inventory[# oDraw.var_slot, Index.SlotAmount] = TempArray[Index.SlotAmount];
		global.Inventory[# oDraw.var_slot, Index.slot_ammo] = TempArray[Index.slot_ammo];
		global.Inventory[# oDraw.var_slot, Index.slot_clip_ammo] = TempArray[Index.slot_clip_ammo];
		global.Inventory[# oDraw.var_slot, Index.slot_durability] = TempArray[Index.slot_durability];
		global.Inventory[# oDraw.var_slot, Index.SlotShootingType] = TempArray[Index.SlotShootingType];
		global.Inventory[# oDraw.var_slot, Index.slot_barrel] = TempArray[Index.slot_barrel];
		global.Inventory[# oDraw.var_slot, Index.slot_grip] = TempArray[Index.slot_grip];
		global.Inventory[# oDraw.var_slot, Index.slot_suppressor] = TempArray[Index.slot_suppressor];
		global.Inventory[# oDraw.var_slot, Index.slot_scope] = TempArray[Index.slot_scope];
	}
	
	if(IS_NET){
		if(slot_type == OtherSlot.Primary || slot_type == OtherSlot.Secondary || slot_type == OtherSlot.Knife){
			with(global.local_player){ weapon_network_propagate(); }
		}else{
			with(global.local_player){ equip_network_propagate(); }
		}
	}
	
	TempArray = undefined;	
}