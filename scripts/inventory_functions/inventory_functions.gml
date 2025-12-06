function can_player_shoot(){
	return (moving_state != states_player.machine_gun_state && moving_state != states_player.mortar_state);
}

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

function GainItem(ID, Amount, ItemAmmo, ItemClipAmmo, ItemDurability, ItemScope, ItemBarrel, ItemGrip, Itemsuppressor, Destroy = true) {
	Slot = 0;
	while(Slot < INVENTORY_SIZE){
	    if(global.ItemIndex[#ID, ItemStat.Type] == "Armour" || global.ItemIndex[#ID, ItemStat.Type] == "Helmet" || global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
	        if (global.Inventory[# Slot, 0] == Item.None){
	            global.Inventory[# Slot, 0] = ID;
	            global.Inventory[# Slot, 1] += Amount;
				global.Inventory[# Slot, Index.slot_durability] = ItemDurability;
	            if(global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
	                ///Weapon
	                Id = global.Inventory[# Slot, 0];
	                global.Inventory[# Slot, 2] = ItemAmmo;
	                global.Inventory[# Slot, 3] = ItemClipAmmo;
					global.Inventory[# Slot, Index.slot_scope] = (ItemScope != -1) ? ItemScope : global.Inventory[# Slot, Index.slot_scope];
					global.Inventory[# Slot, Index.slot_barrel] = (ItemBarrel != -1) ? ItemBarrel : global.Inventory[# Slot, Index.slot_barrel];
					global.Inventory[# Slot, Index.slot_grip] = (ItemGrip != -1) ? ItemGrip : global.Inventory[# Slot, Index.slot_grip];
					global.Inventory[# Slot, Index.slot_suppressor] = (Itemsuppressor != -1) ? Itemsuppressor : global.Inventory[# Slot, Index.slot_suppressor];
	            }
				if(Destroy == true){
					destroy_pickup_instance(id);
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
	    repeat(INVENTORY_SIZE){
	        if(global.Inventory[#yy, 0] == ID){
	            global.Inventory[# yy, 1] += Amount;
	            PickedUp = true;
				if(Destroy == true){
					destroy_pickup_instance(id);
				}
	            break;
	        }else{
	            yy ++;
	        }
	    }
    
	    ///All items
	    if(!PickedUp){
	        yy = 0;
	        repeat(INVENTORY_SIZE){
	            if(global.Inventory[#yy, 0] == Item.None){
	                global.Inventory[# yy, 0] = ID;
	                global.Inventory[# yy, 1] += Amount;
					if(Destroy == true){
						destroy_pickup_instance(id);
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
	
	var slot_width = sprite_get_width(spr_Slot)/2*global.GUIMultiplier;
	var slot_height = sprite_get_height(spr_Slot)/2*global.GUIMultiplier;
	var start_x = camera_get_view_x(CAMERA) + camera_get_view_width(CAMERA)/2 - (SlotRowSize*slot_width/2);
	var start_y = camera_get_view_y(CAMERA) + camera_get_view_height(CAMERA)/1.3 - (SlotColumnSize*slot_height/2);
	
	for(var i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(start_x + i*slot_width, start_y, "OtherO", oSlot);
		Instance.VarSlot = i;
		if(i == 0){
			global.InventoryLeftTopCorner = [Instance.x, Instance.y];
		}
	}
	
	for(var i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(start_x + i*slot_width, start_y + slot_height, "OtherO", oSlot);
		Instance.VarSlot = i + SlotRowSize;
	}
	
	for(var i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(start_x + i*slot_width, start_y + slot_height*2, "OtherO", oSlot);
		Instance.VarSlot = i + SlotRowSize*2;
		if(i == SlotRowSize - 1){
			global.InventoryRightBottomCorner = [Instance.x + slot_width, Instance.y + slot_height];
		}
	}
	
	var equipment_slot_size = OtherSlot.Total - INVENTORY_SIZE - 1;
	for(var i = 0;i<equipment_slot_size;i++){
		Instance = instance_create_layer(start_x + i*slot_width + ((SlotRowSize-equipment_slot_size)*slot_width/2), start_y - slot_height*1.25, "OtherO", oSlot);
		Instance.VarSlot = i + OtherSlot.Primary;
		Instance.image_index = i + 2;
		if(i == 0){
			global.InventoryEquipLeftTopCorner = [Instance.x, Instance.y];
		}else if(i == OtherSlot.Total - INVENTORY_SIZE - 2){
			global.InventoryEquipRightBottomCorner = [Instance.x + slot_width, Instance.y + slot_height];
		}
	}
}

function InventoryInit() {

	enum Item{
	    None, AKM, KevlarHelm, DesertEagle, KevlarVest, Spas, MilitaryHelm, MilitaryVest, SSG08, HEGrenade, MAC11, FlashBangGrenade, SG550, SpecOpsHelm, 
		SpecOpsVest, MilitaryNightVision, BasicNightVision, HealingKit, InfraredVision, SmokeGrenade, Javelin, HELandMine, CELandMine, LELandMine, Glock, 
		StickyGrenade, red_dot_scope, two_scope, adaptive_chambering, vertical_grip, horizontal_grip, military_suppressor, m4a1, awm, usp, base_explosion,
		nuclear_explosion, basic_machine_gun, galil, p250, m4_carbine, famas, MolotovGrenade, steel_knife, tec9, Total
	}

	enum ItemStat{
		/* Draw weapon stats */
	    Damage, Ammo, ClipAmmo, ReloadSpeed, Range, MovingInaccuracyMultiplier, Inaccuracy, ShootTimer, KickBackInaccuracyMultiplier, DamageDrop, RangeInaccuracyMultiplier, 
		WeaponTypeClass, MovingSpdMul, PenetrationPower, ShootingMode,
		
		/* Draw armour stats */
		Weight, Defense, BaseDurability, KickBackPower, RecoilOffsetX, RecoilOffsetY, Description, MaxKickBack, SniperScope, ShootSpdMul, has_barrel, EquipTime, has_suppressor,
		BulletCasingID, ItemColor, ScopeInaccuracyResetTimer, WeaponType, AmmoType, NightVisionIntensityPower, NightVisionNoisePower, AmmoSpriteID, has_scope, has_grip,
		EnemyInaccuracyCompensation, MaxAmmo, Type, Name, ID, Bullets, SoundID, CrosshairShake, CameraShake, HardRecoil, KBPhase1, KBPhase2, RecoilX, RecoilY,
		advantages, disadvantages, usable, Cost, ReloadSpdMul, difficulty, KBResetMultiplier, reward, KBStabilization, random_bullet_spread, Total
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
	
	if(scope_attachment == -1){
		if(image_index == Item.SG550){
			scope_attachment = Item.red_dot_scope;	
		}else if(image_index == Item.SSG08 || image_index == Item.awm){
			scope_attachment = Item.two_scope;	
		}
	}
	
	if(suppressor_attachment == -1){
		if(image_index == Item.m4a1){
			suppressor_attachment = Item.military_suppressor;
		}else if(image_index == Item.usp){
			suppressor_attachment = Item.military_suppressor;
		}
	}
	
	if(Ammo <= -1){
		Ammo = global.ItemIndex[#image_index, ItemStat.Ammo];
		ClipAmmo = global.ItemIndex[#image_index, ItemStat.ClipAmmo];
		MaxAmmo = Ammo;
	}
}
	
function ItemAmountSubstract(ID, Amount){
	global.Inventory[# ID, Index.SlotAmount] -= Amount;
	if(global.Inventory[# ID, Index.SlotAmount] <= 0){
		for(i=0;i<ds_grid_height(global.Inventory);i++){
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
	var ItemDropped = instance_create_layer(PositionX, PositionY, "ItemsO", oItems);
	ItemDropped.Amount = ObjectAmount;
	ItemDropped.image_index = ID;
	if(global.ItemIndex[#ID, ItemStat.Type] == "Weapon"){
		ItemDropped.scope_attachment = global.ItemIndex[#ID, ItemStat.has_scope];
		if(OWSA != -1){
			ItemDropped.scope_attachment = OWSA;
		}	
		ItemDropped.barrel_attachment = global.ItemIndex[#ID, ItemStat.has_barrel];
		if(OWBA != -1){
			ItemDropped.barrel_attachment = OWBA;
		}
		ItemDropped.grip_attachment = global.ItemIndex[#ID, ItemStat.has_grip];
		if(OWGA != -1){
			ItemDropped.grip_attachment = OWGA;
		}
		ItemDropped.suppressor_attachment = global.ItemIndex[#ID, ItemStat.has_suppressor];
		if(OWsuppressorA != -1){
			ItemDropped.suppressor_attachment = OWsuppressorA;
		}
		ItemDropped.Ammo = global.ItemIndex[#ID, ItemStat.Ammo];
		if(ObjectAmmo != -1){
			ItemDropped.Ammo = ObjectAmmo;
		}
		ItemDropped.ClipAmmo = global.ItemIndex[#ID, ItemStat.ClipAmmo];
		if(ObjectClipAmmo != -1){
			ItemDropped.ClipAmmo = ObjectClipAmmo;
		}
			
	}else if(global.ItemIndex[#ID, ItemStat.Type] == "Armour" || 
	global.ItemIndex[#ID, ItemStat.Type] == "Helmet"){
		ItemDropped.Durability = ObjectDurability;
	}
		
	ItemDropped.alarm[0] = 1;
	
	if(IS_NET){
	    with (oNetworkManager) {			
	        buffer_seek(send_buffer, buffer_seek_start, 0);
	        buffer_write(send_buffer, buffer_u8, PACKET.OBJECT_SYNC);
	        buffer_write(send_buffer, buffer_u32, send_sequence++);
	        buffer_write(send_buffer, buffer_u8, 0);       // create
	        buffer_write(send_buffer, buffer_u16, ItemDropped.network_id); // net_id
	        buffer_write(send_buffer, buffer_u16, ItemDropped.object_index); // object_index
	        buffer_write(send_buffer, buffer_f16, PositionX);
	        buffer_write(send_buffer, buffer_f16, PositionY);
	        buffer_write(send_buffer, buffer_u8,  ItemDropped.image_index);
	        buffer_write(send_buffer, buffer_u8,  ItemDropped.scope_attachment);
	        buffer_write(send_buffer, buffer_u8,  ItemDropped.barrel_attachment);
	        buffer_write(send_buffer, buffer_u8,  ItemDropped.grip_attachment);
	        buffer_write(send_buffer, buffer_u8,  ItemDropped.suppressor_attachment);
	        buffer_write(send_buffer, buffer_u16, ItemDropped.ClipAmmo);
	        buffer_write(send_buffer, buffer_u8,  ItemDropped.Ammo);
	        buffer_write(send_buffer, buffer_f16, ItemDropped.Durability);
        
	        var socket_key = ds_map_find_first(clients);
	        for (var i = 0; i < ds_map_size(clients); i++) {
	            sent_server_udp(server_socket, socket_key, send_buffer);
	            socket_key = ds_map_find_next(clients, socket_key);
	        }
	    }
	}
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
		}
		with(id){ weapon_network_propagate(); }
	}
}
	
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



























