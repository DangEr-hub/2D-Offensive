// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_shooting_modes(weapon, modes) {
	var shootingModesList = ds_list_create();
    
	for (var i = 0; i < array_length_1d(modes); i++) {
		ds_list_add(shootingModesList, modes[i]);
	}

	global.ItemIndex[#weapon, ItemStat.ShootingMode] = shootingModesList;
}

function get_shooting_modes_string(weapon) {
    var shootingModesListID = global.ItemIndex[#weapon, ItemStat.ShootingMode];
    var modesString = "";
    var first = true;

    for (var i = 0; i < ds_list_size(shootingModesListID); i++) {
        if (!first) {
            modesString += ", ";
        }
        modesString += ds_list_find_value(shootingModesListID, i);
        first = false;
    }

    return modesString;
}

function weapon_attachment_equip(ID, AttachmentPosition, ObjectType = oPlayer) {
    var weapon_id = global.weapon_id[ObjectType.WeaponID];
    var possible_attachments = ds_list_create();
    var weaponTypeClass = global.ItemIndex[#weapon_id, ItemStat.WeaponTypeClass];
	
    switch(weaponTypeClass) {
        case "Shotgun":
            ds_list_add(possible_attachments, weapon_attachments.weapon_barrel, weapon_attachments.weapon_grip);
        break;
        case "Assault rifle":
            ds_list_add(possible_attachments, weapon_attachments.weapon_scope, weapon_attachments.weapon_barrel, weapon_attachments.weapon_grip, weapon_attachments.weapon_suppressor);
        break;
        case "Pistol":
            ds_list_add(possible_attachments, weapon_attachments.weapon_grip, weapon_attachments.weapon_suppressor);
        break;
        case "Sniper rifle":
            ds_list_add(possible_attachments, weapon_attachments.weapon_scope, weapon_attachments.weapon_barrel, weapon_attachments.weapon_grip, weapon_attachments.weapon_suppressor);
        break;
        case "Submachine gun":
            ds_list_add(possible_attachments, weapon_attachments.weapon_barrel, weapon_attachments.weapon_grip, weapon_attachments.weapon_suppressor);
        break;
        case "Anti-tank missile":
            ds_list_add(possible_attachments, weapon_attachments.weapon_scope, weapon_attachments.weapon_barrel, weapon_attachments.weapon_grip, weapon_attachments.weapon_suppressor);
        break;
    }

    var canEquip = (weapon_id != Item.None) && (ds_list_find_index(possible_attachments, AttachmentPosition) != -1) && (global.weapon_attachments[ObjectType.WeaponID][AttachmentPosition] == Item.None);

    if (canEquip) {
        global.weapon_attachments[ObjectType.WeaponID][AttachmentPosition] = ID;
		with(oPlayer){
			ItemAmountSubstract(ItemUsePosition, 1);
		}
    }
	
    ds_list_destroy(possible_attachments);
}

function ItemDataBase(){
	///Define shooting modes for every weapon
	add_shooting_modes(Item.Spas, ["Auto", "Semi", "Safety"]);
	add_shooting_modes(Item.AKM, ["Auto", "Semi", "Burst", "Safety"]);
	add_shooting_modes(Item.DesertEagle, ["Semi", "Safety"]);
	add_shooting_modes(Item.SG550, ["Auto", "Safety"]);
	add_shooting_modes(Item.SSG08, ["Semi", "Safety"]);
	add_shooting_modes(Item.Javelin, ["Semi", "Safety"]);
	add_shooting_modes(Item.MAC11, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(Item.Glock, ["Semi", "Burst", "Safety"]);
	
	///Define stats for Item.None because multiplying by zero
	global.ItemIndex[#Item.None, ItemStat.Defense] = 1;
	global.ItemIndex[#Item.None, ItemStat.ShootTimer] = 1;	
	global.ItemIndex[#Item.None, ItemStat.KickBackInaccuracyMultiplier] = 1;	
	global.ItemIndex[#Item.None, ItemStat.KickBackPower] = 1;	
	
	global.ItemIndex[#Item.AKM, ItemStat.Type] = "Weapon";
	WeaponStats(Item.AKM, "AKM", 2 * room_speed, 900, 45, 270, 30, "Main", 1, 2.5, 6, snd_AKM, 5, 2, true,
	10, 20, 10, 5.9, 30, .03, 10, 3.5, .007, 1, 9, .25, 1, "Assault rifle", .81, .89, .00015, .5 * room_speed);
	global.ItemIndex[#Item.AKM, ItemStat.ItemColor] = $FF16C3E5; ///orange
	global.ItemIndex[#Item.AKM, ItemStat.AmmoSpriteID] = 0;
	global.ItemIndex[#Item.AKM, ItemStat.Description] = "Avtomat Kalashnikova modernizirovanny, The AKM was designed to succeed the AK-47, which had been launched ten years earlier. This assault rifle uses the 7.62x39mm Soviet intermediate round.It features a gas-operated mechanism with a rotating bolt and can be set to fire in either semi-automatic or automatic modes.";
	
	global.ItemIndex[#Item.KevlarHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.KevlarHelm, "Kevlar helmet", 3, .9);
	global.ItemIndex[#Item.KevlarHelm, ItemStat.ItemColor] = $FF007F02; ///green
	global.ItemIndex[#Item.KevlarHelm, ItemStat.BaseDurability] = 100;
	
	global.ItemIndex[#Item.DesertEagle, ItemStat.Type] = "Weapon";
	WeaponStats(Item.DesertEagle, "IMI Desert eagle", 1.75 * room_speed, 850, 53, 70, 7, "Secondary", 1, 4, 11, snd_DesertEagle, 7, 2, false,
	0, 0, 10, 30, 7, .5, 9, 7.5, .003, 0, 0, .5, 1, "Pistol", .95, .932, .0001, .1 * room_speed);
	global.ItemIndex[#Item.DesertEagle, ItemStat.ItemColor] = $FFB2B2B2; ///ltgray
	global.ItemIndex[#Item.DesertEagle, ItemStat.AmmoSpriteID] = 1;
	global.ItemIndex[#Item.DesertEagle, ItemStat.Description] = "A semi-automatic pistol powered by gas is recognized for using the .50 Action Express cartridge, the most significant centerfire round for any magazine-loaded, self-firing handgun.";
	
	global.ItemIndex[#Item.KevlarVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.KevlarVest, "Kevlar vest", 4, .9);
	global.ItemIndex[#Item.KevlarVest, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	global.ItemIndex[#Item.KevlarVest, ItemStat.BaseDurability] = 100;
	
	global.ItemIndex[#Item.Spas, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Spas, "Spas-12", .75 * room_speed, 500, 33, 120, 12, "Main", 5, 5, 30, snd_Spas, 15, 2, false,
	0, 0, 20, 10, 12, 1.5, 2, 10, .009, 0, 0, .25, 2, "Shotgun", .89, .575, .00125, .75 * room_speed);
	global.ItemIndex[#Item.Spas, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	global.ItemIndex[#Item.Spas, ItemStat.AmmoSpriteID] = 5;
	global.ItemIndex[#Item.Spas, ItemStat.EnemyInaccuracyCompensation] = 1;
	global.ItemIndex[#Item.Spas, ItemStat.Defense] = 1; //Fractionating reloading
	global.ItemIndex[#Item.Spas, ItemStat.Description] = "A battle shotgun produced by the Italian gunmaker Franchi between 1979 and 2000. The SPAS-12 can be set to either semi-automatic or manual pump-action.";
	
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.MilitaryHelm, "Military helmet", 5, .75);
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.ItemColor] = $FF007F02; ///green
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.BaseDurability] = 100;
	
	global.ItemIndex[#Item.MilitaryVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.MilitaryVest, "Military vest", 7, .75);
	global.ItemIndex[#Item.MilitaryVest, ItemStat.ItemColor] = $FF007F02; ///green
	global.ItemIndex[#Item.MilitaryVest, ItemStat.BaseDurability] = 100; 
	
	global.ItemIndex[#Item.SSG08, ItemStat.Type] = "Weapon";
	WeaponStats(Item.SSG08, "Steyr SSG 08", 3 * room_speed, 1000, 110, 100, 10, "Main", 1, 3, 30, snd_SSG08, 15, 5, false,
	0, 0, 10, 20, 10, 50, 5, 10, .001, 0, 0, .25, 1, "Sniper rifle", .87, .85, .00007, 1 * room_speed);
	global.ItemIndex[#Item.SSG08, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	global.ItemIndex[#Item.SSG08, ItemStat.AmmoSpriteID] = 2;
	global.ItemIndex[#Item.SSG08, ItemStat.ScopeInaccuracyResetTimer] = 15;
	global.ItemIndex[#Item.SSG08, ItemStat.Description] = "An Austrian-made sniper rifle with a bolt-action mechanism is crafted by Steyr Mannlicher. This rifle is an advanced version of Steyr's prior SSG 04 sniper model. It's known for its exceptional precision as a bolt-action sniper weapon.";
	
	global.ItemIndex[#Item.MAC11, ItemStat.Type] = "Weapon";
	WeaponStats(Item.MAC11, "MAC11", 1.5 * room_speed, 790, 29, 300, 30, "Main", 1, 2, 6, snd_MAC11, 2, 1, true,
	15, 20, -9, 9, 30, 0.025, 1.5, 2, .015, 3, 5, .9, 0, "Submachine gun", .9, .57, .00053, .1 * room_speed);
	global.ItemIndex[#Item.MAC11, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	global.ItemIndex[#Item.MAC11, ItemStat.AmmoSpriteID] = 3;
	global.ItemIndex[#Item.MAC11, ItemStat.EnemyInaccuracyCompensation] = 3;
	global.ItemIndex[#Item.MAC11, ItemStat.Description] = "An American firearm creator, Gordon Ingram, designed a machine pistol/submachine gun at the Military Armament Corporation (MAC) in the 1970s. This weapon is a more compact variant of the Model 10 (MAC-10) and uses the smaller .380 ACP ammunition.";
	
	global.ItemIndex[#Item.HEGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.HEGrenade, ItemStat.Name] = "High-explosion grenade";
	global.ItemIndex[#Item.HEGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[#Item.HEGrenade, ItemStat.Damage] = 98;
	global.ItemIndex[#Item.HEGrenade, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.HEGrenade, ItemStat.DamageDrop] = .001;
	global.ItemIndex[#Item.HEGrenade, ItemStat.BulletCasingID] = 0;
	global.ItemIndex[#Item.HEGrenade, ItemStat.ItemColor] = $FF007F02; ///green
	
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Name] = "Flashbang grenade";
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Damage] = 11;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.DamageDrop] = .001;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.BulletCasingID] = 1;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.ItemColor] = $FFFFFFFF; ///white

	global.ItemIndex[#Item.SG550, ItemStat.Type] = "Weapon";
	WeaponStats(Item.SG550, "SIG SG550", 2.5 * room_speed, 950, 43, 300, 30, "Main", 1, 3, 7, snd_SG550, 7, 3, true,
	10, 17, -9, 7, 40, 0.01, 7, 3.5, .005, 3, 10, .15, 1, "Assault rifle", .79, .97, .0001, .75 * room_speed);
	global.ItemIndex[#Item.SG550, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	global.ItemIndex[#Item.SG550, ItemStat.AmmoSpriteID] = 4;
	global.ItemIndex[#Item.SG550, ItemStat.SniperScope] = true;
	global.ItemIndex[#Item.SG550, ItemStat.Description] = "An assault weapon made by SIG Sauer AG in Switzerland, which was once a part of the Schweizerische Industrie Gesellschaft, now called SIG Holding AG. SG stands for Sturmgewehr, the German term for assault rifle.";

	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.SpecOpsHelm, "Spec ops helmet", 5, .59);
	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.ItemColor] = $FF343434; ///dkgray
	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.BaseDurability] = 50;
	
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.SpecOpsVest, "Spec ops vest", 8, .59);
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.ItemColor] = $FF343434; ///dkgray
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.BaseDurability] = 50; 
	
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.MilitaryNightVision, "Military night vision", 3, .975);
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.ItemColor] = $FF007F02; ///green
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.BaseDurability] = 100;
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.NightVisionIntensityPower] = 2;
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.NightVisionNoisePower] = 1;
	
	global.ItemIndex[#Item.BasicNightVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.BasicNightVision, "Basic night vision", 1, .99);
	global.ItemIndex[#Item.BasicNightVision, ItemStat.ItemColor] = $FF007F02; ///green
	global.ItemIndex[#Item.BasicNightVision, ItemStat.BaseDurability] = 150;
	global.ItemIndex[#Item.BasicNightVision, ItemStat.NightVisionIntensityPower] = 1.5;
	global.ItemIndex[#Item.BasicNightVision, ItemStat.NightVisionNoisePower] = 2;
	
	global.ItemIndex[#Item.HealingKit, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.HealingKit, ItemStat.Name] = "Healing kit";
	global.ItemIndex[#Item.HealingKit, ItemStat.ReloadSpeed] = 3 * room_speed;
	global.ItemIndex[#Item.HealingKit, ItemStat.Damage] = 100;
	global.ItemIndex[#Item.HealingKit, ItemStat.ItemColor] = $FF0000FF; ///red
	
	global.ItemIndex[#Item.InfraredVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.InfraredVision, "Infrared vision", 3, .975);
	global.ItemIndex[#Item.InfraredVision, ItemStat.ItemColor] = $FF0000FF; ///red
	global.ItemIndex[#Item.InfraredVision, ItemStat.BaseDurability] = 150;
	
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.Name] = "Smoke grenade";
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.BulletCasingID] = 2;
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.ItemColor] = $FF4D4D4D; ///gray

	global.ItemIndex[#Item.Javelin, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Javelin, "FGM-148 Javelin", 1.5 * room_speed, 590, 138, 50, 1, "Main", 1, 25, 15, snd_Javelin, 15, 5, false,
	0, 0, 0, 0, 1, 0, 5, 10, .001, 15, 25, .25, -1, "Anti-tank missile", .59, .99, .00075, 1 * room_speed);
	global.ItemIndex[#Item.Javelin, ItemStat.ItemColor] = $FF007F02; ///gray
	global.ItemIndex[#Item.Javelin, ItemStat.AmmoSpriteID] = 6;
	global.ItemIndex[#Item.Javelin, ItemStat.Description] = "A man-portable, anti-tank weapon system developed in America, operational since 1996. Its design includes a fire-and-forget mechanism with integrated infrared guidance, enabling the operator to find shelter right after firing.";

	global.ItemIndex[#Item.Glock, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Glock, "Glock-17", 1.25 * room_speed, 750, 33, 240, 24, "Secondary", 1, 2, 9, snd_Glock, 3, 1, false,
	0, 0, 5, 8, 24, .1, 1.75, 4, .008, 0, 0, .99, 0, "Pistol", .97, .47, .001, 0.05 * room_speed);
	global.ItemIndex[#Item.Glock, ItemStat.ItemColor] = $FF007F02; ///gray
	global.ItemIndex[#Item.Glock, ItemStat.AmmoSpriteID] = 7;
	global.ItemIndex[#Item.Glock, ItemStat.Description] = "Glock handgun has emerged as the most lucrative product line for the company, being distributed to military services, security organizations, and law enforcement agencies in no fewer than 48 nations.";

	global.ItemIndex[#Item.HELandMine, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.HELandMine, ItemStat.Name] = "High-explosion landmine";
	global.ItemIndex[#Item.HELandMine, ItemStat.BulletCasingID] = 0;
	global.ItemIndex[#Item.HELandMine, ItemStat.Damage] = 98;
	global.ItemIndex[#Item.HELandMine, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.HELandMine, ItemStat.DamageDrop] = .005;
	global.ItemIndex[#Item.HELandMine, ItemStat.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[#Item.HELandMine, ItemStat.ItemColor] = $FF0000FF; ///red
	
	global.ItemIndex[#Item.CELandMine, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.CELandMine, ItemStat.Name] = "Cluster-explosion landmine";
	global.ItemIndex[#Item.CELandMine, ItemStat.BulletCasingID] = 4;
	global.ItemIndex[#Item.CELandMine, ItemStat.Damage] = 75;
	global.ItemIndex[#Item.CELandMine, ItemStat.PenetrationPower] = .99;
	global.ItemIndex[#Item.CELandMine, ItemStat.DamageDrop] = .01;
	global.ItemIndex[#Item.CELandMine, ItemStat.AmmoSpriteID] = 10; ///Shrapnel number
	global.ItemIndex[#Item.CELandMine, ItemStat.ItemColor] = $FFFF00FF; ///yellow
	
	global.ItemIndex[#Item.LELandMine, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.LELandMine, ItemStat.Name] = "Low-explosion landmine";
	global.ItemIndex[#Item.LELandMine, ItemStat.BulletCasingID] = 8;
	global.ItemIndex[#Item.LELandMine, ItemStat.Damage] = 46;
	global.ItemIndex[#Item.LELandMine, ItemStat.PenetrationPower] = .59;
	global.ItemIndex[#Item.LELandMine, ItemStat.DamageDrop] = .005;
	global.ItemIndex[#Item.LELandMine, ItemStat.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[#Item.LELandMine, ItemStat.ItemColor] = $0E86D4FF; ///aqua
	
	global.ItemIndex[#Item.StickyGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.StickyGrenade, ItemStat.Name] = "Sticky grenade";
	global.ItemIndex[#Item.StickyGrenade, ItemStat.ReloadSpeed] = 5;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.Damage] = 49;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.PenetrationPower] = .89;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.DamageDrop] = .005;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.BulletCasingID] = 3;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.ItemColor] = $FF759A9E; ///camo
	
	global.ItemIndex[#Item.red_dot_scope, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.red_dot_scope, ItemStat.Name] = "Red dot sight";
	global.ItemIndex[#Item.red_dot_scope, ItemStat.ItemColor] = $FF0000FF; ///red
	
	global.ItemIndex[#Item.two_scope, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.two_scope, ItemStat.Name] = "2x scope";
	global.ItemIndex[#Item.two_scope, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.Name] = "Adaptive chambering";
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.ShootTimer] = .75;
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	
	global.ItemIndex[#Item.vertical_grip, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.vertical_grip, ItemStat.Name] = "Vertical grip";
	global.ItemIndex[#Item.vertical_grip, ItemStat.KickBackPower] = 1;
	global.ItemIndex[#Item.vertical_grip, ItemStat.KickBackInaccuracyMultiplier] = .75;
	global.ItemIndex[#Item.vertical_grip, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	
	global.ItemIndex[#Item.horizontal_grip, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.horizontal_grip, ItemStat.Name] = "Horizontal grip";
	global.ItemIndex[#Item.horizontal_grip, ItemStat.KickBackInaccuracyMultiplier] = 1;
	global.ItemIndex[#Item.horizontal_grip, ItemStat.KickBackPower] = .75;
	global.ItemIndex[#Item.horizontal_grip, ItemStat.ItemColor] = $FF4D4D4D; ///gray
	
	global.ItemIndex[#Item.military_suppressor, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.military_suppressor, ItemStat.Name] = "Military suppressor";
	global.ItemIndex[#Item.military_suppressor, ItemStat.Description] = "A muzzle device functions to dampen the noise generated upon firing a firearm, thus diminishing the sound level produced by the discharge.";
	global.ItemIndex[#Item.military_suppressor, ItemStat.KickBackPower] = .75;
	global.ItemIndex[#Item.military_suppressor, ItemStat.KickBackInaccuracyMultiplier] = .1;
	global.ItemIndex[#Item.military_suppressor, ItemStat.ItemColor] = $FF4D4D4D; ///gray
}