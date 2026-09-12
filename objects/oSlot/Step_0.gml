/// @description Insert description here
// You can write your code in this editor
var xx1 = (global.InventoryLeftTopCorner[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
var yy1 = (global.InventoryLeftTopCorner[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
var xx2 = (global.InventoryRightBottomCorner[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
var yy2 = (global.InventoryRightBottomCorner[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
var xx12 = (global.InventoryEquipLeftTopCorner[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
var yy12 = (global.InventoryEquipLeftTopCorner[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
var xx22 = (global.InventoryEquipRightBottomCorner[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
var yy22 = (global.InventoryEquipRightBottomCorner[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);

if!(mouse_to_gui(xx1, yy1, xx2, yy2) || mouse_to_gui(xx12, yy12, xx22, yy22)){
	
	if(mouse_check_button_pressed(mb_right) && global.MouseSlot[# 0, Index.slot_id] != Item.None){
		request_item_drop(
			global.MouseSlot[# 0, Index.slot_id],
			global.local_player.x,
			global.local_player.y,
			global.MouseSlot[# 0, Index.slot_ammo],
			global.MouseSlot[# 0, Index.slot_clip_ammo],
			global.MouseSlot[# 0, Index.slot_durability],
			global.MouseSlot[# 0, Index.SlotAmount],
			global.MouseSlot[# 0, Index.slot_scope],
			global.MouseSlot[# 0, Index.slot_barrel],
			global.MouseSlot[# 0, Index.slot_grip],
			global.MouseSlot[# 0, Index.slot_suppressor],
		);	
		
		for(var i=0;i<ds_grid_height(global.MouseSlot);i++){
			global.MouseSlot[# 0, i] = 0;
		}
	}
}

switch(VarSlot){
	case OtherSlot.Primary:
		image_index = 2;
	break;
	
	case OtherSlot.Secondary:
		image_index = 3;
	break;
	
	case OtherSlot.Knife:
		image_index = 4;
	break;
	
	case OtherSlot.Helmet:
		image_index = 5;
	break;
	
	case OtherSlot.Armour:
		image_index = 6;
	break;
	
	case OtherSlot.Shield:
		image_index = 7;
	break;
}

if(global.Inventory[#VarSlot, Index.slot_id] == Item.None){
	DrawItemInfo = false;
}

if(DrawItemInfo == true){
	if(oDraw.DrawInfo == false){
		var Id = global.Inventory[#VarSlot, Index.slot_id];
		if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet" || global.ItemIndex[#Id, ItemStat.Type] == "Shield"){
			oDraw.var_slot = VarSlot;
			oDraw.item_description = global.ItemIndex[#Id, ItemStat.Name];
			item_description_destroy();
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oArmourDescription)){
					alpha = global.GUIHUDAlpha * 3;
				}
			}
		}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item"){
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
		}else if(global.ItemIndex[#Id, ItemStat.Type] == "Grenade" || global.ItemIndex[#Id, ItemStat.Type] == "Landmine"
		 || global.ItemIndex[#Id, ItemStat.Type] == "Bomb"){
			oDraw.var_slot = VarSlot;
			oDraw.item_description = global.ItemIndex[#Id, ItemStat.Name];
			item_description_destroy();
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oUsableItemDescription)){
					alpha = global.GUIHUDAlpha * 3;
				}
			}
		}
		oDraw.DrawInfo = true;	
	}
}				