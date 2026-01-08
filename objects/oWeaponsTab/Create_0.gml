event_inherited();
tab_width = 768 * global.GUIMultiplier;
tab_height = 512 * global.GUIMultiplier;
draw_set_font(set_font("Menu_small"));
zui_set_size(tab_width, tab_height);

stat_x = zui_get_width() * .5;
stat_y = zui_get_height() * .0175;
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
		var dmg_drop = global.ItemIndex[# wpn, ItemStat.DamageDrop];
		var max_range = global.ItemIndex[# wpn, ItemStat.Range];
		
		for(var i = 0; i < array_length(dist); i++){
		    dist[i] = round((i + 1) * max_range / array_length(dist));
		}

		for(var i = 0; i < array_length(dist); i++){
			var dmg = base_dmg * power(1 - dmg_drop, dist[i]);
			var part = string_format(dmg/base_dmg * 100, 0, 1) + "% (" + string(dist[i]) + " u)";

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
			"Penetration power: " + string_format(global.ItemIndex[# wpn, ItemStat.PenetrationPower] * 100, 0, 1) + "%",
			"Reload time: " + string_format(global.ItemIndex[# wpn, ItemStat.ReloadSpeed] / 60, 0, 1) + "s",
			"Kill reward: " + string(global.ItemIndex[# wpn, ItemStat.reward]),
			"Damage progress (1): " + dmg_drop_txt_1,
			"Damage progress (2): " + dmg_drop_txt_2,
			"Range spread increase: " + string_format(10000 * global.ItemIndex[# wpn, ItemStat.accuracy_drop], 0, 1) + "% per 100 units",
			"Maximal range: " + string_format(max_range, 0, 1) + " units",
			"Fire modes: " + fire_modes,
			"Class: " + string(get_wpn_type(wpn)),
			"Type: " + string(global.ItemIndex[# wpn, ItemStat.WeaponType]),
			"Moving spread increase: " + string_format(global.ItemIndex[# wpn, ItemStat.MovingInaccuracyMultiplier] * 100, 0, 1) + "%",
			"Kickback spread increase: " + string_format(global.ItemIndex[# wpn, ItemStat.KickBackInaccuracyMultiplier] * 100, 0, 1) + "% per shot",
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
		
		var zui_width = 0;
		with(oWeaponsTab){
			zui_width = zui_get_width();
		}
		
		with(ui_objects[0]){
			__x = zui_width * .25 - string_width(oWeaponsTab.wpn_string[0])/2;
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

	    if(instance_exists(img_lockbg)){
	        with(img_lockbg){ drawable = is_locked; }
	    }
	}
};

draw_set_font(set_font("Console"));
weapons = [Item.AKM, Item.MK18, Item.m4a1, Item.SG550, Item.galil, 
			Item.famas, Item.awm, Item.SSG08, Item.MAC11, Item.DesertEagle, Item.Glock, Item.usp, Item.p250, Item.tec9, Item.Spas,
			Item.Javelin
		  ];
wpn = weapons[0];


/* INIT */
img_lock = zui_create(c_x, c_y, objUIImage);
img_lockbg = zui_create(c_x, c_y, objUIImage);
wpn_sprite = zui_create(zui_get_width() * .25, zui_get_height() * .25, objUIImage);
wpn_desc = zui_create(zui_get_width() * .025, zui_get_height() * .45, objUILabel);
search_bar = zui_create(zui_get_width() * .675 + string_width("Search weapon: "), zui_get_height() * .075 - string_height("a")/2, objUITextInput);
search_txt = zui_create(zui_get_width() * .675, zui_get_height() * .075, objUILabel);

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
	zui_set_size(180 * global.GUIMultiplier, 180 * global.GUIMultiplier);
	zui_set_depth(-1000);
	sprite = spr_Lock;
	clickable = false;
	drawable = other.is_locked;
	alpha = .9;
	sprite_image_index = 0;
	sprite_width_size = 180 * global.GUIMultiplier;
	sprite_height_size = 180 * global.GUIMultiplier;
}
with(img_lockbg){
	zui_set_size(other.tab_width, other.tab_height);
	zui_set_depth(-1000);
	sprite = spr_lockbg;
	drawable = other.is_locked;
	clickable = false;
	sprite_image_index = 0;
	sprite_width_size = other.tab_width;
	sprite_height_size = other.tab_height;
}
refresh_weapon_ui();
/***************************************************/


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
		show_debug_message(oWeaponsTab.wpn_index);
			
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




