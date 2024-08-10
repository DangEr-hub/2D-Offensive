event_inherited();
weapon_description_width = max(896 * global.GUIMultiplier, 1080);
weapon_description_height = max(192 * global.GUIMultiplier, 256);

draw_set_font(set_font("Menu_small"));
zui_set_size(weapon_description_width, weapon_description_height);

cell_width = min(192 * global.GUIMultiplier, 256);
offset_position_x = zui_get_width() * .05;
offset_position_y = zui_get_height() * .2;
grid_width = cell_width * 3.15;
grid_height = ITEM_CELL_HEIGHT * global.GUIMultiplier * 3; 

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
		with(oWeaponDescription){
			zui_destroy();
		}
	};
}

with(zui_create(zui_get_width() * .35, zui_get_height() - button_height*1.25, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Dequip";
	if(oDraw.var_slot < OtherSlot.Primary){
		caption = "Equip";
	}
	callback = function(){
		if(global.Inventory[#oDraw.var_slot, Index.SlotAmount] <= 1){
			with(oWeaponDescription){
				zui_destroy();
			}
		}
		var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
		switch(global.ItemIndex[#Id, ItemStat.Type]){
				
			case "Weapon":
			
			#region Primary equip and dequip
			var primary_slot_id = global.Inventory[# OtherSlot.Primary, Index.slot_id];
			if (primary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Primary")) {
				item_swap("item_use_position", OtherSlot.Primary);
				primary_slot_id = Item.None;
			} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Primary") {
				item_swap("item_use_position", OtherSlot.Primary);
			}
			#endregion
				
			#region Secondary equip and dequip
			var secondary_slot_id = global.Inventory[# OtherSlot.Secondary, Index.slot_id];
			if (secondary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Secondary")) {
				item_swap("item_use_position", OtherSlot.Secondary);
				secondary_slot_id = Item.None;
			} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Secondary") {
				item_swap("item_use_position", OtherSlot.Secondary);
			}
			#endregion
				
			break;
		}
	};
}


with(zui_create(offset_position_x, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
	type = "Weapon description";
	cell_width = other.cell_width;
}

var description_position_x = offset_position_x + grid_width;
var description_position_y = offset_position_y;
if(global.GUIMultiplier <= 1){
	description_position_y = offset_position_y * 1.25;
}
with(zui_create(description_position_x, description_position_y, objUILabel)){
	zui_set_anchor(0, 0);
	font = set_font("GUI_grid");
	description = "Inventory";
	color = c_white;
	caption = global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.Description];
}