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