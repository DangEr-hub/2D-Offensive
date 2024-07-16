event_inherited();
buy_menu_width = min(1152 * global.GUIMultiplier, 1856);
buy_menu_height = min(768 * global.GUIMultiplier, 896);

draw_set_font(set_font("Menu_small"));
zui_set_size(buy_menu_width, buy_menu_height);


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Buy time remaining: ";
	draggable = 1;
}

items = [Item.AKM, Item.m4a1, Item.SG550, Item.SSG08, Item.awm, Item.galil, Item.m4_carbine];
item_number = 7;
position_x = zui_get_width() * .1;
position_y = zui_get_height() * .1;
button_width = min(128 * global.GUIMultiplier, 192);
button_height = min(64 * global.GUIMultiplier, 96);
for(i=0;i<item_number;i++){
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIButton)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		caption_color = MAIN_COLOR;
		caption_offset_y = -other.button_height/4 - 8;
		caption = string(global.ItemIndex[#other.items[other.i], ItemStat.Name]) + " (" + string(global.ItemIndex[#other.items[other.i], ItemStat.Cost]) + ")";
	}
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIImage)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		item_variable = other.items[other.i]; buy_menu = true;
		clickable = true;
		sprite_image_index = other.items[other.i];
		sprite = spr_Items;
		sprite_width_size = other.button_width;
		sprite_height_size = other.button_height;
		callback = function(){
			buy_item(item_variable);
		};
	}
}

items = [Item.MAC11, Item.famas, Item.Spas, Item.None, Item.None, Item.None, Item.None];
position_x = zui_get_width() * .1 + button_width*1.1;
position_y = zui_get_height() * .1;
for(i=0;i<item_number;i++){
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIButton)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		caption_color = MAIN_COLOR;
		caption_offset_y = -32;
		caption = string(global.ItemIndex[#other.items[other.i], ItemStat.Name]) + " (" + string(global.ItemIndex[#other.items[other.i], ItemStat.Cost]) + ")";
	}
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIImage)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		item_variable = other.items[other.i]; buy_menu = true;
		clickable = false;
		sprite_image_index = other.items[other.i];
		sprite = spr_Items;
		sprite_width_size = other.button_width;
		sprite_height_size = other.button_height;
		callback = function(){
			buy_item(item_variable);
		};
	}
}

items = [Item.Glock, Item.usp, Item.DesertEagle, Item.p250, Item.None, Item.None, Item.None];
item_number = 7;
position_x = zui_get_width() * .1 + button_width*1.1*2;
position_y = zui_get_height() * .1;
for(i=0;i<item_number;i++){
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIButton)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		caption_color = MAIN_COLOR;
		caption_offset_y = -32;
		caption = string(global.ItemIndex[#other.items[other.i], ItemStat.Name]) + " (" + string(global.ItemIndex[#other.items[other.i], ItemStat.Cost]) + ")";
	}
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIImage)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		item_variable = other.items[other.i]; buy_menu = true;
		clickable = false;
		sprite_image_index = other.items[other.i];
		sprite = spr_Items;
		sprite_width_size = other.button_width;
		sprite_height_size = other.button_height;
		callback = function(){
			buy_item(item_variable);	
		};
	}
}

items = [Item.Javelin, Item.None, Item.None, Item.None, Item.None, Item.None, Item.None];
position_x = zui_get_width() * .1 + button_width*1.1*3;
position_y = zui_get_height() * .1;
for(i=0;i<item_number;i++){
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIButton)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		caption_color = MAIN_COLOR;
		caption_offset_y = -32;
		caption = string(global.ItemIndex[#other.items[other.i], ItemStat.Name]) + " (" + string(global.ItemIndex[#other.items[other.i], ItemStat.Cost]) + ")";
	}
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIImage)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		item_variable = other.items[other.i]; buy_menu = true;
		clickable = false;
		sprite_image_index = other.items[other.i];
		sprite = spr_Items;
		sprite_width_size = other.button_width;
		sprite_height_size = other.button_height;
		callback = function(){
			buy_item(item_variable);	
		};
	}
}

items = [Item.HEGrenade, Item.SmokeGrenade, Item.StickyGrenade, Item.FlashBangGrenade, Item.None, Item.None, Item.None];
position_x = zui_get_width() * .1 + button_width*1.1*4;
position_y = zui_get_height() * .1;
for(i=0;i<item_number;i++){
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIButton)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		caption_color = MAIN_COLOR;
		caption_offset_y = -32;
		caption = string(global.ItemIndex[#other.items[other.i], ItemStat.Name]) + " (" + string(global.ItemIndex[#other.items[other.i], ItemStat.Cost]) + ")";
	}
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIImage)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		item_variable = other.items[other.i]; buy_menu = true;
		clickable = false;
		sprite_image_index = other.items[other.i];
		sprite = spr_Items;
		sprite_width_size = other.button_width;
		sprite_height_size = other.button_height;
		callback = function(){
			buy_item(item_variable);	
		};
	}
}

items = [Item.KevlarHelm, Item.KevlarVest, Item.MilitaryHelm, Item.MilitaryVest, Item.SpecOpsHelm, Item.SpecOpsVest, Item.None];
position_x = zui_get_width() * .1 + button_width*1.1*5;
position_y = zui_get_height() * .1;
for(i=0;i<item_number;i++){
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIButton)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		caption_color = MAIN_COLOR;
		caption_offset_y = -32;
		caption = string(global.ItemIndex[#other.items[other.i], ItemStat.Name]) + " (" + string(global.ItemIndex[#other.items[other.i], ItemStat.Cost]) + ")";
	}
	with(zui_create(position_x, position_y + i*button_height*1.1, objUIImage)){
		zui_set_size(other.button_width, other.button_height);
		zui_set_anchor(0.5, 0);
		item_variable = other.items[other.i]; buy_menu = true;
		clickable = false;
		sprite_image_index = other.items[other.i];
		sprite = spr_Items;
		sprite_width_size = other.button_width;
		sprite_height_size = other.button_height;
		callback = function(){
			buy_item(item_variable);	
		};
	}
}