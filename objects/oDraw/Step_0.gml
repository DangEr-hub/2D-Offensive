ViewX = camera_get_view_x(CAM);
ViewY = camera_get_view_y(CAM);
global.GuiW = display_get_gui_width();
global.GuiH = display_get_gui_height();
global.local_player = get_local_player();

if(instance_exists(global.local_player)){
	
	#region Bird spawning
	if((!IS_NET || oNetworkManager.is_server) && percent_chance(0.25) && PauseMenu == false && RespawnMenu == false && GameEndMenu == false && instance_number(oBird) < 10){
		var birds = random_range(1, 2);
		var offset = 8;
		var areas = {
		    top:    [ViewX, ViewY - offset * 2, ViewX + global.CameraWidth, ViewY - offset],
		    left:   [ViewX - offset * 2, ViewY, ViewX - offset, ViewY + global.CameraHeight],
		    bottom: [ViewX, ViewY + global.CameraHeight + offset, ViewX + global.CameraWidth, ViewY + global.CameraHeight + offset * 2],
		    right:  [ViewX + global.CameraWidth + offset, ViewY, ViewX + global.CameraWidth + offset * 2, ViewY + global.CameraHeight]
		};
	

	
		repeat(birds){
			var area_key = choose("top", "left", "bottom", "right");
			var area = areas[$ area_key];
			var bird = instance_create_depth(random_range(area[0], area[2]), random_range(area[1], area[3]), -100, oBird);	

            if (IS_NET && oNetworkManager.is_server) {
                    server_process_bird_change(bird, 0);
            }
		}
	}
	#endregion
	
	#region Airplane spawn
	var chance = .05;
	if((!IS_NET || oNetworkManager.is_server) && percent_chance(chance) && PauseMenu == false && RespawnMenu == false && GameEndMenu == false){
		var offset = sprite_get_width(spr_AirPlane) * .5;
		var ao = 45;
		var areas = {
		    top:    [ViewX, ViewY - offset * 2, ViewX + global.CameraWidth, ViewY - offset, random_range(270 - ao, 270 + ao)],
		    left:   [ViewX - offset * 2, ViewY, ViewX - offset, ViewY + global.CameraHeight, random_range(-ao, +ao)],
		    bottom: [ViewX, ViewY + global.CameraHeight + offset, ViewX + global.CameraWidth, ViewY + global.CameraHeight + offset * 2, random_range(90 - ao, 90 + ao)],
		    right:  [ViewX + global.CameraWidth + offset, ViewY, ViewX + global.CameraWidth + offset * 2, ViewY + global.CameraHeight, random_range(180 - ao, 180 + ao)]
		};
	

	
		var area_key = choose("top", "left", "bottom", "right");
		var area = areas[$ area_key];
		
		var airplane = instance_create_depth(random_range(area[0], area[2]), random_range(area[1], area[3]), -1500, oAirPlane);	
		airplane.direction = area[4];
		airplane.image_angle = area[4];

        if (IS_NET && oNetworkManager.is_server) {
                //process airplane spawn
        }
	}
	#endregion

	if (bird_snd_timer > 0) {
	    bird_snd_timer--;
	} else {
	    var bird_sound = choose(snd_Bird1, snd_Bird2, snd_Bird3, snd_Bird4, snd_Bird5);
	    play_sound(global.local_player.x, global.local_player.y, bird_sound, global.local_player.id);
	    bird_snd_timer = irandom_range(game_get_speed(gamespeed_fps)*2, game_get_speed(gamespeed_fps) * 7);
	}
	
	bloom_threshold = .29;
	if(global.local_player.ToggleInfraVision == true){
		bloom_threshold = .35;
	}
	
	if(keyboard_check_pressed(global.KeyBinds[| KEY.Pause]) && RespawnMenu == false && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments) && !instance_exists(oBuyMenu) && !instance_exists(oMortarMenu)){
		if(PauseMenu == false){

			pause(id);
			PauseMenu = true;	
		}else{
			unpause(id);
			PauseMenu = false;
		}
	}
	
	if(keyboard_check_pressed(vk_escape)){
		if(global.local_player.player_can_shoot == false){
			global.local_player.player_can_shoot = true;
		}
		
		if(instance_exists(oMortarMenu)){
			with(oMortarMenu){
				zui_destroy();
			}
			global.local_player.moving_state = STATES_PLAYER.none_state;
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

	if(PauseMenu == true || RespawnMenu == true || GameEndMenu == true || show_weapon_attachments == true || instance_exists(oInventory) || global.my_console[? "active"] || global.local_player.player_can_shoot == false){
		window_set_cursor(cr_default);
	}else{
		window_set_cursor(cr_none);	
	}

	if(keyboard_check_pressed(global.KeyBinds[| KEY.WeaponAttachments])){
		if(global.Inventory[# global.local_player.WeaponID, Index.slot_id] != Item.None && (!global.my_console[? "active"]) && !instance_exists(oInventory) && PauseMenu == false &&
		!instance_exists(oBuyMenu)){
			if(show_weapon_attachments == false){
				with(zui_main()){
					with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
					}
				}
				global.local_player.Moving = false;
				global.local_player.Legs.image_speed = 0;
				global.local_player.RelativeSpeedX = 0;
				global.local_player.RelativeSpeedY = 0;
				global.local_player.player_can_shoot = false;
				show_weapon_attachments = true;
			}else{
				if(instance_exists(oWeaponAttachments)){
					with(oWeaponAttachments){
						zui_destroy();
					}
				}
				show_weapon_attachments = false;
				if!(instance_exists(oInventory)){
					global.local_player.player_can_shoot = true;	
				}
			}
		}
	}
	
	#region Buy menu
	if (!global.my_console[? "active"] && !instance_exists(oInventory) && global.local_player.moving_state != STATES_PLAYER.mortar_state && 
	keyboard_check_pressed(global.KeyBinds[| KEY.BuyMenu])) {
		if (instance_exists(oBuyMenu)) {
			global.local_player.player_can_shoot = true;
			with (oBuyMenuDescription) zui_destroy();
			with (oBuyMenu) zui_destroy();
		} else {
			global.local_player.player_can_shoot = false;
			with(oWeaponAttachments) zui_destroy();
			with (zui_main()) zui_create(zui_get_width()*.5, zui_get_height()*.5, oBuyMenu);
		}
	}
	#endregion


	if(RespawnMenu == true && alarm[0] == -1 && BackGround < 0){
		with(zui_main()){
			if(other.GameEndMenu == true && !instance_exists(oGameEndMenu)){
				zui_create(0, 0, objUIBlack, -1000);
				with (zui_create(zui_get_width() * 0.5, zui_get_height() * .5, oGameEndMenu, -1000)) {
					alpha_value = 0;
					alpha = global.GUIHUDAlpha * 2.25; 
					window_id = id;
				}
			}
			if(other.GameEndMenu == false && !instance_exists(oRoundEndMenu)){
				zui_create(0, 0, objUIBlack, -1000);
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