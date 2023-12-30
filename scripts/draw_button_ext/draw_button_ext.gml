// draw_button_ext(x, y, width, height, text, normal_color, hover_color)
function draw_button_ext(xx, yy, b_width, b_height, text, normal_color, hover_color, type) {
    
    // Check if mouse is over the button
    var mouse_over = mouse_to_gui(xx, yy, xx + b_width, yy + b_height);
	
    // Draw button outline
    var outlineWidth = 1; // Adjust the width of the outline as per your requirement
	draw_set_alpha(2 * global.GUIHUDAlpha);
    draw_set_color(c_black); // Set the color of the outline
    draw_rectangle(xx - outlineWidth, yy - outlineWidth, xx + b_width + outlineWidth, yy + b_height + outlineWidth, false);
    
	
	draw_set_color(mouse_over ? hover_color : normal_color);
    draw_rectangle(xx, yy, xx + b_width, yy + b_height, false);
    
    // Draw text
	draw_set_alpha(1);
    draw_set_font(set_font("GUI_button"));
    draw_set_color(c_white);
    var b_text_width = string_width(text);
    draw_text(xx + (b_width - b_text_width) / 2, yy + b_height/2, text);
	draw_set_font(set_font("Console"));
    
    // Check for click
    if (mouse_over && mouse_check_button_pressed(mb_left)) {
		switch(type){
			case "description_exit":
				if(instance_exists(oSlot)){
					oSlot.DrawItemInfo = false;
				}
				if(instance_exists(oDraw)){
					oDraw.DrawInfo = false;
				}
			break;
			
			case "pause_exit":
				if(instance_exists(oDraw)){
					oDraw.PopupWindow = "game_end";
				}
			break;
			
			case "pause_exit_yes":
				save_game();
				game_end();
			break;
			
			case "pause_exit_no":
				if(instance_exists(oDraw)){
					oDraw.PopupWindow = "";
				}
			break;
			
			case "player_death_screen_continue":
				if(instance_exists(oDraw)){
					if(oDraw.PopupWindow == ""){
						if(sprite_exists(BackGround) && BackGround != -1){sprite_delete(BackGround);}
						save_game();
						room_restart();
					}
				}
			break;
			
			case "player_death_screen_toggle_message":
				if(instance_exists(oDraw)){
					if(oDraw.PopupWindow == ""){
						oDraw.Alpha = 0;
						oDraw.ToggleMessage = !oDraw.ToggleMessage;
					}
				}
			break;
			
			case "description_drop":
				if(instance_exists(oDraw) && instance_exists(oSlot)){
					ItemDrop(global.Inventory[#VarSlot, InventoryIndex.SlotID], oPlayer.x, oPlayer.y, 100, global.Inventory[#VarSlot, InventoryIndex.SlotAmmo], global.Inventory[#VarSlot, InventoryIndex.SlotClipAmmo], global.Inventory[#VarSlot, InventoryIndex.SlotDurability], 1);	
					ItemAmountSubstract(VarSlot, 1);
				}
			break;
			
			case "weapon_scope_dequip":
				GainItem(
					global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope],
					1,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					false
				);
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope] = Item.None;
			break;
			
			case "weapon_barrel_dequip":
				GainItem(
					global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_barrel],
					1,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					false
				);
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_barrel] = Item.None;
			break;

			case "weapon_grip_dequip":
				GainItem(
					global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_grip],
					1,
					0,
					0,
					0,
					0,
					0,
					0,
					0, 
					false
				);
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_grip] = Item.None;
			break;
			
			case "weapon_suppressor_dequip":
				GainItem(
					global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_suppressor],
					1,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					false
				);
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_suppressor] = Item.None;
			break;
		}
    }
}