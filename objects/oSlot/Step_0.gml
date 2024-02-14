/// @description Insert description here
// You can write your code in this editor
var xx1 = (global.InventoryLeftTopCorner[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
var yy1 = (global.InventoryLeftTopCorner[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
var xx2 = (global.InventoryRightBottomCorner[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
var yy2 = (global.InventoryRightBottomCorner[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
if!(mouse_to_gui(xx1, yy1, xx2, yy2)){
	if(mouse_check_button_pressed(mb_right) && global.MouseSlot[#0, InventoryIndex.SlotID] != Item.None){
		ItemDrop(
			global.MouseSlot[# 0, InventoryIndex.SlotID],
			oPlayer.x,
			oPlayer.y,
			100,
			global.MouseSlot[# 0, InventoryIndex.SlotAmmo],
			global.MouseSlot[# 0, InventoryIndex.SlotClipAmmo],
			global.MouseSlot[# 0, InventoryIndex.SlotDurability],
			global.MouseSlot[# 0, InventoryIndex.SlotAmount]
		);	
		
		for(i=0;i<ds_grid_height(global.MouseSlot);i++){
			global.MouseSlot[# 0, i] = 0;
		}
	}
}


if(VarSlot == oPlayer.ItemUsePosition){
    image_index = 1;
}else{
    image_index = 0;
}

if(global.Inventory[#VarSlot, InventoryIndex.SlotID] == Item.None){
	DrawItemInfo = false;
}

if(DrawItemInfo == true){
	if(oDraw.DrawInfo == false){
		var Id = global.Inventory[#VarSlot, InventoryIndex.SlotID];
		if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){
			oDraw.var_slot = VarSlot;
			oDraw.item_description = global.ItemIndex[#Id, ItemStat.Name];
			item_description_destroy();
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oArmourDescription)){
					alpha = global.GUIHUDAlpha * 3;
				}
			}
		}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item" || global.ItemIndex[#Id, ItemStat.Type] == "Grenade"){
			oDraw.var_slot = VarSlot;
			oDraw.item_description = global.ItemIndex[#Id, ItemStat.Name];
			item_description_destroy();
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oItemDescription)){
					alpha = global.GUIHUDAlpha * 3;
				}
			}
		}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
			oDraw.var_slot = VarSlot;
			oDraw.item_description = global.ItemIndex[#Id, ItemStat.Name];
			item_description_destroy();
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oWeaponDescription)){
					alpha = global.GUIHUDAlpha * 3;
				}
			}
		}
		oDraw.DrawInfo = true;	
	}
}				