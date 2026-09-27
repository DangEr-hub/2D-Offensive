// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function curve_explinlog(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power, log_power){
    var t = clamp(dist / range, 0, 1); /// normalization between 0 and 1
    // Exp  part
    if(t <= boundary_1){var p = t / boundary_1;return lerp(1.0, start_val, power(p, exp_power));}
    // Lin part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1);return lerp(start_val, mid_val, p);}
    /// Log part
    var p = (t - boundary_2) / (1 - boundary_2); p = ln(1 + log_power * p) / ln(1 + log_power);
    return lerp(mid_val, last_val, p);
}

function curve_loglinexp(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power, log_power){
    var t = clamp(dist / range, 0, 1);
    // Log part
    if(t <= boundary_1){var p = t / boundary_1; p = ln(1 + log_power * p) / ln(1 + log_power); return lerp(1.0, start_val, p);}
    // Lin part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); return lerp(start_val, mid_val, p);}
    // Exp part
    var p = (t - boundary_2) / (1 - boundary_2);
    return lerp(mid_val, last_val, power(p, exp_power));
}
function curve_logexpexp(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power, log_power){
    var t = clamp(dist / range, 0, 1);
    // Log part
    if(t <= boundary_1){var p = t / boundary_1; p = ln(1 + log_power * p) / ln(1 + log_power); return lerp(1.0, start_val, p);}
    // Exp part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); return lerp(start_val, mid_val, power(p, exp_power));}
    // Exp part
    var p = (t - boundary_2) / (1 - boundary_2);
    return lerp(mid_val, last_val, power(p, exp_power));
}

function curve_explinexp(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power){
    var t = clamp(dist / range, 0, 1);
    // Exp part
    if(t <= boundary_1){var p = t / boundary_1; return lerp(1.0, start_val, power(p, exp_power));}
    // Lin part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); return lerp(start_val, mid_val, p);}
    // Exp part
    var p = (t - boundary_2) / (1 - boundary_2);
    return lerp(mid_val, last_val, power(p, exp_power));
}
function curve_explinlin(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power){
    var t = clamp(dist / range, 0, 1);
    // Exp part
    if(t <= boundary_1){var p = t / boundary_1; return lerp(1.0, start_val, power(p, exp_power));}
    // Lin part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); return lerp(start_val, mid_val, p);}
    // Lin part
    var p = (t - boundary_2) / (1 - boundary_2);
    return lerp(mid_val, last_val, p);
}

function curve_loglinlog(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, log_power){
    var t = clamp(dist / range, 0, 1);
    // Log part
    if(t <= boundary_1){var p = t / boundary_1; p = ln(1 + log_power * p) / ln(1 + log_power); return lerp(1.0, start_val, p);}
    // Lin part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); return lerp(start_val, mid_val, p);}
    // Log part
    var p = (t - boundary_2) / (1 - boundary_2); p = ln(1 + log_power * p) / ln(1 + log_power);
    return lerp(mid_val, last_val, p);
}
function curve_expexplog(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power, log_power){
    var t = clamp(dist / range, 0, 1);
    // Exp part
    if(t <= boundary_1){var p = t / boundary_1; return lerp(1.0, start_val, power(p, exp_power));}
    // Exp part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); return lerp(start_val, mid_val, power(p, exp_power));}
    // Log part
    var p = (t - boundary_2) / (1 - boundary_2); p = ln(1 + log_power * p) / ln(1 + log_power);
    return lerp(mid_val, last_val, p);
}
function curve_loglogexp(dist, range, boundary_1, boundary_2, start_val, mid_val, last_val, exp_power, log_power){
    var t = clamp(dist / range, 0, 1);
    // Log part
    if(t <= boundary_1){var p = t / boundary_1; p = ln(1 + log_power * p) / ln(1 + log_power); return lerp(1.0, start_val, p);}
    // Log part
    if(t <= boundary_2){var p = (t - boundary_1) / (boundary_2 - boundary_1); p = ln(1 + log_power * p) / ln(1 + log_power); return lerp(start_val, mid_val, p);}
    // Exp part
    var p = (t - boundary_2) / (1 - boundary_2);
    return lerp(mid_val, last_val, power(p, exp_power));
}
function curve_lin(dist, range, boundary_1, boundary_2, last_val){
    return lerp(1.0, last_val, clamp(dist / range, 0, 1));
}


