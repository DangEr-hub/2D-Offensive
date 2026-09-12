event_inherited();
armour_description_width = max(700 * global.gui_scale, 1080);
armour_description_height = max(192 * global.gui_scale, 256);

draw_set_font(set_font("GUI_small"));
zui_set_size(armour_description_width, armour_description_height);

cell_width = min(192 * global.gui_scale, 256);
offset_position_x = zui_get_width() * .01;
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
		with(oArmourDescription){
			zui_destroy();
		}
	};
}

with(zui_create(zui_get_width() * .25, zui_get_height() - button_height*1.25, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);	
	caption = "Unequip";
	if(oDraw.var_slot < OtherSlot.Primary){
		caption = "Equip";
	}	
	callback = function(){
		if(global.Inventory[#oDraw.var_slot, Index.SlotAmount] <= 1){
			with(oArmourDescription){
				zui_destroy();
			}
		}
		var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
		switch(global.ItemIndex[#Id, ItemStat.Type]){
				
			case "Helmet":
				
				if(oDraw.var_slot < OtherSlot.Helmet){
					
					#region Helmet equip
					var helmet_slot_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
					if (helmet_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Helmet")) {
						ItemAddWeight(global.Inventory[# oDraw.var_slot, Index.slot_id], helmet_slot_id);
						item_swap("item_use_position", OtherSlot.Helmet);
						helmet_slot_id = Item.None;
					} else if (global.ItemIndex[# Id, ItemStat.Type] == "Helmet") {
						ItemAddWeight(global.Inventory[# oDraw.var_slot, Index.slot_id], helmet_slot_id);
						item_swap("item_use_position", OtherSlot.Helmet);
					}
					#endregion
					
				}else{
				
					#region Helmet dequip
					gain_item(
						Id,
						global.Inventory[# oDraw.var_slot, Index.SlotAmount],
						global.Inventory[# oDraw.var_slot, Index.slot_ammo],
						global.Inventory[# oDraw.var_slot, Index.slot_clip_ammo],
						global.Inventory[# oDraw.var_slot, Index.slot_durability],
						global.Inventory[# oDraw.var_slot, Index.slot_scope],
						global.Inventory[# oDraw.var_slot, Index.slot_barrel],
						global.Inventory[# oDraw.var_slot, Index.slot_grip],
						global.Inventory[# oDraw.var_slot, Index.slot_suppressor],
						false
					);
					ItemAddWeight(Item.None, Id);
					item_swap("description_button", OtherSlot.Helmet);
					#endregion
				
				}
					
			break;  
				
			case "Armour":
				
				if(oDraw.var_slot < OtherSlot.Helmet){
					
					#region Armour equip
					var armour_slot_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
					if (armour_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Armour")) {
						ItemAddWeight(global.Inventory[# oDraw.var_slot, Index.slot_id], armour_slot_id);
						item_swap("item_use_position", OtherSlot.Armour);
						armour_slot_id = Item.None;
					} else if (global.ItemIndex[# Id, ItemStat.Type] == "Armour") {
						ItemAddWeight(global.Inventory[# oDraw.var_slot, Index.slot_id], armour_slot_id);
						item_swap("item_use_position", OtherSlot.Armour);
					}
					#endregion
					
				}else{
				
					#region Armour dequip
					gain_item(
						Id,
						global.Inventory[# oDraw.var_slot, Index.SlotAmount],
						global.Inventory[# oDraw.var_slot, Index.slot_ammo],
						global.Inventory[# oDraw.var_slot, Index.slot_clip_ammo],
						global.Inventory[# oDraw.var_slot, Index.slot_durability],
						global.Inventory[# oDraw.var_slot, Index.slot_scope],
						global.Inventory[# oDraw.var_slot, Index.slot_barrel],
						global.Inventory[# oDraw.var_slot, Index.slot_grip],
						global.Inventory[# oDraw.var_slot, Index.slot_suppressor],
						false
					);
					ItemAddWeight(Item.None, Id);
					item_swap("description_button", OtherSlot.Armour);
					#endregion
				
				}
					
			break;  
				
			case "Shield":
			
			
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
if(global.gui_scale < 2){
	description_position_x = offset_position_x;
	description_position_y = offset_position_y + grid_height;
}
with(zui_create(description_position_x, description_position_y, objUILabel)){
	zui_set_anchor(0, 0);
	font = set_font("GUI_grid");
	item_id = global.Inventory[#oDraw.var_slot, Index.slot_id];
	description = "Inventory";
	color = c_white;
	caption = global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.Description];
}
