ViewX = camera_get_view_x(CAMERA);
ViewY = camera_get_view_y(CAMERA);

if(instance_exists(oPlayer)){
	bloom_threshold = .29;
	if(oPlayer.ToggleInfraVision == true){
		bloom_threshold = .35;
	}
	
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPause]) && RespawnMenu == false && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments) && !instance_exists(oBuyMenu)){
		if(PauseMenu == false){
			pause(id);
			PauseMenu = true;	
		}else{
			unpause(id);
			PauseMenu = false;
		}
	}
	
	if(keyboard_check_pressed(vk_escape)){
		if(oPlayer.player_can_shoot == false){
			oPlayer.player_can_shoot = true;
		}
		if(instance_exists(oBuyMenu)){
			if(instance_exists(oBuyMenuDescription)){
				with(oBuyMenuDescription){
					zui_destroy();
				}
			}
			with(oBuyMenu){
				zui_destroy();
			}
		}
		if(instance_exists(oInventory)){
			instance_destroy(oInventory);
			instance_destroy(oSlot);
		}
		if(instance_exists(oWeaponAttachments)){
			show_weapon_attachments = false;
			with(oWeaponAttachments){
				zui_destroy();
			}
		}
		item_description_destroy();
	}

	if(PauseMenu == true || RespawnMenu == true || GameEndMenu == true || show_weapon_attachments == true || instance_exists(oInventory) || global.my_console[? "active"] || oPlayer.player_can_shoot == false){
		window_set_cursor(cr_default);
	}else{
		window_set_cursor(cr_none);	
	}

	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyWeaponAttachments])){
		if(global.weapon_id[min(oPlayer.WeaponID, 1)] != Item.None && (!global.my_console[? "active"]) && !instance_exists(oInventory) && PauseMenu == false){
			if(show_weapon_attachments == false){
				with(zui_main()){
					with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
					}
				}
				oPlayer.Moving = false;
				oPlayer.Legs.image_speed = 0;
				oPlayer.RelativeSpeedX = 0;
				oPlayer.RelativeSpeedY = 0;
				oPlayer.player_can_shoot = false;
				show_weapon_attachments = true;
			}else{
				if(instance_exists(oWeaponAttachments)){
					with(oWeaponAttachments){
						zui_destroy();
					}
				}
				show_weapon_attachments = false;
				if!(instance_exists(oInventory)){
					oPlayer.player_can_shoot = true;	
				}
			}
		}
	}


	if(RespawnMenu == true && BackGround == -1 && alarm[0] == -1){
		with(zui_main()){
			if(other.GameEndMenu == true){
				with (zui_create(zui_get_width() * 0.5, zui_get_height() * .5, oGameEndMenu, -1000)) {
					alpha_value = 0;
					alpha = global.GUIHUDAlpha * 2.25; 
					window_id = id;
				}
			}else{
				with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oRoundEndMenu, -1000)) {
					alpha_value = 0;
					alpha = global.GUIHUDAlpha * 2.25; 
					window_id = id;
				}
			}
		}
		alarm[0] = 1;
	}
}