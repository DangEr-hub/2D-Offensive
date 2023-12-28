function GainItem(ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, Destroy = true) {
	Slot = 0;
	while(Slot < global.InventorySize){
	    if(global.ItemIndex[#ID, ItemStat.Type] == "Armour" || global.ItemIndex[#ID, ItemStat.Type] == "Helmet" || global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
	        if (global.Inventory[# Slot, 0] == Item.None){
	            global.Inventory[# Slot, 0] = ID;
	            global.Inventory[# Slot, 1] += Amount;
				global.Inventory[# Slot, InventoryIndex.SlotDurability] = ItemDurability;
	            if(global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
	                ///Weapon
	                Id = global.Inventory[# Slot, 0];
	                global.Inventory[# Slot, 2] = ItemAmmo;
	                global.Inventory[# Slot, 3] = ItemClipAmmo;
					global.Inventory[# Slot, InventoryIndex.slot_scope] = (ItemScope != -1) ? ItemScope : global.Inventory[# Slot, InventoryIndex.slot_scope];
					global.Inventory[# Slot, InventoryIndex.slot_barrel] = (ItemBarrel != -1) ? ItemBarrel : global.Inventory[# Slot, InventoryIndex.slot_barrel];
					global.Inventory[# Slot, InventoryIndex.slot_grip] = (ItemGrip != -1) ? ItemGrip : global.Inventory[# Slot, InventoryIndex.slot_grip];
					global.Inventory[# Slot, InventoryIndex.slot_suppressor] = (Itemsuppressor != -1) ? Itemsuppressor : global.Inventory[# Slot, InventoryIndex.slot_suppressor];
	            }
				if(Destroy == true){
					instance_destroy();
				}
	            break;
	        }
	    }
	    Slot ++;
	}

	///Item
	if!(global.ItemIndex[#ID, ItemStat.Type] == "Armour" || global.ItemIndex[#ID, ItemStat.Type] == "Helmet" || global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
	    var yy = 0;
		var PickedUp = false;
	    repeat(global.InventorySize){
	        if(global.Inventory[#yy, 0] == ID){
	            global.Inventory[# yy, 1] += Amount;
	            PickedUp = true;
				if(Destroy == true){
					instance_destroy();
				}
	            break;
	        }else{
	            yy ++;
	        }
	    }
    
	    ///All items
	    if(!PickedUp){
	        yy = 0;
	        repeat(global.InventorySize){
	            if(global.Inventory[#yy, 0] == Item.None){
	                global.Inventory[# yy, 0] = ID;
	                global.Inventory[# yy, 1] += Amount;
					if(Destroy == true){
						instance_destroy();
					}
	                PickedUp = true;
	                break;
	            }else{
	                yy ++;
	            }
	        }
	    }
	}
	return false;
}
