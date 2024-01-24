/// @description Insert description here
// You can write your code in this editor
ViewX = camera_get_view_x(view_camera[0]);
ViewY = camera_get_view_y(view_camera[0]);

bloom_threshold = .29;
if(oPlayer.ToggleInfraVision == true){
	bloom_threshold = .35;
}

if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyWeaponAttachments])){
	if(global.weapon_id[min(oPlayer.WeaponID, 2)] != Item.None && (!global.my_console[? "active"])){
		if(show_weapon_attachments == false){
			oPlayer.Moving = false;
			oPlayer.Legs.image_speed = 0;
			oPlayer.RelativeSpeedX = 0;
			oPlayer.RelativeSpeedY = 0;
			oPlayer.player_can_shoot = false;
			show_weapon_attachments = true;
		}else{
			show_weapon_attachments = false;
			if!(instance_exists(oInventory)){
				oPlayer.player_can_shoot = true;	
			}
		}
	}
}

if(RespawnMenu == true){
	if!(instance_exists(objZUIMain)){
		with(zui_main()){
			with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oRespawnMenu, -1000)) {
				alpha = global.GUIHUDAlpha * 2.25;
				window_id = id;
			}
		}
		alarm[0] = 1;
	}
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