function add_shooting_modes(weapon, modes) {
	var shootingModesList = ds_list_create();
    
	for (var i = 0; i < array_length(modes);i++) {
		ds_list_add(shootingModesList, modes[i]);
	}

	global.ItemIndex[#weapon, ITEMSTATS.ShootingMode] = shootingModesList;
}

function get_shooting_modes_string(weapon) {
    var shootingModesListID = global.ItemIndex[#weapon, ITEMSTATS.ShootingMode];
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
        var weapon_id = ITEM.None;
        var slot_empty = false;
        var slot_enum = 0;

        if(is_bot){
            weapon_id = WeaponID[which_slot];
            slot_empty = (attachments[which_slot][AttachmentPosition] == ITEM.None);
            slot_enum = AttachmentPosition;
        }else{
            weapon_id = global.Inventory[# WeaponID, INDEX.slot_id];
            slot_empty = (global.Inventory[# WeaponID, AttachmentPosition] == ITEM.None);
            slot_enum = AttachmentPosition - INDEX.slot_scope + ATTACHMENTS.scope;
        }

        if(weapon_id == ITEM.None || !slot_empty){
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
            weapon_network_propagate();
        }
    }
}


function weapon_can_equip_attachment(weapon_id, attachment_slot){
    var allowed = global.ItemIndex[# weapon_id, ITEMSTATS.attachments];
    return array_contains(allowed, attachment_slot);
}



function ItemDataBase(){
	///Define shooting modes for every weapon
	add_shooting_modes(ITEM.Spas, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.AKM, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(ITEM.g36c, ["Auto", "Safety"]);
	add_shooting_modes(ITEM.Scar, ["Auto", "Semi", "Safety"]);
	add_shooting_modes(ITEM.DesertEagle, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.SG550, ["Auto", "Safety"]);
	add_shooting_modes(ITEM.SSG08, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.Javelin, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.MAC11, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(ITEM.Glock, ["Semi", "Burst", "Safety"]);
	add_shooting_modes(ITEM.m4a1, ["Auto", "Safety"]);
	add_shooting_modes(ITEM.awm, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.usp, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.basic_machine_gun, ["Auto", "Semi", "Burst", "Safety"]);
	add_shooting_modes(ITEM.famas, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(ITEM.galil, ["Auto", "Safety"]);
	add_shooting_modes(ITEM.p250, ["Semi", "Safety"]);;
	add_shooting_modes(ITEM.MK18, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(ITEM.steel_knife, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.tec9, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.Dragunov, ["Semi", "Safety"]);
	add_shooting_modes(ITEM.MP9, ["Auto", "Safety"]);
	add_shooting_modes(ITEM.CZ75, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(ITEM.MP7, ["Auto", "Burst", "Safety"]);
	add_shooting_modes(ITEM.P90, ["Auto", "Safety"]);
	add_shooting_modes(ITEM.m200, ["Semi", "Safety"]);

	// assault rifles + snipers
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.attachments]  = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.galil, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.famas, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.awm, ITEMSTATS.attachments]   = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.m200, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip];
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip];
	// smg
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.attachments] = [ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.attachments] = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.attachments] = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.P90, ITEMSTATS.attachments] = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	// pistole
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.attachments] = [ATTACHMENTS.barrel];
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.attachments]       = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.usp, ITEMSTATS.attachments]         = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.p250, ITEMSTATS.attachments]        = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.attachments]        = [ATTACHMENTS.barrel, ATTACHMENTS.grip, ATTACHMENTS.suppressor];
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.attachments]        = [ATTACHMENTS.barrel, ATTACHMENTS.suppressor];
	// brokovnice
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.attachments] = [ATTACHMENTS.barrel, ATTACHMENTS.grip];
	// ostatní
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.attachments] = [ATTACHMENTS.scope, ATTACHMENTS.barrel, ATTACHMENTS.grip];

	
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.attach_sockets] = { scope: [-3, -14], barrel: [14, -7], grip: [14, 4], suppressor: [47, -5] };
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.attach_sockets] = { scope: [-5, -14], barrel: [16, -7], grip: [16, 4], suppressor: [47, -5] };
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.attach_sockets] = { scope: [-21, -11], barrel: [10, -5], grip: [-3, 5], suppressor: [42, -6] };
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.attach_sockets] = { scope: [-7, -14], barrel: [14, -7], grip: [16, 2], suppressor: [32, -6] };
	global.ItemIndex[# ITEM.awm, ITEMSTATS.attach_sockets] = { scope: [-17, -10], barrel: [3, -3], grip: [1, 7], suppressor: [47, -5] };
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.attach_sockets] = { scope: [-17, -7], barrel: [3, -3], grip: [1, 7], suppressor: [50, 0] };
	global.ItemIndex[# ITEM.famas, ITEMSTATS.attach_sockets] = { scope: [0, -14], barrel: [10, -2], grip: [12, 7], suppressor: [34, -1] };
	global.ItemIndex[# ITEM.galil, ITEMSTATS.attach_sockets] = { scope: [-7, -14], barrel: [14, -6], grip: [14, 2], suppressor: [47, -7] };
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.attach_sockets] = { scope: [0, -14], barrel: [20, -8], grip: [20, 2], suppressor: [37, -8] };
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.attach_sockets] = { scope: [-3, -9], barrel: [14, -4], grip: [14, 4], suppressor: [40, -4] };
	global.ItemIndex[# ITEM.m200, ITEMSTATS.attach_sockets] = { scope: [-17, -7], barrel: [3, -1], grip: [1, 7]};
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.attach_sockets] = { scope: [-5, -18], barrel: [20, -4], grip: [20, 7], suppressor: [50, -4] };

	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.attach_sockets] = { barrel: [14, -8]};
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.attach_sockets] = { barrel: [8, -5], suppressor: [22, -5] };
	global.ItemIndex[# ITEM.usp, ITEMSTATS.attach_sockets] = { barrel: [8, -5], suppressor: [20, -5] };
	global.ItemIndex[# ITEM.p250, ITEMSTATS.attach_sockets] = { barrel: [12, -7], suppressor: [28, -6] };
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.attach_sockets] = { barrel: [13, -11], grip: [14, -2], suppressor: [28, -12] };
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.attach_sockets] = { barrel: [13, -11], grip: [14, -2], suppressor: [28, -12] };

	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.attach_sockets] = { barrel: [10, -8], grip: [10, 1], suppressor: [30, -11] };
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.attach_sockets] = { barrel: [15, -11], suppressor: [38, -10.5] };
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.attach_sockets] = { barrel: [15, -10], suppressor: [38, -9.5] };
	global.ItemIndex[# ITEM.P90, ITEMSTATS.attach_sockets] = { barrel: [20, 0], suppressor: [38, -2] };

	global.ItemIndex[# ITEM.Spas, ITEMSTATS.attach_sockets] = { barrel: [23, -2], grip: [24, 12] };
	
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.attach_sockets] = { scope: [8, -14], barrel: [20, -7], grip: [22, 10]};
	
	global.ItemIndex[# ITEM.steel_knife, ITEMSTATS.attach_sockets] = {};
	global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.attach_sockets] = {};
	
	///Define stats for ITEM.None because multiplying by zero
	global.ItemIndex[# ITEM.None, ITEMSTATS.Defense] = 1;
	global.ItemIndex[# ITEM.None, ITEMSTATS.ShootTimer] = 1;	
	global.ItemIndex[# ITEM.None, ITEMSTATS.KickBackInaccuracyMultiplier] = 1;	
	global.ItemIndex[# ITEM.None, ITEMSTATS.KickBackPower] = 1;	
	
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.AKM, "AKM", 2 * game_get_speed(gamespeed_fps), 775, 35, 270, 30, WEAPON_TYPE.PRIMARY, 7, 6, snd_AKM, 5, 1.25, true,
	10, 20, 10, 5.9, .015, 10, 3.5, 1, 7, .45, 1, WEAPON_CLASS.ASSAULT_RIFLE, .81, .795, .55 * game_get_speed(gamespeed_fps), .85, 270, 1, 5, true, "7.62x39 mm", CALIBER.HIGH);
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.difficulty] = 4;
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.disadvantages] = "-High bullet spread\n-High recoil";
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.advantages] = "+High damage\n+High range\n+Fast equipping";
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.ItemColor] = c_orange;
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.AmmoSpriteID] = 0;
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.Rarity] = RARITY.LEGENDARY;
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.AKM, ITEMSTATS.Range],
		    0.35, 0.57,
		    0.94, 0.92,
		    0.89, 5.0
		);
	}
	global.ItemIndex[# ITEM.AKM, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.AKM, ITEMSTATS.Range],
		    0.15, 0.3, 
			0.72, 0.52, 0.35,   // 0.35 - 165% spread na max range
		    2.0, 4.0
		);
	}
	
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.g36c, "G36C", 2.5 * game_get_speed(gamespeed_fps), 825, 31, 190, 38, WEAPON_TYPE.PRIMARY, 5, 8, snd_g36c, 5.75, 1.75, true,
	10, 22, 3, 9, .05, 15, 4, -3, 14, .4, 1, WEAPON_CLASS.ASSAULT_RIFLE, .7, .89, .85 * game_get_speed(gamespeed_fps), .5, 300, 1, 5, true, "5.56x45 mm", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.difficulty] = 4;
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.disadvantages] = "-High kickback spread\n-High recoil\n-Long reloading";
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.advantages] = "+High range\n+High penetration power\n+Low damage drop-off";
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.ItemColor] = c_dkgray;
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.AmmoSpriteID] = 23;
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.Rarity] = RARITY.RARE;
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.g36c, ITEMSTATS.Range],
		    0.45, 0.7,
		    0.97, 0.95,
		    0.93, 5.0
		);
	}
	global.ItemIndex[# ITEM.g36c, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.g36c, ITEMSTATS.Range],
		    0.4, 0.8, 
			0.88, 0.7, 0.55,   // 0.55 - 145% spread na max range
		    2.0, 4.0
		);
	}
	
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.Scar, "SCAR-L", 2.25 * game_get_speed(gamespeed_fps), 800, 30, 200, 50, WEAPON_TYPE.PRIMARY, 6, 7, snd_Scar, 2, 1, true,
	15, 30, 11, 7, .005, 10, 2, -4, 5, .2, 0, WEAPON_CLASS.ASSAULT_RIFLE, .73, .74, .75 * game_get_speed(gamespeed_fps), .5, 310, .5, 5, true, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.disadvantages] = "-Bad mobility\n-Low clip ammo\n-Low penetration power";
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.advantages] = "+Very low accuracy drop\n+Very low damage drop-off\n+High ammo capacity";
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.ItemColor] = c_yellow;
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.AmmoSpriteID] = 21;
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.Rarity] = RARITY.LEGENDARY;
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.Scar, ITEMSTATS.Range],
		    0.5, 0.75,
		    0.95, 0.93,
		    0.89, 4.0
		);
	}
	global.ItemIndex[# ITEM.Scar, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.Scar, ITEMSTATS.Range],
		    0.25, 0.55, 
			0.88, 0.7, 0.5,   // 150% spread na max range
		    3.0
		);
	}	

	
	global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.Type] = "Shield";
	WeaponStats(ITEM.spec_ops_shield, "Spec ops shield", 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, false,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, WEAPON_CLASS.SHIELD, .15, 0, 2.5 * game_get_speed(gamespeed_fps), 0, 175, 0, 0, false, "", 0);
	global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.BaseDurability] = 50;
	global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.Defense] = .05;
	global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.Weight] = 8;
	
	global.ItemIndex[# ITEM.military_shield, ITEMSTATS.Type] = "Shield";
	WeaponStats(ITEM.military_shield, "Military shield", 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, false,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, WEAPON_CLASS.SHIELD, .25, 0, 2 * game_get_speed(gamespeed_fps), 0, 125, 0, 0, false, "", 0);
	global.ItemIndex[# ITEM.military_shield, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.military_shield, ITEMSTATS.BaseDurability] = 90;
	global.ItemIndex[# ITEM.military_shield, ITEMSTATS.Defense] = .1;
	global.ItemIndex[# ITEM.military_shield, ITEMSTATS.Weight] = 5;


	global.ItemIndex[# ITEM.kevlar_shield, ITEMSTATS.Type] = "Shield";
	WeaponStats(ITEM.kevlar_shield, "Kevlar shield", 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, false,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, WEAPON_CLASS.SHIELD, .35, 0, 1.75 * game_get_speed(gamespeed_fps), 0, 100, 0, 0, false, "", 0);
	global.ItemIndex[# ITEM.kevlar_shield, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.kevlar_shield, ITEMSTATS.BaseDurability] = 100;
	global.ItemIndex[# ITEM.kevlar_shield, ITEMSTATS.Defense] = .15;
	global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.Weight] = 3;

	global.ItemIndex[# ITEM.KevlarHelm, ITEMSTATS.Type] = "Helmet";
	ArmourStats(ITEM.KevlarHelm, "Kevlar helmet", 3, .9, 25);
	global.ItemIndex[# ITEM.KevlarHelm, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.KevlarHelm, ITEMSTATS.BaseDurability] = 100;
	
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.DesertEagle, "Desert Eagle", 1.75 * game_get_speed(gamespeed_fps), 700, 51, 70, 7, WEAPON_TYPE.SECONDARY, 4, 11, snd_DesertEagle, 7, 2, false,
	0, 0, 10, 30, 1.5, 9, 7.5, 0, 0, .5, 1, WEAPON_CLASS.PISTOL, .9, .932, .1 * game_get_speed(gamespeed_fps), .77, 95, 2, 7, true, ".50 AE", CALIBER.HIGH);
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.random_bullet_spread] = true;
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.difficulty] = 5;
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.disadvantages] = "-High recoil\n-Low magazine capacity";
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.advantages] = "+High damage\n+High range\n+High penetration power";
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.ItemColor] = c_ltgray;
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.AmmoSpriteID] = 1;
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.Rarity] = RARITY.LEGENDARY;
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_expexplog(
		    dist,
		    global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.Range],
		    0.43, 0.63,
		    0.87, 0.81,
		    0.77, 3.0, 7.0
		);
	}
	global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.DesertEagle, ITEMSTATS.Range],
		    0.25, 0.7, 
			0.55, 0.1, -0.75,   // -0.75 - 275% spread na max range
		    3.0, 4.0
		);
	}

	global.ItemIndex[# ITEM.KevlarVest, ITEMSTATS.Type] = "Armour";
	ArmourStats(ITEM.KevlarVest, "Kevlar vest", 4, .925, 25);
	global.ItemIndex[# ITEM.KevlarVest, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.KevlarVest, ITEMSTATS.BaseDurability] = 100;
	
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.Spas, "Spas-12", .75 * game_get_speed(gamespeed_fps), 400, 29, 120, 12, WEAPON_TYPE.PRIMARY, 5, 30, snd_Spas, 15, 2, false,
	0, 0, 20, 10, 1.25, 2, 7.5, 0, 0, .25, 2, WEAPON_CLASS.SHOTGUN, .89, .575, .75 * game_get_speed(gamespeed_fps), .73, 140, 2, 10, false, "12 Gauge", CALIBER.GAUGES);
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.disadvantages] = "-Low penetration power\n-Low range";
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.advantages] = "+Great mobility\n+High damage";
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.AmmoSpriteID] = 5;
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.EnemyInaccuracyCompensation] = 1;
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.Bullets] = 5;
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.Rarity] = RARITY.UNCOMMON;
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.BaseDurability] = 1; //Fractionating reloading
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.Spas, ITEMSTATS.Range],
		    0.45, 0.7,
		    0.82, 0.74,
		    0.63, 7.0
		);
	}
	global.ItemIndex[# ITEM.Spas, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_logexpexp(
		    dist,
		    global.ItemIndex[# ITEM.Spas, ITEMSTATS.Range],
		    0.35, 0.69, 
			0.1, -1.2, -3.0,   // -3.0 - 500 % spread na max range
		    5.0, 3.25
		);
	}


	global.ItemIndex[# ITEM.MilitaryHelm, ITEMSTATS.Type] = "Helmet";
	ArmourStats(ITEM.MilitaryHelm, "Military helmet", 3, .875, 45);
	global.ItemIndex[# ITEM.MilitaryHelm, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.MilitaryHelm, ITEMSTATS.BaseDurability] = 90;
	
	global.ItemIndex[# ITEM.MilitaryVest, ITEMSTATS.Type] = "Armour";
	ArmourStats(ITEM.MilitaryVest, "Military vest", 7, .875, 45);
	global.ItemIndex[# ITEM.MilitaryVest, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.MilitaryVest, ITEMSTATS.BaseDurability] = 90; 
	
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.SSG08, "SSG 08", 2 * game_get_speed(gamespeed_fps), 800, 107, 50, 10, WEAPON_TYPE.PRIMARY, 2, 30, snd_SSG08, 15, 2, false,
	0, 0, 10, 20, 50, 10, 10, 0, 0, .9, 1, WEAPON_CLASS.SNIPER_RIFLE, .91, .85, 0.5 * game_get_speed(gamespeed_fps), .5, 170, 2, 7, false, ".338 LM", CALIBER.HIGH);
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.difficulty] = 5;
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.preattached] = { scope: ITEM.two_scope };
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.disadvantages] = "-Low penetration power\n-Limited view";
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.advantages] = "\n+High damage\n+High range";
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.AmmoSpriteID] = 2;
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.Rarity] = RARITY.UNCOMMON;
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.ScopeInaccuracyResetTimer] = 10;
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    global.ItemIndex[# ITEM.SSG08, ITEMSTATS.Range],
		    0.35, 0.57, 0.86
		);
	}
	global.ItemIndex[# ITEM.SSG08, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.SSG08, ITEMSTATS.Range],
		    0.5, 0.7, 
			0.95, 0.89, 0.8,   // 0.9 - 120% spread na max range
		    2.0, 5.0
		);
	}
	
	
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.MAC11, "MAC11", 1.5 * game_get_speed(gamespeed_fps), 550, 24, 300, 30, WEAPON_TYPE.PRIMARY, 5, 6, snd_MAC11, 2, 1, true,
	15, 20, -9, 9, 0.025, 1.5, 2, 1, 5, .9, 0, WEAPON_CLASS.SUBMACHINE_GUN, .9, .57, .1 * game_get_speed(gamespeed_fps), .89, 105, .5, 9, false, ".380 ACP", CALIBER.LOW);
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.disadvantages] = "-Low penetration power\n-High bullet spread\n-Low range";
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.advantages] = "+Great mobility\n+Fast equipping";
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.AmmoSpriteID] = 3;
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.EnemyInaccuracyCompensation] = 3;
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.MAC11, ITEMSTATS.Range],
		    0.25, 0.65,
		    0.84, 0.77,
		    0.63, 9.0, 4.0
		);
	}
	global.ItemIndex[# ITEM.MAC11, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.MAC11, ITEMSTATS.Range],
		    0.5, 0.7, 
			0.37, -0.83, -8.0,   // -8 - 1000% spread na max range
		    5.0, 4.0
		);
	}


	global.ItemIndex[# ITEM.MP9, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.MP9, "MP9", 1.25 * game_get_speed(gamespeed_fps), 640, 23, 280, 30, WEAPON_TYPE.PRIMARY, 5, 5.5, snd_MP9, 1.5, 0.8, true,
	8, 18, 14, 7, 0.02, 2, 1, 4, 7, .925, 0, WEAPON_CLASS.SUBMACHINE_GUN, .91, .7, 1 * game_get_speed(gamespeed_fps), .5, 155, 1, 9, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.disadvantages] = "-Slow equip\n-High recoil\n-High damage drop-off";
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.advantages] = "+Great penetration power\n+Great range for SMG\n+Great rate of fire";
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.AmmoSpriteID] = 17;
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.Rarity] = RARITY.UNCOMMON;
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.EnemyInaccuracyCompensation] = 1.5;
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.MP9, ITEMSTATS.Range],
		    0.38, 0.49,
		    0.95, 0.74,
		    0.59, 9.0, 2.0
		);
	}
	global.ItemIndex[# ITEM.MP9, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.MP9, ITEMSTATS.Range],
		    0.5, 0.7, 
			0.49, -1.53, -5.0,   // -5 - 700% spread na max range
		    5.0, 4.0
		);
	}	
	
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.MP7, "MP7", 1.45 * game_get_speed(gamespeed_fps), 590, 28, 390, 35, WEAPON_TYPE.PRIMARY, 3, 6, snd_mp7, 1.75, 0.9, true,
	18, 28, 8, 7, 0.125, 2.25, 1.25, -2, 5, .87, 0, WEAPON_CLASS.SUBMACHINE_GUN, .825, .63, 0.7 * game_get_speed(gamespeed_fps), .8, 135, 1, 9, false, "4.6x30 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.disadvantages] = "-Low penetration power\n-High kickback inaccuracy\n-High damage drop-off";
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.advantages] = "+High damage\n+Great accuracy";
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.AmmoSpriteID] = 19;
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.Rarity] = RARITY.COMMON;
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.EnemyInaccuracyCompensation] = 1.5;
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.MP7, ITEMSTATS.Range],
		    0.57, 0.7,
		    0.81, 0.54,
		    0.41, 9.0, 4.0
		);
	}
	global.ItemIndex[# ITEM.MP7, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.MP7, ITEMSTATS.Range],
		    0.4, 0.75, 
			0.67, -1.1, -2.8,   // -2.8 - 480% spread na max range
		    5.0, 4.0
		);
	}	
	
	global.ItemIndex[# ITEM.P90, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.P90, "P90", 1.95 * game_get_speed(gamespeed_fps), 600, 26, 550, 55, WEAPON_TYPE.PRIMARY, 5.5, 6, snd_p90, 2, 1, true,
	10, 30, 5, 4, 0.015, 1.7, 1.5, 8, 2, .8, 0, WEAPON_CLASS.SUBMACHINE_GUN, .795, .72, 1 * game_get_speed(gamespeed_fps), .5, 180, 1, 8, false, "5.7x28 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.P90, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.P90, ITEMSTATS.disadvantages] = "-High horizontal recoil\n-High range inaccuracy\n-Bad mobility for SMG";
	global.ItemIndex[# ITEM.P90, ITEMSTATS.advantages] = "+High ammo capacity\n+High penetration power";
	global.ItemIndex[# ITEM.P90, ITEMSTATS.ItemColor] = c_orange;
	global.ItemIndex[# ITEM.P90, ITEMSTATS.AmmoSpriteID] = 20;
	global.ItemIndex[# ITEM.P90, ITEMSTATS.Rarity] = RARITY.COMMON;
	global.ItemIndex[# ITEM.P90, ITEMSTATS.EnemyInaccuracyCompensation] = 1.5;
	global.ItemIndex[# ITEM.P90, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.P90, ITEMSTATS.Range],
		    0.35, 0.5,
		    0.83, 0.61,
		    0.55, 5.0, 4.0
		);
	}
	global.ItemIndex[# ITEM.P90, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.P90, ITEMSTATS.Range],
		    0.25, 0.5, 
			0.5, -1.45, -3.5,   // -3.5 - 550% spread na max range
		    5.0, 4.0
		);
	}	
	
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.Type] = "Grenade";
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.Name] = "HE grenade";
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.Cost] = 25;
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.ReloadSpeed] = 2.5;
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.Damage] = 98;
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.PenetrationPower] = .5;
	//global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.damage_drop] = .001;
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.BulletCasingID] = 0;
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.HEGrenade, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.95
		);
	}
	
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.Name] = "Bomb";
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.Cost] = 25;
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.Damage] = 196;
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.PenetrationPower] = .95;
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.BulletCasingID] = 0;
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.Bomb, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.95
		);
	}

	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.Type] = "Grenade";
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.Name] = "Molotov";
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.Cost] = 45;
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.ReloadSpeed] = 2.5;
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.Damage] = 18;
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.PenetrationPower] = .75;
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.BulletCasingID] = 4;
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.MolotovGrenade, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.95
		);
	}

	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.Type] = "Grenade";
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.Name] = "Flashbang";
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.Cost] = 25;
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.ReloadSpeed] = 2.5;
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.Damage] = 11;
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.PenetrationPower] = .5;
	//global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.damage_drop] = .001;
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.BulletCasingID] = 1;
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.ItemColor] = c_white;
	global.ItemIndex[# ITEM.FlashBangGrenade, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.95
		);
	}


	global.ItemIndex[# ITEM.SG550, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.SG550, "SIG SG550", 2.5 * game_get_speed(gamespeed_fps), 790, 37, 300, 30, WEAPON_TYPE.PRIMARY, 8, 7, snd_SG550, 2, 1.75, true,
	10, 17, -7, 7, 0.01, 9, 3.5, 3, 8, .15, 1, WEAPON_CLASS.ASSAULT_RIFLE, .82, .97, .75 * game_get_speed(gamespeed_fps), .83, 300, 1, 5, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.preattached] = { scope: ITEM.red_dot_scope };
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.disadvantages] = "-Lower rate of fire\n-High recoil\n-Moderate mobility\n-High bullet spread";
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.advantages] = "+High range\n+High damage\n+High penetration power";
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.AmmoSpriteID] = 4;
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.Rarity] = RARITY.RARE;
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.SG550, ITEMSTATS.Range],
		    0.45, 0.77,
		    0.97, 0.85,
		    0.83, 7.0
		);
	}
	global.ItemIndex[# ITEM.SG550, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.SG550, ITEMSTATS.Range],
		    0.15, 0.3, 
			0.97, 0.69, 0.5,   // 0.5 - 150% spread na max range
		    4.0, 5.0
		);
	}

	global.ItemIndex[# ITEM.SpecOpsHelm, ITEMSTATS.Type] = "Helmet";
	ArmourStats(ITEM.SpecOpsHelm, "Spec ops helmet", 5, .85, 75);
	global.ItemIndex[# ITEM.SpecOpsHelm, ITEMSTATS.ItemColor] = c_dkgray;
	global.ItemIndex[# ITEM.SpecOpsHelm, ITEMSTATS.BaseDurability] = 50;
	
	global.ItemIndex[# ITEM.SpecOpsVest, ITEMSTATS.Type] = "Armour";
	ArmourStats(ITEM.SpecOpsVest, "Spec ops vest", 8, .825, 75);
	global.ItemIndex[# ITEM.SpecOpsVest, ITEMSTATS.ItemColor] = c_dkgray;
	global.ItemIndex[# ITEM.SpecOpsVest, ITEMSTATS.BaseDurability] = 50; 
	
	global.ItemIndex[# ITEM.NightVision, ITEMSTATS.Type] = "Helmet";
	ArmourStats(ITEM.NightVision, "Night vision", 3, .975, 75);
	global.ItemIndex[# ITEM.NightVision, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.NightVision, ITEMSTATS.BaseDurability] = 100;
	global.ItemIndex[# ITEM.NightVision, ITEMSTATS.NightVisionIntensityPower] = 2;
	global.ItemIndex[# ITEM.NightVision, ITEMSTATS.NightVisionNoisePower] = 1;
	
	global.ItemIndex[# ITEM.HealingKit, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.HealingKit, ITEMSTATS.Name] = "Healing kit";
	global.ItemIndex[# ITEM.HealingKit, ITEMSTATS.ReloadSpeed] = 3 * game_get_speed(gamespeed_fps);
	global.ItemIndex[# ITEM.HealingKit, ITEMSTATS.Damage] = 100;
	global.ItemIndex[# ITEM.HealingKit, ITEMSTATS.Cost] = 25;
	global.ItemIndex[# ITEM.HealingKit, ITEMSTATS.ItemColor] = c_red;
	
	global.ItemIndex[# ITEM.gold_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.gold_card, ITEMSTATS.Name] = "Golden card";
	global.ItemIndex[# ITEM.gold_card, ITEMSTATS.ItemColor] = MAIN_COLOR;
	
	global.ItemIndex[# ITEM.magenta_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.magenta_card, ITEMSTATS.Name] = "Magenta card";
	global.ItemIndex[# ITEM.magenta_card, ITEMSTATS.ItemColor] = c_purple;
	
	global.ItemIndex[# ITEM.red_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.red_card, ITEMSTATS.Name] = "Red card";
	global.ItemIndex[# ITEM.red_card, ITEMSTATS.ItemColor] = c_red;
	
	global.ItemIndex[# ITEM.aqua_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.aqua_card, ITEMSTATS.Name] = "Cyan card";
	global.ItemIndex[# ITEM.aqua_card, ITEMSTATS.ItemColor] = c_aqua;
	
	global.ItemIndex[# ITEM.green_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.green_card, ITEMSTATS.Name] = "Green card";
	global.ItemIndex[# ITEM.green_card, ITEMSTATS.ItemColor] = c_green;
	
	global.ItemIndex[# ITEM.black_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.black_card, ITEMSTATS.Name] = "Black card";
	global.ItemIndex[# ITEM.black_card, ITEMSTATS.ItemColor] = c_black;
	
	global.ItemIndex[# ITEM.white_card, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.white_card, ITEMSTATS.Name] = "White card";
	global.ItemIndex[# ITEM.white_card, ITEMSTATS.ItemColor] = c_white;
	
	global.ItemIndex[# ITEM.InfraredVision, ITEMSTATS.Type] = "Helmet";
	ArmourStats(ITEM.InfraredVision, "Infrared vision", 3, .975, 150);
	global.ItemIndex[# ITEM.InfraredVision, ITEMSTATS.ItemColor] = c_red;
	global.ItemIndex[# ITEM.InfraredVision, ITEMSTATS.BaseDurability] = 150;
	
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.Type] = "Grenade";
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.Name] = "Smoke grenade";
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.Damage] = 0;
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.PenetrationPower] = 0;
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.Cost] = 25;
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.ReloadSpeed] = 2.5;
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.BulletCasingID] = 2;
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.SmokeGrenade, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.95
		);
	}

	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.Javelin, "FGM-148", 1.5 * game_get_speed(gamespeed_fps), 490, 98, 50, 1, WEAPON_TYPE.PRIMARY, 25, 15, snd_Javelin, 15, 5, false,
	0, 0, 0, 0, 0, 5, 7.5, 15, 25, .25, -1, WEAPON_CLASS.MISSILE, .59, .99, 1 * game_get_speed(gamespeed_fps), .5, 390, 1, 4, false, "127 mm HEAT", CALIBER.ROCKET);
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.difficulty] = 1;
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.disadvantages] = "-Very bad mobility\n-Dangerous explosion\n-Only one rocket per shot";
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.advantages] = "+Homing projectiles\n+High damage";
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.AmmoSpriteID] = 6;
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.Rarity] = RARITY.RARE;
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    global.ItemIndex[# ITEM.Javelin, ITEMSTATS.Range],
		    0.5, 0.75,
		    0.57
		);
	}
	global.ItemIndex[# ITEM.Javelin, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.Javelin, ITEMSTATS.Range],
		    0.55, 0.9, 
			0.59, -1.0, -3.0,   // -3 - 500% spread na max range
		    5.0, 5.0
		);
	}

	global.ItemIndex[# ITEM.Glock, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.Glock, "Glock-17", 1.25 * game_get_speed(gamespeed_fps), 500, 25, 240, 24, WEAPON_TYPE.SECONDARY, 4, 9, snd_Glock, 3, 1, false,
	24, 24, 5, 8, .1, 1.1, 1, 0, 5, .99, 0, WEAPON_CLASS.PISTOL, .97, .47, 0.05 * game_get_speed(gamespeed_fps), .9, 20, .5, 9, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.disadvantages] = "-Low damage\n-Low penetration power";
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.advantages] = "-Great mobility\n-High magazine capacity";
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.AmmoSpriteID] = 7;
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.Glock, ITEMSTATS.Range],
		    0.5, 0.75,
		    0.88, 0.73,
		    0.54, 7.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.Glock, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.Glock, ITEMSTATS.Range],
		    0.45, 0.7, 
			0.39, -2.0, -5.0,   // -5 - 700% spread na max range
		    5.0, 5.0
		);
	}


	global.ItemIndex[# ITEM.MK18, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.MK18, "MK18", 2.1 * game_get_speed(gamespeed_fps), 715, 30, 700, 30, WEAPON_TYPE.PRIMARY, 5.5, 5.5, snd_MK18, 2, 1, true,
	10, 20, 13, 9, .01, 8, 3.5, 0, 10, .5, 0, WEAPON_CLASS.ASSAULT_RIFLE, .92, .71, .5 * game_get_speed(gamespeed_fps), .73, 290, .75, 5, true, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.disadvantages] = "-Low penetration power\n-High recoil";
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.advantages] = "+Good mobility\n+Low bullet spread";
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.AmmoSpriteID] = 8;
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.Rarity] = RARITY.RARE;
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.MK18, ITEMSTATS.Range],
		    0.3, 0.525,
		    0.87, 0.8,
		    0.76, 4.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.MK18, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinexp(
		    dist,
		    global.ItemIndex[# ITEM.MK18, ITEMSTATS.Range],
		    0.5, 0.75, 
			0.73, 0.54, 0.3,   // 170% spread na max range
		    3.0
		);
	}	

	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.m4a1, "M4A1", 2.5 * game_get_speed(gamespeed_fps), 730, 31, 300, 25, WEAPON_TYPE.PRIMARY, 4.5, 6, snd_m4a1, 2.5, 1, true,
	10, 15, -5, 3.9, .01, 8, 3.5, 1, 7.75, .55, 0, WEAPON_CLASS.ASSAULT_RIFLE, .85, .7, .8 * game_get_speed(gamespeed_fps), .73, 280, .75, 5, true, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.disadvantages] = "-Low penetration power\n-Long reloading";
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.advantages] = "+Good mobility\n+Low bullet spread\n+Low recoil";
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.preattached] = { suppressor: ITEM.suppressor };
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.AmmoSpriteID] = 13;
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.Rarity] = RARITY.UNCOMMON;
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinlog(
		    dist,
		    global.ItemIndex[# ITEM.m4a1, ITEMSTATS.Range],
		    0.25, 0.65,
		    0.95, 0.89,
		    0.85, 5.0
		);
	}
	global.ItemIndex[# ITEM.m4a1, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinexp(
		    dist,
		    global.ItemIndex[# ITEM.m4a1, ITEMSTATS.Range],
		    0.15, 0.3, 
			0.92, 0.83, -0.5,   // 250% spread na max range
		    3.0
		);
	}
	
	global.ItemIndex[# ITEM.m200, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.m200, "M200", 2.75 * game_get_speed(gamespeed_fps), 900, 159, 30, 3, WEAPON_TYPE.PRIMARY, 1, 35, snd_M200, 50, 4, false,
	0, 0, 35, 55, 75, 50, 5, 0, 0, .01, 1, WEAPON_CLASS.SNIPER_RIFLE, .7, .98, 1 * game_get_speed(gamespeed_fps), .15, 370, 2, 5, true, ".408 Chey Tac", CALIBER.HIGH);
	global.ItemIndex[# ITEM.m200, ITEMSTATS.difficulty] = 5;
	global.ItemIndex[# ITEM.m200, ITEMSTATS.preattached] = { scope: ITEM.two_scope };
	global.ItemIndex[# ITEM.m200, ITEMSTATS.disadvantages] = "-Ultra bad mobility\n-Limited view\n-Low ammo capacity";
	global.ItemIndex[# ITEM.m200, ITEMSTATS.advantages] = "\n+Very high damage\n+High range\n+Neglidible damage drop-off\n+Neglidible accuracy drop";
	global.ItemIndex[# ITEM.m200, ITEMSTATS.ItemColor] = c_dkgray;
	global.ItemIndex[# ITEM.m200, ITEMSTATS.AmmoSpriteID] = 22;
	global.ItemIndex[# ITEM.m200, ITEMSTATS.ScopeInaccuracyResetTimer] = 70;
	global.ItemIndex[# ITEM.m200, ITEMSTATS.Rarity] = RARITY.LEGENDARY;
	global.ItemIndex[# ITEM.m200, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_explinlin(
		    dist,
		    global.ItemIndex[# ITEM.m200, ITEMSTATS.Range],
		    0.35, 0.7, 
			0.98, 0.95, 0.93,
		    5.0, 7.0
		);
	}
	global.ItemIndex[# ITEM.m200, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    global.ItemIndex[# ITEM.m200, ITEMSTATS.Range],
		    0.25, 0.55, 0.975   // 0.975 - 102.5% spread na max range
		);
	}

	global.ItemIndex[# ITEM.awm, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.awm, "AWM", 3.25 * game_get_speed(gamespeed_fps), 850, 123, 75, 5, WEAPON_TYPE.PRIMARY, 1, 30, snd_awm, 30, 2, false,
	0, 0, 25, 50, 50, 25, 7.5, 0, 0, .05, 1, WEAPON_CLASS.SNIPER_RIFLE, .77, .95, 1.5 * game_get_speed(gamespeed_fps), .33, 350, 2, 5, false, ".338 LM", CALIBER.HIGH);
	global.ItemIndex[# ITEM.awm, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.awm, ITEMSTATS.preattached] = { scope: ITEM.two_scope };
	global.ItemIndex[# ITEM.awm, ITEMSTATS.disadvantages] = "-Very bad mobility\n-Limited view\n-Long reloading\n-Slow equip";
	global.ItemIndex[# ITEM.awm, ITEMSTATS.advantages] = "\n+High damage\n+High range\n+Neglidible damage drop";
	global.ItemIndex[# ITEM.awm, ITEMSTATS.ItemColor] = c_green;
	global.ItemIndex[# ITEM.awm, ITEMSTATS.AmmoSpriteID] = 9;
	global.ItemIndex[# ITEM.awm, ITEMSTATS.ScopeInaccuracyResetTimer] = 55;
	global.ItemIndex[# ITEM.awm, ITEMSTATS.Rarity] = RARITY.LEGENDARY;
	global.ItemIndex[# ITEM.awm, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.awm, ITEMSTATS.Range],
		    0.4, 0.57, 
			0.95, 0.93, 0.91,
		    5.0, 7.0
		);
	}
	global.ItemIndex[# ITEM.awm, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    global.ItemIndex[# ITEM.awm, ITEMSTATS.Range],
		    0.5, 0.7, 0.95   // 0.95 - 105% spread na max range
		);
	}	
	
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.Dragunov, "Dragunov", 3.75 * game_get_speed(gamespeed_fps), 890, 94, 45, 15, WEAPON_TYPE.PRIMARY, 2, 20, snd_Dragunov, 20, 1.5, false,
	0, 0, 15, 25, 5, 25, 5, 0, 0, .15, 1, WEAPON_CLASS.SNIPER_RIFLE, .815, .975, 1 * game_get_speed(gamespeed_fps), .25, 380, 2, 5, false, "7.62x54 mm", CALIBER.HIGH);
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.random_bullet_spread] = true;
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.preattached] = { scope: ITEM.two_scope };
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.disadvantages] = "-Very bad mobility\n-Limited view\n-Long reloading\n-High damage drop";
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.advantages] = "\n+Semi-automatic\n+High range";
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.AmmoSpriteID] = 16;
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.ScopeInaccuracyResetTimer] = 10;
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.Rarity] = RARITY.RARE;
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.Defense] = 1; ///Flag, ze je to semi-automatic
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_explinlog(
		    dist,
		    global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.Range],
		    0.59, 0.72, 
			0.87, 0.79, 0.73,
		    5.0, 7.0
		);
	}
	global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_logexpexp(
		    dist,
		    global.ItemIndex[# ITEM.Dragunov, ITEMSTATS.Range],
		    0.5, 0.8, 
			0.81, 0.55, 0.15,
		    7.0, 4.0,
		);
	}	


	global.ItemIndex[# ITEM.usp, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.usp, "USP", 1.75 * game_get_speed(gamespeed_fps), 580, 33, 350, 15, WEAPON_TYPE.SECONDARY, 2, 8, snd_usp, 2, 1, false,
	9, 12, 1, 1, .175, 5.5, 1, 0, 13, .93, 0, WEAPON_CLASS.PISTOL, .97, .44, 0.15 * game_get_speed(gamespeed_fps), .87, 25, .75, 8, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.usp, ITEMSTATS.KBStabilization] = 10;
	global.ItemIndex[# ITEM.usp, ITEMSTATS.difficulty] = 4;
	global.ItemIndex[# ITEM.usp, ITEMSTATS.disadvantages] = "-Low penetration power";
	global.ItemIndex[# ITEM.usp, ITEMSTATS.advantages] = "+Great mobility\n+High magazine capacity";
	global.ItemIndex[# ITEM.usp, ITEMSTATS.preattached] = { suppressor: ITEM.suppressor };
	global.ItemIndex[# ITEM.usp, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.usp, ITEMSTATS.AmmoSpriteID] = 10;
	global.ItemIndex[# ITEM.usp, ITEMSTATS.Rarity] = RARITY.UNCOMMON;
	global.ItemIndex[# ITEM.usp, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.usp, ITEMSTATS.Range],
		    0.7, 0.85,
		    0.89, 0.87,
		    0.82, 7.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.usp, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.usp, ITEMSTATS.Range],
		    0.55, 0.75, 
			0.75, -0.5, -2.0,   // -2 - 400% spread na max range
		    5.0, 5.0
		);
	}	
	
	
	global.ItemIndex[# ITEM.p250, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.p250, "P250", 1.5 * game_get_speed(gamespeed_fps), 600, 29, 105, 15, WEAPON_TYPE.SECONDARY, 3, 7, snd_p250, 2, 1, false,
	15, 15, 1, 4, .5, 3.75, 2, 0, 5.9, .99, 0, WEAPON_CLASS.PISTOL, .93, .5, round(.23 * game_get_speed(gamespeed_fps)), .95, 55, 1, 7, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.p250, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.p250, ITEMSTATS.disadvantages] = "-Low penetration power";
	global.ItemIndex[# ITEM.p250, ITEMSTATS.advantages] = "+Great mobility\n+First shot accuracy";
	global.ItemIndex[# ITEM.p250, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.p250, ITEMSTATS.AmmoSpriteID] = 12;
	global.ItemIndex[# ITEM.p250, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.p250, ITEMSTATS.Range],
		    0.7, 0.85,
		    0.85, 0.76,
		    0.71, 7.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.p250, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.p250, ITEMSTATS.Range],
		    0.55, 0.78, 
			0.59, -0.85, -1.8,   // -1.8 - 380% spread na max range
		    5.0, 5.0
		);
	}	

	global.ItemIndex[# ITEM.tec9, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.tec9, "TEC-9", 1.9 * game_get_speed(gamespeed_fps), 615, 23, 180, 18, WEAPON_TYPE.SECONDARY, 4, 7, snd_Tec9, 2, 1.1, false,
	7, 12, 1, 3, .025, 2, 3, 2, 10, .95, 0, WEAPON_CLASS.PISTOL, .975, .73, round(.37 * game_get_speed(gamespeed_fps)), .98, 75, 1, 7, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.difficulty] = 2;
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.disadvantages] = "-Low damage\n-Slow equip";
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.advantages] = "+Great mobility\n+Good penetration power";
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.AmmoSpriteID] = 15;
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.Rarity] = RARITY.UNCOMMON;
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.tec9, ITEMSTATS.Range],
		    0.7, 0.85,
		    0.93, 0.89,
		    0.67, 7.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.tec9, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.tec9, ITEMSTATS.Range],
		    0.55, 0.78, 
			0.67, -1.8, -3.7,   // -3.7 - 570% spread na max range
		    5.0, 5.0
		);
	}	

	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.CZ75, "CZ-75", 2 * game_get_speed(gamespeed_fps), 585, 21, 75, 15, WEAPON_TYPE.SECONDARY, 3, 7, snd_CZ75, 1, 1, true,
	5, 8, 7, 5, .0125, 5, 2, 5, 9, .75, 0, WEAPON_CLASS.PISTOL, .875, .67, round(.5 * game_get_speed(gamespeed_fps)), .75, 85, 1.25, 12, false, "9x19 mm", CALIBER.LOW);
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.disadvantages] = "-Low damage\n-Slow equip\n-Worse range accuracy";
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.advantages] = "+Automatic pistol\n+Accurate recoil\n+High kill reward";
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.AmmoSpriteID] = 18;
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.Rarity] = RARITY.RARE;
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.CZ75, ITEMSTATS.Range],
		    0.7, 0.85,
		    0.97, 0.84,
		    0.58, 7.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.CZ75, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_loglinexp(
		    dist,
		    global.ItemIndex[# ITEM.CZ75, ITEMSTATS.Range],
		    0.45, 0.7, 
			0.28, -4.4, -7.5,   // -5.7 - 750% spread na max range
		    5.0, 5.0
		);
	}	
	
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.Type] = "Landmine";
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.Name] = "HE landmine";
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.Cost] = 100;
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.BulletCasingID] = 0;
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.Damage] = 98;
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.PenetrationPower] = .5;
	//global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.damage_drop] = .005;
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.ItemColor] = c_red;
	global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.8
		);
	}	
	
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.Type] = "Landmine";
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.Name] = "CE landmine";
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.Cost] = 100;
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.BulletCasingID] = 4;
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.Damage] = 75;
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.PenetrationPower] = .99;
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.AmmoSpriteID] = 10; ///Shrapnel number
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.ItemColor] = c_aqua;
	global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.75
		);
	}


	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.Type] = "Landmine";
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.Name] = "LE landmine";
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.Cost] = 50;
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.BulletCasingID] = 8;
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.Damage] = 46;
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.PenetrationPower] = .95;
	//global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.damage_drop] = .005;
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.AmmoSpriteID] = 50; ///Shrapnel number
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.ItemColor] = c_yellow;
	global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.8
		);
	}


	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.Type] = "Grenade";
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.Name] = "Sticky grenade";
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.Cost] = 50;
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.ReloadSpeed] = 5;
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.Damage] = 49;
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.PenetrationPower] = .89;
	//global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.damage_drop] = .005;
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.BulletCasingID] = 3;
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.ItemColor] = make_color_rgb(158, 154, 117);
	global.ItemIndex[# ITEM.StickyGrenade, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.85
		);
	}

	global.ItemIndex[# ITEM.red_dot_scope, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.red_dot_scope, ITEMSTATS.Name] = "Red dot sight";
	global.ItemIndex[# ITEM.red_dot_scope, ITEMSTATS.slot] = INDEX.slot_scope;
	global.ItemIndex[# ITEM.red_dot_scope, ITEMSTATS.ItemColor] = c_red;
	global.ItemIndex[# ITEM.red_dot_scope, ITEMSTATS.AmmoSpriteID] = 3; ///attachment image index
	
	global.ItemIndex[# ITEM.DefuseKit, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.DefuseKit, ITEMSTATS.Name] = "Defuse kit";
	global.ItemIndex[# ITEM.DefuseKit, ITEMSTATS.ItemColor] = c_blue;;

	global.ItemIndex[# ITEM.two_scope, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.two_scope, ITEMSTATS.Name] = "Sniper scope";
	global.ItemIndex[# ITEM.two_scope, ITEMSTATS.slot] = INDEX.slot_scope;
	global.ItemIndex[# ITEM.two_scope, ITEMSTATS.ItemColor] = c_gray;
	global.ItemIndex[# ITEM.two_scope, ITEMSTATS.AmmoSpriteID] = 2;
	
	global.ItemIndex[# ITEM.adaptive_chambering, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.adaptive_chambering, ITEMSTATS.Name] = "Adaptive chambering";
	global.ItemIndex[# ITEM.adaptive_chambering, ITEMSTATS.slot] = INDEX.slot_barrel;
	global.ItemIndex[# ITEM.adaptive_chambering, ITEMSTATS.ShootTimer] = .75;
	global.ItemIndex[# ITEM.adaptive_chambering, ITEMSTATS.AmmoSpriteID] = 1;
	global.ItemIndex[# ITEM.adaptive_chambering, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.vertical_grip, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.vertical_grip, ITEMSTATS.Name] = "Vertical grip";
	global.ItemIndex[# ITEM.vertical_grip, ITEMSTATS.slot] = INDEX.slot_grip;
	global.ItemIndex[# ITEM.vertical_grip, ITEMSTATS.KickBackPower] = 1;
	global.ItemIndex[# ITEM.vertical_grip, ITEMSTATS.KickBackInaccuracyMultiplier] = .75;
	global.ItemIndex[# ITEM.vertical_grip, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.bipod, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.bipod, ITEMSTATS.Name] = "Bipod";
	global.ItemIndex[# ITEM.bipod, ITEMSTATS.slot] = INDEX.slot_grip;
	//global.ItemIndex[# ITEM.bipod, ITEMSTATS.KickBackPower] = 1;
	global.ItemIndex[# ITEM.bipod, ITEMSTATS.KickBackInaccuracyMultiplier] = .1;
	global.ItemIndex[# ITEM.bipod, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.horizontal_grip, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.horizontal_grip, ITEMSTATS.Name] = "Horizontal grip";
	global.ItemIndex[# ITEM.horizontal_grip, ITEMSTATS.KickBackInaccuracyMultiplier] = 1;
	global.ItemIndex[# ITEM.horizontal_grip, ITEMSTATS.slot] = INDEX.slot_grip;
	global.ItemIndex[# ITEM.horizontal_grip, ITEMSTATS.KickBackPower] = .75;
	global.ItemIndex[# ITEM.horizontal_grip, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.Name] = "Military suppressor";
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.slot] = INDEX.slot_suppressor;
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.Defense] = .75; ///Damage reduction multiplier
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.KickBackPower] = .9; ///Inaccuracy multiplier
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.KickBackInaccuracyMultiplier] = .1; ///Noise reduction multiplier
	global.ItemIndex[# ITEM.suppressor, ITEMSTATS.ItemColor] = c_gray;
	
	///Reprezentace exploze jako itemu kvůli jeho statistikám
	global.ItemIndex[# ITEM.base_explosion, ITEMSTATS.Name] = "Explosion";
	global.ItemIndex[# ITEM.base_explosion, ITEMSTATS.Damage] = 95;
	global.ItemIndex[# ITEM.base_explosion, ITEMSTATS.PenetrationPower] = .5;
	//global.ItemIndex[# ITEM.base_explosion, ITEMSTATS.damage_drop] = .001;
	global.ItemIndex[# ITEM.base_explosion, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.9
		);
	}
	
	///Reprezentace nukleární exploze jako itemu kvůli jeho statistikám
	global.ItemIndex[# ITEM.nuclear_explosion, ITEMSTATS.Name] = "Nuclear explosion";
	global.ItemIndex[# ITEM.nuclear_explosion, ITEMSTATS.Damage] = 152;
	global.ItemIndex[# ITEM.nuclear_explosion, ITEMSTATS.PenetrationPower] = .9;
	//global.ItemIndex[# ITEM.nuclear_explosion, ITEMSTATS.damage_drop] = .001;
	global.ItemIndex[# ITEM.nuclear_explosion, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_lin(
		    dist,
		    1000,
		    0.5, 0.75,
			0.9
		);
	}
		
	///Reprezentace základní machine gun
	global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.basic_machine_gun, "Basic machine gun", 3 * game_get_speed(gamespeed_fps), 600, 53, 500, 50, WEAPON_TYPE.PRIMARY, 7, 6, snd_machine_gun, 10, 2, false,
	0, 0, 10, 30, .05, 1, 1, 0, 0, 1, 1, WEAPON_CLASS.MACHINE_GUN, .95, .775, 1.75 * game_get_speed(gamespeed_fps), 1, 0, 1, 4, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.ItemColor] = c_ltgray;
	global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.AmmoSpriteID] = 11;	
	global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_logexpexp(
		    dist,
		    global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.Range],
		    0.5, 0.7,
		    0.85, 0.75,
		    0.71, 4.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinexp(
		    dist,
		    global.ItemIndex[# ITEM.basic_machine_gun, ITEMSTATS.Range],
		    0.4, 0.8, 
			0.73, 0.64, 0.1,   // 175% spread na max range
		    4.0
		);
	}		
	
	global.ItemIndex[# ITEM.famas, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.famas, "FAMAS", round(1.89 * game_get_speed(gamespeed_fps)), 680, 27, 250, 25, WEAPON_TYPE.PRIMARY, 4, 7, snd_Famas, 2, 1, true,
	5, 10, 10, 4, .03, 7, 3.5, -1, 9, .7, 0, WEAPON_CLASS.ASSAULT_RIFLE, .83, .69, .8 * game_get_speed(gamespeed_fps), .75, 200, 1, 8, false, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.famas, ITEMSTATS.difficulty] = 3;
	global.ItemIndex[# ITEM.famas, ITEMSTATS.disadvantages] = "-Low magazine capacity\n-Low penetration power\n-High damage drop-off";
	global.ItemIndex[# ITEM.famas, ITEMSTATS.advantages] = "+Low bullet spread\n+Low vertical recoil";
	global.ItemIndex[# ITEM.famas, ITEMSTATS.ItemColor] = c_dkgray;
	global.ItemIndex[# ITEM.famas, ITEMSTATS.AmmoSpriteID] = 14;
	global.ItemIndex[# ITEM.famas, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_logexpexp(
		    dist,
		    global.ItemIndex[# ITEM.famas, ITEMSTATS.Range],
		    0.5, 0.7,
		    0.88, 0.81,
		    0.76, 4.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.famas, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinexp(
		    dist,
		    global.ItemIndex[# ITEM.famas, ITEMSTATS.Range],
		    0.4, 0.8, 
			0.68, 0.33, .05,   // 295% spread na max range
		    4.0
		);
	}		
	
	
	global.ItemIndex[# ITEM.galil, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.galil, "Galil", 1.75 * game_get_speed(gamespeed_fps), 700, 33, 270, 30, WEAPON_TYPE.PRIMARY, 7, 6, snd_galil, 5, 2, true,
	8, 20, 12, 5.9, .02, 10, 3.5, 1, 7, .59, 1, WEAPON_CLASS.ASSAULT_RIFLE, .89, .71, .75 * game_get_speed(gamespeed_fps), .85, 180, 1, 8, true, "5.56x45 mm NATO", CALIBER.MEDIUM);
	global.ItemIndex[# ITEM.galil, ITEMSTATS.difficulty] = 4;
	global.ItemIndex[# ITEM.galil, ITEMSTATS.disadvantages] = "-High bullet spread\n-High horizontal recoil\n-Low penetration power";
	global.ItemIndex[# ITEM.galil, ITEMSTATS.advantages] = "+Fast equipping\n+Fast reloading\n+Low price";
	global.ItemIndex[# ITEM.galil, ITEMSTATS.ItemColor] = c_ltgray;
	global.ItemIndex[# ITEM.galil, ITEMSTATS.AmmoSpriteID] = 11;
	global.ItemIndex[# ITEM.galil, ITEMSTATS.damage_drop] = function(dist)  {
		return curve_logexpexp(
		    dist,
		    global.ItemIndex[# ITEM.galil, ITEMSTATS.Range],
		    0.45, 0.88,
		    0.92, 0.84,
		    0.79, 4.0, 5.0
		);
	}
	global.ItemIndex[# ITEM.galil, ITEMSTATS.accuracy_drop] = function(dist)  {
		return curve_explinexp(
		    dist,
		    global.ItemIndex[# ITEM.galil, ITEMSTATS.Range],
		    0.5, 0.86, 
			0.73, 0.38, 0.0,   // 200% spread na max range
		    4.0
		);
	}

	global.ItemIndex[# ITEM.steel_knife, ITEMSTATS.Type] = "Weapon";
	WeaponStats(ITEM.steel_knife, "Steel knife", .5 * game_get_speed(gamespeed_fps), 48, 27, -1, -1, WEAPON_TYPE.TERTIARY, 0, 10, snd_knife, 5, 2, false,
	0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, WEAPON_CLASS.KNIFE, .97, 1, .25 * game_get_speed(gamespeed_fps), 0, 0, 1, 15, false, "", 0);
	global.ItemIndex[# ITEM.steel_knife, ITEMSTATS.disadvantages] = "";
	global.ItemIndex[# ITEM.steel_knife, ITEMSTATS.advantages] = "";
	global.ItemIndex[# ITEM.steel_knife, ITEMSTATS.ItemColor] = c_ltgray;
	
	global.ItemIndex[# ITEM.low_cal_box, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.low_cal_box, ITEMSTATS.Name] = "Low caliber ammunition box";
	global.ItemIndex[# ITEM.low_cal_box, ITEMSTATS.MaxAmmo] = 100;
	global.ItemIndex[# ITEM.low_cal_box, ITEMSTATS.ItemColor] = c_aqua;
	
	global.ItemIndex[# ITEM.med_cal_box, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.med_cal_box, ITEMSTATS.Name] = "Medium caliber ammunition box";
	global.ItemIndex[# ITEM.med_cal_box, ITEMSTATS.MaxAmmo] = 75;
	global.ItemIndex[# ITEM.med_cal_box, ITEMSTATS.ItemColor] = c_green;
	
	global.ItemIndex[# ITEM.high_cal_box, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.high_cal_box, ITEMSTATS.Name] = "High caliber ammunition box";
	global.ItemIndex[# ITEM.high_cal_box, ITEMSTATS.MaxAmmo] = 25;
	global.ItemIndex[# ITEM.high_cal_box, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.gauge_box, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.gauge_box, ITEMSTATS.Name] = "Gauge ammunition box";
	global.ItemIndex[# ITEM.gauge_box, ITEMSTATS.ItemColor] = c_lime;
	
	global.ItemIndex[# ITEM.range_finder, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.range_finder, ITEMSTATS.Name] = "Range indicator";
	global.ItemIndex[# ITEM.range_finder, ITEMSTATS.slot] = INDEX.slot_barrel;
	global.ItemIndex[# ITEM.range_finder, ITEMSTATS.AmmoSpriteID] = 0;
	global.ItemIndex[# ITEM.range_finder, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.laser, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.laser, ITEMSTATS.Name] = "Laser";
	global.ItemIndex[# ITEM.laser, ITEMSTATS.slot] = INDEX.slot_barrel;
	global.ItemIndex[# ITEM.laser, ITEMSTATS.AmmoSpriteID] = 4;
	global.ItemIndex[# ITEM.laser, ITEMSTATS.KickBackPower] = .75; ///Inaccuracy multiplier
	global.ItemIndex[# ITEM.laser, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.dilatation_pill, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.dilatation_pill, ITEMSTATS.Name] = "Dilatation pill";
	global.ItemIndex[# ITEM.dilatation_pill, ITEMSTATS.ItemColor] = c_gray;
	
	global.ItemIndex[# ITEM.adrenaline, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.adrenaline, ITEMSTATS.Name] = "Adrenaline";
	global.ItemIndex[# ITEM.adrenaline, ITEMSTATS.ItemColor] = c_yellow;
	
	global.ItemIndex[# ITEM.steroids, ITEMSTATS.Type] = "Item";
	global.ItemIndex[# ITEM.steroids, ITEMSTATS.Name] = "Adrenaline";
	global.ItemIndex[# ITEM.steroids, ITEMSTATS.ItemColor] = c_red;
	
	for (var i = 0; i < ITEM.Total; i++) {
	    if (global.ItemIndex[# i, ITEMSTATS.Type] == "Weapon") {
	        global.ItemIndex[# i, ITEMSTATS.BaseMaxAmmo] = global.ItemIndex[# i, ITEMSTATS.MaxAmmo];
	        global.ItemIndex[# i, ITEMSTATS.BaseReloadSpeed] = global.ItemIndex[# i, ITEMSTATS.ReloadSpeed];
	        global.ItemIndex[# i, ITEMSTATS.BaseEquipTime]  = global.ItemIndex[# i, ITEMSTATS.EquipTime];
	        global.ItemIndex[# i, ITEMSTATS.BaseMovingSpdMul]   = global.ItemIndex[# i, ITEMSTATS.MovingSpdMul];
	        global.ItemIndex[# i, ITEMSTATS.BasePenetrationPower] = global.ItemIndex[# i, ITEMSTATS.PenetrationPower];
	        global.ItemIndex[# i, ITEMSTATS.BaseDamage] = global.ItemIndex[# i, ITEMSTATS.Damage];
	    }
	}
	
	global.built_upgrades = {};

	// Projdeme celý ItemIndex a pro každou zbraň vytvoříme záznam
	for (var i = 0; i < ITEM.Total; i++) {
	    if (global.ItemIndex[# i, ITEMSTATS.Type] == "Weapon") { 
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
