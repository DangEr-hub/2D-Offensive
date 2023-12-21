/// @description Insert description here
// You can write your code in this editor
ViewX = camera_get_view_x(view_camera[0]);
ViewY = camera_get_view_y(view_camera[0]);

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
	if(mouse_check_button_pressed(mb_right) && ToggleMessage == false){
		Alpha = 0;
		ToggleMessage = true;	
	}
}

if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPause]) && RespawnMenu == false){
	if(PauseMenu == false){
		alarm[0] = 1;
		PauseMenu = true;	
	}else{
		PopupWindow = "";
		Alpha = 0;
		BackGround = -1;
		surface_free(_surface);
		if(sprite_exists(BackGround) && BackGround != -1){sprite_delete(BackGround);}
		instance_activate_all();
		PauseMenu = false;
	}
}

if(PauseMenu == true){
	if(mouse_check_button_pressed(mb_right)){
		PopupWindow = "";
		Alpha = 0;
		ToggleMessage = !ToggleMessage;	
	}	
}