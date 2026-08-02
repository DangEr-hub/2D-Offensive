function is_inventory_full(Item = Item.None){
	var Slot = 0;
	while(Slot < INVENTORY_SIZE){
		if(global.Inventory[# Slot, Index.slot_id] == Item.None || 
		(global.Inventory[# Slot, Index.slot_id] == Item && (global.ItemIndex[# global.Inventory[# Slot, Index.slot_id], ItemStat.Type] == "Item" ||
		global.ItemIndex[# global.Inventory[# Slot, Index.slot_id], ItemStat.Type] == "Grenade" || global.ItemIndex[# global.Inventory[# Slot, Index.slot_id], ItemStat.Type] == "Landmine"))){
			return false;
		}
		Slot ++;
	}
	
	return true;
}

function gain_item(ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, Destroy = true) {
	var hotbar_n = 4;
	var type = global.ItemIndex[#ID, ItemStat.Type];
	var is_stackable = !(type == "Armour" || type == "Helmet" || type == "Weapon" || type == "Shield");
	var PickedUp = false;

	// --- SEKCE 1: HLEDÁNÍ STEJNÉHO ID ---
	if(is_stackable) {
		// Nejdříve zkusíme přičíst item k existujícímu stacku kdekoli (včetně hotbaru)
		for(var i = 0; i < INVENTORY_SIZE; i++) {
			if(global.Inventory[# i, Index.slot_id] == ID) {
				global.Inventory[# i, Index.SlotAmount] += Amount;
				PickedUp = true;
				break;
			}
		}
	}

	// --- SEKCE 2: VOLNÉ MÍSTO (Pro zbraně nebo nové itemy) ---
	if(!PickedUp) {
		// Priorita 1: Hledáme volné místo od hotbar_n výše
		for(var i = hotbar_n; i < INVENTORY_SIZE; i++) {
			if(global.Inventory[# i, Index.slot_id] == Item.None) {
				insert_item_to_slot(i, ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, type);
				PickedUp = true;
				break;
			}
		}
		
		// Priorita 2: Pokud je stále plno, zkusíme volné místo v hotbaru (0 až hotbar_n-1)
		if(!PickedUp) {
			for(var i = 0; i < hotbar_n; i++) {
				if(global.Inventory[# i, Index.slot_id] == Item.None) {
					insert_item_to_slot(i, ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, type);
					PickedUp = true;
					break;
				}
			}
		}
	}

	// --- FINÁLNÍ ZNIČENÍ PICKUPU ---
	if(PickedUp) {
		if(Destroy) { destroy_pickup_instance(id); }
		return true;
	}

	return false;
}

// Pomocná funkce
function insert_item_to_slot(_slot, _ID, _Amount, _Ammo, _Clip, _Dur, _Scope, _Barr, _Grip, _Supp, _type) {
	global.Inventory[# _slot, Index.slot_id] = _ID;
	global.Inventory[# _slot, Index.SlotAmount] = _Amount;
	global.Inventory[# _slot, Index.slot_durability] = _Dur;
	
	if(_type == "Weapon") {
		global.Inventory[# _slot, Index.slot_ammo] = _Ammo;
		global.Inventory[# _slot, Index.slot_clip_ammo] = _Clip;
		if(_Scope != Item.None) global.Inventory[# _slot, Index.slot_scope] = _Scope;
		if(_Barr != Item.None)  global.Inventory[# _slot, Index.slot_barrel] = _Barr;
		if(_Grip != Item.None)   global.Inventory[# _slot, Index.slot_grip] = _Grip;
		if(_Supp != Item.None)  global.Inventory[# _slot, Index.slot_suppressor] = _Supp;
	}
}

function inventory_create() {
	var SlotRowSize = 7;
	var SlotColumnSize = 3;
	
	var slot_width = sprite_get_width(spr_Slot)/2*global.GUIMultiplier;
	var slot_height = sprite_get_height(spr_Slot)/2*global.GUIMultiplier;
	var start_x = camera_get_view_x(CAM) + camera_get_view_width(CAM)/2 - (SlotRowSize*slot_width/2);
	var start_y = camera_get_view_y(CAM) + camera_get_view_height(CAM)/1.3 - (SlotColumnSize*slot_height/2);
	
	for(var i=0;i<SlotRowSize;i++){
		var Instance = instance_create_layer(start_x + i*slot_width, start_y, "OtherO", oSlot);
		Instance.VarSlot = i;
		if(i == 0){
			global.InventoryLeftTopCorner = [Instance.x, Instance.y];
		}
		
		if(i < HOTBAR_SIZE){
			Instance.image_index = 8;	
		}
	}
	
	for(var i=0;i<SlotRowSize;i++){
		var Instance = instance_create_layer(start_x + i*slot_width, start_y + slot_height, "OtherO", oSlot);
		Instance.VarSlot = i + SlotRowSize;
	}
	
	for(var i=0;i<SlotRowSize;i++){
		var Instance = instance_create_layer(start_x + i*slot_width, start_y + slot_height*2, "OtherO", oSlot);
		Instance.VarSlot = i + SlotRowSize*2;
		if(i == SlotRowSize - 1){
			global.InventoryRightBottomCorner = [Instance.x + slot_width, Instance.y + slot_height];
		}
	}
	
	var equipment_slot_size = OtherSlot.Total - INVENTORY_SIZE - 1;
	for(var i = 0;i<equipment_slot_size;i++){
		var Instance = instance_create_layer(start_x + i*slot_width + ((SlotRowSize-equipment_slot_size)*slot_width/2), start_y - slot_height*1.25, "OtherO", oSlot);
		Instance.VarSlot = i + OtherSlot.Primary;
		Instance.image_index = i + 2;
		if(i == 0){
			global.InventoryEquipLeftTopCorner = [Instance.x, Instance.y];
		}else if(i == OtherSlot.Total - INVENTORY_SIZE - 2){
			global.InventoryEquipRightBottomCorner = [Instance.x + slot_width, Instance.y + slot_height];
		}
	}
}

function wpn_has_preattached(weapon_id, socket, item) {
	if(global.ItemIndex[# weapon_id, ItemStat.preattached][$ socket] != undefined){
		return global.ItemIndex[# weapon_id, ItemStat.preattached][$ socket] == item;	
	}
}

function InventoryInit() {

	enum Item{
	    None, AKM, KevlarHelm, DesertEagle, KevlarVest, Spas, MilitaryHelm, MilitaryVest, SSG08, HEGrenade, MAC11, FlashBangGrenade, SG550, SpecOpsHelm, 
		SpecOpsVest, MilitaryNightVision, BasicNightVision, HealingKit, InfraredVision, SmokeGrenade, Javelin, HELandMine, CELandMine, LELandMine, Glock, 
		StickyGrenade, red_dot_scope, two_scope, adaptive_chambering, vertical_grip, horizontal_grip, advanced_suppressor, m4a1, awm, usp, base_explosion,
		nuclear_explosion, basic_machine_gun, galil, p250, MK18, famas, MolotovGrenade, steel_knife, tec9, low_cal_box, med_cal_box, high_cal_box, gauge_box,
		range_finder, Dragunov, dilatation_pill, MP9, CZ75, kevlar_shield, military_shield, spec_ops_shield, Total
	}

	enum ItemStat{
		/* Draw weapon stats */
	    Damage, MaxAmmo, ReloadSpeed, Range, ShootTimer, WeaponTypeClass, MovingSpdMul, PenetrationPower, ShootingMode, MovingInaccuracyMultiplier, Inaccuracy,
		KickBackInaccuracyMultiplier, damage_drop, accuracy_drop, ClipAmmo,
		
		/* Draw armour stats */
		Weight, Defense, BaseDurability, KickBackPower, RecoilOffsetX, RecoilOffsetY, Description, ShootSpdMul, EquipTime,
		BulletCasingID, ItemColor, ScopeInaccuracyResetTimer, WeaponType, AmmoType, NightVisionIntensityPower, NightVisionNoisePower, AmmoSpriteID,
		EnemyInaccuracyCompensation, Type, Name, Bullets, SoundID, CrosshairShake, CameraShake, HardRecoil, KBPhase1, KBPhase2, RecoilX, RecoilY,
		advantages, disadvantages, slot, Cost, ReloadSpdMul, difficulty, KBResetMultiplier, reward, KBStabilization, random_bullet_spread, is_locked, caliber,
		caliber_type, attach_sockets, attachments, preattached, BaseMaxAmmo, BaseReloadSpeed, BaseEquipTime, BaseMovingSpdMul, BasePenetrationPower, BaseDamage, Rarity,
		Total
	}
	
	enum OtherSlot{
		Primary = 22, Secondary = 23, Knife = 24,
		Helmet = 25, Armour = 26, Shield = 27, Total = 28
	}
	
	enum Index{
		slot_id, SlotAmount, slot_ammo, slot_clip_ammo, slot_durability, SlotShootingType, slot_scope, slot_barrel, slot_grip, slot_suppressor, Total
	}
	
	global.Inventory = ds_grid_create(OtherSlot.Total, Index.Total);
	global.ItemIndex = ds_grid_create(Item.Total, ItemStat.Total);
	global.MouseSlot = ds_grid_create(1, Index.Total);
	ds_grid_clear(global.Inventory, 0);
	ds_grid_clear(global.ItemIndex, 0);
	ItemDataBase(); 
}

function ItemDeclare(){

	if(Durability <= -1){
		Durability = global.ItemIndex[#image_index, ItemStat.BaseDurability];
	}
	
	if(scope_attachment == Item.None){
		if(image_index == Item.SG550){
			scope_attachment = Item.red_dot_scope;	
		}else if(image_index == Item.SSG08 || image_index == Item.awm){
			scope_attachment = Item.two_scope;	
		}
	}
	
	if(suppressor_attachment == Item.None){
		if(image_index == Item.m4a1){
			suppressor_attachment = Item.advanced_suppressor;
		}else if(image_index == Item.usp){
			suppressor_attachment = Item.advanced_suppressor;
		}
	}
	
	if(Ammo <= -1){
		Ammo = global.ItemIndex[#image_index, ItemStat.MaxAmmo];
		ClipAmmo = global.ItemIndex[#image_index, ItemStat.ClipAmmo];
		MaxAmmo = Ammo;
	}
}
	
function ItemAmountSubstract(ID, Amount){
	global.Inventory[# ID, Index.SlotAmount] -= Amount;
	if(global.Inventory[# ID, Index.SlotAmount] <= 0){
		for(i=0;i<Index.Total;i++){
			global.Inventory[# ID, i] = 0;
		}
	}
}

function ItemAddWeight(ID, OtherID){
	global.player_stats_struct.Weight -= global.ItemIndex[# OtherID, ItemStat.Weight];
	global.player_stats_struct.Weight += global.ItemIndex[# ID, ItemStat.Weight];
	global.player_stats_struct.Weight = clamp(global.player_stats_struct.Weight, 0, global.player_stats_struct.Max_weight);
}

function ItemDrop(ID, PositionX, PositionY, ObjectAmmo = -1, ObjectClipAmmo = -1, ObjectDurability = -1, ObjectAmount = 1, OWSA = -1, OWBA = -1, OWGA = -1, OWsuppressorA = -1){
    var drop_scope = global.ItemIndex[#ID, ItemStat.preattached][$ "scope"] ?? Item.None;
    var drop_barrel = global.ItemIndex[#ID, ItemStat.preattached][$ "barrel"] ?? Item.None;
    var drop_grip = global.ItemIndex[#ID, ItemStat.preattached][$ "grip"] ?? Item.None;
    var drop_suppressor = global.ItemIndex[#ID, ItemStat.preattached][$ "suppressor"] ?? Item.None;
    var drop_ammo = global.ItemIndex[#ID, ItemStat.MaxAmmo];
    var drop_clip_ammo = global.ItemIndex[#ID, ItemStat.ClipAmmo];
    var drop_durability = ObjectDurability;

    if(OWSA != -1){
        drop_scope = OWSA;
    }
    if(OWBA != -1){
		drop_barrel = OWBA;
    }
    if(OWGA != -1){
		drop_grip = OWGA;
    }
    if(OWsuppressorA != -1){
		drop_suppressor = OWsuppressorA;
    }
    if(ObjectAmmo != -1){
        drop_ammo = ObjectAmmo;
    }
    if(ObjectClipAmmo != -1){
        drop_clip_ammo = ObjectClipAmmo;
    }

    if(global.ItemIndex[#ID, ItemStat.Type] != "Armour" && global.ItemIndex[#ID, ItemStat.Type] != "Helmet"){
        drop_durability = -1;
    }

    var drop_data = {
	    img_index: ID,
	    amount: ObjectAmount,
	    scope: drop_scope,
	    barrel: drop_barrel,
	    grip: drop_grip,
	    suppressor: drop_suppressor,
	    ammo: drop_ammo,
	    clip_ammo: drop_clip_ammo,
	    durability: drop_durability,
		obj_index: oItems
    };

    if (IS_NET) {
        if (oNetworkManager.is_server) {
            // SERVER: spawn + broadcast
            var net_inst = sync_object_create(PositionX, PositionY, drop_data);
            if (instance_exists(net_inst)) {
                net_inst.alarm[0] = 1;
            }
            return net_inst;
        }

        // CLIENT: nespawnuje item, jen request
        return undefined;
    }
    var ItemDropped = instance_create_layer(PositionX, PositionY, "ItemsO", oItems);
    ItemDropped.Amount = drop_data.amount;
    ItemDropped.image_index = ID;
    ItemDropped.scope_attachment = drop_scope;
    ItemDropped.barrel_attachment = drop_barrel;
    ItemDropped.grip_attachment = drop_grip;
    ItemDropped.suppressor_attachment = drop_suppressor;
    ItemDropped.Ammo = drop_ammo;
    ItemDropped.ClipAmmo = drop_clip_ammo;
    ItemDropped.Durability = drop_durability;

    ItemDropped.alarm[0] = 1;

    return ItemDropped;
}

function WeaponDrop(ID, ObjectType){
	if(ObjectType.object_index == oPlayer){
		global.local_player.Reloading = false;
		global.local_player.ReloadTime = 0;
		for(var i = 0;i<Index.Total;i++){
			global.Inventory[# ID, i] = 0;
		}
	}
}

function ArmourDrop(ID, ObjectType){
	if(ObjectType == oPlayer){
		if(global.local_player.ToggleNightVision == true){
			global.local_player.ToggleNightVision = false;
		}
		global.player_stats_struct.Weight -= global.ItemIndex[# global.Inventory[# ID, Index.slot_id], ItemStat.Weight];
		for(var i = 0;i<Index.Total;i++){
			global.Inventory[# ID, i] = 0;
		}
	}
	
}
	
function switch_weapon_number(){
	if(CanShoot == true){
		switch(WeaponNumber){
			case 0:
				if(WeaponID != OtherSlot.Primary){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = OtherSlot.Primary;
					Reloading = false;
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
			
			case 1:
				if(WeaponID != OtherSlot.Secondary){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = OtherSlot.Secondary;
					Reloading = false;
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;

			case 2:
				if(WeaponID != OtherSlot.Knife){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = OtherSlot.Knife;
					Reloading = false;
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
			
			case 3:
				if(WeaponID != OtherSlot.Shield){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = OtherSlot.Shield;
					Reloading = false;
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
			
		}
		with(id){ weapon_network_propagate(); }
	}
}
	

function item_equip(slot, slot_string, weapon_id, equip = true){
	var Id = global.Inventory[# slot, Index.slot_id];
	var wpn_id = global.Inventory[# weapon_id, Index.slot_id];
			
	if(global.ItemIndex[#Id, ItemStat.Type] == "Grenade") {
				
		#region Grenade use
		if(EquippedGrenadeTimer == -1){
			create_grenade(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
			global.ItemIndex[#Id, ItemStat.BulletCasingID], global.ItemIndex[#Id, ItemStat.ReloadSpeed], oCrosshair.x, oCrosshair.y, Id);						
			ItemAmountSubstract(slot, 1);
			EquippedGrenadeTimer = EquippedGrenadeTime;
			grenade_angle = random(360);
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ItemStat.Type] == "Landmine"){
				
		#region Landmine use
		landmine_create(x, y, Id);
		ItemAmountSubstract(slot, 1);
		#endregion
				
	}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item"){
				
		#region Item use
		switch(Id){
			case Item.HealingKit:
			    if(!Healing && stats.Health_points < global.player_stats_struct.Max_health){
			        global.local_player.item_equip_timer = global.local_player.item_equip_time;
			        HealingItemId = Item.HealingKit; Healing = true; ItemAmountSubstract(slot, 1);
			    }
			break;
			case Item.low_cal_box:
			case Item.med_cal_box:
			case Item.high_cal_box:
			case Item.gauge_box:
			    var cal_needed = global.ItemIndex[# Id, ItemStat.caliber_type]; // Kalibr
			    if(global.ItemIndex[# wpn_id, ItemStat.caliber_type] == cal_needed){
			        var amt = global.ItemIndex[# Id, ItemStat.MaxAmmo];
			        global.Inventory[# WeaponID, Index.slot_clip_ammo] += amt;
			        damage_indicator("+" + string(amt), global.local_player.x, global.local_player.y, c_white, spr_Icons, ICON.ammo);
			        ItemAmountSubstract(slot, 1);
			    }
			break;			
			case Item.red_dot_scope: weapon_attachment_equip(Id, Index.slot_scope); break;
			case Item.two_scope: weapon_attachment_equip(Id, Index.slot_scope); break;
			case Item.adaptive_chambering: weapon_attachment_equip(Id, Index.slot_barrel); break;	
			case Item.vertical_grip: weapon_attachment_equip(Id, Index.slot_grip); break;
			case Item.horizontal_grip: weapon_attachment_equip(Id, Index.slot_grip); break;
			case Item.advanced_suppressor: weapon_attachment_equip(Id, Index.slot_suppressor); break;	
			case Item.range_finder: weapon_attachment_equip(Id, Index.slot_barrel); break;
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
								
		#region Primary equip and dequip
		var primary_slot_id = global.Inventory[# OtherSlot.Primary, Index.slot_id];
		if (primary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == WEAPON_TYPE.PRIMARY)) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Primary);
			primary_slot_id = Item.None;
		} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == WEAPON_TYPE.PRIMARY) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Primary);
		}
		#endregion
				
		#region Secondary equip and dequip
		var secondary_slot_id = global.Inventory[# OtherSlot.Secondary, Index.slot_id];
		if (secondary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == WEAPON_TYPE.SECONDARY)) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Secondary);
			secondary_slot_id = Item.None;
		} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == WEAPON_TYPE.SECONDARY) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Secondary);
		}
		#endregion
				
		#region Knife equip and dequip
		var tertiary_slot_id = global.Inventory[# OtherSlot.Knife, Index.slot_id];
		if (tertiary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == WEAPON_TYPE.TERTIARY)) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Knife);
			tertiary_slot_id = Item.None;
		} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == WEAPON_TYPE.TERTIARY) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Knife);
		}
		#endregion
						
				
	}else if(global.ItemIndex[#Id, ItemStat.Type] == "Armour"){
				
		#region Armour equip and dequip
		var armour_slot_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
		if (armour_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Armour")) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, Index.slot_id], armour_slot_id);
			item_swap("item_use_position", OtherSlot.Armour);
			armour_slot_id = Item.None;
			with(id){ equip_network_propagate(); }
		} else if (global.ItemIndex[# Id, ItemStat.Type] == "Armour") {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, Index.slot_id], armour_slot_id);
			item_swap("item_use_position", OtherSlot.Armour);
			with(id){ equip_network_propagate(); }
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){
				
		#region Helmet equip and dequip
		var helmet_slot_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
		if (helmet_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Helmet")) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, Index.slot_id], helmet_slot_id);
			item_swap("item_use_position", OtherSlot.Helmet);
			helmet_slot_id = Item.None;
			with(id){ equip_network_propagate(); }
		} else if (global.ItemIndex[# Id, ItemStat.Type] == "Helmet") {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, Index.slot_id], helmet_slot_id);
			item_swap("item_use_position", OtherSlot.Helmet);
			with(id){ equip_network_propagate(); }
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ItemStat.Type] == "Shield"){
				
		#region Helmet equip and dequip
		var shield_slot_id = global.Inventory[# OtherSlot.Shield, Index.slot_id];
		if (shield_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Shield")) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, Index.slot_id], shield_slot_id);
			item_swap("item_use_position", OtherSlot.Shield);
			shield_slot_id = Item.None;
			with(id){ equip_network_propagate(); }
		} else if (global.ItemIndex[# Id, ItemStat.Type] == "Shield") {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, Index.slot_id], shield_slot_id);
			item_swap("item_use_position", OtherSlot.Shield);
			with(id){ equip_network_propagate(); }
		}
		#endregion
				
	}
}



























