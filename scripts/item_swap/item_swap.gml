function item_swap(type, slot_type){
	if(slot_type >= OtherSlot.Primary && slot_type < OtherSlot.Total && type != "description_button"){
		var moving_item_id = ITEM.None;
		switch(type){
			case "mouse": moving_item_id = global.MouseSlot[# 0, INDEX.slot_id]; break;
			case "varslot": moving_item_id = global.Inventory[# VarSlot, INDEX.slot_id]; break;
			case "draw_varslot": moving_item_id = global.Inventory[# oDraw.var_slot, INDEX.slot_id]; break;
			case "item_use_position": moving_item_id = global.Inventory[# global.local_player.item_use_position, INDEX.slot_id]; break;
		}
		if(moving_item_id != ITEM.None){
			var moving_item_type = global.ItemIndex[# moving_item_id, ITEMSTATS.Type];
			var moving_weapon_type = global.ItemIndex[# moving_item_id, ITEMSTATS.WeaponType];
			var compatible = (slot_type == OtherSlot.Primary && moving_item_type == "Weapon" && moving_weapon_type == WEAPON_TYPE.PRIMARY)
				|| (slot_type == OtherSlot.Secondary && moving_item_type == "Weapon" && moving_weapon_type == WEAPON_TYPE.SECONDARY)
				|| (slot_type == OtherSlot.Knife && moving_item_type == "Weapon" && moving_weapon_type == WEAPON_TYPE.TERTIARY)
				|| (slot_type == OtherSlot.Helmet && moving_item_type == "Helmet")
				|| (slot_type == OtherSlot.Armour && moving_item_type == "Armour")
				|| (slot_type == OtherSlot.Shield && moving_item_type == "Shield");
			if(!compatible) return;
		}
	}
	if!(instance_exists(oInventory)){
		global.local_player.item_equip_timer = global.local_player.item_equip_time;
	}
	TempArray = array_create(INDEX.Total - 1, 0);
	TempArray[INDEX.slot_id] = global.Inventory[# slot_type, INDEX.slot_id];
	TempArray[INDEX.SlotAmount] = global.Inventory[# slot_type, INDEX.SlotAmount];
	TempArray[INDEX.slot_ammo] = global.Inventory[# slot_type, INDEX.slot_ammo];
	TempArray[INDEX.slot_clip_ammo] = global.Inventory[# slot_type, INDEX.slot_clip_ammo];
	TempArray[INDEX.slot_durability] = global.Inventory[# slot_type, INDEX.slot_durability];
	TempArray[INDEX.SlotShootingType] = global.Inventory[# slot_type, INDEX.SlotShootingType];
	TempArray[INDEX.slot_barrel] = global.Inventory[# slot_type, INDEX.slot_barrel];
	TempArray[INDEX.slot_grip] = global.Inventory[# slot_type, INDEX.slot_grip];
	TempArray[INDEX.slot_scope] = global.Inventory[# slot_type, INDEX.slot_scope];
	TempArray[INDEX.slot_suppressor] = global.Inventory[# slot_type, INDEX.slot_suppressor];
	
	if(type == "mouse"){
		
		global.Inventory[# slot_type, INDEX.slot_id] = global.MouseSlot[# 0, INDEX.slot_id];
		global.Inventory[# slot_type, INDEX.SlotAmount] = global.MouseSlot[# 0, INDEX.SlotAmount];
		global.Inventory[# slot_type, INDEX.slot_ammo] = global.MouseSlot[# 0, INDEX.slot_ammo];
		global.Inventory[# slot_type, INDEX.slot_clip_ammo] = global.MouseSlot[# 0, INDEX.slot_clip_ammo];
		global.Inventory[# slot_type, INDEX.slot_durability] = global.MouseSlot[# 0, INDEX.slot_durability];
		global.Inventory[# slot_type, INDEX.SlotShootingType] = global.MouseSlot[# 0, INDEX.SlotShootingType];
		global.Inventory[# slot_type, INDEX.slot_barrel] = global.MouseSlot[# 0, INDEX.slot_barrel];
		global.Inventory[# slot_type, INDEX.slot_grip] = global.MouseSlot[# 0, INDEX.slot_grip];
		global.Inventory[# slot_type, INDEX.slot_suppressor] = global.MouseSlot[# 0, INDEX.slot_suppressor];
		global.Inventory[# slot_type, INDEX.slot_scope] = global.MouseSlot[# 0, INDEX.slot_scope];	
	
		global.MouseSlot[# 0, INDEX.slot_id] = TempArray[INDEX.slot_id];
		global.MouseSlot[# 0, INDEX.SlotAmount] = TempArray[INDEX.SlotAmount];
		global.MouseSlot[# 0, INDEX.slot_ammo] = TempArray[INDEX.slot_ammo];
		global.MouseSlot[# 0, INDEX.slot_clip_ammo] = TempArray[INDEX.slot_clip_ammo];
		global.MouseSlot[# 0, INDEX.slot_durability] = TempArray[INDEX.slot_durability];
		global.MouseSlot[# 0, INDEX.SlotShootingType] = TempArray[INDEX.SlotShootingType];
		global.MouseSlot[# 0, INDEX.slot_barrel] = TempArray[INDEX.slot_barrel];
		global.MouseSlot[# 0, INDEX.slot_grip] = TempArray[INDEX.slot_grip];
		global.MouseSlot[# 0, INDEX.slot_suppressor] = TempArray[INDEX.slot_suppressor];
		global.MouseSlot[# 0, INDEX.slot_scope] = TempArray[INDEX.slot_scope];
		
	}else if(type == "item_use_position"){
		
		global.Inventory[# slot_type, INDEX.slot_id] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_id];
		global.Inventory[# slot_type, INDEX.SlotAmount] = global.Inventory[# global.local_player.item_use_position, INDEX.SlotAmount];
		global.Inventory[# slot_type, INDEX.slot_ammo] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_ammo];
		global.Inventory[# slot_type, INDEX.slot_clip_ammo] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_clip_ammo];
		global.Inventory[# slot_type, INDEX.slot_durability] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_durability];
		global.Inventory[# slot_type, INDEX.SlotShootingType] = global.Inventory[# global.local_player.item_use_position, INDEX.SlotShootingType];
		global.Inventory[# slot_type, INDEX.slot_barrel] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_barrel];
		global.Inventory[# slot_type, INDEX.slot_grip] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_grip];
		global.Inventory[# slot_type, INDEX.slot_suppressor] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_suppressor];
		global.Inventory[# slot_type, INDEX.slot_scope] = global.Inventory[# global.local_player.item_use_position, INDEX.slot_scope];	
	
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_id] = TempArray[INDEX.slot_id];
		global.Inventory[# global.local_player.item_use_position, INDEX.SlotAmount] = TempArray[INDEX.SlotAmount];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_ammo] = TempArray[INDEX.slot_ammo];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_clip_ammo] = TempArray[INDEX.slot_clip_ammo];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_durability] = TempArray[INDEX.slot_durability];
		global.Inventory[# global.local_player.item_use_position, INDEX.SlotShootingType] = TempArray[INDEX.SlotShootingType];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_barrel] = TempArray[INDEX.slot_barrel];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_grip] = TempArray[INDEX.slot_grip];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_suppressor] = TempArray[INDEX.slot_suppressor];
		global.Inventory[# global.local_player.item_use_position, INDEX.slot_scope] = TempArray[INDEX.slot_scope];
	}else if(type == "description_button"){
		
		for(var i=0;i<INDEX.Total;i++){
			global.Inventory[# slot_type, i] = 0;
		}
		
	}else if(type == "varslot"){
		// Uvnitř objektu oSlot jenom - VarSlot proměnná
		global.Inventory[# slot_type, INDEX.slot_id] = global.Inventory[# VarSlot, INDEX.slot_id];
		global.Inventory[# slot_type, INDEX.SlotAmount] = global.Inventory[# VarSlot, INDEX.SlotAmount];
		global.Inventory[# slot_type, INDEX.slot_ammo] = global.Inventory[# VarSlot, INDEX.slot_ammo];
		global.Inventory[# slot_type, INDEX.slot_clip_ammo] = global.Inventory[# VarSlot, INDEX.slot_clip_ammo];
		global.Inventory[# slot_type, INDEX.slot_durability] = global.Inventory[# VarSlot, INDEX.slot_durability];
		global.Inventory[# slot_type, INDEX.SlotShootingType] = global.Inventory[# VarSlot, INDEX.SlotShootingType];
		global.Inventory[# slot_type, INDEX.slot_barrel] = global.Inventory[# VarSlot, INDEX.slot_barrel];
		global.Inventory[# slot_type, INDEX.slot_grip] = global.Inventory[# VarSlot, INDEX.slot_grip];
		global.Inventory[# slot_type, INDEX.slot_suppressor] = global.Inventory[# VarSlot, INDEX.slot_suppressor];
		global.Inventory[# slot_type, INDEX.slot_scope] = global.Inventory[# VarSlot, INDEX.slot_scope];	
	
		global.Inventory[# VarSlot, INDEX.slot_id] = TempArray[INDEX.slot_id];
		global.Inventory[# VarSlot, INDEX.SlotAmount] = TempArray[INDEX.SlotAmount];
		global.Inventory[# VarSlot, INDEX.slot_ammo] = TempArray[INDEX.slot_ammo];
		global.Inventory[# VarSlot, INDEX.slot_clip_ammo] = TempArray[INDEX.slot_clip_ammo];
		global.Inventory[# VarSlot, INDEX.slot_durability] = TempArray[INDEX.slot_durability];
		global.Inventory[# VarSlot, INDEX.SlotShootingType] = TempArray[INDEX.SlotShootingType];
		global.Inventory[# VarSlot, INDEX.slot_barrel] = TempArray[INDEX.slot_barrel];
		global.Inventory[# VarSlot, INDEX.slot_grip] = TempArray[INDEX.slot_grip];
		global.Inventory[# VarSlot, INDEX.slot_suppressor] = TempArray[INDEX.slot_suppressor];
		global.Inventory[# VarSlot, INDEX.slot_scope] = TempArray[INDEX.slot_scope];
	}else if(type == "draw_varslot"){
		// Uvnitř description od itemu/zbraně/armouru
		global.Inventory[# slot_type, INDEX.slot_id] = global.Inventory[# oDraw.var_slot, INDEX.slot_id];
		global.Inventory[# slot_type, INDEX.SlotAmount] = global.Inventory[# oDraw.var_slot, INDEX.SlotAmount];
		global.Inventory[# slot_type, INDEX.slot_ammo] = global.Inventory[# oDraw.var_slot, INDEX.slot_ammo];
		global.Inventory[# slot_type, INDEX.slot_clip_ammo] = global.Inventory[# oDraw.var_slot, INDEX.slot_clip_ammo];
		global.Inventory[# slot_type, INDEX.slot_durability] = global.Inventory[# oDraw.var_slot, INDEX.slot_durability];
		global.Inventory[# slot_type, INDEX.SlotShootingType] = global.Inventory[# oDraw.var_slot, INDEX.SlotShootingType];
		global.Inventory[# slot_type, INDEX.slot_barrel] = global.Inventory[# oDraw.var_slot, INDEX.slot_barrel];
		global.Inventory[# slot_type, INDEX.slot_grip] = global.Inventory[# oDraw.var_slot, INDEX.slot_grip];
		global.Inventory[# slot_type, INDEX.slot_suppressor] = global.Inventory[# oDraw.var_slot, INDEX.slot_suppressor];
		global.Inventory[# slot_type, INDEX.slot_scope] = global.Inventory[# oDraw.var_slot, INDEX.slot_scope];	
	
		global.Inventory[# oDraw.var_slot, INDEX.slot_id] = TempArray[INDEX.slot_id];
		global.Inventory[# oDraw.var_slot, INDEX.SlotAmount] = TempArray[INDEX.SlotAmount];
		global.Inventory[# oDraw.var_slot, INDEX.slot_ammo] = TempArray[INDEX.slot_ammo];
		global.Inventory[# oDraw.var_slot, INDEX.slot_clip_ammo] = TempArray[INDEX.slot_clip_ammo];
		global.Inventory[# oDraw.var_slot, INDEX.slot_durability] = TempArray[INDEX.slot_durability];
		global.Inventory[# oDraw.var_slot, INDEX.SlotShootingType] = TempArray[INDEX.SlotShootingType];
		global.Inventory[# oDraw.var_slot, INDEX.slot_barrel] = TempArray[INDEX.slot_barrel];
		global.Inventory[# oDraw.var_slot, INDEX.slot_grip] = TempArray[INDEX.slot_grip];
		global.Inventory[# oDraw.var_slot, INDEX.slot_suppressor] = TempArray[INDEX.slot_suppressor];
		global.Inventory[# oDraw.var_slot, INDEX.slot_scope] = TempArray[INDEX.slot_scope];
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
