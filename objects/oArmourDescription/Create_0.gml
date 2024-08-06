event_inherited();
armour_description_width = max(896 * global.GUIMultiplier, 1080);
armour_description_height = max(192 * global.GUIMultiplier, 256);

draw_set_font(set_font("Menu_small"));
zui_set_size(armour_description_width, armour_description_height);

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
		with(oArmourDescription){
			zui_destroy();
		}
	};
}

with(zui_create(zui_get_width() * .35, zui_get_height() - button_height*1.25, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Equip";
	callback = function(){
		if(global.Inventory[#oDraw.var_slot, Index.SlotAmount] <= 1){
			with(oArmourDescription){
				zui_destroy();
			}
		}
		var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
		switch(global.ItemIndex[#Id, ItemStat.Type]){
				
			case "Helmet":
				
				#region Helmet use
				if(global.ArmourID[1] == Item.None){
					oPlayer.EquipmentAlpha = global.GUIHUDAlpha;
					global.ArmourID[1] = global.Inventory[# oDraw.var_slot, Index.slot_id];
					global.ArmourDurability[1] = global.Inventory[# oDraw.var_slot, Index.SlotDurability];
					ItemAddWeight(oDraw.var_slot);
					ItemAmountSubstract(oDraw.var_slot, 1);
				}
				#endregion
					
			break;  
				
			case "Armour":
				
				#region Armour use
				if(global.ArmourID[0] == Item.None){
					oPlayer.EquipmentAlpha = global.GUIHUDAlpha;
					global.ArmourID[0] = global.Inventory[# oDraw.var_slot, Index.slot_id];
					global.ArmourDurability[0] = global.Inventory[# oDraw.var_slot, Index.SlotDurability];
					ItemAddWeight(oDraw.var_slot);
					ItemAmountSubstract(oDraw.var_slot, 1);
				}
				#endregion
					
			break;  
				
			case "Shield":
				
				ItemAmountSubstract(oDraw.var_slot, 1);
					
			break;
		}
	};
}

with(zui_create(offset_position_x, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
	type = "Armour description";
	cell_width = other.cell_width;
}

var description_position_x = offset_position_x + grid_width;
var description_position_y = offset_position_y;
if(global.GUIMultiplier < 2){
	description_position_x = offset_position_x;
	description_position_y = offset_position_y + grid_height;
}
with(zui_create(description_position_x, description_position_y, objUILabel)){
	zui_set_anchor(0, 0);
	font = set_font("GUI_grid");
	description = "Inventory";
	color = c_white;
	caption = global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.Description];
}