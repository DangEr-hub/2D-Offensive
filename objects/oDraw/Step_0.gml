ViewX = camera_get_view_x(CAMERA);
ViewY = camera_get_view_y(CAMERA);


if(instance_exists(oPlayer)){
	
	#region Bird spawning
	if(percent_chance(0.5) && PauseMenu == false && RespawnMenu == false && GameEndMenu == false){
		var birds = random_range(1, 3);
		var offset = 8;
		var areas = {
		    top:    [ViewX - offset, ViewY - offset * 2, ViewX + global.CameraWidth, ViewY - offset],
		    left:   [ViewX - offset * 2, ViewY, ViewX - offset, ViewY + global.CameraHeight],
		    bottom: [ViewX - offset, ViewY + global.CameraHeight - offset * 2, ViewX + global.CameraWidth, ViewY + global.CameraHeight - offset],
		    right:  [ViewX + global.CameraWidth - offset * 2, ViewY, ViewX + global.CameraWidth - offset, ViewY + global.CameraHeight]
		};
	

	
		repeat(birds){
			var area_key = choose("top", "left", "bottom", "right");
			var area = areas[$ area_key];
			instance_create_depth(random_range(area[0], area[2]), random_range(area[1], area[3]), -100, oBird);	
		}
	}
	#endregion

	if (bird_snd_timer > 0) {
	    bird_snd_timer--;
	} else {
	    var bird_sound = choose(snd_Bird1, snd_Bird2, snd_Bird3, snd_Bird4, snd_Bird5);
	    play_sound(oPlayer.x, oPlayer.y, bird_sound, oPlayer.id);
	    bird_snd_timer = irandom_range(game_get_speed(gamespeed_fps)*2, game_get_speed(gamespeed_fps) * 7);
	}
	
	bloom_threshold = .29;
	if(oPlayer.ToggleInfraVision == true){
		bloom_threshold = .35;
	}
	
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPause]) && RespawnMenu == false && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments) && !instance_exists(oBuyMenu) && !instance_exists(oMortarMenu)){
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
		
		if(instance_exists(oMortarMenu)){
			with(oMortarMenu){
				zui_destroy();
			}
			oPlayer.moving_state = player_states.none_state;
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
		if(global.Inventory[# oPlayer.WeaponID, Index.slot_id] != Item.None && (!global.my_console[? "active"]) && !instance_exists(oInventory) && PauseMenu == false){
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