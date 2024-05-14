with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = global.ItemIndex[#other.item_variable, ItemStat.Name];
	draggable = 1;
}

draw_set_font(set_font("GUI_grid"));
var text_gap = string_height("a")*1.19;
var start_x = zui_get_width() * .09;
var start_y = zui_get_height() * .1;

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