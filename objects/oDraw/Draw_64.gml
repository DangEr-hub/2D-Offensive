draw_set_font(set_font("Console"));
var TextHeightSmall = string_height("a");
draw_set_valign(fa_middle);
	
#region Slot
with(oSlot){
	var scale = 1 * global.GUIMultiplier;
	var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	var Id = global.Inventory[# VarSlot, Index.slot_id];
	var Amount = global.Inventory[# VarSlot, Index.SlotAmount];
	var xx2 = (mouse_x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	var yy2 = (mouse_y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	var Ammo = global.Inventory[# VarSlot, Index.slot_ammo];
	var ClipAmmo = global.Inventory[# VarSlot, Index.slot_clip_ammo];
	var Durability = global.Inventory[# VarSlot, Index.slot_durability];
	var MouseID = global.MouseSlot[# 0, Index.slot_id];
	var MouseAmount = global.MouseSlot[# 0, Index.SlotAmount];
	var slot_alpha = global.GUIHUDAlpha*2.75;

	draw_sprite_ext(sprite_index, image_index, xx, yy, scale, scale, 0, image_blend, slot_alpha);
	if (Id != Item.None){ 
	    draw_sprite_ext(spr_Items, Id, xx + sprite_get_width(spr_Slot)/2*scale, yy + sprite_get_height(spr_Slot)/2*scale, scale, scale, 0, c_white, slot_alpha);
		draw_set_alpha(slot_alpha);
		
		if(VarSlot < OtherSlot.Primary){
			draw_text_outlined(xx + sprite_get_width(spr_Slot)/1.5*scale - string_width(Amount), yy + sprite_get_height(spr_Slot)/1.5*scale, Amount, c_white, c_black, 1);
		}
		
		draw_set_alpha(1);
	}
	
	if(instance_exists(oPlayer)){
		if(VarSlot == oPlayer.WeaponID){
			draw_sprite_ext(sprite_index, 8, xx, yy, scale, scale, 0, image_blend, slot_alpha);
		}
	}
	
	if (global.MouseSlot[# 0, Index.slot_id] != Item.None){
	    draw_sprite_ext(spr_Items, global.MouseSlot[# 0, Index.slot_id], xx2, yy2, scale, scale, 0, c_white, slot_alpha);
	} 
	
	
	if(mouse_to_gui(xx, yy, xx + sprite_get_width(spr_Slot)*scale, yy + sprite_get_height(spr_Slot)*scale)){
		image_blend = MAIN_COLOR;
		
		if(mouse_check_button_pressed(mb_left) && MouseID == Item.None){
			item_description_destroy();
			if(oDraw.DrawInfo == true){
				oDraw.DrawInfo = false;
			}
			with(oSlot){
				DrawItemInfo = false;
			}
			if(VarSlot < OtherSlot.Primary){
				oPlayer.item_use_position = VarSlot;
			}
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

			if(VarSlot <= INVENTORY_SIZE){
				
				#region Usable slots item switching
				if (Id == 0 || MouseID == 0 || Id != MouseID || (Id == MouseID && global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet" || global.ItemIndex[#Id, ItemStat.Type] == "Shield" || global.ItemIndex[#Id, ItemStat.Type] == "Weapon")){
					item_swap("mouse", VarSlot);
				}else if (Id == MouseID){
					global.Inventory[# VarSlot, 1] += global.MouseSlot[# 0, Index.SlotAmount];
					global.MouseSlot[# 0, Index.slot_id] = Item.None;
					global.MouseSlot[# 0, Index.SlotAmount] = 0;
				}
				#endregion
			
			}else if(VarSlot == OtherSlot.Primary){
			
				#region Primary equip and dequip
				if (Id != Item.None && (MouseID == Item.None || global.ItemIndex[#MouseID, ItemStat.WeaponType] == "Primary")) {
				    item_swap("mouse", VarSlot);
				    Id = Item.None;
				} else if (global.ItemIndex[#MouseID, ItemStat.WeaponType] == "Primary") {
				    item_swap("mouse", VarSlot);
				}
				#endregion
				
			}else if(VarSlot == OtherSlot.Secondary){
				
				#region Secondary equip and dequip
				if (Id != Item.None && (MouseID == Item.None || global.ItemIndex[#MouseID, ItemStat.WeaponType] == "Secondary")) {
				    item_swap("mouse", VarSlot);
				    Id = Item.None;
				} else if (global.ItemIndex[#MouseID, ItemStat.WeaponType] == "Secondary") {
				    item_swap("mouse", VarSlot);
				}
				#endregion
				
			}else if(VarSlot == OtherSlot.Knife){
				
				#region Knife equip and dequip
				if (Id != Item.None && (MouseID == Item.None || global.ItemIndex[#MouseID, ItemStat.WeaponType] == "Tertiary")) {
				    item_swap("mouse", VarSlot);
				    Id = Item.None;
				} else if (global.ItemIndex[#MouseID, ItemStat.WeaponType] == "Tertiary") {
				    item_swap("mouse", VarSlot);
				}
				#endregion
				
			}else if(VarSlot == OtherSlot.Helmet){
				
				#region Helmet equip and dequip
				if (Id != Item.None && (MouseID == Item.None || global.ItemIndex[#MouseID, ItemStat.Type] == "Helmet")) {
					ItemAddWeight(MouseID, global.Inventory[# VarSlot, Index.slot_id]);
				    item_swap("mouse", VarSlot);
				    Id = Item.None;
				} else if (global.ItemIndex[#MouseID, ItemStat.Type] == "Helmet") {
					ItemAddWeight(MouseID, global.Inventory[# VarSlot, Index.slot_id]);
				    item_swap("mouse", VarSlot);
				}
				#endregion
				
			}else if(VarSlot == OtherSlot.Armour){
				
				#region Armour equip and dequip
				if (Id != Item.None && (MouseID == Item.None || global.ItemIndex[#MouseID, ItemStat.Type] == "Armour")) {
					ItemAddWeight(MouseID, global.Inventory[# VarSlot, Index.slot_id]);
				    item_swap("mouse", VarSlot);
				    Id = Item.None;
				} else if (global.ItemIndex[#MouseID, ItemStat.Type] == "Armour") {
					ItemAddWeight(MouseID, global.Inventory[# VarSlot, Index.slot_id]);
				    item_swap("mouse", VarSlot);
				}
				#endregion
				
			}else if(VarSlot == OtherSlot.Shield){
				
				#region Shield equip and dequip
				if (Id != Item.None && (MouseID == Item.None || global.ItemIndex[#MouseID, ItemStat.Type] == "Shield")) {
				    item_swap("mouse", VarSlot);
				    Id = Item.None;
				} else if (global.ItemIndex[#MouseID, ItemStat.Type] == "Shield") {
				    item_swap("mouse", VarSlot);
				}
				#endregion
				
			}		
		}
	}else{
		image_blend = c_white;
	}
}

#endregion

if(instance_exists(oPlayer) && RespawnMenu == false && PauseMenu == false && !instance_exists(oBuyMenu)){
	
	#region Draw shooting mode
	if(global.Inventory[# oPlayer.WeaponID, Index.slot_id] != Item.None && !instance_exists(oInventory)){ 
		var shooting_mode_string = ds_list_find_value(global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.ShootingMode], oPlayer.weapon_shooting_mode) + 
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
		if(oPlayer.player_has_scope == 0){
			var ScopeBlurValue = min((.005 + (oPlayer.ViewShake / 100)) * (inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer)*5), 0.1);
			BlurValue = lerp(BlurValue, ScopeBlurValue, 0.05);
			var ScopeRadius = sprite_get_width(spr_SniperScope) * 2;
			if (!surface_exists(BlackoutSurface)) {
				BlackoutSurface = surface_create(SurfaceWidth, SurfaceHeight);
			} else if (surface_get_width(BlackoutSurface) != SurfaceWidth || surface_get_height(BlackoutSurface) != SurfaceHeight) {
				surface_resize(BlackoutSurface, SurfaceWidth, SurfaceHeight);
			}
					
			#region Zoom unused
			/*ZoomValue = lerp(ZoomValue, scope_zoom_value, 0.01);
		    var captureWidth = ScopeRadius*4;
		    var captureHeight = ScopeRadius*4;
		    var captureX = oCrosshair.crosshair_x - captureWidth / 2;
		    var captureY = oCrosshair.crosshair_y - captureHeight / 2;

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
			shader_reset();*/
			#endregion
			
			#region Fish eye zoom
			var scope_zoom_value = 1.5;
			ZoomValue = lerp(ZoomValue, scope_zoom_value, .01);
			var captureWidth = ScopeRadius * 4;
			var captureHeight = ScopeRadius * 4;
			var captureX = oCrosshair.crosshair_x - captureWidth / 2;
			var captureY = oCrosshair.crosshair_y - captureHeight / 2;

			// Check if surface exists and then set its target
			if (surface_exists(zoomSurface)) {
			    surface_set_target(zoomSurface);
			    draw_surface_part_ext(application_surface, captureX, captureY, captureWidth, captureHeight, 0, 0, 1, 1, c_olive, 1);
			    surface_reset_target();
			} else {
			    zoomSurface = surface_create(captureWidth, captureHeight);
			}

			// Set the fish-eye shader
			shader_set(shd_FishEye);
			shader_set_uniform_f(shader_get_uniform(shd_FishEye, "u_zoomFactor"), ZoomValue); // Adjust this for the zoom level you want
			draw_surface(zoomSurface, captureX, captureY);
			shader_reset();
			#endregion
			
			#region Draw black surface
			surface_set_target(BlackoutSurface);
			draw_clear_alpha(c_black, 1);
			gpu_set_blendmode(bm_subtract);

			// Draw a circle at the mouse position to create a "view" in the black surface
			draw_circle(oCrosshair.crosshair_x, oCrosshair.crosshair_y, ScopeRadius, false);

			gpu_set_blendmode(bm_normal);
			
			draw_set_alpha(.5);
			draw_circle_color(oCrosshair.crosshair_x, oCrosshair.crosshair_y, ScopeRadius, c_olive, c_olive, false);
			draw_set_alpha(1);
			surface_reset_target();
			draw_surface(BlackoutSurface, 0, 0);
			#endregion
			
			#region Draw scope
		    shader_set(shd_Blur1Pass);
		    shader_set_uniform_f(usize, 64, 64, BlurValue);
			draw_sprite_ext(spr_SniperScope, oPlayer.player_has_scope, oCrosshair.crosshair_x + oCrosshair.x_offset, oCrosshair.crosshair_y + oCrosshair.y_offset, 4.2, 4.2, 0, c_white, 0.75);
			shader_reset();
			#endregion
			
		}else if(oPlayer.player_has_scope == 1){
			var ScopeBlurValue = min((.005 + (oPlayer.ViewShake / 100)) * (inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer)), 0.15);
			BlurValue = lerp(BlurValue, ScopeBlurValue, 0.05);
		    shader_set(shd_Blur1Pass);
		    shader_set_uniform_f(usize, 64, 64, BlurValue);
			draw_sprite_ext(spr_SniperScope, oPlayer.player_has_scope, oCrosshair.crosshair_x + oCrosshair.x_offset, oCrosshair.crosshair_y + oCrosshair.y_offset, 2.1, 2.1, 0, c_white, 0.5);
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
		
		#region Draw item switching inside of inventory
		if(instance_exists(oInventory)){
			draw_set_font(set_font("Console"));
			var CycleUpString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleInvUp])) + "] - Cycle up";
			var CycleDownString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleInvDown])) + "] - Cycle down";
			var CycleLeftString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleInvLeft])) + "] - Cycle left";
			var CycleRightString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleInvRight])) + "] - Cycle right";
			var position_y = oDraw.HUDShift*2;
			var position_x = global.GuiW/2 - string_width(CycleRightString)/2; 
			draw_text_outlined(position_x, position_y, CycleUpString, c_white, c_black, 1);
			draw_text_outlined(position_x, position_y + string_height("A"), CycleLeftString, c_white, c_black, 1);
			draw_text_outlined(position_x, position_y + string_height("A")*2, CycleDownString, c_white, c_black, 1);
			draw_text_outlined(position_x, position_y + string_height("A")*3, CycleRightString, c_white, c_black, 1);
		}
		#endregion
		
		#region Draw mortar GUI
		if (oPlayer.moving_state == player_states.mortar_state) {
		    var mortar_object = instance_nearest(oPlayer.x, oPlayer.y, oMortar);
		    var camera_width = camera_get_view_width(view_camera[0]) * 3;
		    var camera_height = camera_get_view_height(view_camera[0]) * 3;
		    var xx = (mortar_object.x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
		    var yy = (mortar_object.y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);

		    // Draw the vertical line
		    draw_line(xx, yy - camera_height, xx, yy + camera_height);
    
		    // Draw numbers on the vertical line starting from zero
		    for (var i = 0; i <= camera_height; i += 100) {
		        if (i != 0) {
		            draw_text(xx + 10, yy - i, string(i)); // Positive numbers on top
		            draw_text(xx + 10, yy + i, string(-i)); // Negative numbers on bottom
		        }
		    }

		    // Draw the horizontal line
		    draw_line(xx - camera_width, yy, xx + camera_width, yy);
    
		    // Draw numbers on the horizontal line starting from zero
		    for (var j = 0; j <= camera_width; j += 100) {
		        if (j != 0) {
		            draw_text(xx + j, yy + 10, string(j)); // Positive numbers on right
		            draw_text(xx - j, yy + 10, string(-j)); // Negative numbers on left
		        }
		    }
		}
		#endregion
		
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
					(equip_time/global.ItemIndex[# WeaponID[1 - WeaponPositionID], ItemStat.EquipTime]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
					default_yy -= bar_spacing;
				}
					
				if!(instance_exists(oInventory)){
					draw_sprite_ext(spr_ranks, get_rank(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]), default_xx, default_yy, 1, 1, 0, c_white, global.GUIHUDAlpha);
				}
			}
		}
		#endregion

		#region Draw damage indicator
		with(oDamageIndicator){
		    var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
		    var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
			draw_set_font(Font);
		    draw_text_outlined(xx, yy, Damage_Indicator, Color, c_black, 1);
		    draw_sprite_ext(Sprite, SpriteID, xx + string_width(Damage_Indicator), yy, 1, 1, 0, c_white, 1);
			draw_set_font(set_font("Console"));
		}
		#endregion
	
		#region Draw use button
		if!(instance_exists(oInventory)){
			if(instance_exists(oItems)){
				with(oItems){
					var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
					var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
				    if(distance_to_object(oPlayer) <= oPlayer.PickUpDistance){   
						draw_text_outlined(round(xx), round(yy), oDraw.Pick, c_white, c_black, 1);
				    }
				}
			}
			
			if(oPlayer.moving_state == player_states.none_state){
				if(instance_exists(oMachineGun)){
					with(oMachineGun){
						var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
						var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
					    if(distance_to_object(oPlayer) <= oPlayer.PickUpDistance){   
							draw_text_outlined(round(xx), round(yy), oDraw.Pick, c_white, c_black, 1);
					    }
					}
				}
			
				if(instance_exists(oMortar)){
					with(oMortar){
						var xx = (x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
						var yy = (y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
					    if(distance_to_object(oPlayer) <= oPlayer.PickUpDistance){   
							draw_text_outlined(round(xx), round(yy), oDraw.Pick, c_white, c_black, 1);
					    }
					}
				}
			}
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

		if!(instance_exists(oInventory)){
			
			#region Draw item switching outside of inventory
			if(global.Inventory[#oPlayer.item_use_position, Index.slot_id] != Item.None){
				var CycleLeftString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleLeft])) + "] - Left ";
				var CycleRightString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleRight])) + "] - Right";
				var ItemX = HUDShift + sprite_get_width(spr_Items)/2 * global.GUIMultiplier;
			    var Id = global.Inventory[#oPlayer.item_use_position, Index.slot_id];        
			    draw_sprite_ext(spr_Items, Id, ItemX, ItemY, 1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1);  
				draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier, ItemY + TextHeightSmall*2, global.ItemIndex[#Id, ItemStat.Name], c_white, c_black, 1);            
				draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier, ItemY + TextHeightSmall*3, CycleLeftString, c_white, c_black, 1);
				draw_text_outlined(ItemX - sprite_get_width(spr_Items)/2 * global.GUIMultiplier + string_width(CycleLeftString), ItemY + TextHeightSmall*3, CycleRightString, c_white, c_black, 1);
			}
			#endregion
			
			#region Draw player healtbars, mags and money
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
			var AmmoDrawValue = min(ceil(global.Inventory[# oPlayer.WeaponID, Index.slot_clip_ammo]/global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.MaxAmmo]), 10);
			var AmmoRemain = ceil(global.Inventory[# oPlayer.WeaponID, Index.slot_clip_ammo]/global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.MaxAmmo]) - AmmoDrawValue;
			var Value = 0;
			var money_string = "Money: " + string(global.player_stats_struct.Money);
			var money_x = HUDShift;
			var money_y = StaminaY - bar_gap*4;
		
			if(global.Inventory[# oPlayer.WeaponID, Index.slot_id] != Item.None){
				for(var i=0;i<AmmoDrawValue;i++){
					draw_sprite_ext(spr_AmmoType, global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.AmmoSpriteID], MagX + (i*AmmoSpriteWidth), MagY, 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, global.GUIHUDAlpha);
					Value ++;
				}
		
				if(AmmoRemain > 0){
					var AmmoRemainString = "(+" + string(AmmoRemain) + ")";
					draw_text_outlined(MagX*1.25 + ((Value-1)*AmmoSpriteWidth) - string_width(AmmoRemainString), MagY + string_height("a")/2, AmmoRemainString, c_white, c_black, 1);
				}
			}
			
			draw_text_outlined(money_x, money_y, "Money: ", c_white, c_black, 1);
			draw_text_outlined(money_x + string_width("Money: "), money_y, string(global.player_stats_struct.Money), global.gold_color, c_black, 1);
			draw_sprite_ext(spr_Coin, 0, money_x + 8 + string_width(money_string)*1.1, money_y, 2 * global.GUIMultiplier, 2 * global.GUIMultiplier, 0, c_white, 1);

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
			
			#region Draw HUD weapon, armour and helmet
			with(oPlayer){
		
				var HotBarOffsetX = sprite_get_width(spr_Items)/2 * global.GUIMultiplier;
				var HotBarOffsetY = sprite_get_height(spr_Items) * global.GUIMultiplier;
				var HotBarX = display_get_gui_width() - HotBarOffsetX - oDraw.HUDShift;
				var HotBarY = display_get_gui_height();
				var HotBarTabWidth = display_get_gui_width() - (HotBarX - HotBarOffsetX*2) - oDraw.HUDShift;
		
				#region Draw HUD weapon
				var r = 54;
				var g = 54;
				var b = 54;
				Value = 0;
				for(var i=0;i<oDraw.HotBarItems;i++){
					var Id = global.Inventory[# (OtherSlot.Knife - i), Index.slot_id];
					if(Id != Item.None){
					
						#region Draw weapon
						shader_set(shd_LightGray);
						if(WeaponID == OtherSlot.Knife - i){
							shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
						}else{
							shader_set_uniform_f(oDraw.BlendColor, r/255, g/255, b/255, 1.0);	
						}
						draw_sprite_ext(
							spr_Items, Id, HotBarX, HotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
						);		
						shader_reset();
						#endregion
					
						#region Draw no ammo weapon
						if(global.ItemIndex[# Id, ItemStat.MaxAmmo] != -1){ ///Pokud item není nůž
							if(global.Inventory[# (OtherSlot.Knife - i), Index.slot_clip_ammo] <= 0 && global.Inventory[# (OtherSlot.Knife - i), Index.slot_ammo] <= 0){
								draw_sprite_ext(
									spr_broken, 0, HotBarX, HotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
									1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
								);		
							}
						}
						#endregion
					
						Value ++;
					}
				}
				#endregion
				
				#region Draw HUD armour and helmet
				Value = 0;
				var armour_slots = 3;
				var ArmourHotBarX = HotBarX - sprite_get_width(spr_Items)/1.25*global.GUIMultiplier;
				var ArmourHotBarY = HotBarY;
				for(var i=0;i<armour_slots;i++){
					if(global.Inventory[# (OtherSlot.Shield - i), Index.slot_id] != Item.None){
					
						#region Draw armour and helmet
						shader_set(shd_LightGray);
						shader_set_uniform_f(oDraw.BlendColor, 0.1, 0.1, 0.1, 1.0);
						draw_sprite_ext(
							spr_Items, global.Inventory[# (OtherSlot.Shield - i), Index.slot_id], ArmourHotBarX, ArmourHotBarY - HotBarOffsetY - Value*HotBarOffsetY, 
							1 * global.GUIMultiplier, 1 * global.GUIMultiplier, 0, c_white, 1
						);		
						shader_reset();
						#endregion
					
					
						#region Draw broken armour and helmet
						if(global.Inventory[# (OtherSlot.Shield - i), Index.slot_durability] <= 0 && global.Inventory[# (OtherSlot.Shield - i), Index.slot_id] != Item.None){
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
			#endregion
		
		}
	
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
			    (ReloadTime/global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
				default_yy -= bar_spacing;
			}
			
			if(equip_timer > -1){
			    draw_sprite_ext(spr_HealthBar, 0, xx - sprite_width/2, default_yy, 1*global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
			    draw_sprite_ext(spr_HealthBar, 7, xx - sprite_width/2, default_yy,
			    (equip_time/global.ItemIndex[# global.Inventory[# min(max(OtherSlot.Secondary - WeaponID, OtherSlot.Primary), OtherSlot.Knife), Index.slot_id], ItemStat.EquipTime]) * global.GUIMultiplier, 1*global.GUIMultiplier, 0, c_white, 1);
				default_yy -= bar_spacing;
			}
			
			var rank_position = 0;
			if(global.player_elo_struct.Played_games >= TRACKING_GAMES/2){
				rank_position = get_rank(global.player_elo_struct.Elo);	
			}
			if!(instance_exists(oInventory)){
				draw_sprite_ext(spr_ranks, rank_position, xx - sprite_width/2, default_yy, 1, 1, 0, c_white, global.GUIHUDAlpha);
			}
		}
		#endregion
		
	}

}
if(!instance_exists(oBuyMenu) && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments)){
	
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
	
	if(instance_exists(oPlayer) && RespawnMenu == false && PauseMenu == false){
	
		#region Draw ranked score
		if(global.ranked_game == true){
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
	
		#region Draw admin HUD
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
			var player_inaccuracy = inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer);
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
		#endregion
	
	}

}

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

#region Console
console_draw(global.my_console, global.ConsoleHeight * global.GUIMultiplier,c_gray,c_silver,c_white,c_white, global.GUIHUDAlpha*2, global.ConsoleWidth * global.GUIMultiplier);
#endregion

#region Crosshair
with(oCrosshair){
	var x_scale = image_xscale * .5;
	var y_scale = image_yscale * .5;
	crosshair_x = (x + x_offset - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	crosshair_y = (y + y_offset - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	if(instance_exists(oPlayer)){
		if(HitMarker > -1){
			draw_sprite_ext(spr_HitMarker, HitMarker, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, image_blend, global.CrosshairAlpha);	
		}
		if(oPlayer.player_can_shoot == true && !global.my_console[? "active"] && global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] != "Sniper rifle" && oPlayer.ScopeIn == false){
			draw_sprite_ext(spr_StaticCrosshair, 0, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
			if(global.DynamicCrosshair == true){
				Gap = 25;
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					crosshair_x - Gap - inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer)*2 + x_offset, 
					crosshair_y, 
					y_scale, 
					x_scale, 
					0, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Left
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					crosshair_x + Gap + inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer)*2 + x_offset, 
					crosshair_y, 
					y_scale, 
					x_scale, 
					0, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Right
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					crosshair_x, 
					crosshair_y - Gap - inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer)*2 + y_offset, 
					y_scale, 
					x_scale, 
					90, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Top
				draw_sprite_ext(
					spr_DynamicCrosshair, 
					0, 
					crosshair_x, 
					crosshair_y + Gap + inaccuracy_formula(global.Inventory[# oPlayer.WeaponID, Index.slot_id], oPlayer)*2 + y_offset, 
					y_scale, 
					x_scale, 
					90, 
					global.crosshair_color, 
					global.CrosshairAlpha
				); ///Down
			}
		}
	}else{
		draw_sprite_ext(spr_StaticCrosshair, 0, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
		if(global.DynamicCrosshair == true){
			Gap = 25;
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x - Gap - 1 + x_offset, crosshair_y, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Left
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x + Gap + 1 + x_offset, crosshair_y, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Right
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x, crosshair_y - Gap - 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Top
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x, crosshair_y + Gap + 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Down
		}
	}
}
#endregion

