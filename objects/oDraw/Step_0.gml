ViewX = camera_get_view_x(CAMERA);
ViewY = camera_get_view_y(CAMERA);

if(instance_exists(oPlayer)){
	bloom_threshold = .29;
	if(oPlayer.ToggleInfraVision == true){
		bloom_threshold = .35;
	}

	if(PauseMenu == true || RespawnMenu == true || GameEndMenu == true || show_weapon_attachments == true || instance_exists(oInventory) || global.my_console[? "active"] || oPlayer.player_can_shoot == false){
		window_set_cursor(cr_default);
	}else{
		window_set_cursor(cr_none);	
	}

	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyWeaponAttachments])){
		if(global.weapon_id[min(oPlayer.WeaponID, 2)] != Item.None && (!global.my_console[? "active"])){
			if(show_weapon_attachments == false){
				with(zui_main()){
					with(zui_create(zui_get_width() * .5, zui_get_height() * .87, oWeaponAttachments)){
						
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
				with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.55, oGameEndMenu, -1000)) {
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

	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPause]) && RespawnMenu == false){
		if(PauseMenu == false){
			pause(id);
			PauseMenu = true;	
		}else{
			unpause(id);
			PauseMenu = false;
		}
	}
}