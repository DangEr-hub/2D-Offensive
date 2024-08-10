crosshair_x = (x + x_offset - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
crosshair_y = (y + y_offset - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
recoil_speed = .1;
WobbleResetSpeed = .25;
StabilizationSpeed = 15;
if(global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == "Pistol"){
	recoil_speed = 10;
	StabilizationSpeed = 75;
}

if(HitMarker > -1){	
	HitMarker += .5;
	if(HitMarker % 4 == 0){
		HitMarker = -1;
	}
}

if(instance_exists(oPlayer) ){
	
	#region Wobble
	if(oPlayer.CrosshairShake > 0){
		WobbleX += oPlayer.CrosshairShake;
		WobbleY += oPlayer.CrosshairShake * 1.5;
		WobbleCrosshairMultiplier = oPlayer.CrosshairShake;
	}else{
		WobbleCrosshairMultiplier = lerp(WobbleCrosshairMultiplier, 0, WobbleResetSpeed);
	}
	
	if(oPlayer.ScopeIn == true){
	    WobbleX += max(100/(oPlayer.stats.Stamina_points + 1), 3);
	    WobbleY += max(100/(oPlayer.stats.Stamina_points + 1), 3) * 1.5;
		WobbleScopeInMultiplier = clamp(100/(oPlayer.stats.Stamina_points + 1), 3, 10);		
	}else{
	    WobbleX += max(ceil((100/(oPlayer.stats.Stamina_points + 1)) - 1)*2, 0);
	    WobbleY += max(ceil((100/(oPlayer.stats.Stamina_points + 1)) - 1)*2, 0) * 1.5;
		WobbleScopeInMultiplier = clamp(ceil((100/(oPlayer.stats.Stamina_points + 1)) - 1)*5, 0, 10);		
	}
	
	if(oPlayer.AimPunchTimer > -1){
		WobbleX += oPlayer.AimPunchTimer * .25;
		WobbleY += oPlayer.AimPunchTimer * 1.5;
		WobbleAimPunchMultiplier = oPlayer.AimPunchTimer;	
	}else{
		WobbleAimPunchMultiplier = lerp(WobbleAimPunchMultiplier, 0, WobbleResetSpeed);	
	}
	
	var WobbleMultiplier = WobbleCrosshairMultiplier + WobbleScopeInMultiplier + WobbleAimPunchMultiplier;
	x_offset = sin(degtorad(WobbleX)) * WobbleMultiplier;
	y_offset = sin(degtorad(WobbleY)) * WobbleMultiplier;
	#endregion

	#region Recoil
	var horizontal_recoil_multiplier = global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_grip], ItemStat.KickBackInaccuracyMultiplier];
	var vertical_recoil_multiplier = global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_grip], ItemStat.KickBackPower];	
	var recoilY = global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.RecoilY] * horizontal_recoil_multiplier;
	var recoilX = global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.RecoilX] * vertical_recoil_multiplier;
	
	if(global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.HardRecoil] == true){
		
		#region Hard recoil
		if(oPlayer.KickBack > 0){
			
			#region Variables
			var KBPhase1 = global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.KBPhase1];
			var KBPhase2 = global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.KBPhase2];
			var MaxKickBack = global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.MaxKickBack];
			#endregion

			if ((!oPlayer.CanShoot && oPlayer.ShootTimer >= global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.ShootTimer] / 2 && global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == "Pistol") || (oPlayer.shooting && global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] != "Pistol")) {
				
				#region Recoil mechanic
			    axis_multiplier[1] = -sign(global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.RecoilY]);
			    var targetX = mouse_x;
			    var targetY = mouse_y;
				
			    if (oPlayer.KickBack == KBPhase1 || oPlayer.KickBack == KBPhase2 || oPlayer.KickBack >= MaxKickBack) {
			        oPlayer.DeltaKickBack = oPlayer.KickBack;
			    }					

			    if (oPlayer.KickBack <= KBPhase1) {
					targetY = mouse_y - oPlayer.KickBack * recoilY;
			    } else if (oPlayer.KickBack < KBPhase2) {
			        targetX -= ((oPlayer.KickBack - oPlayer.DeltaKickBack) * recoilX);
					targetY = mouse_y - DeltaY;
			    } else {
					if(sign(recoilX) == -1){
						targetX += (oPlayer.KickBack - oPlayer.DeltaKickBack) * recoilX;
					}else{
						targetX += ((oPlayer.KickBack - oPlayer.DeltaKickBack) * recoilX) - (KBPhase1 * recoilX);
					}
					targetY = mouse_y - DeltaY;
			    }

			    x = lerp(x, targetX, recoil_speed*2);
			    y = lerp(y, targetY, recoil_speed*2);

			    var newDeltaX = mouse_x - x;
			    var newDeltaY = mouse_y - y;
			    DeltaX = newDeltaX;
				if(oPlayer.KickBack <= KBPhase1){
				 DeltaY = newDeltaY;
				}
				#endregion
				
			}else {
				
				#region Recoil reset
				axis_multiplier[0] = sign(oPlayer.crosshair_position[0] - mouse_x);
				distance[0] = abs(oPlayer.crosshair_position[0] - mouse_x);
				distance[1] = abs(oPlayer.crosshair_position[1] - mouse_y);
				
				if(axis_multiplier[0] == -1){ //If recoil goes to the left
					if(x < mouse_x){
						x = oPlayer.crosshair_position[0] - (distance[0]/oPlayer.KickBack * axis_multiplier[0]);
					}else{
						x = mouse_x;
					}
				}else if(axis_multiplier[0] == 1){ //If recoil goes to the right
					if(x > mouse_x){
						x = oPlayer.crosshair_position[0] - (distance[0]/oPlayer.KickBack * axis_multiplier[0]);
					}else{
						x = mouse_x;
					}
				}
				
				if(axis_multiplier[1] == -1){ //If recoil goes up
					if(y < mouse_y){
						y = oPlayer.crosshair_position[1] - (distance[1]/oPlayer.KickBack * axis_multiplier[1]);
					}else{
						y = mouse_y;
					}
				}else if(axis_multiplier[1] == 1){ //If recoil goes down
					if(y > mouse_y){
						y = oPlayer.crosshair_position[1] - (distance[1]/oPlayer.KickBack * axis_multiplier[1]);
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
		if(oPlayer.CanShoot == false && oPlayer.ShootTimer >= global.ItemIndex[#global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.ShootTimer]/2){
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
			Recoil[0] = min(Recoil[0], recoilY * oPlayer.KickBack);
			RecoilTimer[0] --;
		}else{
			Recoil[0] -= StabilizationSpeed * sign(recoilY);
			Recoil[0] = max(0, Recoil[0]);
		}
		#endregion
		
		#region Recoil X
		if(RecoilTimer[1] > -1){
			if(global.Inventory[# oPlayer.WeaponID, Index.slot_ammo] % 2 == 0){ 
				Recoil[1] += StabilizationSpeed * sign(recoilX);
				Recoil[1] = min(Recoil[1], recoilX * oPlayer.KickBack);
			}else{
				Recoil[1] -= StabilizationSpeed * sign(recoilX);
				Recoil[1] = min(abs(Recoil[1]), recoilX * oPlayer.KickBack);
			}
			RecoilTimer[1] --;
		}else{
			Recoil[1] -= StabilizationSpeed * sign(recoilX);
			Recoil[1] = max(0, Recoil[1]);
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