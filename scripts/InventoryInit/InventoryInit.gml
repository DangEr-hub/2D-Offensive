/// @description Setup item variables
function InventoryInit() {

	enum Item{
	    None, AKM, KevlarHelm, DesertEagle, KevlarVest, Spas, MilitaryHelm, MilitaryVest, SSG08, HEGrenade, MAC11, FlashBangGrenade, SG550, SpecOpsHelm, 
		SpecOpsVest, MilitaryNightVision, BasicNightVision, HealingKit, InfraredVision, SmokeGrenade, Javelin, HELandMine, CELandMine, LELandMine, Glock, 
		StickyGrenade, red_dot_scope, two_scope, adaptive_chambering, vertical_grip, horizontal_grip, military_suppressor, m4_carbine, MolotovGrenade, Total
	}

	enum ItemStat{
		/* Draw weapon stats */
	    Damage, Ammo, ClipAmmo, ReloadSpeed, Range, MovingInaccuracyMultiplier, Inaccuracy, ShootTimer, KickBackInaccuracyMultiplier, DamageDrop, RangeInaccuracyMultiplier, 
		WeaponTypeClass, MovingSpdMul, PenetrationPower, ShootingMode,
		
		/* Draw armour stats */
		Weight, Defense, BaseDurability, KickBackPower, RecoilOffsetX, RecoilOffsetY, Description, MaxKickBack, SniperScope, ShootSpdMul, EquipTime, has_suppressor,
		BulletCasingID, ItemColor, ScopeInaccuracyResetTimer, WeaponType, AmmoType, NightVisionIntensityPower, NightVisionNoisePower, AmmoSpriteID,
		EnemyInaccuracyCompensation, MaxAmmo, Type, Name, ID, Bullets, SoundID, CrosshairShake, CameraShake, HardRecoil, KBPhase1, KBPhase2, RecoilX, RecoilY,
		Total
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
