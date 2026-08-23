ViewX = camera_get_view_x(CAM);
ViewY = camera_get_view_y(CAM);
global.GuiW = display_get_gui_width();
global.GuiH = display_get_gui_height();
global.local_player = get_local_player();

var audio_listener_target = get_audio_listener_target();
if (instance_exists(audio_listener_target)) {
	audio_listener_position(audio_listener_target.x, audio_listener_target.y, 0);
}

#region Bomb timer
var has_bomb_authority = !IS_NET || oNetworkManager.is_server;
if (has_bomb_authority && global.bomb_planted) {
	var bomb_round_resolved = IS_NET && oNetworkManager.round_resolved;
	if (bomb_round_resolved) {
		global.bomb_planted = false;
		global.bomb_timer = 0;
		global.bomb_planter_pid = -1;
		with (oBomb) {
			instance_destroy();
		}
	} else {
		global.bomb_timer = max(0, global.bomb_timer - 1);
	}

	if (global.bomb_planted && global.bomb_timer <= 0) {
		bomb_detonation_pending = true;
		global.bomb_planted = false;
		var exploded_bomb_planter_pid = global.bomb_planter_pid;

		with (oBomb) {
			explosion_create(
				32,
				[x, y],
				500,
				false,
				noone,
				stats.Item_id,
				2,
				max(power(500 / 10, 2), 256),
				{
					owner_id: exploded_bomb_planter_pid,
					owner_name: "Bomb",
					object_index: oBomb
				},
				5
			);
			image_alpha = 0;
			instance_destroy();
		}
		global.bomb_planter_pid = -1;

		if(round_end_timer == -1){
			round_end_timer = ROUND_END_TIMER;
		}
	}
}

if(round_end_timer > 0){ round_end_timer --;}
if(round_end_timer == 0){
	var bomb_round_result = "Loss";
	if (instance_exists(global.local_player) && global.local_player.stats.Team == TEAM.TERRORIST) {
		bomb_round_result = "Win";
	}

	round_end_timer = -1;
	round_end(bomb_round_result, TEAM.TERRORIST);
}
#endregion

if(instance_exists(global.local_player)){
	
	#region Decoration spawning
	if(!decor_spawned){
		var decor_clearance = sprite_get_width(spr_Decor) * .5;
		var decor_spawn_attempts = 25;
		var first_decor_frame = global.MapID == MAP.Desert ? 6 : 0;
		var last_decor_frame = sprite_get_number(spr_Decor) - 1;
		var decor_collision_list = ds_list_create();

		for(var i = 0; i < decor_n; i++){
			var decor_frame = irandom_range(first_decor_frame, last_decor_frame);

			for(var attempt = 0; attempt < decor_spawn_attempts; attempt++){
				var decor_x = random_range(decor_clearance, room_width - decor_clearance);
				var decor_y = random_range(decor_clearance, room_height - decor_clearance);
				var can_spawn_decor = true;

				ds_list_clear(decor_collision_list);
				var decor_collision_count = collision_circle_list(
					decor_x,
					decor_y,
					decor_clearance,
					all,
					false,
					true,
					decor_collision_list,
					false
				);

				for(var collision_i = 0; collision_i < decor_collision_count; collision_i++){
					var collision_instance = decor_collision_list[| collision_i];
					var collision_object = collision_instance.object_index;

					while(collision_object != oParentTile && object_exists(collision_object)){
						collision_object = object_get_parent(collision_object);
					}

					if(collision_object != oParentTile || decor_frame <= 4){
						can_spawn_decor = false;
						break;
					}
				}

				if(can_spawn_decor){
					var decor = instance_create_layer(decor_x, decor_y, "ItemsO", oDecor);
					decor.image_index = decor_frame;
					break;
				}
			}
		}

		ds_list_destroy(decor_collision_list);
		decor_spawned = true;
	}
	#endregion

	if (spectating) {
		if (!instance_exists(spectate_target) || spectate_target.stats.Health_points <= 0) {
			spectate_target = find_living_player_teammate(global.local_player.stats.Team, global.local_player);
		}
	}

	#region Buy time
	if(buy_time > 0){
		buy_time --;
	}
	#endregion
	
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
                server_process_airplane_spawn(airplane);
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

	if(PauseMenu == true
	|| RespawnMenu == true
	|| GameEndMenu == true
	|| show_weapon_attachments == true
	|| instance_exists(oWeaponAttachments)
	|| instance_exists(oInventory)
	|| instance_exists(oBuyMenu)
	|| instance_exists(oMortarMenu)
	|| instance_exists(oStatisticsTable)
	|| keyboard_check(global.KeyBinds[| KEY.Scoreboard])
	|| global.my_console[? "active"]
	|| global.local_player.player_can_shoot == false){
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
	keyboard_check_pressed(global.KeyBinds[| KEY.BuyMenu]) && buy_time > 0) {
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
