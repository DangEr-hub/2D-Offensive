function ui_scale_set_window_size(window_w, window_h){
    global.window_width = window_w;
    global.window_height = window_h;

    window_set_size(window_w, window_h);
	window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
}


function mouse_to_gui(xpos1, ypos1, xpos2, ypos2){
	var window_multiplier = 1;
	if(window_get_fullscreen() == false){
		window_multiplier = 1.02;	
	}
	return device_mouse_x_to_gui(0) >= xpos1 && device_mouse_x_to_gui(0) <= xpos2 && device_mouse_y_to_gui(0) * window_multiplier >= ypos1 && device_mouse_y_to_gui(0) * window_multiplier <= ypos2;
}

function window_resize(){
    window_set_size(global.window_width, global.window_height);
    surface_resize(application_surface, global.GuiW, global.GuiH);
    camera_set_view_size(CAM, global.CameraWidth, global.CameraHeight);
}

function draw_health_bar_fill(frame, xpos, ypos, progress, scale = global.GUIMultiplier, blend = c_white){
	var source_width = round(sprite_get_width(spr_HealthBar) * clamp(progress, 0, 1));
	if(source_width <= 0){
		return;
	}

	var draw_x = round(xpos - sprite_get_xoffset(spr_HealthBar) * scale);
	var draw_y = round(ypos - sprite_get_yoffset(spr_HealthBar) * scale);
	draw_sprite_part_ext(
		spr_HealthBar,
		frame,
		0,
		0,
		source_width,
		sprite_get_height(spr_HealthBar),
		draw_x,
		draw_y,
		scale,
		scale,
		blend,
		1
	);
}

function pause(ObjectType){
	if(instance_exists(oWeaponAttachments)){
		global.local_player.player_can_shoot = true;
		with(oWeaponAttachments){
			zui_destroy();
		}
	}
	if(instance_exists(oBuyMenu)){
		global.local_player.player_can_shoot = true;
		with(oBuyMenuDescription){
			zui_destroy();
		}
		with(oBuyMenu){
			zui_destroy();
		}
	}
	with(zui_main()){
		zui_create(0, 0, objUIBlack, -1000);
		with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oPause, -1000)) {
			alpha = global.GUIHUDAlpha * 2.25; alpha_value = 0;
			window_id = id;
		}
	}
	camera_set_view_angle(CAM, 0);
	ObjectType.alarm[0] = 1;
}

function unpause(ObjectType){
	with(zui_main()){
		zui_destroy();
	}
	with(ObjectType){
		PopupWindow = "";
		Alpha = 0;
		BackGround = -1;
		if(sprite_exists(BackGround) && BackGround > -1){sprite_delete(BackGround);}
		instance_activate_all();
	}
}

function item_description_destroy(){
	if(instance_exists(oItemDescription)){
		with(oItemDescription){
			zui_destroy();
		}
	}
	if(instance_exists(oWeaponDescription)){
		with(oWeaponDescription){
			zui_destroy();
		}	
	}
	if(oArmourDescription){
		with(oArmourDescription){
			zui_destroy();
		}
	}
	if(oUsableItemDescription){
		with(oUsableItemDescription){
			zui_destroy();
		}
	}
}

function statistics_table_open(){
	if(instance_exists(oStatisticsTable) || !instance_exists(global.local_player)) return;

	with(zui_main()){
		zui_create(zui_get_width() * .5, zui_get_height() * .5, oStatisticsTable, -2000);
	}
}

function statistics_table_close(){
	if(instance_exists(oStatisticsTable)){
		with(oStatisticsTable){
			zui_destroy();
		}
	}
}

function open_ingame_settings(){
	var settings_is_open = false;
	with(oSettingsTab){
		if(instance_exists(__parent)){
			settings_is_open = true;
		}else{
			var black_id = overlay_black;
			if(instance_exists(black_id)){
				with(black_id){
					zui_destroy();
				}
			}
			zui_destroy();
		}
	}

	if(settings_is_open){
		return;
	}

	with(zui_main()){
		var settings_black = zui_create(0, 0, objUIBlack, -1999);
		with(zui_create(zui_get_width() * .5, zui_get_height() * .5, oSettingsTab, -2000)){
			ingame_overlay = true;
			overlay_black = settings_black;
			alpha = global.GUIHUDAlpha * 1.25;
			alpha_value = 0;
			window_id = id;

			with(zui_create(zui_get_width() * .5, zui_get_height() - 32 * global.GUIMultiplier, objUIButton)){
				zui_set_anchor(.5, 0);
				zui_set_size(128 * global.GUIMultiplier, 24 * global.GUIMultiplier);
				caption = "Back";
				callback = function(){
					with(oSettingsTab){
						if(ingame_overlay){
							var black_id = overlay_black;
							if(instance_exists(black_id)){
								with(black_id){
									zui_destroy();
								}
							}
							zui_destroy();
						}
					}
				};
			}
		}
	}
}

