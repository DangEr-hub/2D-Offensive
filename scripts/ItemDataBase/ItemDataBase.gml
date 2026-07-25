// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function damage_curve_explinlog(dist, range, boundary_1, boundary_2, value_1, value_2, value_3, exp_power, log_power){
    var t = clamp(dist / range, 0, 1);

    // Exp  part
    if(t <= boundary_1){
        var p = t / boundary_1;
        return lerp(1.0, value_1, power(p, exp_power));
    }

    // Lin part
    if(t <= boundary_2){
        var p = (t - boundary_1) / (boundary_2 - boundary_1);
        return lerp(value_1, value_2, p);
    }

    /// Log part
    var p = (t - boundary_2) / (1 - boundary_2);
    p = ln(1 + log_power * p) / ln(1 + log_power);

    return lerp(value_2, value_3, p);
}


function add_shooting_modes(weapon, modes) {
	var shootingModesList = ds_list_create();
    
	for (var i = 0; i < array_length(modes);i++) {
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

function weapon_attachment_equip(ID, AttachmentPosition, ObjectType = global.local_player, which_slot = 0){
    with(ObjectType){

        var is_bot = (object_index == oBot);
        var weapon_id = Item.None;
        var slot_empty = false;
        var slot_enum = 0;

        if(is_bot){
            weapon_id = WeaponID[which_slot];
            slot_empty = (attachments[which_slot][AttachmentPosition] == Item.None);
            slot_enum = AttachmentPosition;
        }else{
            weapon_id = global.Inventory[# WeaponID, Index.slot_id];
            slot_empty = (global.Inventory[# WeaponID, AttachmentPosition] == Item.None);
            slot_enum = AttachmentPosition - Index.slot_scope + ATTACHMENTS.slot_scope;
        }

        if(weapon_id == Item.None || !slot_empty){
            exit;
        }

        if(!weapon_can_equip_attachment(weapon_id, slot_enum)){
            exit;
        }

        if(is_bot){
            attachments[which_slot][AttachmentPosition] = ID;
        }else{
            global.Inventory[# WeaponID, AttachmentPosition] = ID;
            item_equip_timer = item_equip_time;
            ItemAmountSubstract(item_use_position, 1);
        }
    }
}


function weapon_can_equip_attachment(weapon_id, attachment_slot){
    var allowed = global.ItemIndex[# weapon_id, ItemStat.attachments];
    return array_contains(allowed, attachment_slot);
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
	add_shooting_modes(Item.m4a1, ["Auto", "Safety"]);
	add_shooting_modes(Item.awm, ["Semi", "Safety"]);
	add_shooting_modes(Item.usp, ["Semi", "Safety"]);
	add_shooting_modes(Item.basic_machine_gun, ["Auto", "Semi", "Burst", "Safety"]);
	add_shooting_modes(Item.famas, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(Item.galil, ["Auto", "Safety"]);
	add_shooting_modes(Item.p250, ["Semi", "Safety"]);
	add_shooting_modes(Item.MK18, ["Auto", "Semi", "Burst", "Safety"]);
	add_shooting_modes(Item.steel_knife, ["Semi", "Safety"]);
	add_shooting_modes(Item.tec9, ["Semi", "Safety"]);
	add_shooting_modes(Item.Dragunov, ["Semi", "Safety"]);
	add_shooting_modes(Item.MP9, ["Auto", "Safety"]);
	add_shooting_modes(Item.CZ75, ["Auto", "Burst", "Safety"]);

	// assault rifles + snipers
	global.ItemIndex[# Item.AKM, ItemStat.attachments]  = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.MK18, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.m4a1, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.SG550, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.galil, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.famas, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.awm, ItemStat.attachments]   = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.SSG08, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.Dragunov, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	// smg
	global.ItemIndex[# Item.MAC11, ItemStat.attachments] = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.MP9, ItemStat.attachments] = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_suppressor];
	// pistole
	global.ItemIndex[# Item.DesertEagle, ItemStat.attachments] = [ATTACHMENTS.slot_barrel];
	global.ItemIndex[# Item.Glock, ItemStat.attachments]       = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.usp, ItemStat.attachments]         = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.p250, ItemStat.attachments]        = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.tec9, ItemStat.attachments]        = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip, ATTACHMENTS.slot_suppressor];
	global.ItemIndex[# Item.CZ75, ItemStat.attachments]        = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_suppressor];
	// brokovnice
	global.ItemIndex[# Item.Spas, ItemStat.attachments] = [ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip];
	// ostatní
	global.ItemIndex[# Item.Javelin, ItemStat.attachments] = [ATTACHMENTS.slot_scope, ATTACHMENTS.slot_barrel, ATTACHMENTS.slot_grip];

	
	global.ItemIndex[# Item.AKM, ItemStat.attach_sockets] = { scope: [-3, -14], barrel: [14, -7], grip: [14, 4], suppressor: [47, -5] };
	global.ItemIndex[# Item.SG550, ItemStat.attach_sockets] = { scope: [-5, -14], barrel: [16, -7], grip: [16, 4], suppressor: [47, -5] };
	global.ItemIndex[# Item.SSG08, ItemStat.attach_sockets] = { scope: [-21, -11], barrel: [10, -5], grip: [-3, 5], suppressor: [42, -6] };
	global.ItemIndex[# Item.m4a1, ItemStat.attach_sockets] = { scope: [-7, -14], barrel: [14, -7], grip: [16, 2], suppressor: [32, -6] };
	global.ItemIndex[# Item.awm, ItemStat.attach_sockets] = { scope: [-17, -10], barrel: [3, -3], grip: [1, 7], suppressor: [47, -5] };
	global.ItemIndex[# Item.Dragunov, ItemStat.attach_sockets] = { scope: [-17, -7], barrel: [3, -3], grip: [1, 7], suppressor: [50, 0] };
	global.ItemIndex[# Item.famas, ItemStat.attach_sockets] = { scope: [0, -14], barrel: [10, -2], grip: [12, 7], suppressor: [34, -1] };
	global.ItemIndex[# Item.galil, ItemStat.attach_sockets] = { scope: [-7, -14], barrel: [14, -6], grip: [14, 2], suppressor: [47, -7] };
	global.ItemIndex[# Item.MK18, ItemStat.attach_sockets] = { scope: [0, -14], barrel: [20, -8], grip: [20, 2], suppressor: [37, -8] };

	global.ItemIndex[# Item.DesertEagle, ItemStat.attach_sockets] = { barrel: [14, -8]};
	global.ItemIndex[# Item.Glock, ItemStat.attach_sockets] = { barrel: [8, -5], suppressor: [22, -5] };
	global.ItemIndex[# Item.usp, ItemStat.attach_sockets] = { barrel: [8, -5], suppressor: [20, -5] };
	global.ItemIndex[# Item.p250, ItemStat.attach_sockets] = { barrel: [12, -7], suppressor: [28, -6] };
	global.ItemIndex[# Item.tec9, ItemStat.attach_sockets] = { barrel: [13, -11], grip: [14, -2], suppressor: [28, -12] };
	global.ItemIndex[# Item.CZ75, ItemStat.attach_sockets] = { barrel: [13, -11], grip: [14, -2], suppressor: [28, -12] };

	global.ItemIndex[# Item.MAC11, ItemStat.attach_sockets] = { barrel: [10, -8], grip: [10, 1], suppressor: [30, -11] };
	global.ItemIndex[# Item.MP9, ItemStat.attach_sockets] = { barrel: [15, -11], suppressor: [38, -10.5] };

	global.ItemIndex[# Item.Spas, ItemStat.attach_sockets] = { barrel: [23, -2], grip: [24, 12] };
	
	global.ItemIndex[# Item.Javelin, ItemStat.attach_sockets] = { scope: [8, -14], barrel: [20, -7], grip: [22, 10]};
	
	global.ItemIndex[# Item.steel_knife, ItemStat.attach_sockets] = {};
	global.ItemIndex[# Item.basic_machine_gun, ItemStat.attach_sockets] = {};
	
	///Define stats for Item.None because multiplying by zero
	global.ItemIndex[# Item.None, ItemStat.Defense] = 1;
	global.ItemIndex[# Item.None, ItemStat.ShootTimer] = 1;	
	global.ItemIndex[# Item.None, ItemStat.KickBackInaccuracyMultiplier] = 1;	
	global.ItemIndex[# Item.None, ItemStat.KickBackPower] = 1;	
	
	global.ItemIndex[# Item.AKM, ItemStat.Type] = "Weapon";
	WeaponStats(Item.AKM, "AKM", 2 * game_get_speed(gamespeed_fps), 775, 36, 270, 30, WEAPON_TYPE.PRIMARY, 8, 6, snd_AKM, 5, 1.25, true,
	10, 20, 10, 5.9, .015, 10, 3.5, .0013, 1, 7, .25, 1, WEAPON_CLASS.ASSAULT_RIFLE, .81, .795, .00015, .5 * game_get_speed(gamespeed_fps), .85, 270, 1, 5, true, "7.62x39 mm", CALIBER.HIGH);
	global.ItemIndex[# Item.AKM, ItemStat.difficulty] = 4;
	global.ItemIndex[# Item.AKM, ItemStat.disadvantages] = "-High bullet spread\n-High recoil\n-Long reloading";
	global.ItemIndex[# Item.AKM, ItemStat.advantages] = "+High damage\n+High range\n+Fast equipping";
	global.ItemIndex[# Item.AKM, ItemStat.ItemColor] = c_orange;
	global.ItemIndex[# Item.AKM, ItemStat.AmmoSpriteID] = 0;
	global.ItemIndex[# Item.AKM, ItemStat.Description] = "Known for its challenging handling yet unmatched lethality on the battlefield. Mastering its recoil demands skill, but once tamed, it becomes a devastating tool capable of swiftly dispatching foes with deadly precision.";
	
	global.ItemIndex[# Item.KevlarHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.KevlarHelm, "Kevlar helmet", 3, .925, 25);
	global.ItemIndex[# Item.KevlarHelm, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.KevlarHelm, ItemStat.BaseDurability] = 100;
	global.ItemIndex[# Item.KevlarHelm, ItemStat.Description] = "This basic helmet provides " + string_format((1 - global.ItemIndex[# Item.KevlarHelm, ItemStat.Defense]) * 100, 0, 1) + "% damage reduction, offering essential head protection against low-level threats. Lightweight design ensures mobility is maintained.";
	
	global.ItemIndex[# Item.DesertEagle, ItemStat.Type] = "Weapon";
	WeaponStats(Item.DesertEagle, "Desert Eagle", 1.75 * game_get_speed(gamespeed_fps), 700, 53, 70, 7, WEAPON_TYPE.SECONDARY, 4, 11, snd_DesertEagle, 7, 2, false,
	0, 0, 10, 30, 2.5, 9, 7.5, .003, 0, 0, .5, 1, WEAPON_CLASS.PISTOL, .9, .932, .00059, .1 * game_get_speed(gamespeed_fps), .77, 75, 2, 7, true, ".50 AE", CALIBER.HIGH);
	global.ItemIndex[# Item.DesertEagle, ItemStat.random_bullet_spread] = true;
	global.ItemIndex[# Item.DesertEagle, ItemStat.difficulty] = 5;
	global.ItemIndex[# Item.DesertEagle, ItemStat.disadvantages] = "-High recoil\n-Low magazine capacity";
	global.ItemIndex[# Item.DesertEagle, ItemStat.advantages] = "+High damage\n+High range\n+High penetration power";
	global.ItemIndex[# Item.DesertEagle, ItemStat.ItemColor] = c_ltgray;
	global.ItemIndex[# Item.DesertEagle, ItemStat.AmmoSpriteID] = 1;
	global.ItemIndex[# Item.DesertEagle, ItemStat.Description] = "Known for its high damage and armor penetration, presents a formidable challenge to master due to its recoil and limited magazine capacity. Despite these drawbacks, skilled player harness its power to devastating effect, making each well-placed shot count in engagements.";
	
	global.ItemIndex[# Item.KevlarVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.KevlarVest, "Kevlar vest", 4, .925, 50);
	global.ItemIndex[# Item.KevlarVest, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.KevlarVest, ItemStat.BaseDurability] = 100;
	global.ItemIndex[# Item.KevlarVest, ItemStat.Description] = "This lightweight vest offers a basic " + string_format((1 - global.ItemIndex[# Item.KevlarVest, ItemStat.Defense]) * 100, 0, 1) + "% damage reduction, enhancing survivability against threats. Ideal for added protection without sacrificing mobility.";
	
	global.ItemIndex[# Item.Spas, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Spas, "Spas-12", .75 * game_get_speed(gamespeed_fps), 400, 33, 120, 12, WEAPON_TYPE.PRIMARY, 5, 30, snd_Spas, 15, 2, false,
	0, 0, 20, 10, 1.25, 2, 7.5, .009, 0, 0, .25, 2, WEAPON_CLASS.SHOTGUN, .89, .575, .00135, .75 * game_get_speed(gamespeed_fps), .73, 140, 2, 10, false, "12 Gauge", CALIBER.GAUGES);
	global.ItemIndex[# Item.Spas, ItemStat.difficulty] = 2;
	global.ItemIndex[# Item.Spas, ItemStat.disadvantages] = "-Low penetration power\n-Low range";
	global.ItemIndex[# Item.Spas, ItemStat.advantages] = "+Great mobility\n+High damage";
	global.ItemIndex[# Item.Spas, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.Spas, ItemStat.AmmoSpriteID] = 5;
	global.ItemIndex[# Item.Spas, ItemStat.EnemyInaccuracyCompensation] = 1;
	global.ItemIndex[# Item.Spas, ItemStat.Bullets] = 5;
	global.ItemIndex[# Item.Spas, ItemStat.BaseDurability] = 1; //Fractionating reloading
	global.ItemIndex[# Item.Spas, ItemStat.Description] = "A lethal close-quarters option, the SPAS-12 shotgun delivers swift takedowns up close but falters at longer distances. Ideal for tight encounters where its devastating power reigns supreme.";
	
	global.ItemIndex[# Item.MilitaryHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.MilitaryHelm, "Military helmet", 3, .875, 50);
	global.ItemIndex[# Item.MilitaryHelm, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.MilitaryHelm, ItemStat.BaseDurability] = 100;
	global.ItemIndex[# Item.MilitaryHelm, ItemStat.Description] = "With a " + string_format((1 - global.ItemIndex[# Item.MilitaryHelm, ItemStat.Defense]) * 100, 0, 1) + "% damage reduction, the Military Helmet offers enhanced head protection against moderate threats. A balanced choice for defense and comfort.";
	
	global.ItemIndex[# Item.MilitaryVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.MilitaryVest, "Military vest", 7, .875, 75);
	global.ItemIndex[# Item.MilitaryVest, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.MilitaryVest, ItemStat.BaseDurability] = 100; 
	global.ItemIndex[# Item.MilitaryVest, ItemStat.Description] = "Enhanced with " + string_format((1 - global.ItemIndex[# Item.MilitaryVest, ItemStat.Defense]) * 100, 0, 1) + "% damage reduction, this robust military vest provides significant protection against moderate threats, balancing defense with agility.";
	
	global.ItemIndex[# Item.SSG08, ItemStat.Type] = "Weapon";
	WeaponStats(Item.SSG08, "SSG 08", 3 * game_get_speed(gamespeed_fps), 825, 110, 100, 10, WEAPON_TYPE.PRIMARY, 2, 30, snd_SSG08, 15, 2, false,
	0, 0, 10, 20, 50, 10, 10, .001, 0, 0, .25, 1, WEAPON_CLASS.SNIPER_RIFLE, .87, .85, .00013, 1 * game_get_speed(gamespeed_fps), .5, 170, 2, 7, false, ".338 LM", CALIBER.HIGH);
	global.ItemIndex[# Item.SSG08, ItemStat.difficulty] = 5;
	global.ItemIndex[# Item.SSG08, ItemStat.preattached] = { scope: Item.two_scope };
	global.ItemIndex[# Item.SSG08, ItemStat.disadvantages] = "-Bad mobility\n-Limited view";
	global.ItemIndex[# Item.SSG08, ItemStat.advantages] = "\n+High damage\n+High range";
	global.ItemIndex[# Item.SSG08, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.SSG08, ItemStat.AmmoSpriteID] = 2;
	global.ItemIndex[# Item.SSG08, ItemStat.ScopeInaccuracyResetTimer] = 15;
	global.ItemIndex[# Item.SSG08, ItemStat.Description] = "SSG08 is a precision sniper rifle known for its deadly accuracy. While it offers unmatched precision, its lower damage requires skilled shooters to make each shot count, making it a challenging yet rewarding choice on the battlefield.";
	
	global.ItemIndex[# Item.MAC11, ItemStat.Type] = "Weapon";
	WeaponStats(Item.MAC11, "MAC11", 1.5 * game_get_speed(gamespeed_fps), 580, 29, 300, 30, WEAPON_TYPE.PRIMARY, 3, 6, snd_MAC11, 2, 1, true,
	15, 20, -9, 9, 0.025, 1.5, 2, .015, 1, 5, .9, 0, WEAPON_CLASS.SUBMACHINE_GUN, .9, .57, .00053, .1 * game_get_speed(gamespeed_fps), .89, 105, .5, 9, false, ".380 ACP", CALIBER.LOW);
	global.ItemIndex[# Item.MAC11, ItemStat.difficulty] = 2;
	global.ItemIndex[# Item.MAC11, ItemStat.disadvantages] = "-Low penetration power\n-High bullet spread\n-Low range";
	global.ItemIndex[# Item.MAC11, ItemStat.advantages] = "+Great mobility\n+Fast equipping";
	global.ItemIndex[# Item.MAC11, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.MAC11, ItemStat.AmmoSpriteID] = 3;
	global.ItemIndex[# Item.MAC11, ItemStat.EnemyInaccuracyCompensation] = 3;
	global.ItemIndex[# Item.MAC11, ItemStat.Description] = "MAC11 is offering exceptional mobility in close-quarters combat, altough it has limited damage output and armor penetration. Has lightweight design and rapid rate of fire but requires skilled maneuvering to maximize its effectiveness while minimizing its drawbacks.";
	
	global.ItemIndex[# Item.MP9, ItemStat.Type] = "Weapon";
	WeaponStats(Item.MP9, "MP9", 1.25 * game_get_speed(gamespeed_fps), 685, 28, 280, 30, WEAPON_TYPE.PRIMARY, 4, 5, snd_MP9, 1.5, 0.8, true,
	8, 18, 14, 7, 0.02, 1.75, 1, .011, 4, 7, .925, 0, WEAPON_CLASS.SUBMACHINE_GUN, .88, .7, .00058, 1 * game_get_speed(gamespeed_fps), .5, 135, 1, 9, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# Item.MP9, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.MP9, ItemStat.disadvantages] = "-Slow equip\n-High recoil\n-High damage drop-off";
	global.ItemIndex[# Item.MP9, ItemStat.advantages] = "+Great penetration power\n+Great range for SMG\n+Great rate of fire";
	global.ItemIndex[# Item.MP9, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.MP9, ItemStat.AmmoSpriteID] = 17;
	global.ItemIndex[# Item.MP9, ItemStat.EnemyInaccuracyCompensation] = 1.5;
	global.ItemIndex[# Item.MP9, ItemStat.Description] = "MP9 has a high rate of fire and impressive armor penetration, making it perfect for rapid ambushes. While lethal at close range, it suffers from a lengthy equip time and significant damage drop-off. Its stout vertical recoil demands steady control to balance its high-velocity output against its handling drawbacks.";
	
	global.ItemIndex[# Item.HEGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[# Item.HEGrenade, ItemStat.Name] = "HE grenade";
	global.ItemIndex[# Item.HEGrenade, ItemStat.Cost] = 25;
	global.ItemIndex[# Item.HEGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[# Item.HEGrenade, ItemStat.Damage] = 98;
	global.ItemIndex[# Item.HEGrenade, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[# Item.HEGrenade, ItemStat.DamageDrop] = .001;
	global.ItemIndex[# Item.HEGrenade, ItemStat.BulletCasingID] = 0;
	global.ItemIndex[# Item.HEGrenade, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.HEGrenade, ItemStat.Description] = "Designed for maximum impact, it delivers lethal damage over a broad radius, perfect for neutralizing enemy clusters or securing critical spaces. Handle with care; its potent blast is as swift as it is fierce.";
	
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.Name] = "Flashbang";
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.Cost] = 25;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.Damage] = 11;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.DamageDrop] = .001;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.BulletCasingID] = 1;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.ItemColor] = c_white;
	global.ItemIndex[# Item.FlashBangGrenade, ItemStat.Description] = "Disorient foes with this non-lethal flashbang. Its blinding flash and deafening bang disrupt enemy senses, ideal for stealthy advances.";

	global.ItemIndex[# Item.SG550, ItemStat.Type] = "Weapon";
	WeaponStats(Item.SG550, "SIG SG550", 2.5 * game_get_speed(gamespeed_fps), 790, 43, 300, 30, WEAPON_TYPE.PRIMARY, 10, 7, snd_SG550, 2, 1.75, true,
	10, 17, -7, 7, 0.01, 9, 3.5, .0025, 3, 8, .15, 1, WEAPON_CLASS.ASSAULT_RIFLE, .82, .97, .00014, .75 * game_get_speed(gamespeed_fps), .83, 300, 1, 5, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# Item.SG550, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.SG550, ItemStat.preattached] = { scope: Item.red_dot_scope };
	global.ItemIndex[# Item.SG550, ItemStat.disadvantages] = "-Lower rate of fire\n-High recoil\n-Moderate mobility\n-High bullet spread";
	global.ItemIndex[# Item.SG550, ItemStat.advantages] = "+High range\n+High damage\n+High penetration power";
	global.ItemIndex[# Item.SG550, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.SG550, ItemStat.AmmoSpriteID] = 4;
	global.ItemIndex[# Item.SG550, ItemStat.Description] = "The SIG 550 comes equipped with a preattached scope, offering exceptional range and damage. However, its high recoil and slower rate of fire demand precision shooting, while its bulkier build limits movement speed. Ideal for those who excel in calculated, long-range engagements.";

	global.ItemIndex[# Item.SpecOpsHelm, ItemStat.Type] = "Helmet";
	ArmourStats(Item.SpecOpsHelm, "Spec ops helmet", 5, .825, 100);
	global.ItemIndex[# Item.SpecOpsHelm, ItemStat.ItemColor] = c_dkgray;
	global.ItemIndex[# Item.SpecOpsHelm, ItemStat.BaseDurability] = 50;
	global.ItemIndex[# Item.SpecOpsHelm, ItemStat.Description] = "The Spec Ops Helmet, featuring a " + string_format((1 - global.ItemIndex[# Item.SpecOpsHelm, ItemStat.Defense]) * 100, 0, 1) + "% damage reduction, is designed for intense combat situations but has lower durability. Its heavier construction focuses on maximal protection, demanding strategic use to compensate for its shorter lifespan.";
	
	global.ItemIndex[# Item.SpecOpsVest, ItemStat.Type] = "Armour";
	ArmourStats(Item.SpecOpsVest, "Spec ops vest", 8, .825, 125);
	global.ItemIndex[# Item.SpecOpsVest, ItemStat.ItemColor] = c_dkgray;
	global.ItemIndex[# Item.SpecOpsVest, ItemStat.BaseDurability] = 50; 
	global.ItemIndex[# Item.SpecOpsVest, ItemStat.Description] = "Equipped with " + string_format((1 - global.ItemIndex[# Item.SpecOpsVest, ItemStat.Defense]) * 100, 0, 1) + "% damage reduction, the Spec Ops Vest offers advanced protection but with lower durability. Ideal for high-risk scenarios, its heavier build prioritizes maximum defense, requiring careful management due to its limited lifespan.";
	
	global.ItemIndex[# Item.MilitaryNightVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.MilitaryNightVision, "Military night vision", 3, .975, 150);
	global.ItemIndex[# Item.MilitaryNightVision, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.MilitaryNightVision, ItemStat.BaseDurability] = 100;
	global.ItemIndex[# Item.MilitaryNightVision, ItemStat.NightVisionIntensityPower] = 2;
	global.ItemIndex[# Item.MilitaryNightVision, ItemStat.NightVisionNoisePower] = 1;
	global.ItemIndex[# Item.MilitaryNightVision, ItemStat.Description] = "Upgrade your nighttime capabilities with Military Night Vision Goggles. Offering superior vision in low-light environments.";
	
	global.ItemIndex[# Item.BasicNightVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.BasicNightVision, "Basic night vision", 1, .99, 100);
	global.ItemIndex[# Item.BasicNightVision, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.BasicNightVision, ItemStat.BaseDurability] = 150;
	global.ItemIndex[# Item.BasicNightVision, ItemStat.NightVisionIntensityPower] = 1.5;
	global.ItemIndex[# Item.BasicNightVision, ItemStat.NightVisionNoisePower] = 2;
	global.ItemIndex[# Item.BasicNightVision, ItemStat.Description] = "These goggles offer enhanced visibility in low-light conditions, allowing you to spot enemies and navigate with confidence. They're go-to choice for nighttime operations.";
	
	global.ItemIndex[# Item.HealingKit, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.HealingKit, ItemStat.Name] = "Healing kit";
	global.ItemIndex[# Item.HealingKit, ItemStat.ReloadSpeed] = 3 * game_get_speed(gamespeed_fps);
	global.ItemIndex[# Item.HealingKit, ItemStat.Damage] = 100;
	global.ItemIndex[# Item.HealingKit, ItemStat.Cost] = 25;
	global.ItemIndex[# Item.HealingKit, ItemStat.ItemColor] = c_red;
	global.ItemIndex[# Item.HealingKit, ItemStat.Description] = "The Healing kit restores a substantial amount of health, providing crucial support during intense combat situations.";
	
	global.ItemIndex[# Item.InfraredVision, ItemStat.Type] = "Helmet";
	ArmourStats(Item.InfraredVision, "Infrared vision", 3, .975, 150);
	global.ItemIndex[# Item.InfraredVision, ItemStat.ItemColor] = c_red;
	global.ItemIndex[# Item.InfraredVision, ItemStat.BaseDurability] = 150;
	global.ItemIndex[# Item.InfraredVision, ItemStat.Description] = "Gain a tactical advantage in darkness with Infrared Vision Goggles. Spot enemies easily in low-light conditions and stay ahead in nighttime missions.";
	
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.Name] = "Smoke grenade";
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.Damage] = 0;
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.PenetrationPower] = 0;
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.Cost] = 25;
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.ReloadSpeed] = 2.5;
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.BulletCasingID] = 2;
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.SmokeGrenade, ItemStat.Description] = "Upon impact, smoke grenade blankets the surrounding area with dense smoke, perfect for obscuring vision, enabling stealthy movements, or disorienting opponents.";

	global.ItemIndex[# Item.Javelin, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Javelin, "FGM-148", 1.5 * game_get_speed(gamespeed_fps), 490, 138, 50, 1, WEAPON_TYPE.PRIMARY, 25, 15, snd_Javelin, 15, 5, false,
	0, 0, 0, 0, 0, 5, 7.5, .001, 15, 25, .25, -1, WEAPON_CLASS.MISSILE, .59, .99, .00075, 1 * game_get_speed(gamespeed_fps), .5, 350, 1, 4, false, "127 mm HEAT", CALIBER.ROCKET);
	global.ItemIndex[# Item.Javelin, ItemStat.difficulty] = 1;
	global.ItemIndex[# Item.Javelin, ItemStat.disadvantages] = "-Very bad mobility\n-Dangerous explosion\n-Only one rocket per shot";
	global.ItemIndex[# Item.Javelin, ItemStat.advantages] = "+Homing projectiles\n+High damage";
	global.ItemIndex[# Item.Javelin, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.Javelin, ItemStat.AmmoSpriteID] = 6;
	global.ItemIndex[# Item.Javelin, ItemStat.Description] = "High-damage, armor-piercing powerhouse. Mastery requires skill due to its inaccuracy and limited magazine but in the hands of a skilled player, each shot spells devastation for your enemies.";

	global.ItemIndex[# Item.Glock, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Glock, "Glock-17", 1.25 * game_get_speed(gamespeed_fps), 500, 29, 240, 24, WEAPON_TYPE.SECONDARY, 4, 9, snd_Glock, 3, 1, false,
	24, 24, 5, 8, .1, 1.1, 1, .008, 0, 5, .99, 0, WEAPON_CLASS.PISTOL, .97, .47, .001, 0.05 * game_get_speed(gamespeed_fps), .9, 20, .5, 9, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# Item.Glock, ItemStat.difficulty] = 2;
	global.ItemIndex[# Item.Glock, ItemStat.disadvantages] = "-Low damage\n-Low penetration power";
	global.ItemIndex[# Item.Glock, ItemStat.advantages] = "-Great mobility\n-High magazine capacity";
	global.ItemIndex[# Item.Glock, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.Glock, ItemStat.AmmoSpriteID] = 7;
	global.ItemIndex[# Item.Glock, ItemStat.Description] = "The Glock-17 balances moderate damage with a generous magazine capacity, but its limited armor penetration capabilities make it less effective against heavily protected targets.";

	global.ItemIndex[# Item.MK18, ItemStat.Type] = "Weapon";
	WeaponStats(Item.MK18, "MK18", 2.1 * game_get_speed(gamespeed_fps), 715, 33, 700, 30, WEAPON_TYPE.PRIMARY, 7, 5.5, snd_MK18, 2, 1, true,
	10, 20, 13, 9, .01, 8, 3.5, .0012, 0, 10, .9, 0, WEAPON_CLASS.ASSAULT_RIFLE, .89, .71, .00019, .2 * game_get_speed(gamespeed_fps), .73, 300, .75, 5, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# Item.MK18, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.MK18, ItemStat.disadvantages] = "-Low penetration power\n-High recoil";
	global.ItemIndex[# Item.MK18, ItemStat.advantages] = "+Good mobility\n+Low bullet spread";
	global.ItemIndex[# Item.MK18, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.MK18, ItemStat.AmmoSpriteID] = 8;
	global.ItemIndex[# Item.MK18, ItemStat.Description] = "MK18 is a potent rifle renowned for its rapid fire rate and exceptional accuracy over longer distances, though with a punchier recoil. While sacrificing some armor penetration, its swift RPM makes it ideal for precise engagements, striking a balance between speed and effectiveness on the battlefield.";
	global.ItemIndex[# Item.MK18, ItemStat.DamageDrop] = function(dist)  {
		return damage_curve_explinlog(
		    dist,
		    global.ItemIndex[# Item.MK18, ItemStat.Range],
		    0.25,   // boundary_1 - 20 % dostřelu
		    0.65,   // boundary_2 - 70 % dostřelu
		    0.92,   // value_1 - 97 % damage
		    0.87,   // value_2 - 85 % damage
		    0.81,   // value_3 - 77 % damage na max range

		    3.0,
		    5.0 
		);
	}

	global.ItemIndex[# Item.m4a1, ItemStat.Type] = "Weapon";
	WeaponStats(Item.m4a1, "M4A1", 2.5 * game_get_speed(gamespeed_fps), 730, 34, 300, 25, WEAPON_TYPE.PRIMARY, 5, 6, snd_m4a1, 2.5, 1, true,
	10, 15, -5, 3.9, .01, 8, 3.5, .0027, 1, 7.75, .9, 0, WEAPON_CLASS.ASSAULT_RIFLE, .85, .7, .00027, .1 * game_get_speed(gamespeed_fps), .73, 290, .75, 5, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# Item.m4a1, ItemStat.difficulty] = 2;
	global.ItemIndex[# Item.m4a1, ItemStat.disadvantages] = "-Low penetration power\n-Long reloading";
	global.ItemIndex[# Item.m4a1, ItemStat.advantages] = "+Good mobility\n+Low bullet spread\n+Low recoil";
	global.ItemIndex[# Item.m4a1, ItemStat.preattached] = { suppressor: Item.advanced_suppressor };
	global.ItemIndex[# Item.m4a1, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.m4a1, ItemStat.AmmoSpriteID] = 13;
	global.ItemIndex[# Item.m4a1, ItemStat.Description] = "The M4A1 rifle is a great choice with a preattached silencer, offering reduced recoil for improved accuracy, altough at the cost of lower armor penetration. While it may struggle against heavily armored opponents, its stealthy profile and manageable recoil make it a favored option for precise engagements.";
	
	global.ItemIndex[# Item.awm, ItemStat.Type] = "Weapon";
	WeaponStats(Item.awm, "AWM", 3.25 * game_get_speed(gamespeed_fps), 900, 118, 50, 5, WEAPON_TYPE.PRIMARY, 1, 30, snd_awm, 30, 2, false,
	0, 0, 25, 50, 50, 25, 7.5, .0005, 0, 0, .05, 1, WEAPON_CLASS.SNIPER_RIFLE, .77, .99, .000075, 1.5 * game_get_speed(gamespeed_fps), .33, 440, 2, 5, false, ".338 LM", CALIBER.HIGH);
	global.ItemIndex[# Item.awm, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.awm, ItemStat.preattached] = { scope: Item.two_scope };
	global.ItemIndex[# Item.awm, ItemStat.disadvantages] = "-Very bad mobility\n-Limited view\n-Long reloading\n-Slow equip";
	global.ItemIndex[# Item.awm, ItemStat.advantages] = "\n+High damage\n+High range\n+Neglidible damage drop";
	global.ItemIndex[# Item.awm, ItemStat.ItemColor] = c_green;
	global.ItemIndex[# Item.awm, ItemStat.AmmoSpriteID] = 9;
	global.ItemIndex[# Item.awm, ItemStat.ScopeInaccuracyResetTimer] = 55;
	global.ItemIndex[# Item.awm, ItemStat.Description] = "Formidable long-range weapon, boasting unparalleled damage and minimal damage drop over distance, yet hampered by its poor mobility. Skilled marksmen wield it to devastating effect, delivering precise and lethal shots.";
	
	global.ItemIndex[# Item.Dragunov, ItemStat.Type] = "Weapon";
	WeaponStats(Item.Dragunov, "Dragunov", 3.75 * game_get_speed(gamespeed_fps), 890, 94, 45, 15, WEAPON_TYPE.PRIMARY, 2, 20, snd_Dragunov, 20, 1.5, false,
	0, 0, 15, 25, 5, 25, 5, .00075, 0, 0, .15, 1, WEAPON_CLASS.SNIPER_RIFLE, .815, .975, .00075, 1 * game_get_speed(gamespeed_fps), .25, 500, 2, 5, false, "7.62x54 mm", CALIBER.HIGH);
	global.ItemIndex[# Item.Dragunov, ItemStat.difficulty] = 2;
	global.ItemIndex[# Item.Dragunov, ItemStat.random_bullet_spread] = true;
	global.ItemIndex[# Item.Dragunov, ItemStat.preattached] = { scope: Item.two_scope };
	global.ItemIndex[# Item.Dragunov, ItemStat.disadvantages] = "-Very bad mobility\n-Limited view\n-Long reloading\n-High damage drop";
	global.ItemIndex[# Item.Dragunov, ItemStat.advantages] = "\n+Semi-automatic\n+High range";
	global.ItemIndex[# Item.Dragunov, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.Dragunov, ItemStat.AmmoSpriteID] = 16;
	global.ItemIndex[# Item.Dragunov, ItemStat.ScopeInaccuracyResetTimer] = 10;
	global.ItemIndex[# Item.Dragunov, ItemStat.Defense] = 1; ///Flag, ze je to semi-automatic
	global.ItemIndex[# Item.Dragunov, ItemStat.Description] = "Semi-automatic long-range rifle with high base damage and strong penetration, offset by limited mobility and noticeable damage drop over distance. Its ability to fire successive shots without breaking aim rewards steady, disciplined marksmanship.";
	
	global.ItemIndex[# Item.usp, ItemStat.Type] = "Weapon";
	WeaponStats(Item.usp, "USP", 1.75 * game_get_speed(gamespeed_fps), 580, 35, 350, 15, WEAPON_TYPE.SECONDARY, 3, 8, snd_usp, 2, 1, false,
	9, 12, 1, 1, .175, 5.5, 1, .0057, 0, 13, .93, 0, WEAPON_CLASS.PISTOL, .97, .44, .0002, 0.15 * game_get_speed(gamespeed_fps), .87, 35, .75, 8, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# Item.usp, ItemStat.KBStabilization] = 10;
	global.ItemIndex[# Item.usp, ItemStat.difficulty] = 4;
	global.ItemIndex[# Item.usp, ItemStat.disadvantages] = "-Low penetration power";
	global.ItemIndex[# Item.usp, ItemStat.advantages] = "+Great mobility\n+High magazine capacity";
	global.ItemIndex[# Item.usp, ItemStat.preattached] = { suppressor: Item.advanced_suppressor };
	global.ItemIndex[# Item.usp, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.usp, ItemStat.AmmoSpriteID] = 10;
	global.ItemIndex[# Item.usp, ItemStat.Description] = "Is a precision weapon, excelling in accuracy with its first shot and boasting considerable damage, yet its lackluster armor penetration. Enhanced with a preattached silencer, offering skilled players a tactical advantage despite its limitations against heavily protected foes.";
	
	global.ItemIndex[# Item.p250, ItemStat.Type] = "Weapon";
	WeaponStats(Item.p250, "P250", 1.75 * game_get_speed(gamespeed_fps), 600, 33, 105, 15, WEAPON_TYPE.SECONDARY, 4, 7, snd_p250, 2, 1, false,
	15, 15, 1, 4, .5, 3.75, 2, .0075, 0, 5.9, .99, 0, WEAPON_CLASS.PISTOL, .93, .5, .00029, round(.23 * game_get_speed(gamespeed_fps)), .95, 40, 1, 7, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# Item.p250, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.p250, ItemStat.disadvantages] = "-Low penetration power";
	global.ItemIndex[# Item.p250, ItemStat.advantages] = "+Great mobility\n+First shot accuracy";
	global.ItemIndex[# Item.p250, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.p250, ItemStat.AmmoSpriteID] = 12;
	global.ItemIndex[# Item.p250, ItemStat.Description] = "With sharp first-shot accuracy, the P250 is ideal for quick surprises on a budget. Despite its recoil, skilled hands can make it work. While it lacks armor penetration, its tactical edge remains in sudden encounters.";
	
	global.ItemIndex[# Item.tec9, ItemStat.Type] = "Weapon";
	WeaponStats(Item.tec9, "TEC-9", 1.9 * game_get_speed(gamespeed_fps), 615, 27, 180, 18, WEAPON_TYPE.SECONDARY, 5, 7, snd_Tec9, 2, 1.1, false,
	7, 12, 1, 3, .025, 2.5, 3, .00725, 2, 10, .95, 0, WEAPON_CLASS.PISTOL, .975, .71, .00037, round(.37 * game_get_speed(gamespeed_fps)), .98, 70, 1, 7, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# Item.tec9, ItemStat.difficulty] = 2;
	global.ItemIndex[# Item.tec9, ItemStat.disadvantages] = "-Low damage\n-Slow equip";
	global.ItemIndex[# Item.tec9, ItemStat.advantages] = "+Great mobility\n+Good penetration power";
	global.ItemIndex[# Item.tec9, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.tec9, ItemStat.AmmoSpriteID] = 15;
	global.ItemIndex[# Item.tec9, ItemStat.Description] = "Fast and unforgiving, the TEC-9 thrives in constant motion. Its mobility and accuracy while moving make it a dangerous tool. With higher penetration than most pistols, it rewards bold plays and relentless pressure. The TEC-9 turns reckless rushes into calculated strikes.";

	global.ItemIndex[# Item.CZ75, ItemStat.Type] = "Weapon";
	WeaponStats(Item.CZ75, "CZ-75", 2 * game_get_speed(gamespeed_fps), 585, 23, 96, 15, WEAPON_TYPE.SECONDARY, 2, 5, snd_CZ75, 1, 1, true,
	5, 10, 3, 4, .0125, 5, 2, .00925, 2, 12, .75, 0, WEAPON_CLASS.PISTOL, .875, .67, .00042, round(.5 * game_get_speed(gamespeed_fps)), .75, 75, 1.25, 12, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# Item.CZ75, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.CZ75, ItemStat.disadvantages] = "-Low damage\n-Slow equip\n-Worse range accuracy";
	global.ItemIndex[# Item.CZ75, ItemStat.advantages] = "+Automatic pistol\n+Accurate recoil\n+High kill reward";
	global.ItemIndex[# Item.CZ75, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.CZ75, ItemStat.AmmoSpriteID] = 18;
	global.ItemIndex[# Item.CZ75, ItemStat.Description] = "";
	
	global.ItemIndex[# Item.HELandMine, ItemStat.Type] = "Landmine";
	global.ItemIndex[# Item.HELandMine, ItemStat.Name] = "HE landmine";
	global.ItemIndex[# Item.HELandMine, ItemStat.Cost] = 100;
	global.ItemIndex[# Item.HELandMine, ItemStat.BulletCasingID] = 0;
	global.ItemIndex[# Item.HELandMine, ItemStat.Damage] = 98;
	global.ItemIndex[# Item.HELandMine, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[# Item.HELandMine, ItemStat.DamageDrop] = .005;
	global.ItemIndex[# Item.HELandMine, ItemStat.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[# Item.HELandMine, ItemStat.ItemColor] = c_red;
	global.ItemIndex[# Item.HELandMine, ItemStat.Description] = "The High-explosive landmine delivers devastating force, ideal for ambush tactics and area denial.";
	
	global.ItemIndex[# Item.CELandMine, ItemStat.Type] = "Landmine";
	global.ItemIndex[# Item.CELandMine, ItemStat.Name] = "Cluster-explosion landmine";
	global.ItemIndex[# Item.CELandMine, ItemStat.Cost] = 100;
	global.ItemIndex[# Item.CELandMine, ItemStat.BulletCasingID] = 4;
	global.ItemIndex[# Item.CELandMine, ItemStat.Damage] = 75;
	global.ItemIndex[# Item.CELandMine, ItemStat.PenetrationPower] = .99;
	global.ItemIndex[# Item.CELandMine, ItemStat.DamageDrop] = .01;
	global.ItemIndex[# Item.CELandMine, ItemStat.AmmoSpriteID] = 10; ///Shrapnel number
	global.ItemIndex[# Item.CELandMine, ItemStat.ItemColor] = c_aqua;
	global.ItemIndex[# Item.CELandMine, ItemStat.Description] = "The Cluster-explosion landmine disperses explosives projectiles upon detonation, creating deadly shrapnel to eliminate nearby threats.";
	
	global.ItemIndex[# Item.LELandMine, ItemStat.Type] = "Landmine";
	global.ItemIndex[# Item.LELandMine, ItemStat.Name] = "Low-explosive landmine";
	global.ItemIndex[# Item.LELandMine, ItemStat.Cost] = 50;
	global.ItemIndex[# Item.LELandMine, ItemStat.BulletCasingID] = 8;
	global.ItemIndex[# Item.LELandMine, ItemStat.Damage] = 46;
	global.ItemIndex[# Item.LELandMine, ItemStat.PenetrationPower] = .95;
	global.ItemIndex[# Item.LELandMine, ItemStat.DamageDrop] = .005;
	global.ItemIndex[# Item.LELandMine, ItemStat.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[# Item.LELandMine, ItemStat.ItemColor] = c_yellow;
	global.ItemIndex[# Item.LELandMine, ItemStat.Description] = "The Low-explosive landmine, while inflicting less damage than High-explosive variant, features shrapnels with superior armor penetration.";
	
	global.ItemIndex[# Item.StickyGrenade, ItemStat.Type] = "Grenade";
	global.ItemIndex[# Item.StickyGrenade, ItemStat.Name] = "Sticky grenade";
	global.ItemIndex[# Item.StickyGrenade, ItemStat.Cost] = 50;
	global.ItemIndex[# Item.StickyGrenade, ItemStat.ReloadSpeed] = 5;
	global.ItemIndex[# Item.StickyGrenade, ItemStat.Damage] = 49;
	global.ItemIndex[# Item.StickyGrenade, ItemStat.PenetrationPower] = .89;
	global.ItemIndex[# Item.StickyGrenade, ItemStat.DamageDrop] = .005;
	global.ItemIndex[# Item.StickyGrenade, ItemStat.BulletCasingID] = 3;
	global.ItemIndex[# Item.StickyGrenade, ItemStat.ItemColor] = make_color_rgb(158, 154, 117);
	global.ItemIndex[# Item.StickyGrenade, ItemStat.Description] = "The sticky grenade has moderate damage but a unique ability to adhere to targets upon impact. While its explosive power maybe be less dangerous, its ability to immobilize adversaries offers strategic oppurtunities for skilled players to neutralize threats with precision.";
	
	global.ItemIndex[# Item.red_dot_scope, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.red_dot_scope, ItemStat.Name] = "Red dot sight";
	global.ItemIndex[# Item.red_dot_scope, ItemStat.slot] = Index.slot_scope;
	global.ItemIndex[# Item.red_dot_scope, ItemStat.ItemColor] = c_red;
	global.ItemIndex[# Item.red_dot_scope, ItemStat.Description] = "The red dot sight offers improved aiming, but is lacking magnification.";

	global.ItemIndex[# Item.two_scope, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.two_scope, ItemStat.Name] = "Sniper scope";
	global.ItemIndex[# Item.two_scope, ItemStat.slot] = Index.slot_scope;
	global.ItemIndex[# Item.two_scope, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.two_scope, ItemStat.Description] = "This item provides double magnification for a high-range engagements.";
	
	global.ItemIndex[# Item.adaptive_chambering, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.adaptive_chambering, ItemStat.Name] = "Adaptive chambering";
	global.ItemIndex[# Item.adaptive_chambering, ItemStat.slot] = Index.slot_barrel;
	global.ItemIndex[# Item.adaptive_chambering, ItemStat.ShootTimer] = .75;
	global.ItemIndex[# Item.adaptive_chambering, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.adaptive_chambering, ItemStat.Description] = "This item enhances a weapons fire rate when attached, improving its overall combat efficiency.";
	
	global.ItemIndex[# Item.vertical_grip, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.vertical_grip, ItemStat.Name] = "Vertical grip";
	global.ItemIndex[# Item.vertical_grip, ItemStat.slot] = Index.slot_grip;
	global.ItemIndex[# Item.vertical_grip, ItemStat.KickBackPower] = 1;
	global.ItemIndex[# Item.vertical_grip, ItemStat.KickBackInaccuracyMultiplier] = .75;
	global.ItemIndex[# Item.vertical_grip, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.vertical_grip, ItemStat.Description] = "The vertical grip improves weapon vertical recoil control, ideal for players who prefer spraying over burst fire tactics.";
	
	global.ItemIndex[# Item.horizontal_grip, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.horizontal_grip, ItemStat.Name] = "Horizontal grip";
	global.ItemIndex[# Item.horizontal_grip, ItemStat.Description] = "Reduces horizontal recoil when shooting with firearms.";
	global.ItemIndex[# Item.horizontal_grip, ItemStat.KickBackInaccuracyMultiplier] = 1;
	global.ItemIndex[# Item.horizontal_grip, ItemStat.slot] = Index.slot_grip;
	global.ItemIndex[# Item.horizontal_grip, ItemStat.KickBackPower] = .75;
	global.ItemIndex[# Item.horizontal_grip, ItemStat.ItemColor] = c_gray;
	global.ItemIndex[# Item.horizontal_grip, ItemStat.Description] = "The horizontal grip improves weapon horizontal recoil control, ideal for players who prefer spraying over burst fire tactics.";
	
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.Name] = "Military suppressor";
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.slot] = Index.slot_suppressor;
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.Description] = "A muzzle device functions to dampen the noise generated upon firing a firearm, thus diminishing the sound level produced by the discharge.";
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.Defense] = .75; ///Damage reduction multiplier
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.KickBackPower] = .75; ///Inaccuracy multiplier
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.KickBackInaccuracyMultiplier] = .1; ///Noise reduction multiplier
	global.ItemIndex[# Item.advanced_suppressor, ItemStat.ItemColor] = c_gray;
	
	///Reprezentace exploze jako itemu kvůli jeho statistikám
	global.ItemIndex[# Item.base_explosion, ItemStat.Name] = "Explosion";
	global.ItemIndex[# Item.base_explosion, ItemStat.Damage] = 95;
	global.ItemIndex[# Item.base_explosion, ItemStat.PenetrationPower] = .5;
	global.ItemIndex[# Item.base_explosion, ItemStat.DamageDrop] = .001;
	
	///Reprezentace nukleární exploze jako itemu kvůli jeho statistikám
	global.ItemIndex[# Item.nuclear_explosion, ItemStat.Name] = "Nuclear explosion";
	global.ItemIndex[# Item.nuclear_explosion, ItemStat.Damage] = 152;
	global.ItemIndex[# Item.nuclear_explosion, ItemStat.PenetrationPower] = .9;
	global.ItemIndex[# Item.nuclear_explosion, ItemStat.DamageDrop] = .001;
		
	///Reprezentace základní machine gun
	global.ItemIndex[# Item.basic_machine_gun, ItemStat.Type] = "Weapon";
	WeaponStats(Item.basic_machine_gun, "Basic machine gun", 3 * game_get_speed(gamespeed_fps), 600, 33, 500, 50, WEAPON_TYPE.PRIMARY, 10, 7, snd_machine_gun, 10, 2, false,
	0, 0, 10, 30, .05, 1, 1, .0025, 0, 0, 1, 1, WEAPON_CLASS.MACHINE_GUN, .95, .775, .001, 1.75 * game_get_speed(gamespeed_fps), 1, 0, 1, 4, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# Item.basic_machine_gun, ItemStat.ItemColor] = c_ltgray;
	global.ItemIndex[# Item.basic_machine_gun, ItemStat.AmmoSpriteID] = 11;	
	
	global.ItemIndex[# Item.famas, ItemStat.Type] = "Weapon";
	WeaponStats(Item.famas, "FAMAS", round(1.89 * game_get_speed(gamespeed_fps)), 680, 30, 250, 25, WEAPON_TYPE.PRIMARY, 5, 7, snd_Famas, 2, 1, true,
	5, 10, 10, 4, .03, 7, 3.5, .00175, -1, 9, .75, 0, WEAPON_CLASS.ASSAULT_RIFLE, .83, .69, .00035, .25 * game_get_speed(gamespeed_fps), .75, 200, 1, 8, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# Item.famas, ItemStat.difficulty] = 3;
	global.ItemIndex[# Item.famas, ItemStat.disadvantages] = "-Low magazine capacity\n-Low penetration power\n-High damage drop-off";
	global.ItemIndex[# Item.famas, ItemStat.advantages] = "+Low bullet spread\n+Low vertical recoil";
	global.ItemIndex[# Item.famas, ItemStat.ItemColor] = c_dkgray;
	global.ItemIndex[# Item.famas, ItemStat.AmmoSpriteID] = 14;
	global.ItemIndex[# Item.famas, ItemStat.Description] = "FAMAS is a reliable weapon with low recoil and high accuracy. Despite its 25-round magazine, poor armor penetration, and high damage drop-off, mastering it unleashes devastating close to mid-range power, swiftly eliminating targets with precision.";
	
	global.ItemIndex[# Item.galil, ItemStat.Type] = "Weapon";
	WeaponStats(Item.galil, "Galil", 1.75 * game_get_speed(gamespeed_fps), 700, 36, 270, 30, WEAPON_TYPE.PRIMARY, 10, 6, snd_galil, 5, 2, true,
	8, 20, 12, 5.9, .02, 10, 3.5, .002, 1, 7, .59, 1, WEAPON_CLASS.ASSAULT_RIFLE, .89, .71, .0003, .25 * game_get_speed(gamespeed_fps), .85, 180, 1, 8, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# Item.galil, ItemStat.difficulty] = 4;
	global.ItemIndex[# Item.galil, ItemStat.disadvantages] = "-High bullet spread\n-High horizontal recoil\n-Low penetration power";
	global.ItemIndex[# Item.galil, ItemStat.advantages] = "+Fast equipping\n+Fast reloading\n+Low price";
	global.ItemIndex[# Item.galil, ItemStat.ItemColor] = c_ltgray;
	global.ItemIndex[# Item.galil, ItemStat.AmmoSpriteID] = 11;
	global.ItemIndex[# Item.galil, ItemStat.Description] = "Galil is a fierce contender known for its unruly recoil and limited armor penetration. Despite its challenges, mastering this weapon unlocks a devastating force on the battlefield, swiftly eliminating targets with precision and agility.";

	global.ItemIndex[# Item.steel_knife, ItemStat.Type] = "Weapon";
	WeaponStats(Item.steel_knife, "Steel knife", .5 * game_get_speed(gamespeed_fps), 48, 27,-1, -1, WEAPON_TYPE.TERTIARY, 0, 10, snd_knife, 5, 2, false,
	0, 0, 0, 0, 10, 0, 0, 10, 0, 0, 0, 0, WEAPON_CLASS.KNIFE, .97, 1, 0, .25 * game_get_speed(gamespeed_fps), 0, 0, 1, 15, false, "", 0);
	global.ItemIndex[# Item.steel_knife, ItemStat.disadvantages] = "";
	global.ItemIndex[# Item.steel_knife, ItemStat.advantages] = "";
	global.ItemIndex[# Item.steel_knife, ItemStat.ItemColor] = c_ltgray;
	global.ItemIndex[# Item.steel_knife, ItemStat.Description] = "";
	
	global.ItemIndex[# Item.low_cal_box, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.low_cal_box, ItemStat.Name] = "Low caliber ammunition box";
	global.ItemIndex[# Item.low_cal_box, ItemStat.Description] = "";
	global.ItemIndex[# Item.low_cal_box, ItemStat.MaxAmmo] = 100;
	global.ItemIndex[# Item.low_cal_box, ItemStat.ItemColor] = c_aqua;
	
	global.ItemIndex[# Item.med_cal_box, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.med_cal_box, ItemStat.Name] = "Medium caliber ammunition box";
	global.ItemIndex[# Item.med_cal_box, ItemStat.Description] = "";
	global.ItemIndex[# Item.med_cal_box, ItemStat.MaxAmmo] = 75;
	global.ItemIndex[# Item.med_cal_box, ItemStat.ItemColor] = c_green;
	
	global.ItemIndex[# Item.high_cal_box, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.high_cal_box, ItemStat.Name] = "High caliber ammunition box";
	global.ItemIndex[# Item.high_cal_box, ItemStat.Description] = "";
	global.ItemIndex[# Item.high_cal_box, ItemStat.MaxAmmo] = 25;
	global.ItemIndex[# Item.high_cal_box, ItemStat.ItemColor] = c_gray;
	
	global.ItemIndex[# Item.gauge_box, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.gauge_box, ItemStat.Name] = "Gauge ammunition box";
	global.ItemIndex[# Item.gauge_box, ItemStat.Description] = "";
	global.ItemIndex[# Item.gauge_box, ItemStat.MaxAmmo] = 50;
	global.ItemIndex[# Item.gauge_box, ItemStat.ItemColor] = c_lime;
	
	global.ItemIndex[# Item.range_finder, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.range_finder, ItemStat.Name] = "Range indicator";
	global.ItemIndex[# Item.range_finder, ItemStat.slot] = Index.slot_barrel;
	global.ItemIndex[# Item.range_finder, ItemStat.Description] = "A barrel attachment designed to display a visual indication of a firearm’s effective range based on crosshair alignment, assisting the user in judging distance and projectile reach during combat.";
	global.ItemIndex[# Item.range_finder, ItemStat.ItemColor] = c_gray;
	
	global.ItemIndex[# Item.dilatation_pill, ItemStat.Type] = "Item";
	global.ItemIndex[# Item.dilatation_pill, ItemStat.Name] = "Dilatation pill";
	global.ItemIndex[# Item.dilatation_pill, ItemStat.Description] = "";
	global.ItemIndex[# Item.dilatation_pill, ItemStat.MaxAmmo] = 25;
	global.ItemIndex[# Item.dilatation_pill, ItemStat.ItemColor] = c_gray;
	
	for (var i = 0; i < Item.Total; i++) {
	    if (global.ItemIndex[# i, ItemStat.Type] == "Weapon") {
	        global.ItemIndex[# i, ItemStat.BaseMaxAmmo] = global.ItemIndex[# i, ItemStat.MaxAmmo];
	        global.ItemIndex[# i, ItemStat.BaseReloadSpeed] = global.ItemIndex[# i, ItemStat.ReloadSpeed];
	        global.ItemIndex[# i, ItemStat.BaseEquipTime]  = global.ItemIndex[# i, ItemStat.EquipTime];
	        global.ItemIndex[# i, ItemStat.BaseMovingSpdMul]   = global.ItemIndex[# i, ItemStat.MovingSpdMul];
	        global.ItemIndex[# i, ItemStat.BasePenetrationPower] = global.ItemIndex[# i, ItemStat.PenetrationPower];
	        global.ItemIndex[# i, ItemStat.BaseDamage] = global.ItemIndex[# i, ItemStat.Damage];
	    }
	}
	
	global.built_upgrades = {};

	// Projdeme celý ItemIndex a pro každou zbraň vytvoříme záznam
	for (var i = 0; i < Item.Total; i++) {
	    if (global.ItemIndex[# i, ItemStat.Type] == "Weapon") { 
	        global.built_upgrades[$ string(i)] = {
	            ammo: false,
	            reload: false,
				equip: false,
				movement: false,
	            penetration: false,
				damage: false
	        };
	    }
	}
}