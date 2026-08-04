event_inherited();
tab_width = 1536;
tab_height = 1024;
draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);

stat_x = zui_get_width() * .5;
stat_y = zui_get_height() * .1;
gap = 170 * global.GUIMultiplier;
c_x = zui_get_width() * .5;
c_y = zui_get_height() * .5;
text_height = string_height("a")*1.25;
wpn_index = 0;
is_locked = false;
img_lock = noone;
img_lockbg = noone;
wpn_sprite = noone;
wpn_desc = noone;
ammo_upg = noone;
reload_upg = noone;
equip_upg = noone;
move_upg = noone;
pen_upg = noone;
dmg_upg = noone;


show_dmg_graph = noone;
dmg_graph = noone;

show_range_graph = noone;
range_graph = noone;


wpn_desc_txt = "";
wpn_string = array_create(29, "");
ui_objects = array_create(29, noone);




refresh_weapon_ui = function(){
	with(oWeaponsTab){
	    wpn = weapons[wpn_index];
		wpn_desc_txt = global.ItemIndex[# wpn, ItemStat.Description];
		
		var fire_modes = "";
		for(var i = 0; i < ds_list_size(global.ItemIndex[# wpn, ItemStat.ShootingMode]);i ++){
			fire_modes += string(global.ItemIndex[# wpn, ItemStat.ShootingMode][| i]);
			
			if(i != ds_list_size(global.ItemIndex[# wpn, ItemStat.ShootingMode]) - 1){
				fire_modes += ", ";
			}
		}
		
		var complex_recoil = "no";
		if(global.ItemIndex[# wpn, ItemStat.HardRecoil] == true){
			complex_recoil = "yes";
		}
		
		var dmg_drop_txt_1 = "";
		var dmg_drop_txt_2 = "";
		var dist = array_create(4, 0);
		var base_dmg = global.ItemIndex[# wpn, ItemStat.Damage];
		var dmg_drop = global.ItemIndex[# wpn, ItemStat.damage_drop];
		var max_range = global.ItemIndex[# wpn, ItemStat.Range];
		
		for(var i = 0; i < array_length(dist); i++){
		    dist[i] = round((i + 1) * max_range / array_length(dist));
		}

		for(var i = 0; i < array_length(dist); i++){
			var dmg = 0;
	        if(is_method(dmg_drop)){
				dmg = base_dmg * dmg_drop(dist[i]);
			}else{
				dmg = base_dmg * power(1 - dmg_drop, dist[i]);
			}
			var part = string_format(dmg/base_dmg * 100, 0, 1) + " % (" + string(dist[i]) + " u)";

			if(i < array_length(dist) div 2){
				if(dmg_drop_txt_1 != ""){ dmg_drop_txt_1 += ", "; }
				dmg_drop_txt_1 += part;
			}else{
				if(dmg_drop_txt_2 != ""){ dmg_drop_txt_2 += ", "; }
				dmg_drop_txt_2 += part;
			}
		}
		
		var caliber_type = "Low";
		if(global.ItemIndex[# wpn, ItemStat.caliber_type] == CALIBER.GAUGES){
			caliber_type = "Gauges";
		}else if(global.ItemIndex[# wpn, ItemStat.caliber_type] == CALIBER.HIGH){
			caliber_type = "High";
		}else if(global.ItemIndex[# wpn, ItemStat.caliber_type] == CALIBER.MEDIUM){
			caliber_type = "Medium";
		}else if(global.ItemIndex[# wpn, ItemStat.caliber_type] == CALIBER.ROCKET){
			caliber_type = "Rocket";
		}
		
		wpn_string = [
			global.ItemIndex[# wpn, ItemStat.Name],
			"Ammo: " + string(global.ItemIndex[# wpn, ItemStat.MaxAmmo]) + "/" + string(global.ItemIndex[# wpn, ItemStat.ClipAmmo]),
			"Price: " + string(global.ItemIndex[# wpn, ItemStat.Cost]),
			"RPM: " + string(round(3600 / global.ItemIndex[# wpn, ItemStat.ShootTimer])),
			"Base damage: " + string_format(base_dmg, 0, 1),
			"Body damage: " + string_format(base_dmg * BODY_MULTIPLIER, 0, 1),
			"Head damage: " + string_format(base_dmg * HEADSHOT_MULTIPLIER, 0, 1),
			"Arm damage: " + string_format(base_dmg * ARM_MULTIPLIER, 0, 1),
			"Leg damage: " + string_format(base_dmg * LEG_MULTIPLIER, 0, 1),
			"Movement speed: " + string_format(MOVE_SPD * global.ItemIndex[# wpn, ItemStat.MovingSpdMul], 0, 1) + " units/s",
			"Base Spread: " + string(global.ItemIndex[# wpn, ItemStat.Inaccuracy]) + " units",
			"Penetration power: " + string_format(global.ItemIndex[# wpn, ItemStat.PenetrationPower] * 100, 0, 1) + " %",
			"Reload time: " + string_format(global.ItemIndex[# wpn, ItemStat.ReloadSpeed] / 60, 0, 1) + " s",
			"Equip time: " + string_format(global.ItemIndex[# wpn, ItemStat.EquipTime] / 60, 0, 1) + " s",
			"Kill reward: " + string(global.ItemIndex[# wpn, ItemStat.reward]),
			"Damage progress (1): " + dmg_drop_txt_1,
			"Damage progress (2): " + dmg_drop_txt_2,
			"Maximal range: " + string_format(max_range, 0, 1) + " units",
			"Fire modes: " + fire_modes,
			"Class: " + string(get_wpn_type(wpn)),
			"Type: " + (global.ItemIndex[# wpn, ItemStat.WeaponType] == WEAPON_TYPE.PRIMARY ? "Primary" : (global.ItemIndex[# wpn, ItemStat.WeaponType] == WEAPON_TYPE.SECONDARY ? "Secondary" : "Tertiary")),
			"Moving spread increase: " + string_format(global.ItemIndex[# wpn, ItemStat.MovingInaccuracyMultiplier] * 100, 0, 1) + " %",
			"Kickback spread increase: " + string_format(global.ItemIndex[# wpn, ItemStat.KickBackInaccuracyMultiplier] * 100, 0, 1) + " % per shot",
			"Complex recoil: " + complex_recoil,
			"Caliber: " + string(global.ItemIndex[# wpn, ItemStat.caliber]) + " (" + string(caliber_type) + ")",
			"Crosshair vertical recoil: " + string(global.ItemIndex[# wpn, ItemStat.RecoilY]) + " units per shot",
			"Crosshair horizontal recoil: " + string(global.ItemIndex[# wpn, ItemStat.RecoilX]) + " units per shot",
			"Bullet vertical offset: " + string(global.ItemIndex[# wpn, ItemStat.RecoilOffsetY]) + " units per shot",
			"Bullet horizontal offset: " + string(global.ItemIndex[# wpn, ItemStat.RecoilOffsetX]) + " units per shot"
		];
	    var is_locked = global.ItemIndex[# wpn, ItemStat.is_locked];
		
		for(var i = 0;i < array_length(ui_objects);i ++){
			if(instance_exists(ui_objects[i])){
		        var wpn_txt = oWeaponsTab.wpn_string[i];

		        if(is_locked && i != 0){
		            var p = string_pos(":", wpn_txt);
		            if(p > 0){
		                wpn_txt = string_copy(wpn_txt, 1, p) + " ?";
		            }
		        }
				with(ui_objects[i]){ caption = wpn_txt;}
				
				var reward = string_pos("Kill reward", wpn_txt) || string_pos("Price", wpn_txt);
				
				if(reward > 0){
					if(is_locked == false){
						with(ui_objects[i]){
							icon_sprite_index = spr_Coin;
							icon_image_index = 0;
							icon_after = true;
							sprite_scale = 3;
						}
					}else{
						with(ui_objects[i]){
							icon_sprite_index = -1;
							icon_image_index = -1;
							icon_after = false;
						}						
					}
				}
				
			}
		}
		
		var zui_width = zui_get_width();
		
		with(ui_objects[0]){
			draw_set_font(set_font("Title"));
			__x = zui_width * .25 - string_width(global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Name])/2;
			draw_set_font(set_font("Console"));
		}

	    if(instance_exists(img_lock)){
	        with(img_lock){ drawable = is_locked; }
	    }
		
		with(search_bar){
			chars = [];
			init_text = oWeaponsTab.wpn_string[0]; alarm[0] = 1;
		}
		
		with(wpn_sprite){ sprite_image_index = oWeaponsTab.wpn; }
		
		
		with(wpn_desc){ caption = oWeaponsTab.wpn_desc_txt; item_id = oWeaponsTab.wpn; }
		
		with(ammo_upg)      { zui_set_depth(is_locked ? 100 : -1000); }
		with(reload_upg)      { zui_set_depth(is_locked ? 100 : -1000); }
		with(equip_upg)       { zui_set_depth(is_locked ? 100 : -1000); }
		with(move_upg)        { zui_set_depth(is_locked ? 100 : -1000); }
		with(pen_upg)         { zui_set_depth(is_locked ? 100 : -1000); }
		with(dmg_upg)         { zui_set_depth(is_locked ? 100 : -1000); }
		with(show_dmg_graph)  { zui_set_depth(is_locked ? 100 : -1000); }
		with(show_range_graph)  { zui_set_depth(is_locked ? 100 : -1000); }

	    if(instance_exists(img_lockbg)){
	        with(img_lockbg){ drawable = is_locked; }
	    }
		
		if(instance_exists(dmg_graph)){ with(dmg_graph){ zui_destroy(); } }
		if(instance_exists(range_graph)){ with(range_graph){ zui_destroy(); } }
		
		// --- RESET A AKTUALIZACE UPGRADŮ V UI ---
        var upg_data = global.built_upgrades[$ string(wpn)];
        
        // 1. Reset barev všech statistik v seznamu na bílo
        for(var i = 1; i < array_length(ui_objects); i++) {
            if(instance_exists(ui_objects[i])) ui_objects[i].color = c_white;
        }

        // 2. Aktualizace stavu tlačítek a barev statistik
        // AMMO
        var is_ammo = upg_data.ammo;
        with(ammo_upg) { 
            color = is_ammo ? c_lime : c_white; 
            caption = (is_ammo ? "-" : "+") + string((AMMO_UPG - 1) * 100) + " % Magazine capacity";
        }
        if(is_ammo) ui_objects[1].color = c_lime;

        // RELOAD
        var is_reload = upg_data.reload;
        with(reload_upg) { 
            color = is_reload ? c_lime : c_white; 
            caption = (is_reload ? "-" : "+") + string_format((1 - RELOAD_UPG) * 100, 0, 1) + " % Reload speed";
        }
        if(is_reload) ui_objects[12].color = c_lime;

        // EQUIP
        var is_equip = upg_data.equip;
        with(equip_upg) { 
            color = is_equip ? c_lime : c_white; 
            caption = (is_equip ? "-" : "+") + string_format((1 - EQUIP_UPG) * 100, 0, 1) + " % Equip speed";
        }
        if(is_equip) ui_objects[13].color = c_lime;

        // MOVEMENT
        var is_move = upg_data.movement;
        with(move_upg) { 
            color = is_move ? c_lime : c_white; 
            caption = (is_move ? "-" : "+") + string_format((MV_UPG - 1) * 100, 0, 1) + " % Movement speed";
        }
        if(is_move) ui_objects[9].color = c_lime;

        // PENETRATION
        var is_pen = upg_data.penetration;
        with(pen_upg) { 
            color = is_pen ? c_lime : c_white; 
            caption = (is_pen ? "-" : "+") + string_format((PEN_UPG - 1) * 100, 0, 1) + " % Armor penetration";
        }
        if(is_pen) ui_objects[11].color = c_lime;

        // DAMAGE
        var is_dmg = upg_data.damage;
        with(dmg_upg) { 
            color = is_dmg ? c_lime : c_white; 
            caption = (is_dmg ? "-" : "+") + string_format((DMG_UPG - 1) * 100, 0, 1) + " % Base damage";
        }
        if(is_dmg) {
            for(var k=4; k<=8; k++) if(instance_exists(ui_objects[k])) ui_objects[k].color = c_lime;
        }
	}
};

draw_set_font(set_font("Console"));
weapons = [Item.AKM, Item.MK18, Item.m4a1, Item.SG550, Item.galil, 
			Item.famas, Item.awm, Item.SSG08, Item.Dragunov, Item.MAC11, Item.MP9, Item.MP7, Item.DesertEagle, Item.Glock, Item.usp, Item.p250, Item.tec9, Item.CZ75,
			Item.Spas, Item.Javelin
		  ];
wpn = weapons[0];
wpn_x = zui_get_width() * .25;
wpn_y = zui_get_height() * .3;

/* INIT */
r_x = zui_get_width() * .675;
r_y = zui_get_height() * .075;
img_lock = zui_create(c_x, c_y, objUIImage);
img_lockbg = zui_create(c_x, c_y, objUIImage);
wpn_sprite = zui_create(wpn_x, wpn_y, objUIImage);
wpn_desc = zui_create(zui_get_width() * .025, zui_get_height() * .55, objUILabel);
search_bar = zui_create(r_x + string_width("Search weapon: "), r_y - string_height("a")/2, objUITextInput);
search_txt = zui_create(r_x, r_y, objUILabel);


upgrades = {
    ammo: {
         cost: 4,
        callback: function() {
            var w_id = oWeaponsTab.wpn; var upg_data = global.built_upgrades[$ string(w_id)];
            if (upg_data.ammo == false) {
                if (global.player_stats_struct.Diamonds >= self.cost) {
                    upg_data.ammo = true; global.player_stats_struct.Diamonds -= self.cost;
                    global.ItemIndex[# w_id, ItemStat.MaxAmmo] = ceil(global.ItemIndex[# w_id, ItemStat.BaseMaxAmmo] * AMMO_UPG);
                    oWeaponsTab.ammo_upg.color = c_lime;
                    oWeaponsTab.ui_objects[1].color = c_lime;
                }
            } else {
                upg_data.ammo = false; global.player_stats_struct.Diamonds += self.cost;
                global.ItemIndex[# w_id, ItemStat.MaxAmmo] = global.ItemIndex[# w_id, ItemStat.BaseMaxAmmo];        
                oWeaponsTab.ammo_upg.color = c_white;
                oWeaponsTab.ui_objects[1].color = c_white;
            }
            oWeaponsTab.ammo_upg.caption = (upg_data.ammo ? "-" : "+") + string((AMMO_UPG - 1) * 100) + " % Magazine capacity";
            oWeaponsTab.diamonds.caption = string(global.player_stats_struct.Diamonds);
            oWeaponsTab.ui_objects[1].caption = "Ammo: " + string(global.ItemIndex[# w_id, ItemStat.MaxAmmo]) + "/" + string(global.ItemIndex[# w_id, ItemStat.ClipAmmo]);
        }
    },
    reload: {
        cost: 8,
        callback: function() {
            var w_id = oWeaponsTab.wpn; var upg_data = global.built_upgrades[$ string(w_id)];
            if (upg_data.reload == false) {
                if (global.player_stats_struct.Diamonds >= self.cost) {
                    upg_data.reload = true; global.player_stats_struct.Diamonds -= self.cost;
                    global.ItemIndex[# w_id, ItemStat.ReloadSpeed] = round(global.ItemIndex[# w_id, ItemStat.BaseReloadSpeed] * RELOAD_UPG);
                    oWeaponsTab.reload_upg.color = c_lime;
                    oWeaponsTab.ui_objects[12].color = c_lime;
                }
            } else {
                upg_data.reload = false; global.player_stats_struct.Diamonds += self.cost;
                global.ItemIndex[# w_id, ItemStat.ReloadSpeed] = global.ItemIndex[# w_id, ItemStat.BaseReloadSpeed];
                oWeaponsTab.reload_upg.color = c_white;
                oWeaponsTab.ui_objects[12].color = c_white;
            }
            oWeaponsTab.reload_upg.caption = (upg_data.reload ? "-" : "+") + string_format((1 - RELOAD_UPG) * 100, 0, 1) + " % Reload speed";   
            oWeaponsTab.diamonds.caption = string(global.player_stats_struct.Diamonds);
            oWeaponsTab.ui_objects[12].caption = "Reload time: " + string_format(global.ItemIndex[# w_id, ItemStat.ReloadSpeed] / 60, 0, 1) + " s";
        }
    },
    equip: {
        cost: 2,
        callback: function() {
            var w_id = oWeaponsTab.wpn; var upg_data = global.built_upgrades[$ string(w_id)];
            if (upg_data.equip == false) {
                if (global.player_stats_struct.Diamonds >= self.cost) {
                    upg_data.equip = true; global.player_stats_struct.Diamonds -= self.cost;
                    global.ItemIndex[# w_id, ItemStat.EquipTime] = round(global.ItemIndex[# w_id, ItemStat.BaseEquipTime] * EQUIP_UPG);
                    oWeaponsTab.equip_upg.color = c_lime;
                    oWeaponsTab.ui_objects[13].color = c_lime;
                }
            } else {
                upg_data.equip = false; global.player_stats_struct.Diamonds += self.cost;
                global.ItemIndex[# w_id, ItemStat.EquipTime] = global.ItemIndex[# w_id, ItemStat.BaseEquipTime];
                oWeaponsTab.equip_upg.color = c_white;
                oWeaponsTab.ui_objects[13].color = c_white;
            }
            oWeaponsTab.equip_upg.caption = (upg_data.equip ? "-" : "+") + string_format((1 - EQUIP_UPG) * 100, 0, 1) + " % Equip speed";
            oWeaponsTab.diamonds.caption = string(global.player_stats_struct.Diamonds);
            oWeaponsTab.ui_objects[13].caption = "Equip time: " + string_format(global.ItemIndex[# w_id, ItemStat.EquipTime] / 60, 0, 1) + " s";
        }
    },
    movement: {
        cost: 2,
        callback: function() {
            var w_id = oWeaponsTab.wpn; var upg_data = global.built_upgrades[$ string(w_id)];
            if (upg_data.movement == false) {
                if (global.player_stats_struct.Diamonds >= self.cost) {
                    upg_data.movement = true; global.player_stats_struct.Diamonds -= self.cost;
                    global.ItemIndex[# w_id, ItemStat.MovingSpdMul] = min(global.ItemIndex[# w_id, ItemStat.BaseMovingSpdMul] * MV_UPG, 1);
                    oWeaponsTab.move_upg.color = c_lime;
                    oWeaponsTab.ui_objects[9].color = c_lime;
                }
            } else {
                upg_data.movement = false; global.player_stats_struct.Diamonds += self.cost;
                global.ItemIndex[# w_id, ItemStat.MovingSpdMul] = global.ItemIndex[# w_id, ItemStat.BaseMovingSpdMul];
                oWeaponsTab.move_upg.color = c_white;
                oWeaponsTab.ui_objects[9].color = c_white;
            }
            oWeaponsTab.move_upg.caption = (upg_data.movement ? "-" : "+") + string_format((MV_UPG - 1) * 100, 0, 1) + " % Movement speed";
            oWeaponsTab.diamonds.caption = string(global.player_stats_struct.Diamonds);
            oWeaponsTab.ui_objects[9].caption = "Movement speed: " + string_format(MOVE_SPD * global.ItemIndex[# w_id, ItemStat.MovingSpdMul], 0, 1) + " units/s";
        }
    },
    penetration: {
        cost: 2,
        callback: function() {
            var w_id = oWeaponsTab.wpn; var upg_data = global.built_upgrades[$ string(w_id)];
            if (upg_data.penetration == false) {
                if (global.player_stats_struct.Diamonds >= self.cost) {
                    upg_data.penetration = true; global.player_stats_struct.Diamonds -= self.cost;
                    global.ItemIndex[# w_id, ItemStat.PenetrationPower] = min(global.ItemIndex[# w_id, ItemStat.BasePenetrationPower] * PEN_UPG, 1);
                    oWeaponsTab.pen_upg.color = c_lime;
                    oWeaponsTab.ui_objects[11].color = c_lime;
                }
            } else {
                upg_data.penetration = false; global.player_stats_struct.Diamonds += self.cost;
                global.ItemIndex[# w_id, ItemStat.PenetrationPower] = global.ItemIndex[# w_id, ItemStat.BasePenetrationPower];
                oWeaponsTab.pen_upg.color = c_white;
                oWeaponsTab.ui_objects[11].color = c_white;
            }
            oWeaponsTab.pen_upg.caption = (upg_data.penetration ? "-" : "+") + string_format((PEN_UPG - 1) * 100, 0, 1) + " % Armor penetration";
            oWeaponsTab.diamonds.caption = string(global.player_stats_struct.Diamonds);
            oWeaponsTab.ui_objects[11].caption = "Penetration power: " + string_format(global.ItemIndex[# w_id, ItemStat.PenetrationPower] * 100, 0, 1) + " %";
        }
    },
    damage: {
        cost: 10,
        callback: function() {
            var w_id = oWeaponsTab.wpn; var upg_data = global.built_upgrades[$ string(w_id)];
            if (upg_data.damage == false) {
                if (global.player_stats_struct.Diamonds >= self.cost) {
                    upg_data.damage = true; global.player_stats_struct.Diamonds -= self.cost;
                    global.ItemIndex[# w_id, ItemStat.Damage] = global.ItemIndex[# w_id, ItemStat.BaseDamage] * DMG_UPG;
                    oWeaponsTab.dmg_upg.color = c_lime;
                    for(var i=4; i<=8; i++) oWeaponsTab.ui_objects[i].color = c_lime;
                }
            } else {
                upg_data.damage = false; global.player_stats_struct.Diamonds += self.cost;
                global.ItemIndex[# w_id, ItemStat.Damage] = global.ItemIndex[# w_id, ItemStat.BaseDamage];
                oWeaponsTab.dmg_upg.color = c_white;
                for(var i=4; i<=8; i++) oWeaponsTab.ui_objects[i].color = c_white;
            }
            var bd = global.ItemIndex[# w_id, ItemStat.Damage];
            oWeaponsTab.dmg_upg.caption = (upg_data.damage ? "-" : "+") + string_format((DMG_UPG - 1) * 100, 0, 1) + " % Base damage";
            oWeaponsTab.diamonds.caption = string(global.player_stats_struct.Diamonds);
            oWeaponsTab.ui_objects[4].caption = "Base damage: " + string_format(bd, 0, 1);
            oWeaponsTab.ui_objects[5].caption = "Body damage: " + string_format(bd * BODY_MULTIPLIER, 0, 1);
            oWeaponsTab.ui_objects[6].caption = "Head damage: " + string_format(bd * HEADSHOT_MULTIPLIER, 0, 1);
            oWeaponsTab.ui_objects[7].caption = "Arm damage: " + string_format(bd * ARM_MULTIPLIER, 0, 1);
            oWeaponsTab.ui_objects[8].caption = "Leg damage: " + string_format(bd * LEG_MULTIPLIER, 0, 1);
        }
    }
};

diamonds = zui_create(zui_get_width() * 0.025, zui_get_height() * .059, objUILabel);	
with(diamonds){
	color = c_white;
	sprite_scale = 2;
	font = set_font("Console");
	icon_sprite_index = spr_Coin;
	icon_image_index = 1;
	caption = string(global.player_stats_struct.Diamonds);
}

ui_objects[0] = zui_create(zui_get_width() * .25, zui_get_height() * .07, objUILabel);	
with(ui_objects[0]){
	color = MAIN_COLOR;
	font = set_font("Title");
	caption = other.wpn_string[0];
}

for(j = 1;j < array_length(ui_objects); j ++){
	ui_objects[j] = zui_create(stat_x, stat_y + text_height*j, objUILabel);	
	with(ui_objects[j]){
		color = c_white;
		font = set_font("Console");
		caption = other.wpn_string[other.j];
	}
}

with(wpn_desc){
	color = c_white;
	font = set_font("Console");
	caption = other.wpn_desc_txt;
	item_id = other.wpn;
	description = "Inventory";
	max_width = 350 * global.GUIMultiplier;
}

with(wpn_sprite){
	zui_set_size(sprite_get_width(spr_Items) * 2 * global.GUIMultiplier, sprite_get_height(spr_Items) * 2 * global.GUIMultiplier);
	sprite = spr_Items;
	clickable = false;
	sprite_image_index = oWeaponsTab.wpn;
	sprite_width_size = sprite_get_width(spr_Items) * 2 * global.GUIMultiplier;
	sprite_height_size = sprite_get_height(spr_Items) * 2 * global.GUIMultiplier;
}

with(img_lock){
	var lock = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.is_locked];
	zui_set_size(180 * global.GUIMultiplier, 180 * global.GUIMultiplier);
	zui_set_depth(lock ? -1000 : 1000);
	sprite = spr_Lock;
	clickable = false;
	drawable = other.is_locked;
	alpha = .9;
	sprite_image_index = 0;
	sprite_width_size = 180 * global.GUIMultiplier;
	sprite_height_size = 180 * global.GUIMultiplier;
}
with(img_lockbg){
	var lock = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.is_locked];
	zui_set_size(other.tab_width, other.tab_height);
	zui_set_depth(lock ? -1000 : 1000);
	sprite = spr_lockbg;
	drawable = other.is_locked;
	clickable = false;
	sprite_image_index = 0;
	sprite_width_size = other.tab_width;
	sprite_height_size = other.tab_height;
}
refresh_weapon_ui();



/***************************************************/

/* --- UI SETUP --- */
b_w = 96 * global.GUIMultiplier;
b_h = 32 * global.GUIMultiplier;
upg_gap = b_w * 1.25;
upg_x = zui_get_width() * .075;
upg1_y = zui_get_height() * .175;
upg2_y = zui_get_height() * .45;

// AMMO
ammo_upg = zui_create(upg_x, upg1_y, objUIButton);
ammo_cost = zui_create(upg_x, upg1_y - string_height("a")*2, objUILabel);
with(ammo_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(oWeaponsTab.upgrades.ammo.cost); }
with(ammo_upg){
    zui_set_size(oWeaponsTab.b_w, oWeaponsTab.b_h);
    var is_upg = global.built_upgrades[$ string(oWeaponsTab.wpn)].ammo;
    caption = (is_upg ? "-" : "+") + string((AMMO_UPG - 1) * 100) + " % Magazine capacity"; 
    if(is_upg) { color = c_lime; oWeaponsTab.ui_objects[1].color = c_lime; }
    callback = oWeaponsTab.upgrades.ammo.callback;
}

// RELOAD
reload_upg = zui_create(upg_x + upg_gap, upg1_y, objUIButton);
reload_cost = zui_create(upg_x + upg_gap, upg1_y - string_height("a")*2, objUILabel);
with(reload_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(oWeaponsTab.upgrades.reload.cost); }
with(reload_upg){
    zui_set_size(oWeaponsTab.b_w, oWeaponsTab.b_h);
    var is_upg = global.built_upgrades[$ string(oWeaponsTab.wpn)].reload;
    caption = (is_upg ? "-" : "+") + string_format((1 - RELOAD_UPG) * 100, 0, 1) + " % Reload speed";
    if(is_upg) { color = c_lime; oWeaponsTab.ui_objects[12].color = c_lime; }
    callback = oWeaponsTab.upgrades.reload.callback;
}

// EQUIP
equip_upg = zui_create(upg_x + upg_gap*2, upg1_y, objUIButton);
equip_cost = zui_create(upg_x + upg_gap*2, upg1_y - string_height("a")*2, objUILabel);
with(equip_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(oWeaponsTab.upgrades.equip.cost); }
with(equip_upg){
    zui_set_size(oWeaponsTab.b_w, oWeaponsTab.b_h);
    var is_upg = global.built_upgrades[$ string(oWeaponsTab.wpn)].equip;
    caption = (is_upg ? "-" : "+") + string_format((1 - EQUIP_UPG) * 100, 0, 1) + " % Equip speed";
    if(is_upg) { color = c_lime; oWeaponsTab.ui_objects[13].color = c_lime; }
    callback = oWeaponsTab.upgrades.equip.callback;
}

// MOVEMENT
move_upg = zui_create(upg_x, upg2_y, objUIButton);
move_cost = zui_create(upg_x, upg2_y - string_height("a")*2, objUILabel);
with(move_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(oWeaponsTab.upgrades.movement.cost); }
with(move_upg){
    zui_set_size(oWeaponsTab.b_w, oWeaponsTab.b_h);
    var is_upg = global.built_upgrades[$ string(oWeaponsTab.wpn)].movement;
    caption = (is_upg ? "-" : "+") + string_format((MV_UPG - 1) * 100, 0, 1) + " % Movement speed";
    if(is_upg) { color = c_lime; oWeaponsTab.ui_objects[9].color = c_lime; }
    callback = oWeaponsTab.upgrades.movement.callback;
}

// PENETRATION
pen_upg = zui_create(upg_x + upg_gap, upg2_y, objUIButton);
pen_cost = zui_create(upg_x + upg_gap, upg2_y - string_height("a")*2, objUILabel);
with(pen_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(oWeaponsTab.upgrades.penetration.cost); }
with(pen_upg){
    zui_set_size(oWeaponsTab.b_w, oWeaponsTab.b_h);
    var is_upg = global.built_upgrades[$ string(oWeaponsTab.wpn)].penetration;
    caption = (is_upg ? "-" : "+") + string_format((PEN_UPG - 1) * 100, 0, 1) + " % Armor penetration";
    if(is_upg) { color = c_lime; oWeaponsTab.ui_objects[11].color = c_lime; }
    callback = oWeaponsTab.upgrades.penetration.callback;
}

// DAMAGE
dmg_upg = zui_create(upg_x + upg_gap*2, upg2_y, objUIButton);
dmg_cost = zui_create(upg_x + upg_gap*2, upg2_y - string_height("a")*2, objUILabel);
with(dmg_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(oWeaponsTab.upgrades.damage.cost); }
with(dmg_upg){
    zui_set_size(oWeaponsTab.b_w, oWeaponsTab.b_h);
    var is_upg = global.built_upgrades[$ string(oWeaponsTab.wpn)].damage;
    caption = (is_upg ? "-" : "+") + string_format((DMG_UPG - 1) * 100, 0, 1) + " % Base damage";
    if(is_upg) { color = c_lime; for(var i=4; i<=8; i++) oWeaponsTab.ui_objects[i].color = c_lime; }
    callback = oWeaponsTab.upgrades.damage.callback;
}

/*****************************************************/


/* Arrows */
var arrow_w = 32 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .25 + arrow_w/1.95, zui_get_height() * .9, objUIButton)){
    zui_set_anchor(0.5, 0);
    zui_set_width(arrow_w);
    zui_set_height(16 * global.GUIMultiplier);
	zui_set_depth(-1001);
	caption = "->";
    callback = function(){
		with(oWeaponsTab){
	        wpn_index++;
	        if(wpn_index >= array_length(weapons)){
	            wpn_index = 0;
	        }
			refresh_weapon_ui();
		}
    };
}

with(zui_create(zui_get_width() * .25 - arrow_w/1.95, zui_get_height() * .9, objUIButton)){
    zui_set_anchor(0.5, 0);
    zui_set_width(arrow_w);
    zui_set_height(16 * global.GUIMultiplier);
	zui_set_depth(-1001);
	caption = "<-";
    callback = function(){
		with(oWeaponsTab){
	        wpn_index--;
	        if(wpn_index < 0){
	            wpn_index = array_length(weapons) - 1;
	        }
			refresh_weapon_ui();
		}
    };
}
/***************************************************/

/* GRAPHS */
dmg_graph_callback = function(){
	
	if(instance_exists(oWeaponsTab.range_graph)){
		with(oWeaponsTab.range_graph){
			zui_destroy();	
		}
	}
	
	if!(instance_exists(oWeaponsTab.dmg_graph)){
	oWeaponsTab.dmg_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);
	
	/*with(dmg_graph){
		zui_set_depth(-1000);
		scale = 10;
		var steps = ceil(global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Range] / scale) + 1;
		
		for(var i = 0; i < steps; i++){
			array_push(values_x, i*scale);	
		}
		
		var base_dmg = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Damage];
		var dmg_drop = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.damage_drop];
		for(var i = 0; i < array_length(values_x); i ++){
			array_push(values_y, base_dmg * power(1 - dmg_drop, values_x[i]));
		}
	}*/

	with(dmg_graph){
	    zui_set_depth(-1000);

	    values_x = [];
	    values_y = [];

	    var sample_step = 50;
	    var weapon_range = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Range];
	    var base_dmg = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Damage];
		var dmg_func = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.damage_drop];

	    var steps = ceil(weapon_range / sample_step) + 1;

	    for(var i = 0; i < steps; i++){
	        var dist = min(i * sample_step, weapon_range);
	        var damage = base_dmg;

	        if(is_callable(dmg_func) && !is_real(dmg_func)){
	            damage = dmg_func(dist);
	        }

	        array_push(values_x, dist);
	        array_push(values_y, base_dmg * damage);
	    }
	}
	
	}else{
		with(oWeaponsTab.dmg_graph){with(oWeaponsTab.dmg_graph){zui_destroy();}}
	}
};

range_graph_callback = function(){
	
	if(instance_exists(oWeaponsTab.dmg_graph)){
		with(oWeaponsTab.dmg_graph){
			zui_destroy();	
		}
	}
	
	
	if!(instance_exists(oWeaponsTab.range_graph)){
	oWeaponsTab.range_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);
	
	with(range_graph){
	    zui_set_depth(-1000);
	    values_x = [];
	    values_y = [];
	    var sample_step = 50;
	    var weapon_range = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Range];
	    var base_spread = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.Inaccuracy];
	    var accuracy_func = global.ItemIndex[# oWeaponsTab.wpn, ItemStat.accuracy_drop];

	    var steps = ceil(weapon_range / sample_step) + 1;

	    for(var i = 0; i < steps; i++){
	        var dist = min(i * sample_step, weapon_range);
	        var accuracy_modifier = 1.0;

	        if(is_callable(accuracy_func)){
	            accuracy_modifier = accuracy_func(dist);
	        }

	        array_push(values_x, dist);
	        array_push(values_y, (1.0 + (1.0 - accuracy_modifier)) * base_spread);
	    }
	}
	
	}else{
		with(oWeaponsTab.range_graph){with(oWeaponsTab.range_graph){zui_destroy();}}
	}
};

graph_x = r_x + text_height*5;
graph_y = r_y + text_height*3;
show_dmg_graph = zui_create(graph_x, graph_y, objUIButton);
with(show_dmg_graph){
    zui_set_size(oWeaponsTab.b_w*1.25, oWeaponsTab.b_h);
	caption = "Damage function";
    color = c_white;
    callback = oWeaponsTab.dmg_graph_callback;
}

show_range_graph = zui_create(graph_x, graph_y + text_height*3, objUIButton);
with(show_range_graph){
    zui_set_size(oWeaponsTab.b_w*1.25, oWeaponsTab.b_h);
	caption = "Accuracy function";
    color = c_white;
    callback = oWeaponsTab.range_graph_callback;
}


with(search_bar){
	zui_set_anchor(0, 0);
	zui_set_depth(-1001);
	init_text = other.wpn_string[0];
	max_string_length = 10;
	callback = function(){	
		var search_id = 0;
		for(var i = 0;i < array_length(oWeaponsTab.weapons); i++){
			if(string_pos(text, global.ItemIndex[# oWeaponsTab.weapons[i], ItemStat.Name]) > 0){
				search_id = i;
			}
		}
		
		oWeaponsTab.wpn_index = search_id;
			
		with(oWeaponsTab){
			refresh_weapon_ui();
		}
	}
}

with(search_txt){
	zui_set_depth(-1001);
	color = c_white;
	font = set_font("Console");
	caption = "Search weapon: ";
}

with (zui_create(0, 0, objUIWindowCaption)) {
	zui_set_depth(-1001);
	caption = "Weapon database";
	draggable = 1;
}