function reset_gui(){
	var restore_statistics_table = instance_exists(oStatisticsTable)
		&& keyboard_check(global.KeyBinds[| KEY.Scoreboard]);
	statistics_table_close();

	if(instance_exists(oWeaponAttachments)){
		with(oWeaponAttachments){
			zui_destroy();
		}
		instance_destroy(objZUIMain);
		with(zui_main()){
			with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
			}
		}
	}
	if(instance_exists(oInventory)){
		instance_destroy(oInventory);
		instance_destroy(oSlot);
		instance_create_layer(global.local_player.x, global.local_player.y, "OtherO", oInventory);
	}
	if(instance_exists(oController)){
		instance_destroy(oController);	
		instance_create_depth(0, 0, -1000, oController);
	}
	if(instance_exists(oBuyMenu)){
		with(oBuyMenu){
			zui_destroy();
		}
		instance_destroy(objZUIMain);
		with(zui_main()){
			zui_create(zui_get_width() * .5, zui_get_height() * .5, oBuyMenu);
		}
		with(oBuyMenuDescription){
			zui_destroy();
		}
	}
	if(instance_exists(oDraw)){
		with(oDraw){
			if(PauseMenu == true){
				instance_destroy(objZUIMain);
				pause(id);
			}else if(RespawnMenu == true){
				instance_destroy(objZUIMain);
				with(zui_main()){
					if(other.GameEndMenu == true){
						zui_create(0, 0, objUIBlack, -1000);
						with (zui_create(zui_get_width() * 0.5, zui_get_height() * .5, oGameEndMenu, -1000)) {
							alpha_value = 0;
							alpha = global.GUIHUDAlpha * 2.25; 
							window_id = id;
						}
					}else{
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
			
			if(oDraw.DrawInfo == true){
				instance_destroy(objZUIMain);
				with(zui_main()){
					var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
					if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet" || global.ItemIndex[#Id, ItemStat.Type] == "Shield"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oArmourDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oItemDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oWeaponDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Grenade" || global.ItemIndex[#Id, ItemStat.Type] == "Landmine"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oUsableItemDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}
				}
			}
		}
	}

	if(restore_statistics_table){
		statistics_table_open();
	}
}
	
function damage_indicator(DamageIndicatorString, PositionX, PositionY, DamageIndicatorColor, DamageIndicatorSprite, DamageIndicatorSpriteID, DamageIndicatorFont = set_font("Console")) {
	
	if(global.draw_damage == false && DamageIndicatorSpriteID == ICON.health){
		return;
	}
	
	if(object_index == oBot){
		if(Visible == true){
			Indicator = instance_create_depth(PositionX, PositionY, -100, oDamageIndicator);
			Indicator.Font = DamageIndicatorFont;
			Indicator.Damage_Indicator = DamageIndicatorString;
			Indicator.Color = DamageIndicatorColor;
			Indicator.Sprite = DamageIndicatorSprite;
			Indicator.SpriteID = DamageIndicatorSpriteID;
		}
	}else{
		Indicator = instance_create_depth(PositionX, PositionY, -100, oDamageIndicator);
		Indicator.Font = DamageIndicatorFont;
		Indicator.Damage_Indicator = DamageIndicatorString;
		Indicator.Color = DamageIndicatorColor;
		Indicator.Sprite = DamageIndicatorSprite;
		Indicator.SpriteID = DamageIndicatorSpriteID;
	}
}

function set_crosshair_color(ColorString){
	if (string_length(ColorString) == 9) {
		var r = string_copy(ColorString, 1, 3);
		var g = string_copy(ColorString, 4, 3);
		var b = string_copy(ColorString, 7, 3);

		r = real(r);
		g = real(g);
		b = real(b);

		r = clamp(r, 0, 255);
		g = clamp(g, 0, 255);
		b = clamp(b, 0, 255);

		global.crosshair_color = make_color_rgb(r, g, b);
	}
}
