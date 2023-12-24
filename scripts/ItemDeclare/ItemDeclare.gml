// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ItemDeclare(){
	Damage = global.ItemIndex[#image_index, ItemStat.Damage];

	if(Durability <= -1){
		Durability = global.ItemIndex[#image_index, ItemStat.BaseDurability];
	}
	
	if(scope_attachment == -1){
		if(image_index == Item.SG550){
			scope_attachment = Item.red_dot_scope;	
		}else if(image_index == Item.SSG08 || image_index == Item.awm){
			scope_attachment = Item.two_scope;	
		}
	}
	
	if(suppressor_attachment == -1){
		if(image_index == Item.m4_carbine){
			suppressor_attachment = Item.military_suppressor;
		}
	}
	
	if(Ammo <= -1){
		WeaponAmmo();
	}
}
	
function ItemAmountSubstract(ID, Amount){
	global.Inventory[# ID, InventoryIndex.SlotAmount] -= Amount;
	if(global.Inventory[# ID, InventoryIndex.SlotAmount] <= 0){
		for(i=0;i<ds_grid_height(global.Inventory);i++){
			global.Inventory[# ID, i] = 0;
		}
	}
}

function ItemAddWeight(ID){
	if(global.Weight <= global.MaxWeight - global.ItemIndex[#global.Inventory[#ID, InventoryIndex.SlotID], ItemStat.Weight]){
		global.Weight += global.ItemIndex[#global.Inventory[#ID, InventoryIndex.SlotID], ItemStat.Weight];
	}	
}

function ItemDrop(ID, PositionX, PositionY, Chance, ObjectAmmo = 0, ObjectClipAmmo = 0, ObjectDurability = 0, ObjectAmount = 1, OWSA = Item.None, OWBA = Item.None, OWGA = Item.None, OWsuppressorA = Item.None){
	if(PercentChance(Chance)){
		ItemDropped = instance_create_layer(PositionX, PositionY, "ItemsO", oItems);
		ItemDropped.Amount = ObjectAmount;
		ItemDropped.image_index = ID;
		if(global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
			ItemDropped.scope_attachment = OWSA;
			ItemDropped.barrel_attachment = OWBA;
			ItemDropped.grip_attachment = OWGA;
			ItemDropped.suppressor_attachment = OWsuppressorA;
			ItemDropped.Ammo = ObjectAmmo;
			ItemDropped.ClipAmmo = ObjectClipAmmo;
		}else if(global.ItemIndex[#ID, ItemStat.Type] == "Armour" || 
		global.ItemIndex[#ID, ItemStat.Type] == "Helmet"){
			ItemDropped.Durability = ObjectDurability;
		}
	}
}

function WeaponAmmo(){
	Ammo = global.ItemIndex[#image_index, ItemStat.Ammo];
	ClipAmmo = global.ItemIndex[#image_index, ItemStat.ClipAmmo];
	MaxAmmo = Ammo;
}

function WeaponDrop(ID, ObjectType){
	if(ObjectType.object_index == oPlayer){
		ObjectType.Reloading = false;
		ObjectType.ReloadTime = 0;
		for(i = 0;i<weapon_attachments.Total;i++){
			global.weapon_attachments[ID][i] = Item.None;
		}
		global.weapon_id[ID] = Item.None;
		global.ClipAmmo[ID] = 0;
		global.Ammo[ID] = 0;
		global.MaxAmmo[ID] = 0;
	}else{
		
	}
}

function ArmourDrop(ID, ObjectType){
	if(ObjectType == oPlayer){
		if(oPlayer.ToggleNightVision == true){
			oPlayer.ToggleNightVision = false;
		}
		global.Weight -= global.ItemIndex[#global.ArmourID[ID], ItemStat.Weight];
		global.ArmourID[ID] = Item.None;
		global.ArmourDurability[ID] = 0;
	}else{
		
	}
	
}



























