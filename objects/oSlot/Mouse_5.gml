Id = global.Inventory[# VarSlot, InventoryIndex.SlotID];
Amount = global.Inventory[# VarSlot, InventoryIndex.SlotAmount];
Ammo = global.Inventory[# VarSlot, InventoryIndex.SlotAmmo];
ClipAmmo = global.Inventory[# VarSlot, InventoryIndex.SlotClipAmmo];
Durability = global.Inventory[# VarSlot, InventoryIndex.SlotDurability];
MouseID = global.MouseSlot[# 0, InventoryIndex.SlotID];
MouseAmount = global.MouseSlot[# 0, InventoryIndex.SlotAmount];

if (Id == 0 || MouseID == 0 || Id != MouseID || (Id == MouseID && global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet" || global.ItemIndex[#Id, ItemStat.Type] == "Shield" || global.ItemIndex[#Id, ItemStat.Type] == "Weapon")){
    global.Inventory[# VarSlot, InventoryIndex.SlotID] = MouseID;
    global.Inventory[# VarSlot, InventoryIndex.SlotAmount] = MouseAmount;
    global.Inventory[# VarSlot, InventoryIndex.SlotAmmo] = global.MouseSlot[# 0, InventoryIndex.SlotAmmo];
    global.Inventory[# VarSlot, InventoryIndex.SlotClipAmmo] = global.MouseSlot[# 0, InventoryIndex.SlotClipAmmo];
    global.Inventory[# VarSlot, InventoryIndex.SlotDurability] = global.MouseSlot[# 0, InventoryIndex.SlotDurability];
    global.MouseSlot[# 0, InventoryIndex.SlotID] = Id;
    global.MouseSlot[# 0, InventoryIndex.SlotAmount] = Amount;
    global.MouseSlot[# 0, InventoryIndex.SlotAmmo] = Ammo;
    global.MouseSlot[# 0, InventoryIndex.SlotClipAmmo] = ClipAmmo;
	global.MouseSlot[# 0, InventoryIndex.SlotDurability] = Durability;
}else if (Id == MouseID){
    global.Inventory[# VarSlot, 1] += global.MouseSlot[# 0, 1];
    global.MouseSlot[# 0, 1] = 0;
    global.MouseSlot[# 0, 0] = Item.None;
}


