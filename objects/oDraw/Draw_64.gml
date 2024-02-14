draw_set_font(set_font("Console"));
var TextHeightSmall = string_height("a");
draw_set_valign(fa_middle);
	
#region Slot
with(oSlot){
	var scale = 1 * global.GUIMultiplier;
	var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	var Id = global.Inventory[# VarSlot, InventoryIndex.SlotID];
	var Amount = global.Inventory[# VarSlot, InventoryIndex.SlotAmount];
	draw_sprite_ext(sprite_index, image_index, xx, yy, scale, scale, 0, image_blend, global.GUIHUDAlpha*2);
	if (Id != Item.None){ 
	    draw_sprite_ext(spr_Items, Id, xx + sprite_get_width(spr_Slot)/2*scale, yy + sprite_get_height(spr_Slot)/2*scale, scale, scale, 0, c_white, 1);
	    draw_text_outlined(xx + sprite_get_width(spr_Slot)/1.5*scale - string_width(Amount), yy + sprite_get_height(spr_Slot)/1.5*scale, Amount, c_white, c_black, 1);
	}	
	xx2 = (mouse_x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	yy2 = (mouse_y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	if (global.MouseSlot[# 0, InventoryIndex.SlotID] != Item.None){
	    draw_sprite_ext(spr_Items, global.MouseSlot[# 0, InventoryIndex.SlotID], xx2, yy2, scale, scale, 0, c_white, 1);
	}  
	if(mouse_to_gui(xx, yy, xx + sprite_get_width(spr_Slot)*scale, yy + sprite_get_height(spr_Slot)*scale)){
		image_blend = MAIN_COLOR;
		if(mouse_check_button_pressed(mb_left) && global.Inventory[#VarSlot, InventoryIndex.SlotID] != Item.None){
			item_description_destroy();
			if(oDraw.DrawInfo == true){
				oDraw.DrawInfo = false;
			}
			with(oSlot){
				DrawItemInfo = false;
			}
			oPlayer.ItemUsePosition = VarSlot;
			DrawItemInfo = true;	
		}
		if(mouse_check_button_pressed(mb_right)){
			item_description_destroy();
			if(oDraw.DrawInfo == true){
				oDraw.DrawInfo = false;
			}
			with(oSlot){
				DrawItemInfo = false;
			}
			
			var Ammo = global.Inventory[# VarSlot, InventoryIndex.SlotAmmo];
			var ClipAmmo = global.Inventory[# VarSlot, InventoryIndex.SlotClipAmmo];
			var Durability = global.Inventory[# VarSlot, InventoryIndex.SlotDurability];
			var MouseID = global.MouseSlot[# 0, InventoryIndex.SlotID];
			var MouseAmount = global.MouseSlot[# 0, InventoryIndex.SlotAmount];

			if (Id == 0 || MouseID == 0 || Id != MouseID || (Id == MouseID && global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet" || global.ItemIndex[#Id, ItemStat.Type] == "Shield" || global.ItemIndex[#Id, ItemStat.Type] == "Weapon")){
				global.Inventory[# VarSlot, InventoryIndex.SlotID] = MouseID;
				global.Inventory[# VarSlot, InventoryIndex.SlotAmount] = MouseAmount;
				global.Inventory[# VarSlot, InventoryIndex.SlotAmmo] = global.MouseSlot[# 0, InventoryIndex.SlotAmmo];
				global.Inventory[# VarSlot, InventoryIndex.SlotClipAmmo] = global.MouseSlot[# 0, InventoryIndex.SlotClipAmmo];
				global.Inventory[# VarSlot, InventoryIndex.SlotDurability] = global.MouseSlot[# 0, InventoryIndex.SlotDurability];
				global.MouseSlot[# 0, InventoryIndex.SlotID] = Id;
				global.MouseSlot[# 0, InventoryIndex.SlotAmount] = Amount;
				global.MouseSlot[# 0, InventoryIndex.SlotAmmo] = Ammo;
				global.MouseSlot[# 0, InventoryIndex.SlotClipAmmo] = ClipAmmo;
				global.MouseSlot[# 0, InventoryIndex.SlotDurability] = Durability;
			}else if (Id == MouseID){
				global.Inventory[# VarSlot, 1] += global.MouseSlot[# 0, 1];
				global.MouseSlot[# 0, 1] = 0;
				global.MouseSlot[# 0, 0] = Item.None;
			}
		}
	}else{
		image_blend = c_white;
	}
}
#endregion

if(instance_exists(oPlayer) && RespawnMenu == false && PauseMenu == false){
	
	#region Draw ranked score
	if(global.ranked_game == true && !instance_exists(oInventory)){
		draw_set_font(set_font("Title"));
		var player_score = string(global.player_elo_struct.Rounds_win);
		var enemy_score = string(global.player_elo_struct.Rounds_lost);
		var separator = "/";
		var score_string_width = string_width(player_score + enemy_score + separator);
		var player_score_string_width = string_width(player_score);
		var position_y = oDraw.HUDShift*2;
		var position_x = global.GuiW/2 - score_string_width/2; 
		draw_text_outlined(position_x, position_y, player_score, MAIN_COLOR, c_black, 1);
		draw_text_outlined(position_x + player_score_string_width, position_y, separator, c_dkgray, c_black, 1);
		draw_text_outlined(position_x + player_score_string_width + string_width(separator), position_y, enemy_score, c_dkgray, c_black, 1);
		draw_set_font(set_font("Console"));
	}
	#endregion
	
	#region Weapon attachments
	if(show_weapon_attachments == true){
		var button_width = 48 * global.GUIMultiplier;
		var weapon_scale = 2 * global.GUIMultiplier;
		var weapon_sprite_width = sprite_get_width(spr_Items) * weapon_scale;
		var weapon_sprite_height = sprite_get_height(spr_Items)/2 * weapon_scale;
		var weapon_position_x = display_get_gui_width()/2;
		var weapon_position_y = display_get_gui_height() - weapon_sprite_height;
		
		draw_sprite_ext(spr_Items, global.weapon_id[min(oPlayer.WeaponID, 2)], weapon_position_x, weapon_position_y, weapon_scale, weapon_scale, 0, c_white, 1);
		
		#region Weapon scope attachment
		if(global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope] != Item.None){
			draw_sprite_ext(
				spr_Items,
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope], 
				weapon_position_x + weapon_sprite_width/8, 
				weapon_position_y - weapon_sprite_height/2,
				weapon_scale/2,
				weapon_scale/2,
				0,
				c_white,
				1
			);	
			
			draw_button_ext(
				weapon_position_x + weapon_sprite_width/8 + 16 * global.GUIMultiplier, 
				weapon_position_y - weapon_sprite_height/1.5, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Dequip",
				c_dkgray,
				MAIN_COLOR,
				"weapon_scope_dequip"
			);
		}else{
			draw_button_ext(
				weapon_position_x + weapon_sprite_width/8 + 16 * global.GUIMultiplier, 
				weapon_position_y - weapon_sprite_height/1.5, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Empty",
				c_dkgray,
				MAIN_COLOR,
				"None"
			);
		}
		#endregion
		
		#region Weapon barrel attachment
		if(global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_barrel] != Item.None){
			draw_sprite_ext(
				spr_Items,
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_barrel], 
				weapon_position_x, 
				weapon_position_y - weapon_sprite_height/5,
				weapon_scale/2,
				weapon_scale/2,
				0,
				c_white,
				1
			);	
			
			draw_button_ext(
				weapon_position_x + 16 * global.GUIMultiplier, 
				weapon_position_y - weapon_sprite_height/3.75, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Dequip",
				c_dkgray,
				MAIN_COLOR,
				"weapon_barrel_dequip"
			);
		}else{
			draw_button_ext(
				weapon_position_x + 16 * global.GUIMultiplier, 
				weapon_position_y - weapon_sprite_height/3.75, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Empty",
				c_dkgray,
				MAIN_COLOR,
				"None"
			);
		}
		#endregion
		
		#region Weapon grip attachment
		if(global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_grip] != Item.None){
			draw_sprite_ext(
				spr_Items,
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_grip], 
				weapon_position_x + weapon_sprite_width/8, 
				weapon_position_y + weapon_sprite_height/4,
				weapon_scale/2,
				weapon_scale/2,
				0,
				c_white,
				1
			);	
			
			draw_button_ext(
				weapon_position_x + weapon_sprite_width/8 + 16 * global.GUIMultiplier, 
				weapon_position_y + 8 * global.GUIMultiplier, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Dequip",
				c_dkgray,
				MAIN_COLOR,
				"weapon_grip_dequip"
			);
		}else{
			draw_button_ext(
				weapon_position_x + weapon_sprite_width/8 + 16 * global.GUIMultiplier, 
				weapon_position_y + 8 * global.GUIMultiplier, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Empty",
				c_dkgray,
				MAIN_COLOR,
				"None"
			);
		}
		#endregion
		
		#region Weapon suppressor attachment
		if(global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_suppressor] != Item.None){
			draw_sprite_ext(
				spr_Items,
				global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_suppressor], 
				weapon_position_x + weapon_sprite_width/2.5, 
				weapon_position_y - weapon_sprite_height/4,
				weapon_scale/2,
				weapon_scale/2,
				0,
				c_white,
				1
			);	
			
			draw_button_ext(
				weapon_position_x + weapon_sprite_width/2.5 + 16 * global.GUIMultiplier, 
				weapon_position_y - weapon_sprite_height/3, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Dequip",
				c_dkgray,
				MAIN_COLOR,
				"weapon_suppressor_dequip"
			);
		}else{
			draw_button_ext(
				weapon_position_x + weapon_sprite_width/5 + 16 * global.GUIMultiplier, 
				weapon_position_y - weapon_sprite_height/3, 
				button_width, 
				16 * global.GUIMultiplier, 
				"Empty",
				c_dkgray,
				MAIN_COLOR,
				"None"
			);
		}
		#endregion
		
	}
	#endregion
	
	#region Draw shooting mode
	if(global.weapon_id[min(oPlayer.WeaponID, 2)] != Item.None){ 
		var shooting_mode_string = ds_list_find_value(global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.ShootingMode], oPlayer.weapon_shooting_mode) + 
									"[" + keycode_to_string(global.KeyBinds[| KeyBind.KeyChangeMode]) + "]";
		var shooting_mode_x = display_get_gui_width()/2 - string_width(shooting_mode_string);
		var shooting_mode_y = display_get_gui_height() - HUDShift*2;
		draw_text_outlined(shooting_mode_x, shooting_mode_y, shooting_mode_string, c_white, c_black, 1);
	}
	#endregion
	
	#region Draw lens flare
	if(instance_exists(oObjectLamp)){
		with(oObjectLamp){
			draw_lens_flare(id, oPlayer, spr_FlareEffect, 0.5, 1, 0.1 * oLightRenderer.intensity, .25 * oLightRenderer.intensity, sprite_get_width(spr_FlareEffect)*.5);
		}
	}
	#endregion
	
	#region Draw flashed background
	if(oPlayer.FlashedBackGround != -1){
		draw_sprite_ext(oPlayer.FlashedBackGround, 0, 0, 0, global.GuiW/sprite_get_width(oPlayer.FlashedBackGround), global.GuiH/sprite_get_height(oPlayer.FlashedBackGround), 0, c_white, oPlayer.FlashedAlpha);	
	}
	#endregion
	
	#region Draw scope
	if (oPlayer.ScopeIn == true) {
		var scope_zoom_value = 2;
		if(oPlayer.player_has_scope == 0){
			var ScopeBlurValue = min((.005 + (oPlayer.ViewShake / 100)) * (inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer)*5), 0.175);
			BlurValue = lerp(BlurValue, ScopeBlurValue, 0.05);
			var ScopeRadius = sprite_get_width(spr_SniperScope) * 2;
			if (!surface_exists(BlackoutSurface)) {
				BlackoutSurface = surface_create(SurfaceWidth, SurfaceHeight);
			} else if (surface_get_width(BlackoutSurface) != SurfaceWidth || surface_get_height(BlackoutSurface) != SurfaceHeight) {
				surface_resize(BlackoutSurface, SurfaceWidth, SurfaceHeight);
			}
					
			#region Zoom
			ZoomValue = lerp(ZoomValue, scope_zoom_value, 0.01);
		    var captureWidth = ScopeRadius*4;
		    var captureHeight = ScopeRadius*4;
		    var captureX = oCrosshair.xx - captureWidth / 2;
		    var captureY = oCrosshair.yy - captureHeight / 2;

		    // Check if surface exists and then set its target
		    if (surface_exists(zoomSurface)) {
		        surface_set_target(zoomSurface);
		        draw_surface_part_ext(application_surface, captureX, captureY, captureWidth, captureHeight, 0, 0, 1, 1, c_olive, 1);
		        surface_reset_target();
		    }else{
				zoomSurface = surface_create(captureWidth, captureHeight);
			}
			shader_set(shd_Zoom);
			shader_set_uniform_f(shader_get_uniform(shd_Zoom, "u_zoomFactor"), ZoomValue); // Adjust this for the zoom level you want
		    draw_surface(zoomSurface, captureX, captureY);
			shader_reset();
			#endregion
			
			#region Draw black surface
			surface_set_target(BlackoutSurface);
			draw_clear_alpha(c_black, 1);
			gpu_set_blendmode(bm_subtract);

			// Draw a circle at the mouse position to create a "view" in the black surface
			draw_circle(oCrosshair.xx, oCrosshair.yy, ScopeRadius, false);

			gpu_set_blendmode(bm_normal);
			
			draw_set_alpha(.5);
			draw_circle_color(oCrosshair.xx, oCrosshair.yy, ScopeRadius, c_olive, c_olive, false);
			draw_set_alpha(1);
			surface_reset_target();
			draw_surface(BlackoutSurface, 0, 0);
			#endregion
			
			#region Draw scope
		    shader_set(shd_Blur1Pass);
		    shader_set_uniform_f(usize, 64, 64, BlurValue);
			draw_sprite_ext(spr_SniperScope, oPlayer.player_has_scope, oCrosshair.xx + oCrosshair.x_offset, oCrosshair.yy + oCrosshair.y_offset, 4.2, 4.2, 0, c_white, 0.75);
			shader_reset();
			#endregion
			
		}else if(oPlayer.player_has_scope == 1){
			var ScopeBlurValue = min((.005 + (oPlayer.ViewShake / 100)) * (inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer)), 0.175);
			BlurValue = lerp(BlurValue, ScopeBlurValue, 0.05);
		    shader_set(shd_Blur1Pass);
		    shader_set_uniform_f(usize, 64, 64, BlurValue);
			draw_sprite_ext(spr_SniperScope, oPlayer.player_has_scope, oCrosshair.xx + oCrosshair.x_offset, oCrosshair.yy + oCrosshair.y_offset, 2.1, 2.1, 0, c_white, 0.5);
			shader_reset();
		}

	}else{
		if(surface_exists(zoomSurface)){
			surface_free(zoomSurface);	
		}
		if(surface_exists(BlackoutSurface)){
			surface_free(BlackoutSurface);	
		}
		if(ZoomValue != 1){
			ZoomValue = 1;	
		}
	}
	#endregion
	
	#region Draw snow fog
	if(global.Weather == "snow"){
		draw_set_color(c_white);
		draw_set_alpha(.1);
		draw_rectangle(0, 0, global.GuiW, global.GuiH, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}else if(global.Weather == "rain"){
		draw_set_color(c_dkgray);
		draw_set_alpha(.5);
		draw_rectangle(0, 0, global.GuiW, global.GuiH, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	#endregion
	
	if(oPlayer.player_has_scope != 0 || (oPlayer.player_has_scope == 0 && oPlayer.ScopeIn == false)){
		
		#region Bokeh effect
		if(instance_exists(oLightRenderer)){
			if(oLightRenderer.intensity > 1){
				for (var i = 0; i < numParticles; i++) {
				    var px = bokehProperties[i, 0];
				    var py = bokehProperties[i, 1];
				    var size = bokehProperties[i, 2];
				    var alpha = clamp(0.05, 0, bokehProperties[i, 3] * oLightRenderer.intensity);
					shader_set(shd_Blur1Pass);
					shader_set_uniform_f(usize, 128, 128, .5);
				    draw_sprite_ext(spr_FlareEffect, 0, px, py, size, size, 0, c_white, alpha);
					shader_reset();
				}
			}
		}
		#endregion

		#region Draw enemy health
		with(oEnemy){
			if(stats.Health_points > 0 && Visible == true){
				var HealthX = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
				var HealthY = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
				var default_xx = HealthX - sprite_width/2;
				var default_yy = HealthY - sprite_height*.75 - sprite_get_height(spr_HealthBar)*global.GUIMultiplier*1.1;
				var bar_spacing = sprite_get_height(spr_ranks)*.5 * global.GUIMultiplier;
				draw_set_font(set_font("Console"));
				draw_set_color(c_black);
				draw_sprite_ext(spr_HealthBar, 0, HealthX - ceil(sprite_width/2), HealthY - sprite_height/2, global.GUIMultiplier, global.GUIMultiplier, 0, c_white, 1);
				draw_sprite_ext(spr_HealthBar, 3, HealthX - ceil(sprite_width/2), HealthY - sprite_height/2, (stats.Damage_health_points/stats.Max_health_points) * global.GUIMultiplier, global.GUIMultiplier, 0, c_white, 1);	
				draw_sprite_ext(spr_HealthBar, 2, HealthX - ceil(sprite_width/2), HealthY - sprite_height/2, (stats.Health_points/stats.Max_health_points) * global.GUIMultiplier, global.GUIMultiplier, 0, c_white, 1);	

				if(healing == true){
					draw_sprite_ext(spr_HealthBar, 0, default_xx, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					draw_sprite_ext(spr_HealthBar, 5, default_xx, default_yy,
					(healing_time/global.ItemIndex[#Item.HealingKit, ItemStat.ReloadSpeed]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					default_yy -= bar_spacing;
				}

				if(Reloading == true){
					draw_sprite_ext(spr_HealthBar, 0, default_xx, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					draw_sprite_ext(spr_HealthBar, 1, default_xx, default_yy,
					(ReloadTime/global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					default_yy -= bar_spacing;
				}
			
				if(equip_timer > -1){
					draw_sprite_ext(spr_HealthBar, 0, default_xx, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					draw_sprite_ext(spr_HealthBar, 7, default_xx, default_yy,
					(equip_time/global.ItemIndex[#WeaponID[1 - WeaponPositionID], ItemStat.EquipTime]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					default_yy -= bar_spacing;
				}
					
				if!(instance_exists(oInventory)){
					draw_sprite_ext(spr_ranks, get_rank(id), default_xx, default_yy, 1, 1, 0, c_white, global.GUIHUDAlpha);
				}
			}
		}
		#endregion

		#region Draw damage indicator
		with(oDamageIndicator){
		    var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
		    var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
		    draw_text_outlined(xx, yy, Damage_Indicator, Color, c_black, 1);
		    draw_sprite_ext(Sprite, SpriteID, xx + string_width(Damage_Indicator), yy, 1, 1, 0, c_white, 1);
		}
		#endregion
	
		#region Draw pickup
		if!(instance_exists(oInventory)){
			if(instance_exists(oItems)){
				with(oItems){
					xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
					yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
				    if(distance_to_object(oPlayer) <= oPlayer.PickUpDistance){   
						draw_text_outlined(round(xx), round(yy), oDraw.Pick, c_white, c_black, 1);
				    }
				}
			}
		}
		#endregion

		#region Draw item switching
		if(global.Inventory[#oPlayer.ItemUsePosition, InventoryIndex.SlotID] != Item.None){
			var ItemX = HUDShift + sprite_get_width(spr_Items)/2 * global.GUIMultiplier;
		    var Id = global.Inventory[#oPlayer.ItemUsePosition, InventoryIndex.SlotID];        
		    draw_sprite_ext(spr_Items, Id, ItemX, ItemY, 1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1);  
			draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier + string_width(global.ItemIndex[#Id, ItemStat.Name]), ItemY + TextHeightSmall*2, UseString, c_white, c_black, 1); 
			draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier, ItemY + TextHeightSmall*2, global.ItemIndex[#Id, ItemStat.Name], c_white, c_black, 1);            
			draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier, ItemY + TextHeightSmall*3, CycleLeftString, c_white, c_black, 1);
			draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier + string_width(CycleLeftString), ItemY + TextHeightSmall*3, CycleRightString, c_white, c_black, 1);
		}
		#endregion

		#region Draw aimpunch
		if(instance_exists(oPlayer)){
			if(oPlayer.AimPunchTimer > -1){
				draw_sprite_ext(spr_AimPunch, oPlayer.AimPunchDir, 0, 0, global.GuiW/sprite_get_width(spr_AimPunch),
				global.GuiH/sprite_get_height(spr_AimPunch), 0, c_white, .75);	
			}
		}
		#endregion

		#region Draw player healtbars and mags
		var bar_gap = (sprite_get_height(spr_HealthBar)*1.1*global.GUIMultiplier);
		var HealthX = HUDShift;
		var HealthY = global.GuiH - HUDShift - bar_gap;
		var StaminaX = HUDShift;
		var StaminaY = HealthY - bar_gap*2;
		var xp_x = HUDShift;
		var xp_y = StaminaY - bar_gap*2;
		var MagX = HealthX + sprite_get_width(spr_HealthBar) * 2 * global.GUIMultiplier + HUDShift;
		var MagY = StaminaY;
		var AmmoSpriteWidth = sprite_get_width(spr_AmmoType)/1.5*global.GUIMultiplier;
		var AmmoDrawValue = min(ceil(global.ClipAmmo[oPlayer.WeaponID]/global.MaxAmmo[oPlayer.WeaponID]), 10);
		var AmmoRemain = ceil(global.ClipAmmo[oPlayer.WeaponID]/global.MaxAmmo[oPlayer.WeaponID]) - AmmoDrawValue;
		var Value = 0;
		
		for(var i=0;i<AmmoDrawValue;i++){
			draw_sprite_ext(spr_AmmoType, global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.AmmoSpriteID], MagX + (i*AmmoSpriteWidth), MagY, 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, global.GUIHUDAlpha);
			Value ++;
		}
		
		if(AmmoRemain > 0){
			var AmmoRemainString = "(+" + string(AmmoRemain) + ")";
			draw_text_outlined(MagX*1.25 + ((Value-1)*AmmoSpriteWidth) - string_width(AmmoRemainString), MagY + string_height("a")/2, AmmoRemainString, c_white, c_black, 1);
		}

		draw_set_color(c_black);
		
		#region Health bar
		draw_sprite_ext(spr_HealthBar, 0, HealthX, HealthY, global.GUIMultiplier * 2, 2 * global.GUIMultiplier, 0, c_white, 1);
		draw_sprite_ext(spr_HealthBar, 3, HealthX, HealthY, (oPlayer.stats.Damage_health_points/global.player_stats_struct.Max_health) * 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, 1);	
		draw_sprite_ext(spr_HealthBar, 2, HealthX, HealthY, (oPlayer.stats.Health_points/global.player_stats_struct.Max_health) * 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, 1);
		#endregion
			
		#region Stamina bar
		draw_sprite_ext(spr_HealthBar, 0, StaminaX, StaminaY, global.GUIMultiplier * 2, 2 * global.GUIMultiplier, 0, c_white, 1);
		draw_sprite_ext(spr_HealthBar, 3, StaminaX, StaminaY, (oPlayer.stats.Damage_stamina_points/global.player_stats_struct.Max_stamina) * 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, 1);	
		draw_sprite_ext(spr_HealthBar, 6, StaminaX, StaminaY, (oPlayer.stats.Stamina_points/global.player_stats_struct.Max_stamina) * 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, 1);
		#endregion
		
		#region Experience bar
		draw_sprite_ext(spr_HealthBar, 0, xp_x, xp_y, global.GUIMultiplier * 2, 2 * global.GUIMultiplier, 0, c_white, 1);
		draw_sprite_ext(spr_HealthBar, 8, xp_x, xp_y, (global.player_stats_struct.Xp/global.player_stats_struct.Max_xp) * 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, 1);
		#endregion
			
		#endregion
	
		#region Player
		with(oPlayer){
			var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
			var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
			draw_set_font(set_font("Console"));
			var default_yy = yy;
			var bar_spacing = sprite_get_height(spr_HealthBar) * global.GUIMultiplier;
			

			if(Healing == true){
			    draw_sprite_ext(spr_HealthBar, 0, xx - sprite_width/2, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
			    draw_sprite_ext(spr_HealthBar, 5, xx - sprite_width/2, default_yy,
			    (HealingTime/global.ItemIndex[#HealingItemId, ItemStat.ReloadSpeed]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
			    default_yy -= bar_spacing;
			}

			if(Reloading == true){
			    draw_sprite_ext(spr_HealthBar, 0, xx - sprite_width/2, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
			    draw_sprite_ext(spr_HealthBar, 1, xx - sprite_width/2, default_yy,
			    (ReloadTime/global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
				default_yy -= bar_spacing;
			}
			
			if(equip_timer > -1){
			    draw_sprite_ext(spr_HealthBar, 0, xx - sprite_width/2, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
			    draw_sprite_ext(spr_HealthBar, 7, xx - sprite_width/2, default_yy,
			    (equip_time/global.ItemIndex[#global.weapon_id[min(max(1 - WeaponID, 0), 2)], ItemStat.EquipTime]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
				default_yy -= bar_spacing;
			}
			
			var rank_position = 0;
			if(global.player_elo_struct.Played_games >= TRACKING_GAMES/2){
				rank_position = get_rank(id);	
			}
			if!(instance_exists(oInventory)){
				draw_sprite_ext(spr_ranks, rank_position, xx - sprite_width/2, default_yy, 1, 1, 0, c_white, global.GUIHUDAlpha);
			}
		}
		#endregion
	
		with(oPlayer){
		
			#region Draw Tab HUD
			var HotBarOffsetX = sprite_get_width(spr_Items)/2 * global.GUIMultiplier;
			var HotBarOffsetY = sprite_get_height(spr_Items) * global.GUIMultiplier;
			var HotBarX = display_get_gui_width() - HotBarOffsetX - oDraw.HUDShift;
			var HotBarY = display_get_gui_height();
			var HotBarTabWidth = display_get_gui_width() - (HotBarX - HotBarOffsetX*2) - oDraw.HUDShift;
			draw_menu_tab(
				HotBarX - HotBarOffsetX*2, 
				HotBarY - oDraw.HotBarItems*HotBarOffsetY, 
				HotBarTabWidth, 128 * global.GUIMultiplier, 
				32 * global.GUIMultiplier, 
				48 * global.GUIMultiplier, 
				c_black, 
				c_dkgray, 
				c_black, 
				EquipmentAlpha, 
				1, 
				MAIN_COLOR, 
				"Equipment"
			);
			#endregion
		
			#region Draw HUD weapon
			var r = 54;
			var g = 54;
			var b = 54;
			var Value = 0;
			for(var i=0;i<oDraw.HotBarItems - 1;i++){ ///- 1 for knife
				if(global.weapon_id[1 - i] != Item.None){
					if(mouse_to_gui(
						HotBarX - sprite_get_width(spr_Items)*global.GUIMultiplier/2,  
						HotBarY - HotBarOffsetY - Value*HotBarOffsetY - sprite_get_height(spr_Items)/2*global.GUIMultiplier/2, 
						HotBarX + sprite_get_width(spr_Items)*global.GUIMultiplier/2,
						HotBarY - HotBarOffsetY - Value*HotBarOffsetY + sprite_get_height(spr_Items)/2*global.GUIMultiplier/2)
					){
						
					
						#region Draw weapon
						shader_set(shd_LightGray);
						if(WeaponID == 1 - i){
							shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
						}else{
							shader_set_uniform_f(oDraw.BlendColor, r/255, g/255, b/255, 1.0);	
						}
						draw_sprite_outlined_ext(
							spr_Items, global.weapon_id[1 - i], HotBarX, HotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							c_black, 5, 1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, 1
						);
						shader_reset();
						#endregion
					
						#region Draw drop text
						draw_text_outlined(
							HotBarX - 24 - string_width(oDraw.DropString)/2, HotBarY - HotBarOffsetY/2 - Value*HotBarOffsetY, 
							oDraw.DropString, c_white, c_black, 1				
						);
						#endregion
					
						#region Drop weapon				
						if(mouse_check_button_pressed(global.KeyBinds[| KeyBind.KeyDropMouse]) && keyboard_check(global.KeyBinds[| KeyBind.KeyDrop])){
							if(oDraw.show_weapon_attachments == true){
								player_can_shoot = true;
								oDraw.show_weapon_attachments = false;
							}
							player_has_scope = -1;
							ScopeIn = false;	
							ItemDrop(
								global.weapon_id[1 - i], 
								x, 
								y, 
								100,
								global.Ammo[1 - i], 
								global.ClipAmmo[1 - i], 
								0, 
								1, 
								global.weapon_attachments[1 - i][weapon_attachments.weapon_scope],
								global.weapon_attachments[1 - i][weapon_attachments.weapon_barrel],
								global.weapon_attachments[1 - i][weapon_attachments.weapon_grip],
								global.weapon_attachments[1 - i][weapon_attachments.weapon_suppressor]
							);
							WeaponDrop(1 - i, id);
						}
						#endregion
					
					}else{
					
						#region Draw weapon
						shader_set(shd_LightGray);
						if(WeaponID == 1 - i){
							shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
						}else{
							shader_set_uniform_f(oDraw.BlendColor, r/255, g/255, b/255, 1.0);	
						}
						draw_sprite_ext(
							spr_Items, global.weapon_id[1 - i], HotBarX, HotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
						);		
						shader_reset();
						#endregion
					
					}
					
					#region Draw no ammo weapon
					if(global.ClipAmmo[1 - i] <= 0 && global.Ammo[1 - i] <= 0 && global.weapon_id[1 - i] != Item.None){
						draw_sprite_ext(
							spr_broken, 0, HotBarX, HotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
						);		
					}
					#endregion
					
					Value ++;
				}
			}
			#endregion
				
			#region Draw HUD armour and helmet
			Value = 0;
			var ArmourHotBarX = HotBarX - sprite_get_width(spr_Items)/1.25*global.GUIMultiplier;
			var ArmourHotBarY = HotBarY;
			for(var i=0;i<2;i++){
				if(global.ArmourID[1 - i] != Item.None){
					if(mouse_to_gui(
						ArmourHotBarX - sprite_get_width(spr_Items)*global.GUIMultiplier/4,  
						ArmourHotBarY - HotBarOffsetY - Value*HotBarOffsetY - sprite_get_height(spr_Items)/2*global.GUIMultiplier/2, 
						ArmourHotBarX + sprite_get_width(spr_Items)*global.GUIMultiplier/4,
						ArmourHotBarY - HotBarOffsetY - Value*HotBarOffsetY + sprite_get_height(spr_Items)/2*global.GUIMultiplier/2)
					){
					
						#region Draw armour and helmet
						shader_set(shd_LightGray);
						shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
						draw_sprite_outlined_ext(
							spr_Items, global.ArmourID[1 - i], ArmourHotBarX, ArmourHotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							c_black, 5, 1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, 1
						);
						shader_reset();
						#endregion
					
						#region Draw drop text
						draw_text_outlined(
							ArmourHotBarX - 24 - string_width(oDraw.DropString)/2, ArmourHotBarY - HotBarOffsetY/2 - Value*HotBarOffsetY, 
							oDraw.DropString, c_white, c_black, 1				
						);
						#endregion
					
						#region Drop armour				
						if(mouse_check_button_pressed(global.KeyBinds[| KeyBind.KeyDropMouse]) && keyboard_check(global.KeyBinds[| KeyBind.KeyDrop])){
							ItemDrop(global.ArmourID[1 - i], x, y, 100, 0, 0, global.ArmourDurability[1 - i]);
							ArmourDrop(1 - i, oPlayer);
						}
						#endregion
					
					}else{
					
						#region Draw armour and helmet
						shader_set(shd_LightGray);
						shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
						draw_sprite_ext(
							spr_Items, global.ArmourID[1 - i], ArmourHotBarX, ArmourHotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
						);		
						shader_reset();
						#endregion
					
					}
					
					#region Draw broken armour and helmet
					if(global.ArmourDurability[1 - i] <= 0 && global.ArmourID[1 - i] != Item.None){
						draw_sprite_ext(
							spr_broken, 0, ArmourHotBarX, ArmourHotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
						);	
					}
					#endregion
					
					Value ++;
				}
			}		
			#endregion
		
			draw_set_alpha(1);
		
		}
	
		#region Item description
		if(instance_exists(oInventory)){
				
			/*with(oSlot){
				if(DrawItemInfo == true){
					oDraw.DrawInfo = true;
					var Id = global.Inventory[#VarSlot, InventoryIndex.SlotID];
				
					#region Draw tab and exit button
					var ButtonOffset = 8;
					var ButtonWidth = 64 * global.GUIMultiplier;
					var TabWidth = 768 * global.GUIMultiplier;
					var TitleHeight = 24 * global.GUIMultiplier;
					var MiddleHeight = 128 * global.GUIMultiplier;
					var EndHeight = 24 * global.GUIMultiplier;
					var ButtonHeight = EndHeight - ButtonOffset;
					var TabX = display_get_gui_width()/2 - (TabWidth/2);
					var TabY = oDraw.HUDShift;
					draw_menu_tab(
						TabX, 
						TabY, 
						TabWidth,
						MiddleHeight, 
						TitleHeight, 
						EndHeight, 
						c_black,
						c_dkgray, 
						c_black, 
						global.GUIHUDAlpha*1.5, 
						2, 
						MAIN_COLOR, 
						global.ItemIndex[#Id, ItemStat.Name], 
					);
				
					draw_button_ext(
						TabX + TabWidth/2 - ButtonWidth/2, 
						TabY + TitleHeight + MiddleHeight + ButtonOffset/2, 
						ButtonWidth, 
						ButtonHeight, 
						"Exit", 
						c_dkgray, 
						MAIN_COLOR,
						"description_exit"
					);
					#endregion				
				
					if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
					
						#region Variables
						var rows = 5;
						var columns = 3;
						var cell_width = (TabWidth - 2*oDraw.HUDShift)/columns/1.75;
						var cell_height = (MiddleHeight - 2*oDraw.HUDShift)/rows;
						var statTitles = [
							"Damage power: ", "Ammo: ", "Clip ammo: ", "Reload time: ", "Max. range: ", "Moving inaccuracy: ", "Inaccuracy: ", "RPM: ", "Inaccuracy/shot: ", "Damage drop: ", "Range drop: ",
							"Class: ", "Moving speed: ", "Penetration: ", "Modes: "
						];					
						#endregion
					
						#region Draw grid
					    for (var i = 0; i < rows; i++) {
					        for (var j = 0; j < columns; j++) {
					            var cell_x = TabX + oDraw.HUDShift + j * cell_width;
					            var cell_y = TabY + TitleHeight + oDraw.HUDShift + i * cell_height;
								draw_set_color(MAIN_COLOR);
					            draw_rectangle(cell_x, cell_y, cell_x + cell_width, cell_y + cell_height, true);
								draw_set_color(c_white);
							
								draw_set_font(set_font("GUI_grid"));
						        var text = "";
						        var statIndex = ItemStat.Damage + i * columns + j;
						        if (statIndex <= array_length(statTitles)){
								
									#region Specific cases
									switch(statIndex){
										
										case ItemStat.Ammo:
											text = statTitles[statIndex] + string(global.Inventory[#VarSlot, InventoryIndex.SlotAmmo]);
										break;
										
										case ItemStat.ClipAmmo:
											text = statTitles[statIndex] + string(global.Inventory[#VarSlot, InventoryIndex.SlotClipAmmo]);
										break;
									
										case ItemStat.ReloadSpeed:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]/game_get_speed(gamespeed_fps)) + "s";
										break;
									
										case ItemStat.DamageDrop:
											text = statTitles[statIndex] + string_format(global.ItemIndex[#Id, statIndex], 0, 5) + "%/Unit";
										break;
									
										case ItemStat.RangeInaccuracyMultiplier:
											text = statTitles[statIndex] + string_format(global.ItemIndex[#Id, statIndex], 0, 4) + "%/Unit";
										break;

										case ItemStat.MovingSpdMul:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]*100) + "%";
										break;

										case ItemStat.PenetrationPower:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]*100) + "%";
										break;
									
										case ItemStat.ShootTimer:
											text = statTitles[statIndex] + string(game_get_speed(gamespeed_fps)/global.ItemIndex[#Id, statIndex]*60);
										break;

										case ItemStat.Range:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]) + " Units";
										break;
									
										case ItemStat.Inaccuracy:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]);
										break;
									
										case ItemStat.MovingInaccuracyMultiplier:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]*100) + "%";
										break;
										
										case ItemStat.ShootingMode:
											text = statTitles[statIndex] + get_shooting_modes_string(Id);
										break;
									
										default:
											text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]);
										break;
									}
									#endregion
								
						        }
						        var text_x = cell_x + cell_width / 2 - string_width(text) / 2;
						        var text_y = cell_y + cell_height/2;
						        draw_text_outlined(text_x, text_y, text, c_white, c_black, 1);
					        }
					    }		
						#endregion
					
						#region Draw description
						draw_set_font(set_font("GUI_grid"));
						var DescriptionString = string_wrap(global.ItemIndex[#Id, ItemStat.Description], 300 * global.GUIMultiplier);
						var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
						var DescriptionX = TabX + oDraw.HUDShift + columns*cell_width + oDraw.HUDShift;
						var DescriptionY = TabY + TitleHeight - oDraw.HUDShift/2 + DescriptionStringHeight;
						var StartDescriptionY = DescriptionY + DescriptionStringHeight/2;
						var disadvantages_string = global.ItemIndex[#Id, ItemStat.disadvantages];
						var disadvantages_height = string_count_lines(disadvantages_string) * font_get_size(draw_get_font());
						var advantages_string = global.ItemIndex[#Id, ItemStat.advantages];
						var advantages_height = string_count_lines(advantages_string) * font_get_size(draw_get_font());
						var disadvantages_x = DescriptionX + string_width(advantages_string)*1.5;
						var advantages_x = DescriptionX;
						var advantages_y = DescriptionY + DescriptionStringHeight*3;
						draw_text_outlined(DescriptionX, StartDescriptionY, DescriptionString, c_white, c_black, 1);
						draw_text_outlined(disadvantages_x, advantages_y, disadvantages_string, c_red, c_black, 1);
						draw_text_outlined(advantages_x, advantages_y, advantages_string, c_green, c_black, 1);
						
						
						draw_set_font(set_font("Console"));
						#endregion
		
						#region Draw drop button
						draw_button_ext(
							DescriptionX + string_width(DescriptionString)/4,
							advantages_y + max(advantages_height, disadvantages_height) + ButtonHeight,
							ButtonWidth,
							ButtonHeight,
							"Drop item",
							c_dkgray,
							MAIN_COLOR,
							"description_drop"
						);
						#endregion	
						
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){		
					
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item" || global.ItemIndex[#Id, ItemStat.Type] == "Grenade"){
						
						#region Draw description
						draw_set_font(set_font("GUI_grid"));
						var DescriptionString = string_wrap(global.ItemIndex[#Id, ItemStat.Description], 300 * global.GUIMultiplier);
						var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
						var DescriptionX = TabX + oDraw.HUDShift*1.5;
						var DescriptionY = TabY + TitleHeight + oDraw.HUDShift*1.5 + DescriptionStringHeight;
						var StartDescriptionY = DescriptionY + DescriptionStringHeight/2;
						draw_text_outlined(DescriptionX, StartDescriptionY, DescriptionString, c_white, c_black, 1);
						#endregion
						
						#region Item statistics
						var statistics_string = "";
						var statistics_x = TabX + oDraw.HUDShift + string_width(DescriptionString)*1.5;
						var statistics_y = TabY + TitleHeight + oDraw.HUDShift*2;
						if (Id == Item.military_suppressor) {
						    var accuracy = (1 - global.ItemIndex[#Id, ItemStat.KickBackPower]) * 100;
						    var spotted_chance = (1 - global.ItemIndex[#Id, ItemStat.KickBackInaccuracyMultiplier]) * 100;
						    var attack_power = (1 - global.ItemIndex[#Id, ItemStat.Defense]) * 100;

						    draw_string_line(statistics_x, statistics_y, "Accuracy: ", accuracy, c_green, "%");
						    draw_string_line(statistics_x, statistics_y + 20, "Getting spotted chance: ", -spotted_chance, c_green, "%");
						    draw_string_line(statistics_x, statistics_y + 40, "Attack power: ", -attack_power, c_red, "%");
						} else if (Id == Item.vertical_grip) {
						    var vertical_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackInaccuracyMultiplier]) * 100;
						    var horizontal_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackPower]) * 100;

						    draw_string_line(statistics_x, statistics_y, "Vertical recoil: ", -vertical_recoil, c_green, "%");
						    draw_string_line(statistics_x, statistics_y + 20, "Horizontal recoil: ", -horizontal_recoil, c_red, "%");
						} else if (Id == Item.horizontal_grip) {
						    var horizontal_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackPower]) * 100;
						    var vertical_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackInaccuracyMultiplier]) * 100;

						    draw_string_line(statistics_x, statistics_y, "Horizontal recoil: ", -horizontal_recoil, c_green, "%");
						    draw_string_line(statistics_x, statistics_y + 20, "Vertical recoil: ", -vertical_recoil, c_red, "%");
						}

						
					draw_set_font(set_font("Console"));
					#endregion
						
					#region Draw drop button
					draw_button_ext(
						DescriptionX + string_width(DescriptionString)/4,
						DescriptionY + DescriptionStringHeight*1.1 + ButtonHeight,
						ButtonWidth,
						ButtonHeight,
						"Drop item",
						c_dkgray,
						MAIN_COLOR,
						"description_drop"
					);
					#endregion
					
					}
				
				}
			}*/
		}
		#endregion
	
	}

}

#region Draw admin HUD
if(instance_exists(oPlayer)){
	if(global.AdminHUD == true){
				
		var AdminHUDX = global.GuiW - HUDShift;
		var AdminHUDY = HUDShift;
		
		//Player velocity
		var PlayerVelocity = sqrt(power(oPlayer.XSpeed, 2) + power(oPlayer.YSpeed, 2)) * game_get_speed(gamespeed_fps);
		var SpdString = "Velocity: " + string_format(min(PlayerVelocity, oPlayer.MoveSpeed * game_get_speed(gamespeed_fps)), 0, 1) + " Units/Second";
		draw_text_outlined(AdminHUDX - string_width(SpdString), AdminHUDY, SpdString, c_white, c_black, 1);	
		
		//Crosshair range
		var RangeString = "Range: " + string_format(oPlayer.Range, 0, 1) + " Units";
		draw_text_outlined(AdminHUDX - string_width(RangeString), AdminHUDY + TextHeightSmall, RangeString, c_white, c_black, 1);	
		
		//KickBack
		var KBString = "Kickback: " + string_format(oPlayer.KickBack, 0, 1);
		draw_text_outlined(AdminHUDX - string_width(KBString), AdminHUDY + TextHeightSmall*2, KBString, c_white, c_black, 1);	
				
		//Inaccuracy
		var player_inaccuracy = global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.Inaccuracy]*inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer);
		var inaccuracy_string = "Inaccuracy: " + string_format(player_inaccuracy, 0, 1) + " Units";
		draw_text_outlined(AdminHUDX - string_width(inaccuracy_string), AdminHUDY + TextHeightSmall*3, inaccuracy_string, c_white, c_black, 1);	
		
		if(global.ranked_game == true){
			//Elo
			var player_elo = global.player_elo_struct.Elo;
			var elo_string = "EP: " + string_format(convert_back(player_elo), 0, 1);
			var elo_string_eggy_scale = "EP (eggy scale): " + string_format(player_elo, 0, 1);
			draw_text_outlined(AdminHUDX - string_width(elo_string), AdminHUDY + TextHeightSmall*4, elo_string, c_white, c_black, 1);	
			draw_text_outlined(AdminHUDX - string_width(elo_string_eggy_scale), AdminHUDY + TextHeightSmall*5, elo_string_eggy_scale, c_white, c_black, 1);	
		
			//Volatility
			var player_game_volatility = global.player_elo_struct.Local_volatility;
			var player_volatility = global.player_elo_struct.Game_volatility;
			var volatility_string = "Global volatility: " + string_format(player_volatility, 0, 1);
			var game_volatility_string = "Local volatility: " + string_format(player_game_volatility, 0, 1);
			draw_text_outlined(AdminHUDX - string_width(volatility_string), AdminHUDY + TextHeightSmall*6, volatility_string, c_white, c_black, 1);	
			draw_text_outlined(AdminHUDX - string_width(game_volatility_string), AdminHUDY + TextHeightSmall*7, game_volatility_string, c_white, c_black, 1);
			
			//Enemy elos
			var enemy_elos_string = "Enemy EP: [ ";
			var enemy_elos_string_eggy_scale = "Enemy EP (eggy scale): " + string(global.player_elo_struct.Enemy_elo);
			
			for (var i = 0; i < array_length(global.player_elo_struct.Enemy_elo); i++) {
			    var converted_elo = convert_back(global.player_elo_struct.Enemy_elo[i]);
			    enemy_elos_string += string(converted_elo) + (i < array_length(global.player_elo_struct.Enemy_elo) - 1 ? "," : "");
			}
			enemy_elos_string += " ]";
			draw_text_outlined(AdminHUDX - string_width(enemy_elos_string), AdminHUDY + TextHeightSmall*8, enemy_elos_string, c_white, c_black, 1);	
			draw_text_outlined(AdminHUDX - string_width(enemy_elos_string_eggy_scale), AdminHUDY + TextHeightSmall*9, enemy_elos_string_eggy_scale, c_white, c_black, 1);	
		}
		
	}
}
#endregion

#region Flashed
if(RespawnMenu == false){
	if(instance_exists(oPlayer)){	
		if(oPlayer.Flashed == true){
			draw_set_alpha(oPlayer.FlashedAlpha);
			draw_set_color(c_white);
			draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
			draw_set_alpha(1);
		}
	}
}
#endregion

#region Fps
draw_set_font(set_font("Console"));
draw_text_outlined(50, 50, "Fps: " + string(fps), c_white, c_black, 1);
draw_text_outlined(50, 50 + TextHeightSmall, "Real fps: " + string(fps_real), c_white, c_black, 1);
#endregion

#region Time
if(instance_exists(oLightRenderer)){
	draw_set_font(set_font("Console"));
	var hour_str = (oLightRenderer.CurrentHour < 10 ? "0" + string(oLightRenderer.CurrentHour) : string(oLightRenderer.CurrentHour));
	var minute_str = (oLightRenderer.CurrentMinute < 10 ? "0" + string(oLightRenderer.CurrentMinute) : string(oLightRenderer.CurrentMinute));
	draw_text_outlined(50, 50 + TextHeightSmall*2, "Time: " + string(hour_str) + ":" + string(minute_str), c_white, c_black, 1);
}
#endregion

#region Console
console_draw(global.my_console, global.ConsoleHeight * global.GUIMultiplier,c_gray,c_silver,c_white,c_white, global.GUIHUDAlpha*2, global.ConsoleWidth * global.GUIMultiplier);
#endregion

#region Crosshair
with(oCrosshair){
	var x_scale = image_xscale * .5;
	var y_scale = image_yscale * .5;
	var xx = (x + x_offset - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	var yy = (y + y_offset - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	if(instance_exists(oPlayer)){
		if(HitMarker > -1){
			draw_sprite_ext(spr_HitMarker, HitMarker, xx, yy, y_scale, x_scale, image_angle, image_blend, global.CrosshairAlpha);	
		}
		if(oPlayer.player_can_shoot == true && !global.my_console[? "active"] && global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.WeaponTypeClass] != "Sniper rifle"){
			draw_sprite_ext(spr_StaticCrosshair, 0, xx, yy, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
			if(global.DynamicCrosshair == true){
				Gap = 25;
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					xx - Gap - global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.Inaccuracy]*inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer)*2 + x_offset, 
					yy, 
					y_scale, 
					x_scale, 
					0, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Left
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					xx + Gap + global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.Inaccuracy]*inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer)*2 + x_offset, 
					yy, 
					y_scale, 
					x_scale, 
					0, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Right
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					xx, 
					yy - Gap - global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.Inaccuracy]*inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer)*2 + y_offset, 
					y_scale, 
					x_scale, 
					90, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Top
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					xx, 
					yy + Gap + global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.Inaccuracy]*inaccuracy_formula(global.weapon_id[min(oPlayer.WeaponID, 2)], oPlayer)*2 + y_offset, 
					y_scale, 
					x_scale, 
					90, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Down
			}
		}
	}else{
		draw_sprite_ext(spr_StaticCrosshair, 0, xx, yy, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
		if(global.DynamicCrosshair == true){
			Gap = 25;
			draw_sprite_ext(spr_DynamicCrosshair, 0, xx - Gap - 1 + x_offset, yy, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Left
			draw_sprite_ext(spr_DynamicCrosshair, 0, xx + Gap + 1 + x_offset, yy, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Right
			draw_sprite_ext(spr_DynamicCrosshair, 0, xx, yy - Gap - 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Top
			draw_sprite_ext(spr_DynamicCrosshair, 0, xx, yy + Gap + 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Down
		}
	}
}
#endregion

