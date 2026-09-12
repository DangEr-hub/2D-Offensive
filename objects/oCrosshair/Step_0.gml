recoil_speed = .1;
WobbleResetSpeed = .25;
StabilizationSpeed = 15;
if(global.local_player.weapon_shooting_mode == "Semi"){
	recoil_speed = 10;
	StabilizationSpeed = 75;
}

if(HitMarker > -1){	
	HitMarker += .5;
	if(HitMarker % 4 == 0){
		HitMarker = -1;
	}
}

if(instance_exists(global.local_player)){
	
	#region Wobble
	if(global.local_player.CrosshairShake > 0){
		WobbleX += global.local_player.CrosshairShake;
		WobbleY += global.local_player.CrosshairShake * 1.5;
		WobbleCrosshairMultiplier = global.local_player.CrosshairShake;
	}else{
		WobbleCrosshairMultiplier = lerp(WobbleCrosshairMultiplier, 0, WobbleResetSpeed);
	}
	
	if (global.local_player.stats.Stamina_points <= global.player_stats.Max_stamina * 0.75) {
	    if (global.local_player.ScopeIn == true) {
	        WobbleX += 5*max(100/(global.local_player.stats.Stamina_points + 1), 3);
	        WobbleY += 5*max(100/(global.local_player.stats.Stamina_points + 1), 3) * 1.5;
	        WobbleScopeInMultiplier = clamp(100/(global.local_player.stats.Stamina_points + 1), 3, 10);
	    } else {
	        WobbleX += 5*max(round((100/(global.local_player.stats.Stamina_points + 1)) - 1)*2, 0);
	        WobbleY += 5*max(round((100/(global.local_player.stats.Stamina_points + 1)) - 1)*2, 0) * 1.5;
	        WobbleScopeInMultiplier = clamp(round((100/(global.local_player.stats.Stamina_points + 1)) - 1)*5, 0, 10);
	    }
	}

	if(global.local_player.AimPunchTimer > -1){
		WobbleX += global.local_player.AimPunchTimer * .25;
		WobbleY += global.local_player.AimPunchTimer * 1.5;
		WobbleAimPunchMultiplier = global.local_player.AimPunchTimer;	
	}else{
		WobbleAimPunchMultiplier = lerp(WobbleAimPunchMultiplier, 0, WobbleResetSpeed);	
	}
	
	var WobbleMultiplier = WobbleCrosshairMultiplier + WobbleScopeInMultiplier + WobbleAimPunchMultiplier;
	x_offset = sin(degtorad(WobbleX)) * WobbleMultiplier;
	y_offset = sin(degtorad(WobbleY)) * WobbleMultiplier;
	#endregion

	#region Recoil
	var horizontal_recoil_multiplier = global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_grip], ItemStat.KickBackInaccuracyMultiplier];
	var vertical_recoil_multiplier = global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_grip], ItemStat.KickBackPower];	
	var recoilY = global.ItemIndex[# global.local_player.wpn_id, ItemStat.RecoilY] * horizontal_recoil_multiplier;
	var recoilX = global.ItemIndex[# global.local_player.wpn_id, ItemStat.RecoilX] * vertical_recoil_multiplier;
	
	if(global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.HardRecoil] == true){
		
		#region Hard recoil
		if(global.local_player.KickBack > 0){
			
			#region Variables
			var KBPhase1 = global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.KBPhase1];
			var KBPhase2 = global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.KBPhase2];
			#endregion

			if ((!global.local_player.CanShoot && global.local_player.ShootTimer >= global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.ShootTimer] / 2 
			/*&& global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL*/) 
			|| (global.local_player.shooting /*&& global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] != WEAPON_CLASS.PISTOL*/)) {
				
				#region Recoil mechanic
			    axis_multiplier[1] = -sign(global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.RecoilY]);
			    var targetX = mouse_x;
			    var targetY = mouse_y;
				
			    if (global.local_player.KickBack == KBPhase1 || global.local_player.KickBack == KBPhase2) {
			        global.local_player.DeltaKickBack = global.local_player.KickBack;
			    }					

			    if (global.local_player.KickBack <= KBPhase1) {
					targetY = mouse_y - global.local_player.KickBack * recoilY;
			    } else if (global.local_player.KickBack < KBPhase2) {
			        targetX -= ((global.local_player.KickBack - global.local_player.DeltaKickBack) * recoilX);
					targetY = mouse_y - DeltaY;
			    } else {
					targetX += ((global.local_player.KickBack - global.local_player.DeltaKickBack) * recoilX) - ((KBPhase2 - KBPhase1) * recoilX);
					targetY = mouse_y - DeltaY;
			    }

			    x = lerp(x, targetX, recoil_speed*2);
			    y = lerp(y, targetY, recoil_speed*2);

			    var newDeltaX = mouse_x - x;
			    var newDeltaY = mouse_y - y;
			    DeltaX = newDeltaX;
				if(global.local_player.KickBack <= KBPhase1){
				 DeltaY = newDeltaY;
				}
				#endregion
				
			}else {
				
				#region Recoil reset
				axis_multiplier[0] = sign(global.local_player.crosshair_position[0] - mouse_x);
				distance[0] = abs(global.local_player.crosshair_position[0] - mouse_x);
				distance[1] = abs(global.local_player.crosshair_position[1] - mouse_y);
				
				if(axis_multiplier[0] == -1){ //If recoil goes to the left
					if(x < mouse_x){
						x = global.local_player.crosshair_position[0] - (distance[0]/global.local_player.KickBack * axis_multiplier[0]);
					}else{
						x = mouse_x;
					}
				}else if(axis_multiplier[0] == 1){ //If recoil goes to the right
					if(x > mouse_x){
						x = global.local_player.crosshair_position[0] - (distance[0]/global.local_player.KickBack * axis_multiplier[0]);
					}else{
						x = mouse_x;
					}
				}
				
				if(axis_multiplier[1] == -1){ //If recoil goes up
					if(y < mouse_y){
						y = global.local_player.crosshair_position[1] - (distance[1]/global.local_player.KickBack * axis_multiplier[1]);
					}else{
						y = mouse_y;
					}
				}else if(axis_multiplier[1] == 1){ //If recoil goes down
					if(y > mouse_y){
						y = global.local_player.crosshair_position[1] - (distance[1]/global.local_player.KickBack * axis_multiplier[1]);
					}else{
						y = mouse_y;
					}
				}
				#endregion
				
			}
		}else{
			x = lerp(x, mouse_x, WobbleResetSpeed*2);
			y = lerp(y, mouse_y, WobbleResetSpeed*2);
		}
		#endregion
		
	}else{

		#region Basic recoil
		if(global.local_player.CanShoot == false && global.local_player.ShootTimer >= global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.ShootTimer]/2){
			if(RecoilTimer[0] == -1){
				RecoilTimer[0] = floor(abs(recoilY)/StabilizationSpeed);
			}
			if(RecoilTimer[1] == -1){
				RecoilTimer[1] = floor(abs(recoilX)/StabilizationSpeed);
			}
		}
		
		
		#region Recoil Y
		if(RecoilTimer[0] > -1){
			Recoil[0] += StabilizationSpeed * sign(recoilY);
			Recoil[0] = min(Recoil[0], recoilY * global.local_player.KickBack);
			RecoilTimer[0] --;
		}else{
			Recoil[0] -= StabilizationSpeed * sign(recoilY);
			Recoil[0] = max(0, Recoil[0]);
		}
		#endregion
		
		#region Recoil X
		if(RecoilTimer[1] > -1){
			if(global.Inventory[# global.local_player.WeaponID, Index.slot_ammo] % 2 == 0){ 
				Recoil[1] += StabilizationSpeed * sign(recoilX);
				Recoil[1] = min(Recoil[1], recoilX * global.local_player.KickBack);
			}else{
				Recoil[1] -= StabilizationSpeed * sign(recoilX);
				Recoil[1] = min(abs(Recoil[1]), recoilX * global.local_player.KickBack);
			}
			RecoilTimer[1] --;
		}else{
			Recoil[1] -= StabilizationSpeed * sign(recoilX);
			Recoil[1] = clamp(Recoil[1], 0, mouse_x);
		}
		#endregion
		
		
		x = lerp(x, mouse_x - Recoil[1], WobbleResetSpeed*2);
		y = lerp(y, mouse_y - Recoil[0], WobbleResetSpeed*2);
		
		#endregion
		
	}
	// Fade only the recoil offset near the opposite viewport edge. This keeps
	// the spray pattern intact while allowing the crosshair to reach every edge.
	var view_left = oDraw.ViewX;
	var view_top = oDraw.ViewY;
	var view_right = view_left + oDraw.ViewW;
	var view_bottom = view_top + oDraw.ViewH;
	var recoil_from_mouse_x = x - mouse_x;
	var recoil_from_mouse_y = y - mouse_y;

	if(recoil_from_mouse_x < 0){
		recoil_from_mouse_x *= clamp((view_right - mouse_x) / max(1, abs(recoil_from_mouse_x)), 0, 1);
	}else if(recoil_from_mouse_x > 0){
		recoil_from_mouse_x *= clamp((mouse_x - view_left) / max(1, abs(recoil_from_mouse_x)), 0, 1);
	}

	if(recoil_from_mouse_y < 0){
		recoil_from_mouse_y *= clamp((view_bottom - mouse_y) / max(1, abs(recoil_from_mouse_y)), 0, 1);
	}else if(recoil_from_mouse_y > 0){
		recoil_from_mouse_y *= clamp((mouse_y - view_top) / max(1, abs(recoil_from_mouse_y)), 0, 1);
	}

	x = clamp(mouse_x + recoil_from_mouse_x, view_left, view_right);
	y = clamp(mouse_y + recoil_from_mouse_y, view_top, view_bottom);
	#endregion

	#region Scope sway
	var target_sway_strength = 0;
	if(global.local_player.ScopeIn){
		var stamina_ratio = clamp(
			global.local_player.stats.Stamina_points / max(1, global.player_stats.Max_stamina),
			0,
			1
		);
		target_sway_strength = lerp(20, 10, stamina_ratio);

		if(global.local_player.moving_state == STATES_PLAYER.prone_state){
			target_sway_strength *= 0.5;
		}else if(global.local_player.Moving){
			target_sway_strength *= 2.0;
		}

		scope_sway_phase_x += 1.15 * global.time_step;
		scope_sway_phase_y += 0.85 * global.time_step;
	}

	var sway_lerp = min(1, 0.75 * global.time_step);
	scope_sway_strength = lerp(scope_sway_strength, target_sway_strength, sway_lerp);
	scope_sway_x = (dsin(scope_sway_phase_x) + dsin(scope_sway_phase_y * 0.7) * 0.35) * scope_sway_strength;
	scope_sway_y = (dsin(scope_sway_phase_y) + dsin(scope_sway_phase_x * 0.55) * 0.25) * scope_sway_strength * 1.25;
	#endregion
	
}

#region Dynamic crosshair
AlphaMul = 1;
if(global.DynamicCrosshair == true){
	AlphaMul = .25;
}
#endregion

x = round(x);
y = round(y);
var scoped_aim = instance_exists(global.local_player) && global.local_player.ScopeIn;
aim_x = clamp(x + scope_sway_x + (scoped_aim ? x_offset : 0), oDraw.ViewX, oDraw.ViewX + oDraw.ViewW);
aim_y = clamp(y + scope_sway_y + (scoped_aim ? y_offset : 0), oDraw.ViewY, oDraw.ViewY + oDraw.ViewH);
visual_x = aim_x + (scoped_aim ? 0 : x_offset);
visual_y = aim_y + (scoped_aim ? 0 : y_offset);
crosshair_x = (visual_x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
crosshair_y = (visual_y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
