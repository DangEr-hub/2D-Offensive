crosshair_x = (x + x_offset - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
crosshair_y = (y + y_offset - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
recoil_speed = .1;
WobbleResetSpeed = .25;
StabilizationSpeed = 15;
if(global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
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
	
	if (global.local_player.stats.Stamina_points <= global.player_stats_struct.Max_stamina * 0.75) {
	    if (global.local_player.ScopeIn == true) {
	        WobbleX += 5*max(100/(global.local_player.stats.Stamina_points + 1), 3);
	        WobbleY += 5*max(100/(global.local_player.stats.Stamina_points + 1), 3) * 1.5;
	        WobbleScopeInMultiplier = clamp(100/(global.local_player.stats.Stamina_points + 1), 3, 10);
	    } else {
	        WobbleX += 5*max(ceil((100/(global.local_player.stats.Stamina_points + 1)) - 1)*2, 0);
	        WobbleY += 5*max(ceil((100/(global.local_player.stats.Stamina_points + 1)) - 1)*2, 0) * 1.5;
	        WobbleScopeInMultiplier = clamp(ceil((100/(global.local_player.stats.Stamina_points + 1)) - 1)*5, 0, 10);
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
			var MaxKickBack = global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.MaxAmmo];
			#endregion

			if ((!global.local_player.CanShoot && global.local_player.ShootTimer >= global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.ShootTimer] / 2 && global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL) || (global.local_player.shooting && global.ItemIndex[# global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] != WEAPON_CLASS.PISTOL)) {
				
				#region Recoil mechanic
			    axis_multiplier[1] = -sign(global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.RecoilY]);
			    var targetX = mouse_x;
			    var targetY = mouse_y;
				
			    if (global.local_player.KickBack == KBPhase1 || global.local_player.KickBack == KBPhase2 || global.local_player.KickBack >= MaxKickBack) {
			        global.local_player.DeltaKickBack = global.local_player.KickBack;
			    }					

			    if (global.local_player.KickBack <= KBPhase1) {
					targetY = mouse_y - global.local_player.KickBack * recoilY;
			    } else if (global.local_player.KickBack < KBPhase2) {
			        targetX -= ((global.local_player.KickBack - global.local_player.DeltaKickBack) * recoilX);
					targetY = mouse_y - DeltaY;
			    } else {
					if(sign(recoilX) == -1){
						targetX += (global.local_player.KickBack - global.local_player.DeltaKickBack) * recoilX;
					}else{
						targetX += ((global.local_player.KickBack - global.local_player.DeltaKickBack) * recoilX) - (KBPhase1 * recoilX);
					}
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
	x = clamp(x,0,room_width-sprite_width);
	y = clamp(y,0,room_height-sprite_height);
	#endregion
	
}

#region Dynamic crosshair
AlphaMul = 1;
if(global.DynamicCrosshair == true){
	AlphaMul = .25;
}
#endregion