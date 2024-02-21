// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_shooting_modes(weapon, modes) {
	var shootingModesList = ds_list_create();
    
	for (var i = 0; i < array_length(modes); i++) {
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
	add_shooting_modes(Item.m4_carbine, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(Item.awm, ["Semi", "Safety"]);
	add_shooting_modes(Item.usp, ["Semi", "Safety"]);
	
	///Define stats for Item.None because multiplying by zero
	global.ItemIndex[#Item.None, ItemStat.Defense] = 1;
	global.ItemIndex[#Item.None, ItemStat.ShootTimer] = 1;	
	global.ItemIndex[#Item.None, ItemStat.KickBackInaccuracyMultiplier] = 1;	
	global.ItemIndex[#Item.None, ItemStat.KickBackPower] = 1;	
	
	global.ItemIndex[#Item.AKM, ItemStat.Type] = "Weapon";
	WeaponStats(Item.AKM, "AKM", 2 * game_get_speed(gamespeed_fps), 900, 45, 270, 30, "Main", 1, 2.5, 6, snd_AKM, 5, 2, true,
	10, 20, 10, 5.9, 30, .03, 10, 3.5, .007, 1, 7, .25, 1, "Assault rifle", .81, .89, .00015, .5 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.AKM, ItemStat.disadvantages] = "-High bullet spread\n-High recoil\n-Long reloading";
	global.ItemIndex[#Item.AKM, ItemStat.advantages] = "-High damage\n-High range\n-Low equip time";
	global.ItemIndex[#Item.AKM, ItemStat.ItemColor] = c_orange;
	global.ItemIndex[#Item.AKM, ItemStat.AmmoSpriteID] = 0;
	global.ItemIndex[#Item.AKM, ItemStat.Description] = "Known for its challenging handling yet unmatched lethality on the battlefield. Mastering its recoil demands skill, but once tamed, it becomes a devastating tool capable of swiftly dispatching foes with deadly precision.";
	
	global.ItemIndex[#Item.KevlarHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.KevlarHelm, "Kevlar helmet", 3, .9);
	global.ItemIndex[#Item.KevlarHelm, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.KevlarHelm, ItemStat.BaseDurability] = 100;
	global.ItemIndex[#Item.KevlarHelm, ItemStat.Description] = "This basic helmet provides 10% damage reduction, offering essential head protection against low-level threats. Lightweight design ensures mobility is maintained.";
	
	global.ItemIndex[#Item.DesertEagle, ItemStat.Type] = "Weapon";
	WeaponStats(Item.DesertEagle, "IMI Desert eagle", 1.75 * game_get_speed(gamespeed_fps), 850, 53, 70, 7, "Secondary", 1, 4, 11, snd_DesertEagle, 7, 2, false,
	0, 0, 10, 30, 7, 2.5, 9, 7.5, .003, 0, 0, .5, 1, "Pistol", .95, .932, .0001, .1 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.DesertEagle, ItemStat.disadvantages] = "-High recoil\n-Low magazine capacity";
	global.ItemIndex[#Item.DesertEagle, ItemStat.advantages] = "-High damage\n-High range\n-High armour penetration";
	global.ItemIndex[#Item.DesertEagle, ItemStat.ItemColor] = c_ltgray;
	global.ItemIndex[#Item.DesertEagle, ItemStat.AmmoSpriteID] = 1;
	global.ItemIndex[#Item.DesertEagle, ItemStat.Description] = "Known for its high damage and armor penetration, presents a formidable challenge to master due to its recoil and limited magazine capacity. Despite these drawbacks, skilled player harness its power to devastating effect, making each well-placed shot count in engagements.";
	
	global.ItemIndex[#Item.KevlarVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.KevlarVest, "Kevlar vest", 4, .9);
	global.ItemIndex[#Item.KevlarVest, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.KevlarVest, ItemStat.BaseDurability] = 100;
	global.ItemIndex[#Item.KevlarVest, ItemStat.Description] = "This lightweight vest offers a basic 10% damage reduction, enhancing survivability against threats. Ideal for added protection without sacrificing mobility.";
	
	global.ItemIndex[#Item.Spas, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Spas, "Spas-12", .75 * game_get_speed(gamespeed_fps), 500, 33, 120, 12, "Main", 5, 5, 30, snd_Spas, 15, 2, false,
	0, 0, 20, 10, 12, 1.5, 2, 10, .009, 0, 0, .25, 2, "Shotgun", .89, .575, .00125, .75 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.Spas, ItemStat.disadvantages] = "-Low penetration power\n-Low range";
	global.ItemIndex[#Item.Spas, ItemStat.advantages] = "-Great mobility\n-High damage";
	global.ItemIndex[#Item.Spas, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.Spas, ItemStat.AmmoSpriteID] = 5;
	global.ItemIndex[#Item.Spas, ItemStat.EnemyInaccuracyCompensation] = 1;
	global.ItemIndex[#Item.Spas, ItemStat.Defense] = 1; //Fractionating reloading
	global.ItemIndex[#Item.Spas, ItemStat.Description] = "A battle shotgun produced by the Italian gunmaker Franchi between 1979 and 2000. The SPAS-12 can be set to either semi-automatic or manual pump-action.";
	
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.MilitaryHelm, "Military helmet", 3, .75);
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.BaseDurability] = 100;
	global.ItemIndex[#Item.MilitaryHelm, ItemStat.Description] = "With a 25% damage reduction, the Military Helmet offers enhanced head protection against moderate threats. A balanced choice for defense and comfort.";
	
	global.ItemIndex[#Item.MilitaryVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.MilitaryVest, "Military vest", 7, .75);
	global.ItemIndex[#Item.MilitaryVest, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.MilitaryVest, ItemStat.BaseDurability] = 100; 
	global.ItemIndex[#Item.MilitaryVest, ItemStat.Description] = "Enhanced with 25% damage reduction, this robust military vest provides significant protection against moderate threats, balancing defense with agility.";
	
	global.ItemIndex[#Item.SSG08, ItemStat.Type] = "Weapon";
	WeaponStats(Item.SSG08, "Steyr SSG 08", 3 * game_get_speed(gamespeed_fps), 1000, 110, 100, 10, "Main", 1, 3, 30, snd_SSG08, 15, 2, false,
	0, 0, 10, 20, 10, 50, 5, 10, .001, 0, 0, .25, 1, "Sniper rifle", .87, .85, .00007, 1 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.SSG08, ItemStat.has_scope] = Item.two_scope;
	global.ItemIndex[#Item.SSG08, ItemStat.disadvantages] = "-Bad mobility\n-Limited view";
	global.ItemIndex[#Item.SSG08, ItemStat.advantages] = "\n-High damage\n-High range";
	global.ItemIndex[#Item.SSG08, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.SSG08, ItemStat.AmmoSpriteID] = 2;
	global.ItemIndex[#Item.SSG08, ItemStat.ScopeInaccuracyResetTimer] = 15;
	global.ItemIndex[#Item.SSG08, ItemStat.Description] = "Steyr SSG08 is a precision sniper rifle known for its deadly accuracy. While it offers unmatched precision, its lower damage requires skilled shooters to make each shot count, making it a challenging yet rewarding choice on the battlefield.";
	
	global.ItemIndex[#Item.MAC11, ItemStat.Type] = "Weapon";
	WeaponStats(Item.MAC11, "MAC11", 1.5 * game_get_speed(gamespeed_fps), 790, 29, 300, 30, "Main", 1, 2, 6, snd_MAC11, 2, 1, true,
	15, 20, -9, 9, 30, 0.025, 1.5, 2, .015, 3, 5, .9, 0, "Submachine gun", .9, .57, .00053, .1 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.MAC11, ItemStat.disadvantages] = "-Low penetration power\n-High bullet spread\n-Low range";
	global.ItemIndex[#Item.MAC11, ItemStat.advantages] = "-Great mobility\n-Low equip time";
	global.ItemIndex[#Item.MAC11, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.MAC11, ItemStat.AmmoSpriteID] = 3;
	global.ItemIndex[#Item.MAC11, ItemStat.EnemyInaccuracyCompensation] = 3;
	global.ItemIndex[#Item.MAC11, ItemStat.Description] = "MAC11 is offering exceptional mobility in close-quarters combat, altough it has limited damage output and armor penetration. Has lightweight design and rapid rate of fire but requires skilled maneuvering to maximize its effectiveness while minimizing its drawbacks.";
	
	global.ItemIndex[#Item.HEGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.HEGrenade, ItemStat.Name] = "High-explosion grenade";
	global.ItemIndex[#Item.HEGrenade, ItemStat.usable] = true;
	global.ItemIndex[#Item.HEGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[#Item.HEGrenade, ItemStat.Damage] = 98;
	global.ItemIndex[#Item.HEGrenade, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.HEGrenade, ItemStat.DamageDrop] = .001;
	global.ItemIndex[#Item.HEGrenade, ItemStat.BulletCasingID] = 0;
	global.ItemIndex[#Item.HEGrenade, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.HEGrenade, ItemStat.Description] = "Designed for maximum impact, it delivers lethal damage over a broad radius, perfect for neutralizing enemy clusters or securing critical spaces. Handle with care; its potent blast is as swift as it is fierce.";
	
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Name] = "Flashbang grenade";
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.usable] = true;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Damage] = 11;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.DamageDrop] = .001;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.BulletCasingID] = 1;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.ItemColor] = c_white;
	global.ItemIndex[#Item.FlashBangGrenade, ItemStat.Description] = "Disorient foes with this non-lethal flashbang. Its blinding flash and deafening bang disrupt enemy senses, ideal for stealthy advances.";

	global.ItemIndex[#Item.SG550, ItemStat.Type] = "Weapon";
	WeaponStats(Item.SG550, "SIG SG550", 2.5 * game_get_speed(gamespeed_fps), 950, 43, 300, 30, "Main", 1, 3, 7, snd_SG550, 7, 1.75, true,
	10, 17, -9, 7, 40, 0.01, 7, 3.5, .005, 3, 8, .15, 1, "Assault rifle", .79, .97, .0001, .75 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.SG550, ItemStat.has_scope] = Item.red_dot_scope;
	global.ItemIndex[#Item.SG550, ItemStat.disadvantages] = "-Lower rate of fire\n-High recoil\n-Moderate mobility";
	global.ItemIndex[#Item.SG550, ItemStat.advantages] = "-High range\-High damage";
	global.ItemIndex[#Item.SG550, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.SG550, ItemStat.AmmoSpriteID] = 4;
	global.ItemIndex[#Item.SG550, ItemStat.SniperScope] = true;
	global.ItemIndex[#Item.SG550, ItemStat.Description] = "An assault weapon made by SIG Sauer AG in Switzerland, which was once a part of the Schweizerische Industrie Gesellschaft, now called SIG Holding AG. SG stands for Sturmgewehr, the German term for assault rifle.";

	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.SpecOpsHelm, "Spec ops helmet", 5, .59);
	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.ItemColor] = c_dkgray;
	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.BaseDurability] = 50;
	global.ItemIndex[#Item.SpecOpsHelm, ItemStat.Description] = "The Spec Ops Helmet, featuring a 41% damage reduction, is designed for intense combat situations but has lower durability. Its heavier construction focuses on maximal protection, demanding strategic use to compensate for its shorter lifespan.";
	
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.SpecOpsVest, "Spec ops vest", 8, .59);
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.ItemColor] = c_dkgray;
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.BaseDurability] = 50; 
	global.ItemIndex[#Item.SpecOpsVest, ItemStat.Description] = "Equipped with 41% damage reduction, the Spec Ops Vest offers advanced protection but with lower durability. Ideal for high-risk scenarios, its heavier build prioritizes maximum defense, requiring careful management due to its limited lifespan.";
	
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.MilitaryNightVision, "Military night vision", 3, .975);
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.BaseDurability] = 100;
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.NightVisionIntensityPower] = 2;
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.NightVisionNoisePower] = 1;
	global.ItemIndex[#Item.MilitaryNightVision, ItemStat.Description] = "Upgrade your nighttime capabilities with Military Night Vision Goggles. Offering superior vision in low-light environments.a";
	
	global.ItemIndex[#Item.BasicNightVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.BasicNightVision, "Basic night vision", 1, .99);
	global.ItemIndex[#Item.BasicNightVision, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.BasicNightVision, ItemStat.BaseDurability] = 150;
	global.ItemIndex[#Item.BasicNightVision, ItemStat.NightVisionIntensityPower] = 1.5;
	global.ItemIndex[#Item.BasicNightVision, ItemStat.NightVisionNoisePower] = 2;
	global.ItemIndex[#Item.BasicNightVision, ItemStat.Description] = "These goggles offer enhanced visibility in low-light conditions, allowing you to spot enemies and navigate with confidence. They're go-to choice for nighttime operations.";
	
	global.ItemIndex[#Item.HealingKit, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.HealingKit, ItemStat.Name] = "Healing kit";
	global.ItemIndex[#Item.HealingKit, ItemStat.usable] = true;
	global.ItemIndex[#Item.HealingKit, ItemStat.ReloadSpeed] = 3 * game_get_speed(gamespeed_fps);
	global.ItemIndex[#Item.HealingKit, ItemStat.Damage] = 100;
	global.ItemIndex[#Item.HealingKit, ItemStat.ItemColor] = c_red;
	global.ItemIndex[#Item.HealingKit, ItemStat.Description] = "The Healing kit restores a substantial amount of health, providing crucial support during intense combat situations.";
	
	global.ItemIndex[#Item.InfraredVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.InfraredVision, "Infrared vision", 3, .975);
	global.ItemIndex[#Item.InfraredVision, ItemStat.ItemColor] = c_red;
	global.ItemIndex[#Item.InfraredVision, ItemStat.BaseDurability] = 150;
	global.ItemIndex[#Item.InfraredVision, ItemStat.Description] = "Gain a tactical advantage in darkness with Infrared Vision Goggles. Spot enemies easily in low-light conditions and stay ahead in nighttime missions.";
	
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.Name] = "Smoke grenade";
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.usable] = true;
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.BulletCasingID] = 2;
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.SmokeGrenade, ItemStat.Description] = "Upon impact, smoke grenade blankets the surrounding area with dense smoke, perfect for obscuring vision, enabling stealthy movements, or disorienting opponents.";

	global.ItemIndex[#Item.Javelin, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Javelin, "FGM-148 Javelin", 1.5 * game_get_speed(gamespeed_fps), 590, 138, 50, 1, "Main", 1, 25, 15, snd_Javelin, 15, 5, false,
	0, 0, 0, 0, 1, 0, 5, 10, .001, 15, 25, .25, -1, "Anti-tank missile", .59, .99, .00075, 1 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.Javelin, ItemStat.disadvantages] = "-Very bad mobility\n-Dangerous explosion\n-Only one rocket per shot";
	global.ItemIndex[#Item.Javelin, ItemStat.advantages] = "-Homing projectiles\n-High damage";
	global.ItemIndex[#Item.Javelin, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.Javelin, ItemStat.AmmoSpriteID] = 6;
	global.ItemIndex[#Item.Javelin, ItemStat.Description] = "A man-portable, anti-tank weapon system developed in America, operational since 1996. Its design includes a fire-and-forget mechanism with integrated infrared guidance, enabling the operator to find shelter right after firing.";

	global.ItemIndex[#Item.Glock, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Glock, "Glock-17", 1.25 * game_get_speed(gamespeed_fps), 750, 33, 240, 24, "Secondary", 1, 2, 9, snd_Glock, 3, 1, false,
	0, 0, 5, 8, 24, .1, 1.75, 4, .008, 0, 0, .99, 0, "Pistol", .97, .47, .001, 0.05 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.Glock, ItemStat.disadvantages] = "-Low damage\n-Low penetration power";
	global.ItemIndex[#Item.Glock, ItemStat.advantages] = "-Great mobility\n-High magazine capacity";
	global.ItemIndex[#Item.Glock, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.Glock, ItemStat.AmmoSpriteID] = 7;
	global.ItemIndex[#Item.Glock, ItemStat.Description] = "The Glock-17 balances moderate damage with a generous magazine capacity, but its limited armor penetration capabilities make it less effective against heavily protected targets.";

	global.ItemIndex[#Item.m4_carbine, ItemStat.Type] = "Weapon";
	WeaponStats(Item.m4_carbine, "M4A1", 2.5 * game_get_speed(gamespeed_fps), 790, 38, 760, 30, "Main", 1, 2, 5.5, snd_m4_carbine, 2.5, 1, true,
	10, 20, -5, 3.9, 30, .01, 25, 3.5, .0025, 1, 7, .9, 0, "Assault rifle", .89, .7, .00023, .1 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.m4_carbine, ItemStat.disadvantages] = "-Low penetration power\n-Long reloading";
	global.ItemIndex[#Item.m4_carbine, ItemStat.advantages] = "-Good mobility\n-Low bullet spread\n-Low recoil";
	global.ItemIndex[#Item.m4_carbine, ItemStat.has_suppressor] = Item.military_suppressor; ///Military suppressor
	global.ItemIndex[#Item.m4_carbine, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.m4_carbine, ItemStat.AmmoSpriteID] = 8;
	global.ItemIndex[#Item.m4_carbine, ItemStat.Description] = "The M4A1 rifle is a great choice with a preattached silencer, offering reduced recoil for improved accuracy, altough at the cost of lower armor penetration. While it may struggle against heavily armored opponents, its stealthy profile and manageable recoil make it a favored option for precise engagements.";
	
	global.ItemIndex[#Item.awm, ItemStat.Type] = "Weapon";
	WeaponStats(Item.awm, "AWM", 3.25 * game_get_speed(gamespeed_fps), 1150, 118, 50, 5, "Main", 1, 2, 30, snd_awm, 30, 2, false,
	0, 0, 25, 50, 5, 50, 10, 10, .0005, 0, 0, .05, 1, "Sniper rifle", .77, .99, .00001, 1.5 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.awm, ItemStat.has_scope] = Item.two_scope;
	global.ItemIndex[#Item.awm, ItemStat.disadvantages] = "-Very bad mobility\n-Limited view\n-Long reloading\n-Long equip time";
	global.ItemIndex[#Item.awm, ItemStat.advantages] = "\n-High damage\n-High range\n-Neglidible damage drop";
	global.ItemIndex[#Item.awm, ItemStat.ItemColor] = c_green;
	global.ItemIndex[#Item.awm, ItemStat.AmmoSpriteID] = 9;
	global.ItemIndex[#Item.awm, ItemStat.ScopeInaccuracyResetTimer] = 15;
	global.ItemIndex[#Item.awm, ItemStat.Description] = "Formidable long-range weapon, boasting unparalleled damage and minimal damage drop over distance, yet hampered by its poor mobility. Skilled marksmen wield it to devastating effect, delivering precise and lethal shots.";
	
	global.ItemIndex[#Item.usp, ItemStat.Type] = "Weapon";
	WeaponStats(Item.usp, "USP", 1.75 * game_get_speed(gamespeed_fps), 750, 35, 350, 15, "Secondary", 1, 3, 7, snd_usp, 2, 1, false,
	0, 0, 7, 5, 15, .5, 5.5, 5, .0025, 0, 0, .93, 0, "Pistol", .93, .505, .00025, 0.15 * game_get_speed(gamespeed_fps));
	global.ItemIndex[#Item.usp, ItemStat.disadvantages] = "-Low penetration power";
	global.ItemIndex[#Item.usp, ItemStat.advantages] = "-Great mobility\n-High magazine capacity";
	global.ItemIndex[#Item.usp, ItemStat.has_suppressor] = Item.military_suppressor;
	global.ItemIndex[#Item.usp, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.usp, ItemStat.AmmoSpriteID] = 7;
	global.ItemIndex[#Item.usp, ItemStat.Description] = "Is a precision weapon, excelling in accuracy with its first shot and boasting considerable damage, yet its lackluster armor penetration. Enhanced with a preattached silencer, offering skilled players a tactical advantage despite its limitations against heavily protected foes.";

	global.ItemIndex[#Item.HELandMine, ItemStat.Type] = "Landmine";
	global.ItemIndex[#Item.HELandMine, ItemStat.Name] = "High-explosive landmine";
	global.ItemIndex[#Item.HELandMine, ItemStat.usable] = true;
	global.ItemIndex[#Item.HELandMine, ItemStat.BulletCasingID] = 0;
	global.ItemIndex[#Item.HELandMine, ItemStat.Damage] = 98;
	global.ItemIndex[#Item.HELandMine, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.HELandMine, ItemStat.DamageDrop] = .005;
	global.ItemIndex[#Item.HELandMine, ItemStat.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[#Item.HELandMine, ItemStat.ItemColor] = c_red;
	global.ItemIndex[#Item.HELandMine, ItemStat.Description] = "The High-explosive landmine delivers devastating force, ideal for ambush tactics and area denial.";
	
	global.ItemIndex[#Item.CELandMine, ItemStat.Type] = "Landmine";
	global.ItemIndex[#Item.CELandMine, ItemStat.Name] = "Cluster-explosion landmine";
	global.ItemIndex[#Item.CELandMine, ItemStat.usable] = true;
	global.ItemIndex[#Item.CELandMine, ItemStat.BulletCasingID] = 4;
	global.ItemIndex[#Item.CELandMine, ItemStat.Damage] = 75;
	global.ItemIndex[#Item.CELandMine, ItemStat.PenetrationPower] = .99;
	global.ItemIndex[#Item.CELandMine, ItemStat.DamageDrop] = .01;
	global.ItemIndex[#Item.CELandMine, ItemStat.AmmoSpriteID] = 10; ///Shrapnel number
	global.ItemIndex[#Item.CELandMine, ItemStat.ItemColor] = c_aqua;
	global.ItemIndex[#Item.CELandMine, ItemStat.Description] = "The Cluster-explosion landmine disperses explosives projectiles upon detonation, creating deadly shrapnel to eliminate nearby threats.";
	
	global.ItemIndex[#Item.LELandMine, ItemStat.Type] = "Landmine";
	global.ItemIndex[#Item.LELandMine, ItemStat.Name] = "Low-explosive landmine";
	global.ItemIndex[#Item.LELandMine, ItemStat.usable] = true;
	global.ItemIndex[#Item.LELandMine, ItemStat.BulletCasingID] = 8;
	global.ItemIndex[#Item.LELandMine, ItemStat.Damage] = 46;
	global.ItemIndex[#Item.LELandMine, ItemStat.PenetrationPower] = .95;
	global.ItemIndex[#Item.LELandMine, ItemStat.DamageDrop] = .005;
	global.ItemIndex[#Item.LELandMine, ItemStat.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[#Item.LELandMine, ItemStat.ItemColor] = c_yellow;
	global.ItemIndex[#Item.LELandMine, ItemStat.Description] = "The Low-explosive landmine, while inflicting less damage than High-explosive variant, features shrapnels with superior armor penetration.";
	
	global.ItemIndex[#Item.StickyGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[#Item.StickyGrenade, ItemStat.Name] = "Sticky grenade";
	global.ItemIndex[#Item.StickyGrenade, ItemStat.usable] = true;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.ReloadSpeed] = 5;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.Damage] = 49;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.PenetrationPower] = .89;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.DamageDrop] = .005;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.BulletCasingID] = 3;
	global.ItemIndex[#Item.StickyGrenade, ItemStat.ItemColor] = make_color_rgb(158, 154, 117);
	global.ItemIndex[#Item.usp, ItemStat.Description] = "The sticky grenade has moderate damage but a unique ability to adhere to targets upon impact. While its explosive power maybe be less dangerous, its ability to immobilize adversaries offers strategic oppurtunities for skilled players to neutralize threats with precision.";
	
	global.ItemIndex[#Item.red_dot_scope, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.red_dot_scope, ItemStat.Name] = "Red dot sight";
	global.ItemIndex[#Item.red_dot_scope, ItemStat.ItemColor] = c_red;
	global.ItemIndex[#Item.red_dot_scope, ItemStat.Description] = "The red dot sight offers improved aiming, but is lacking magnification.";

	global.ItemIndex[#Item.two_scope, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.two_scope, ItemStat.Name] = "2x scope";
	global.ItemIndex[#Item.two_scope, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.two_scope, ItemStat.Description] = "This item provides double magnification for a high-range engagements.";
	
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.Name] = "Adaptive chambering";
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.ShootTimer] = .75;
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.adaptive_chambering, ItemStat.Description] = "This item enhances a weapons fire rate when attached, improving its overall combat efficiency.";
	
	global.ItemIndex[#Item.vertical_grip, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.vertical_grip, ItemStat.Name] = "Vertical grip";
	global.ItemIndex[#Item.vertical_grip, ItemStat.KickBackPower] = 1;
	global.ItemIndex[#Item.vertical_grip, ItemStat.KickBackInaccuracyMultiplier] = .75;
	global.ItemIndex[#Item.vertical_grip, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.vertical_grip, ItemStat.Description] = "The vertical grip improves weapon vertical recoil control, ideal for players who prefer spraying over burst fire tactics.";
	
	global.ItemIndex[#Item.horizontal_grip, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.horizontal_grip, ItemStat.Name] = "Horizontal grip";
	global.ItemIndex[#Item.horizontal_grip, ItemStat.Description] = "Reduces horizontal recoil when shooting with firearms.";
	global.ItemIndex[#Item.horizontal_grip, ItemStat.KickBackInaccuracyMultiplier] = 1;
	global.ItemIndex[#Item.horizontal_grip, ItemStat.KickBackPower] = .75;
	global.ItemIndex[#Item.horizontal_grip, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[#Item.horizontal_grip, ItemStat.Description] = "The horizontal grip improves weapon horizontal recoil control, ideal for players who prefer spraying over burst fire tactics.";
	
	global.ItemIndex[#Item.military_suppressor, ItemStat.Type] = "Item";
	global.ItemIndex[#Item.military_suppressor, ItemStat.Name] = "Military suppressor";
	global.ItemIndex[#Item.military_suppressor, ItemStat.Description] = "A muzzle device functions to dampen the noise generated upon firing a firearm, thus diminishing the sound level produced by the discharge.";
	global.ItemIndex[#Item.military_suppressor, ItemStat.Defense] = .75; ///Damage reduction multiplier
	global.ItemIndex[#Item.military_suppressor, ItemStat.KickBackPower] = .75; ///Inaccuracy multiplier
	global.ItemIndex[#Item.military_suppressor, ItemStat.KickBackInaccuracyMultiplier] = .1; ///Noise reduction multiplier
	global.ItemIndex[#Item.military_suppressor, ItemStat.ItemColor] = c_gray;
	
	///Reprezentace exploze jako itemu kvůli jeho statistikám
	global.ItemIndex[#Item.base_explosion, ItemStat.Name] = "Explosion";
	global.ItemIndex[#Item.base_explosion, ItemStat.Damage] = 95;
	global.ItemIndex[#Item.base_explosion, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[#Item.base_explosion, ItemStat.DamageDrop] = .001;
	
	///Reprezentace nukleární exploze jako itemu kvůli jeho statistikám
	global.ItemIndex[#Item.nuclear_explosion, ItemStat.Name] = "Nuclear explosion";
	global.ItemIndex[#Item.nuclear_explosion, ItemStat.Damage] = 152;
	global.ItemIndex[#Item.nuclear_explosion, ItemStat.PenetrationPower] = .9;
	global.ItemIndex[#Item.nuclear_explosion, ItemStat.DamageDrop] = .001;
}