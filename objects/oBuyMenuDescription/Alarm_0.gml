function calculate_damage_drop_stars(dmg_drop){
    var best  = global.ItemIndex[# Item.awm, ItemStat.DamageDrop];
    var worst = global.ItemIndex[# Item.Spas, ItemStat.DamageDrop];

    // logaritmická normalizace (lepší rozlišení low-endu)
    var t = (log10(worst) - log10(dmg_drop)) / (log10(worst) - log10(best));
    t = clamp(t, 0, 1);
    t = power(t, 0.8);

    return clamp(1 + floor(t * 4), 1, 5);
}


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = global.ItemIndex[#other.item_variable, ItemStat.Name];
	draggable = 1;
}

draw_set_font(set_font("GUI_grid"));
var text_gap = string_height("a")*1.19;
var start_x = zui_get_width() * .09;
var start_y = zui_get_height() * .1;

with(zui_create(start_x, start_y + text_gap*4, objUILabel)){
	zui_set_anchor(0, 0);
	item_id = other.item_variable;
	font = set_font("GUI_grid");
	color = c_white;
	description = "Buy_menu";
}

if(global.ItemIndex[#other.item_variable, ItemStat.Type] == "Weapon"){

	#region Difficulty
	with(zui_create(start_x, start_y, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Difficulty: ";
	}

	for(var i=0;i<global.ItemIndex[#item_variable, ItemStat.difficulty];i++){
		with(zui_create(start_x + string_width("Difficulty:")*1.25 + (i*32), start_y, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion

	#region Damage
	var base_damage = global.ItemIndex[#item_variable, ItemStat.Damage];
	var damage_rating = min(ceil(.07 * (base_damage - 1)), 5);
	with(zui_create(start_x, start_y + text_gap, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Damage: ";
	}

	for(var i=0;i<damage_rating;i++){
		with(zui_create(start_x + string_width("Damage: ")*1.25 + (i*32), start_y + text_gap, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion

	#region Penetration power
	var base_penetration_power = global.ItemIndex[#item_variable, ItemStat.PenetrationPower];
	var penetration_power = ceil(clamp(((base_penetration_power - 0.5) / 0.5) * 4 + 1, 0, 5));
	with(zui_create(start_x, start_y + text_gap*2, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Penetration: ";
	}

	for(var i=0;i<penetration_power;i++){
		with(zui_create(start_x + string_width("Penetration:")*1.25 + (i*32), start_y + text_gap*2, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion	
	
	#region Damage drop
	var base_damage_drop = global.ItemIndex[#item_variable, ItemStat.DamageDrop];
	var damage_drop = calculate_damage_drop_stars(base_damage_drop);
	with(zui_create(start_x, start_y + text_gap*3, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Damage dropoff: ";
	}
	
	if(global.ItemIndex[#item_variable, ItemStat.Damage] > 0){
		for(var i=0;i<damage_drop;i++){
			with(zui_create(start_x + string_width("Damage dropoff:")*1.25 + (i*32), start_y + text_gap*3, objUIImage)){
				zui_set_size(64, 64);
				sprite = spr_difficulty_star;
				sprite_image_index = 0
				sprite_width_size = 64;
				sprite_height_size = 64;
			}
		}
	}
	#endregion
	
	#region Range
	function range_to_stars(_range){
	    if(_range >= 850){return 5;}
	    if(_range >= 770){return 4;}
	    if(_range >= 600){return 3;}
	    if(_range >= 550){return 2;}
	    return 1;
	}
	
	var base_range = global.ItemIndex[#item_variable, ItemStat.Range];
	var range = range_to_stars(base_range);
	with(zui_create(start_x, start_y + text_gap*4, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Range: ";
	}

	for(var i=0;i<range;i++){
		with(zui_create(start_x + string_width("Range:")*1.25 + (i*32), start_y + text_gap*4, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion
	
	#region Type
	with(zui_create(start_x, start_y + text_gap*5, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		
		var type = get_wpn_type(other.item_variable);
		
		caption = "Class: " + type;
	}
	#endregion

	#region Price
	with(zui_create(start_x, start_y + text_gap*6, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Price: " + string(global.ItemIndex[#other.item_variable, ItemStat.Cost]);
	}

	with(zui_create(start_x + string_width( "Price: " + string(global.ItemIndex[#other.item_variable, ItemStat.Cost]))*1.25+8, start_y + text_gap*6.79, objUIImage)){
		zui_set_size(64, 64);
		sprite = spr_Coin;
		sprite_image_index = 0
		sprite_width_size = 32;
		sprite_height_size = 32;
	}
	#endregion

}else if(global.ItemIndex[#other.item_variable, ItemStat.Type] == "Armour" || 
global.ItemIndex[#other.item_variable, ItemStat.Type] == "Helmet" ||
global.ItemIndex[#other.item_variable, ItemStat.Type] == "Shield"){
	
	
	#region Armour
	var base_armour = global.ItemIndex[#item_variable, ItemStat.Defense];
	var armour_value = ceil(clamp((1 - (base_armour - 0.59) / 0.41) * 4 + 1, 1, 5));
	with(zui_create(start_x, start_y, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Armour: ";
	}

	for(var i=0;i<armour_value;i++){
		with(zui_create(start_x + string_width("Armour: ")*1.25 + (i*32), start_y, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion
	
	#region Price
	with(zui_create(start_x, start_y + text_gap, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Price: " + string(global.ItemIndex[#other.item_variable, ItemStat.Cost]);
	}

	with(zui_create(start_x + string_width( "Price: " + string(global.ItemIndex[#other.item_variable, ItemStat.Cost]))*1.25+8, start_y + text_gap*1.79, objUIImage)){
		zui_set_size(64, 64);
		sprite = spr_Coin;
		sprite_image_index = 0
		sprite_width_size = 32;
		sprite_height_size = 32;
	}
	#endregion
	
}else{
	
	#region Damage drop
	var base_damage_drop = global.ItemIndex[#item_variable, ItemStat.DamageDrop];
	var damage_drop = calculate_damage_drop_stars(base_damage_drop);
	with(zui_create(start_x, start_y + text_gap*3, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Damage dropoff: ";
	}
	
	for(var i=0;i<damage_drop;i++){
		with(zui_create(start_x + string_width("Damage dropoff:")*1.25 + (i*32), start_y + text_gap*3, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion

	#region Damage
	var base_damage = global.ItemIndex[#item_variable, ItemStat.Damage];
	var damage_rating = min(ceil(.07 * (base_damage - 1)), 5);
	with(zui_create(start_x, start_y + text_gap, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Damage: ";
	}

	for(var i=0;i<damage_rating;i++){
		with(zui_create(start_x + string_width("Damage: ")*1.25 + (i*32), start_y + text_gap, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion

	#region Penetration power
	var base_penetration_power = global.ItemIndex[#item_variable, ItemStat.PenetrationPower];
	var penetration_power = ceil(clamp(((base_penetration_power - 0.5) / 0.5) * 4 + 1, 0, 5));
	with(zui_create(start_x, start_y + text_gap*2, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Penetration: ";
	}

	for(var i=0;i<penetration_power;i++){
		with(zui_create(start_x + string_width("Penetration:")*1.25 + (i*32), start_y + text_gap*2, objUIImage)){
			zui_set_size(64, 64);
			sprite = spr_difficulty_star;
			sprite_image_index = 0
			sprite_width_size = 64;
			sprite_height_size = 64;
		}
	}
	#endregion

	#region Price
	with(zui_create(start_x, start_y + text_gap*4, objUILabel)){
		zui_set_anchor(0, 0);
		font = set_font("GUI_grid");
		color = c_white;
		caption = "Price: " + string(global.ItemIndex[#other.item_variable, ItemStat.Cost]);
	}

	with(zui_create(start_x + string_width( "Price: " + string(global.ItemIndex[#other.item_variable, ItemStat.Cost]))*1.25+8, start_y + text_gap*4.79, objUIImage)){
		zui_set_size(64, 64);
		sprite = spr_Coin;
		sprite_image_index = 0
		sprite_width_size = 32;
		sprite_height_size = 32;
	}
	#endregion
}

