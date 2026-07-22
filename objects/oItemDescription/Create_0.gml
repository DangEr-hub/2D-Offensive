event_inherited();
item_description_width = max(896 * global.GUIMultiplier, 1080);
item_description_height = max(192 * global.GUIMultiplier, 256);

draw_set_font(set_font("GUI_small"));
zui_set_size(item_description_width, item_description_height);

cell_width = min(192 * global.GUIMultiplier, 256);
offset_position_x = zui_get_width() * .05;
offset_position_y = zui_get_height() * .2;
grid_width = cell_width * 3.15;
grid_height = ITEM_CELL_HEIGHT * global.GUIMultiplier * 2; 

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = oDraw.item_description;
	draggable = 1;
}

button_width = 128 * global.GUIMultiplier;
button_height = 16 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .5, zui_get_height() - button_height*1.25, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = function(){
		with(oItemDescription){
			zui_destroy();
		}
	};
}

with(zui_create(zui_get_width() * .35, zui_get_height() - button_height*1.25, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Use";
	callback = function(){
		if(global.Inventory[#oDraw.var_slot, Index.SlotAmount] <= 1){
			with(oItemDescription){
				zui_destroy();
			}
		}
		item_equip(oDraw.var_slot, "draw_varslot", global.local_player.WeaponID);
	};
}


with(zui_create(offset_position_x, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
	type = "Item description";
	cell_width = other.cell_width;
}

var offset_y = 0;

if(global.GUIMultiplier < 2){
	offset_y = 32;
}

with(zui_create(offset_position_x, offset_position_y + offset_y, objUILabel)){
	zui_set_anchor(0, 0);
	font = set_font("GUI_grid");
	description = "Inventory";
	color = c_white;
	caption = global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.Description];
}