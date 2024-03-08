function equipped_usable_item(){
	return (global.ItemIndex[#global.Inventory[# ItemUsePosition, InventoryIndex.SlotID], ItemStat.usable] == true);
}

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

function InventoryCreate() {
	var SlotRowSize = 7;
	var SlotColumnSize = 3;
	
	for(i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(
		    camera_get_view_x(CAMERA) + camera_get_view_width(CAMERA)/2 - (SlotRowSize/2*sprite_get_width(spr_Slot)/2*global.GUIMultiplier)+i*sprite_get_width(spr_Slot)/2*global.GUIMultiplier, 
		    camera_get_view_y(CAMERA) + camera_get_view_height(CAMERA)/2 + 32 - SlotColumnSize/2*sprite_get_height(spr_Slot)/2*global.GUIMultiplier,
		    "OtherO", oSlot
		);
		Instance.VarSlot = i;
		if(i == 0){
			global.InventoryLeftTopCorner = [Instance.x, Instance.y];
		}
	}
	
	for(i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(
		    camera_get_view_x(CAMERA) + camera_get_view_width(CAMERA)/2 - (SlotRowSize/2*sprite_get_width(spr_Slot)/2*global.GUIMultiplier)+i*sprite_get_width(spr_Slot)/2*global.GUIMultiplier, 
		    camera_get_view_y(CAMERA) + camera_get_view_height(CAMERA)/2 + 32 - SlotColumnSize/2*sprite_get_height(spr_Slot)/2*global.GUIMultiplier + sprite_get_height(spr_Slot)/2*global.GUIMultiplier,
		    "OtherO", oSlot
		);
		Instance.VarSlot = i + SlotRowSize;
	}
	
	for(i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(
		    camera_get_view_x(CAMERA) + camera_get_view_width(CAMERA)/2 - (SlotRowSize/2*sprite_get_width(spr_Slot)/2*global.GUIMultiplier)+i*sprite_get_width(spr_Slot)/2*global.GUIMultiplier, 
		    camera_get_view_y(CAMERA) + camera_get_view_height(CAMERA)/2 + 32 - SlotColumnSize/2*sprite_get_height(spr_Slot)/2*global.GUIMultiplier + sprite_get_height(spr_Slot)*2/2*global.GUIMultiplier,
		    "OtherO", oSlot
		);
		Instance.VarSlot = i + SlotRowSize*2;
		if(i == SlotRowSize - 1){
			global.InventoryRightBottomCorner = [Instance.x + sprite_get_width(spr_Slot)/2*global.GUIMultiplier, Instance.y + sprite_get_height(spr_Slot)/2*global.GUIMultiplier];
		}
	}
}

function InventoryInit() {

	enum Item{
	    None, AKM, KevlarHelm, DesertEagle, KevlarVest, Spas, MilitaryHelm, MilitaryVest, SSG08, HEGrenade, MAC11, FlashBangGrenade, SG550, SpecOpsHelm, 
		SpecOpsVest, MilitaryNightVision, BasicNightVision, HealingKit, InfraredVision, SmokeGrenade, Javelin, HELandMine, CELandMine, LELandMine, Glock, 
		StickyGrenade, red_dot_scope, two_scope, adaptive_chambering, vertical_grip, horizontal_grip, military_suppressor, m4_carbine, awm, usp, base_explosion,
		nuclear_explosion, MolotovGrenade, Total
	}

	enum ItemStat{
		/* Draw weapon stats */
	    Damage, Ammo, ClipAmmo, ReloadSpeed, Range, MovingInaccuracyMultiplier, Inaccuracy, ShootTimer, KickBackInaccuracyMultiplier, DamageDrop, RangeInaccuracyMultiplier, 
		WeaponTypeClass, MovingSpdMul, PenetrationPower, ShootingMode,
		
		/* Draw armour stats */
		Weight, Defense, BaseDurability, KickBackPower, RecoilOffsetX, RecoilOffsetY, Description, MaxKickBack, SniperScope, ShootSpdMul, has_barrel, EquipTime, has_suppressor,
		BulletCasingID, ItemColor, ScopeInaccuracyResetTimer, WeaponType, AmmoType, NightVisionIntensityPower, NightVisionNoisePower, AmmoSpriteID, has_scope, has_grip,
		EnemyInaccuracyCompensation, MaxAmmo, Type, Name, ID, Bullets, SoundID, CrosshairShake, CameraShake, HardRecoil, KBPhase1, KBPhase2, RecoilX, RecoilY,
		advantages, disadvantages, usable, Cost, Total
	}
	
	enum InventoryIndex{
		SlotID, SlotAmount, SlotAmmo, SlotClipAmmo, SlotDurability, SlotShootingType, slot_scope, slot_barrel, slot_grip, slot_suppressor, Total
	}
	
	enum InventoryOtherSlot{
		ArmourSlot = 21,
		HelmetSlot = 22,
		PrimaryWeaponSlot = 23,
		SecondaryWeaponSlot = 24, 
		KnifeSlot = 25,
		Total = 26	
	}

	global.Inventory = ds_grid_create(global.InventorySize, InventoryIndex.Total);
	global.ItemIndex = ds_grid_create(Item.Total, ItemStat.Total);
	global.MouseSlot = ds_grid_create(1, InventoryIndex.Total);
	ds_grid_clear(global.Inventory, 0);
	ds_grid_clear(global.ItemIndex, 0);
	ItemDataBase(); 
}

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
		}else if(image_index == Item.usp){
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
	if(global.player_stats_struct.Weight <= global.player_stats_struct.Max_weight - global.ItemIndex[#global.Inventory[#ID, InventoryIndex.SlotID], ItemStat.Weight]){
		global.player_stats_struct.Weight += global.ItemIndex[#global.Inventory[#ID, InventoryIndex.SlotID], ItemStat.Weight];
	}	
}

function ItemDrop(ID, PositionX, PositionY, Chance, ObjectAmmo = 0, ObjectClipAmmo = 0, ObjectDurability = 0, ObjectAmount = 1, OWSA = -1, OWBA = -1, OWGA = -1, OWsuppressorA = -1){
	if(percent_chance(Chance)){
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
		global.player_stats_struct.Weight -= global.ItemIndex[#global.ArmourID[ID], ItemStat.Weight];
		global.ArmourID[ID] = Item.None;
		global.ArmourDurability[ID] = 0;
	}else{
		
	}
	
}
	
function switch_weapon_number(){
	if(CanShoot == true){
		switch(WeaponNumber){
			case 0:
				if(WeaponID != 0){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = 0;
					Reloading = false;
					if(global.weapon_id[min(WeaponID, 2)] != Item.None){
						EquipmentAlpha = global.GUIHUDAlpha;
					}
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
			
			case 1:
				if(WeaponID != 1){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = 1;
					Reloading = false;
					if(global.weapon_id[min(WeaponID, 2)] != Item.None){
						EquipmentAlpha = global.GUIHUDAlpha;
					}
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;

			case 2:
				if(WeaponID != 2){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = 2;
					Reloading = false;
					if(global.weapon_id[min(WeaponID, 2)] != Item.None){
						EquipmentAlpha = global.GUIHUDAlpha;
					}
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
		}
	}
}



























