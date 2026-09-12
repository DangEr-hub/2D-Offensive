event_inherited();
description_width = max(384 * global.gui_scale, 512);
description_height = max(192 * global.gui_scale, 256);

draw_set_font(set_font("GUI_small"));
zui_set_size(description_width, description_height);

cell_width = min(192 * global.gui_scale, 256);
offset_position_x = zui_get_width() * .05;
offset_position_y = zui_get_height() * .2;
grid_width = cell_width * 3.15;
grid_height = ITEM_CELL_HEIGHT * global.gui_scale * 2; 

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = oDraw.item_description;
	draggable = 1;
}

button_width = 128 * global.gui_scale;
button_height = 16 * global.gui_scale;
with(zui_create(zui_get_width() * .75, zui_get_height() - button_height*1.25, objUIButton)){
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

with(zui_create(zui_get_width() * .25, zui_get_height() - button_height*1.25, objUIButton)){
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

if(global.gui_scale < 2){
	offset_y = 32;
}

with(zui_create(offset_position_x, offset_position_y + offset_y, objUILabel)){
	zui_set_anchor(0, 0);
	font = set_font("GUI_grid");
	item_id = global.Inventory[#oDraw.var_slot, Index.slot_id];
	description = "Inventory";
	color = c_white;
	caption = global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.Description];
}
