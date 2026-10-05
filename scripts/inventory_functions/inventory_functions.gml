function is_inventory_full(Item = ITEM.None){
	var Slot = 0;
	while(Slot < INVENTORY_SIZE){
		if(global.Inventory[# Slot, INDEX.slot_id] == ITEM.None || 
		(global.Inventory[# Slot, INDEX.slot_id] == Item && (global.ItemIndex[# global.Inventory[# Slot, INDEX.slot_id], ITEMSTATS.Type] == "Item" ||
		global.ItemIndex[# global.Inventory[# Slot, INDEX.slot_id], ITEMSTATS.Type] == "Grenade" || global.ItemIndex[# global.Inventory[# Slot, INDEX.slot_id], ITEMSTATS.Type] == "Landmine"))){
			return false;
		}
		Slot ++;
	}

	return true;
}

function gain_item(ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, Destroy = true) {
	var hotbar_n = 4;
	var type = global.ItemIndex[#ID, ITEMSTATS.Type];
	var is_stackable = !(type == "Armour" || type == "Helmet" || type == "Weapon" || type == "Shield");
	var PickedUp = false;
	
	play_sound(global.local_player.x, global.local_player.y, snd_ItemPickup, global.local_player);

	// --- SEKCE 1: HLEDÁNÍ STEJNÉHO ID ---
	if(is_stackable) {
		// Nejdříve zkusíme přičíst item k existujícímu stacku kdekoli (včetně hotbaru)
		for(var i = 0; i < INVENTORY_SIZE; i++) {
			if(global.Inventory[# i, INDEX.slot_id] == ID) {
				global.Inventory[# i, INDEX.SlotAmount] += Amount;
				PickedUp = true;
				break;
			}
		}
	}

	// --- SEKCE 2: VOLNÉ MÍSTO (Pro zbraně nebo nové itemy) ---
	if(!PickedUp) {
		// Priorita 1: Hledáme volné místo od hotbar_n výše
		for(var i = hotbar_n; i < INVENTORY_SIZE; i++) {
			if(global.Inventory[# i, INDEX.slot_id] == ITEM.None) {
				insert_item_to_slot(i, ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, type);
				PickedUp = true;
				break;
			}
		}
		
		// Priorita 2: Pokud je stále plno, zkusíme volné místo v hotbaru (0 až hotbar_n-1)
		if(!PickedUp) {
			for(var i = 0; i < hotbar_n; i++) {
				if(global.Inventory[# i, INDEX.slot_id] == ITEM.None) {
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
	global.Inventory[# _slot, INDEX.slot_id] = _ID;
	global.Inventory[# _slot, INDEX.SlotAmount] = _Amount;
	global.Inventory[# _slot, INDEX.slot_durability] = _Dur;
	
	if(_type == "Weapon") {
		global.Inventory[# _slot, INDEX.slot_ammo] = _Ammo;
		global.Inventory[# _slot, INDEX.slot_clip_ammo] = _Clip;
		if(_Scope != ITEM.None) global.Inventory[# _slot, INDEX.slot_scope] = _Scope;
		if(_Barr != ITEM.None)  global.Inventory[# _slot, INDEX.slot_barrel] = _Barr;
		if(_Grip != ITEM.None)   global.Inventory[# _slot, INDEX.slot_grip] = _Grip;
		if(_Supp != ITEM.None)  global.Inventory[# _slot, INDEX.slot_suppressor] = _Supp;
	}
}

function inventory_create() {
	var SlotRowSize = 7;
	var SlotColumnSize = 3;
	
	var slot_width = sprite_get_width(spr_Slot)/2*global.gui_scale;
	var slot_height = sprite_get_height(spr_Slot)/2*global.gui_scale;
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
	if(global.ItemIndex[# weapon_id, ITEMSTATS.preattached][$ socket] != undefined){
		return global.ItemIndex[# weapon_id, ITEMSTATS.preattached][$ socket] == item;	
	}
}

function InventoryInit() {

	enum ITEM{
	    None, AKM, KevlarHelm, DesertEagle, KevlarVest, Spas, MilitaryHelm, MilitaryVest, SSG08, HEGrenade, MAC11, flashbang, SG550,
		NightVision, HealingKit, InfraredVision, smoke, Javelin, HELandMine, CELandMine, LELandMine, Glock,
		StickyGrenade, red_dot_scope, two_scope, adaptive_chambering, vertical_grip, horizontal_grip, suppressor, m4a1, awm, usp, base_explosion,
		nuclear_explosion, basic_machine_gun, galil, p250, MK18, famas, steel_knife, tec9, low_cal_box, med_cal_box, high_cal_box, gauge_box,
		range_finder, Dragunov, dilatation_pill, MP9, CZ75, kevlar_shield, military_shield, MP7, P90, Scar, molotov, Bomb, defuse_kit, gold_card,
		magenta_card, red_card, aqua_card, green_card, black_card, white_card, m200, bipod, g36c, laser, adrenaline, steroids, blue_laser, red_laser, yellow_laser, Total
	}

	enum ITEMSTATS{
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
	
	enum INDEX{
		slot_id, SlotAmount, slot_ammo, slot_clip_ammo, slot_durability, SlotShootingType, slot_scope, slot_barrel, slot_grip, slot_suppressor, Total
	}
	
	global.Inventory = ds_grid_create(OtherSlot.Total, INDEX.Total);
	global.ItemIndex = ds_grid_create(ITEM.Total, ITEMSTATS.Total);
	global.MouseSlot = ds_grid_create(1, INDEX.Total);
	ds_grid_clear(global.Inventory, 0);
	ds_grid_clear(global.ItemIndex, 0);
	ItemDataBase(); 
}

function ItemDeclare(){

	if(Durability <= -1){
		Durability = global.ItemIndex[#image_index, ITEMSTATS.BaseDurability];
	}
	
	if(scope_attachment == ITEM.None){
		if(image_index == ITEM.SG550){
			scope_attachment = ITEM.red_dot_scope;	
		}else if(image_index == ITEM.SSG08 || image_index == ITEM.awm){
			scope_attachment = ITEM.two_scope;	
		}
	}
	
	if(suppressor_attachment == ITEM.None){
		if(image_index == ITEM.m4a1){
			suppressor_attachment = ITEM.suppressor;
		}else if(image_index == ITEM.usp){
			suppressor_attachment = ITEM.suppressor;
		}
	}
	
	if(Ammo <= -1){
		Ammo = global.ItemIndex[#image_index, ITEMSTATS.MaxAmmo];
		ClipAmmo = global.ItemIndex[#image_index, ITEMSTATS.ClipAmmo];
		MaxAmmo = Ammo;
	}
}
	
function ItemAmountSubstract(ID, Amount, mouse = false){
	if(mouse == false){
		global.Inventory[# ID, INDEX.SlotAmount] -= Amount;
		if(global.Inventory[# ID, INDEX.SlotAmount] <= 0){
			for(i=0;i<INDEX.Total;i++){
				global.Inventory[# ID, i] = 0;
			}
		}
	}else{
		global.MouseSlot[# ID, INDEX.SlotAmount] -= Amount;
		if(global.MouseSlot[# ID, INDEX.SlotAmount] <= 0){
			for(i=0;i<INDEX.Total;i++){
				global.MouseSlot[# ID, i] = 0;
			}
		}
	}
}

function is_caliber_box_item(item_id) {
	return item_id == ITEM.low_cal_box
		|| item_id == ITEM.med_cal_box
		|| item_id == ITEM.high_cal_box
		|| item_id == ITEM.gauge_box;
}

function ItemAddWeight(ID, OtherID){
	global.player_stats.Weight -= global.ItemIndex[# OtherID, ITEMSTATS.Weight];
	global.player_stats.Weight += global.ItemIndex[# ID, ITEMSTATS.Weight];
	global.player_stats.Weight = clamp(global.player_stats.Weight, 0, global.player_stats.Max_weight);
}

function ItemDrop(ID, PositionX, PositionY, ObjectAmmo = -1, ObjectClipAmmo = -1, ObjectDurability = -1, ObjectAmount = 1, OWSA = -1, OWBA = -1, OWGA = -1, OWsuppressorA = -1){
    var drop_scope = global.ItemIndex[#ID, ITEMSTATS.preattached][$ "scope"] ?? ITEM.None;
    var drop_barrel = global.ItemIndex[#ID, ITEMSTATS.preattached][$ "barrel"] ?? ITEM.None;
    var drop_grip = global.ItemIndex[#ID, ITEMSTATS.preattached][$ "grip"] ?? ITEM.None;
    var drop_suppressor = global.ItemIndex[#ID, ITEMSTATS.preattached][$ "suppressor"] ?? ITEM.None;
    var drop_ammo = global.ItemIndex[#ID, ITEMSTATS.MaxAmmo];
    var drop_clip_ammo = global.ItemIndex[#ID, ITEMSTATS.ClipAmmo];
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

    if(global.ItemIndex[#ID, ITEMSTATS.Type] != "Armour" && global.ItemIndex[#ID, ITEMSTATS.Type] != "Helmet"){
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
		global.local_player.ReloadTimer = -1;
		for(var i = 0;i<INDEX.Total;i++){
			global.Inventory[# ID, i] = 0;
		}
		with(global.local_player){
			weapon_network_propagate();
		}
	}
}

function ArmourDrop(ID, ObjectType){
	if(ObjectType == oPlayer){
		if(global.local_player.ToggleNightVision == true){
			global.local_player.ToggleNightVision = false;
		}
		global.player_stats.Weight -= global.ItemIndex[# global.Inventory[# ID, INDEX.slot_id], ITEMSTATS.Weight];
		for(var i = 0;i<INDEX.Total;i++){
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
	var Id = global.Inventory[# slot, INDEX.slot_id];
	var wpn_id = global.Inventory[# weapon_id, INDEX.slot_id];
			
	if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Grenade") {
				
		#region Grenade use
		if(EquippedGrenadeTimer == -1){
			create_grenade(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
			global.ItemIndex[#Id, ITEMSTATS.BulletCasingID], global.ItemIndex[#Id, ITEMSTATS.ReloadSpeed], oCrosshair.x, oCrosshair.y, Id);						
			item_equip_timer = item_equip_time;
			ItemAmountSubstract(slot, 1);
			EquippedGrenadeTimer = EquippedGrenadeTime;
			grenade_angle = random(360);
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Landmine"){
				
		#region Landmine use
		landmine_create(x, y, Id);
		item_equip_timer = item_equip_time;
		ItemAmountSubstract(slot, 1);
		#endregion
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Item"){
				
		#region Item use
		switch(Id){
			case ITEM.HealingKit:
			    if(!Healing && !defusing && stats.Health_points < global.player_stats.Max_health){
			        global.local_player.item_equip_timer = global.local_player.item_equip_time;
			        HealingItemId = ITEM.HealingKit; Healing = true; ItemAmountSubstract(slot, 1);
			    }
			break;
			case ITEM.low_cal_box:
			case ITEM.med_cal_box:
			case ITEM.high_cal_box:
			case ITEM.gauge_box:
			    var cal_needed = global.ItemIndex[# Id, ITEMSTATS.caliber_type]; // Kalibr
			    if(global.ItemIndex[# wpn_id, ITEMSTATS.caliber_type] == cal_needed){
			        var amt = global.ItemIndex[# Id, ITEMSTATS.MaxAmmo];
			        global.Inventory[# WeaponID, INDEX.slot_clip_ammo] += amt;

					if (!IS_NET) {
						damage_indicator("+" + string(amt), global.local_player.x, global.local_player.y, c_white, spr_Icons, ICON.ammo);
					} else if (oNetworkManager.is_server) {
						server_process_item_action(network_id, Id, global.Inventory[# WeaponID, INDEX.slot_clip_ammo], WeaponID);
					} else if (oNetworkManager.is_connected) {
						send_item_action_complete_client(Id, global.Inventory[# WeaponID, INDEX.slot_clip_ammo], WeaponID);
					}

					item_equip_timer = item_equip_time;
			        ItemAmountSubstract(slot, 1);
			    }
			break;			
			case ITEM.two_scope: case ITEM.red_dot_scope: weapon_attachment_equip(Id, INDEX.slot_scope); break;
			case ITEM.vertical_grip: case ITEM.bipod: case ITEM.horizontal_grip: weapon_attachment_equip(Id, INDEX.slot_grip); break;
			case ITEM.suppressor: weapon_attachment_equip(Id, INDEX.slot_suppressor); break;	
			case ITEM.range_finder: case ITEM.laser: case ITEM.adaptive_chambering: weapon_attachment_equip(Id, INDEX.slot_barrel); break;
			case ITEM.dilatation_pill:
				if (!IS_NET) {
					global.time_step = .25;
					global.local_player.dilatation_timer = DILATATION_TIME;
				} else if (oNetworkManager.is_server) {
					server_process_item_action(global.local_player.network_id, Id);
				} else if (oNetworkManager.is_connected) {
					send_item_action_complete_client(Id);
				}
				global.local_player.item_equip_timer = global.local_player.item_equip_time;
				ItemAmountSubstract(slot, 1);
			break;
			case ITEM.adrenaline:
			case ITEM.steroids:
				if (!IS_NET) {
					if (Id == ITEM.adrenaline) global.local_player.adrenaline_timer = ADRENALINE_TIME;
					else global.local_player.steroids_timer = STEROID_TIME;
				} else if (oNetworkManager.is_server) {
					server_process_item_action(global.local_player.network_id, Id);
				} else if (oNetworkManager.is_connected) {
					send_item_action_complete_client(Id);
				}
				global.local_player.item_equip_timer = global.local_player.item_equip_time;
				ItemAmountSubstract(slot, 1);
			break;
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Weapon"){
								
		#region Primary equip and dequip
		var primary_slot_id = global.Inventory[# OtherSlot.Primary, INDEX.slot_id];
		if (primary_slot_id != ITEM.None && (Id == ITEM.None || global.ItemIndex[# Id, ITEMSTATS.WeaponType] == WEAPON_TYPE.PRIMARY)) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Primary);
			primary_slot_id = ITEM.None;
		} else if (global.ItemIndex[# Id, ITEMSTATS.WeaponType] == WEAPON_TYPE.PRIMARY) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Primary);
		}
		#endregion
				
		#region Secondary equip and dequip
		var secondary_slot_id = global.Inventory[# OtherSlot.Secondary, INDEX.slot_id];
		if (secondary_slot_id != ITEM.None && (Id == ITEM.None || global.ItemIndex[# Id, ITEMSTATS.WeaponType] == WEAPON_TYPE.SECONDARY)) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Secondary);
			secondary_slot_id = ITEM.None;
		} else if (global.ItemIndex[# Id, ITEMSTATS.WeaponType] == WEAPON_TYPE.SECONDARY) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Secondary);
		}
		#endregion
				
		#region Knife equip and dequip
		var tertiary_slot_id = global.Inventory[# OtherSlot.Knife, INDEX.slot_id];
		if (tertiary_slot_id != ITEM.None && (Id == ITEM.None || global.ItemIndex[# Id, ITEMSTATS.WeaponType] == WEAPON_TYPE.TERTIARY)) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Knife);
			tertiary_slot_id = ITEM.None;
		} else if (global.ItemIndex[# Id, ITEMSTATS.WeaponType] == WEAPON_TYPE.TERTIARY) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			item_swap("item_use_position", OtherSlot.Knife);
		}
		#endregion
						
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Armour"){
				
		#region Armour equip and dequip
		var armour_slot_id = global.Inventory[# OtherSlot.Armour, INDEX.slot_id];
		if (armour_slot_id != ITEM.None && (Id == ITEM.None || global.ItemIndex[# Id, ITEMSTATS.Type] == "Armour")) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, INDEX.slot_id], armour_slot_id);
			item_swap("item_use_position", OtherSlot.Armour);
			armour_slot_id = ITEM.None;
			with(id){ equip_network_propagate(); }
		} else if (global.ItemIndex[# Id, ITEMSTATS.Type] == "Armour") {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, INDEX.slot_id], armour_slot_id);
			item_swap("item_use_position", OtherSlot.Armour);
			with(id){ equip_network_propagate(); }
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Helmet"){
				
		#region Helmet equip and dequip
		var helmet_slot_id = global.Inventory[# OtherSlot.Helmet, INDEX.slot_id];
		if (helmet_slot_id != ITEM.None && (Id == ITEM.None || global.ItemIndex[# Id, ITEMSTATS.Type] == "Helmet")) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, INDEX.slot_id], helmet_slot_id);
			item_swap("item_use_position", OtherSlot.Helmet);
			helmet_slot_id = ITEM.None;
			with(id){ equip_network_propagate(); }
		} else if (global.ItemIndex[# Id, ITEMSTATS.Type] == "Helmet") {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, INDEX.slot_id], helmet_slot_id);
			item_swap("item_use_position", OtherSlot.Helmet);
			with(id){ equip_network_propagate(); }
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Shield"){
				
		#region Helmet equip and dequip
		var shield_slot_id = global.Inventory[# OtherSlot.Shield, INDEX.slot_id];
		if (shield_slot_id != ITEM.None && (Id == ITEM.None || global.ItemIndex[# Id, ITEMSTATS.Type] == "Shield")) {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, INDEX.slot_id], shield_slot_id);
			item_swap("item_use_position", OtherSlot.Shield);
			shield_slot_id = ITEM.None;
			with(id){ equip_network_propagate(); }
		} else if (global.ItemIndex[# Id, ITEMSTATS.Type] == "Shield") {
			global.local_player.item_equip_timer = global.local_player.item_equip_time;
			ItemAddWeight(global.Inventory[# slot, INDEX.slot_id], shield_slot_id);
			item_swap("item_use_position", OtherSlot.Shield);
			with(id){ equip_network_propagate(); }
		}
		#endregion
				
	}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Bomb"){
		if (stats.Team == TEAM.TERRORIST && !global.bomb_planted && !Healing && !planting_pending && can_plant) {

			if(planting == false){
				planting = true;
				planting_value = 0;
				planting_slot = slot;
				CanShoot = false;
				player_can_shoot = false;
			}else{
				planting = false;
				planting_value = 0;
				planting_slot = slot;
				CanShoot = true;
				player_can_shoot = true;
			}
		}
	}
}

function find_item(item_id, item_amount = 1){
	for(var i=0;i<ds_grid_width(global.Inventory);i++){
	    var item_to_find = global.Inventory[# i, INDEX.slot_id];
		var item_to_find_amount = global.Inventory[# i, INDEX.SlotAmount];
	    if(item_to_find == item_id && item_to_find_amount >= item_amount){
			return i;
	    }
	}

	return -1;
}



























