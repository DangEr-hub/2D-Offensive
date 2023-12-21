function InaccuracyFormula(WID, ObjectType){
	if(ObjectType.object_index == oPlayer){
		if(instance_exists(oPlayer)){
			MovingIn = 1;
			KickBackIn = 1 + (ObjectType.KickBack * global.ItemIndex[#WID, ItemStat.KickBackInaccuracyMultiplier]);
			range_inaccuracy = 1 + (ObjectType.Range * global.ItemIndex[#WID, ItemStat.RangeInaccuracyMultiplier]);
			moving_state_inaccuracy = 1;
	
			if(ObjectType.moving_state == player_states.running_state){
				moving_state_inaccuracy = 2;
			}else if(ObjectType.moving_state == player_states.prone_state){
				moving_state_inaccuracy = .5;	
			}
	
			if(ObjectType.Moving == true){
				MovingIn = global.ItemIndex[#WID, ItemStat.MovingInaccuracyMultiplier];
			}
			
			ScopeTimerInaccuracy = 1;
			ScopeInaccuracy = 1;
			if(ObjectType.player_has_scope == 0){
				if(ObjectType.ScopeIn == false){
					ScopeTimerInaccuracy = 50;
				}else{
					ScopeTimerInaccuracy = ObjectType.ScopeInaccuracyTimer;
				}
			}else if(ObjectType.player_has_scope != -1){
				if(ObjectType.ScopeIn == true){
					ScopeInaccuracy = .5;
				}
			}
			return min(KickBackIn * MovingIn * range_inaccuracy * ScopeInaccuracy * global.PlayerInaccuracy * moving_state_inaccuracy  * global.ItemIndex[# global.weapon_attachments[min(ObjectType.WeaponID, 1)][weapon_attachments.weapon_suppressor], ItemStat.KickBackPower] * max(ScopeTimerInaccuracy, 1), 50);
		}
	}else if(ObjectType.object_index == oEnemy){
		if(instance_exists(oEnemy)){
			FlashedInaccuracy = 1;
			InSmokeInaccuracy = 1;
			EnemyMovingInaccuracy = 1;
			EnemyRangeInaccuracy = 1 + (point_distance(ObjectType.x, ObjectType.y, ObjectType.ChasingObject.headshot_x, ObjectType.ChasingObject.headshot_x) * 
			global.ItemIndex[#WID, ItemStat.RangeInaccuracyMultiplier]);
			
			if(oPlayer.InSmoke == true && ObjectType.ChasingObject == oPlayer){
				InSmokeInaccuracy = 5;
			}
			
			if(ObjectType.Flashed == true){
				FlashedInaccuracy = 5;
			}
			
			if(sqrt(power(ObjectType.XSpeed, 2) + power(ObjectType.YSpeed, 2)) > ObjectType.MaxSpeed/2){
				EnemyMovingInaccuracy = global.ItemIndex[#WID, ItemStat.MovingInaccuracyMultiplier];
			}
			return EnemyMovingInaccuracy * EnemyRangeInaccuracy * (global.ItemIndex[#WID, ItemStat.EnemyInaccuracyCompensation] + 1) * (ObjectType.AimPunchMultiplier + 1) * InSmokeInaccuracy * FlashedInaccuracy;
		}
	}
}
	
function player_shooting(){
	
	#region Create smoke effect
	Fog = instance_create_layer(FlashLightX, FlashLightY, "OtherO", oFog);
	Fog.moving = true;
	Fog.moving_x = lengthdir_x(5, RotationAngle - 180);
	Fog.moving_y = lengthdir_y(5, RotationAngle - 180);
	with(Fog){
		smoke_effect_create(
			20,
			oPlayer.RotationAngle - 180,
			5,
			5,
			10,
			.1,
			.75,
			clamp(oPlayer.ShootTimer, 10, 30)
		);	
	}
	#endregion
						
	#region Create bullet casing
	if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.BulletCasingID] != -1){
		ParticleCreate(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
		0, point_direction(oPlayer.x, oPlayer.y, oCrosshair.x, oCrosshair.y) - 180, 0, false, true, global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.BulletCasingID], x, y, 1, 60);
	}
	#endregion
				
	#region Create flash effect
	if(HP > 0){
		MuzzleFlashLight = instance_create_depth(FlashLightX, FlashLightY, depth, oFlashLight);
		MuzzleFlashLight.Object = Weapon;
		MuzzleFlashLight.DestroyTimer = ShootTimer - 1;
		with(MuzzleFlashLight){
			light[| eLight.Direction] = other.RotationAngle;
			light[| eLight.Intensity] = 1.3;
			light[| eLight.Color] = $FF0000FF;
		}
	}
	#endregion
								
	for(i=0;i<global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Bullets];i++){
						
		#region Determine shot position
							
		var prone_kickback = 1;
		if(moving_state == player_states.prone_state){
			prone_kickback = .5;
		}
		var current_weapon_id = global.weapon_id[min(WeaponID, 2)];
		var inaccuracy_value = global.ItemIndex[# current_weapon_id, ItemStat.Inaccuracy];
		var inaccuracy_calculation = InaccuracyFormula(current_weapon_id, id);
		var kb_phase_1 = global.ItemIndex[# current_weapon_id, ItemStat.KBPhase1] * prone_kickback;
		var kb_phase_2 = global.ItemIndex[# current_weapon_id, ItemStat.KBPhase2] * prone_kickback;
		var recoil_offset_x = global.ItemIndex[# current_weapon_id, ItemStat.RecoilOffsetX];
		var recoil_offset_y = global.ItemIndex[# current_weapon_id, ItemStat.RecoilOffsetY];
		var horizontal_recoil_multiplier = global.ItemIndex[# global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_grip], ItemStat.KickBackInaccuracyMultiplier];
		var vertical_recoil_multiplier = global.ItemIndex[# global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_grip], ItemStat.KickBackPower];		

		if (global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.HardRecoil] == false) {
			ShotX = random_range(
				oCrosshair.x - inaccuracy_value * inaccuracy_calculation, 
				oCrosshair.x + inaccuracy_value * inaccuracy_calculation
			);
			ShotY = random_range(
				oCrosshair.y - inaccuracy_value * inaccuracy_calculation, 
				oCrosshair.y + inaccuracy_value * inaccuracy_calculation
			);
		} else {
			if (KickBack <= kb_phase_1) {
				ShotX = random_range(oCrosshair.x - inaccuracy_value * inaccuracy_calculation, oCrosshair.x + inaccuracy_value * inaccuracy_calculation) - KickBack * recoil_offset_x * vertical_recoil_multiplier;
				ShotY = random_range(oCrosshair.y - inaccuracy_value * inaccuracy_calculation, oCrosshair.y + inaccuracy_value * inaccuracy_calculation) - KickBack * recoil_offset_y * horizontal_recoil_multiplier;

				if (KickBack == kb_phase_1) {
					DeltaX = random_range(oCrosshair.x - inaccuracy_value * inaccuracy_calculation, oCrosshair.x + inaccuracy_value * inaccuracy_calculation) - ShotX;
					DeltaY = random_range(oCrosshair.y - inaccuracy_value * inaccuracy_calculation, oCrosshair.y + inaccuracy_value * inaccuracy_calculation) - ShotY;
				}
			} else {
				ShotX = random_range(oCrosshair.x - inaccuracy_value * inaccuracy_calculation * 0.25, oCrosshair.x + inaccuracy_value * 0.25) - DeltaX;
				ShotY = random_range(oCrosshair.y - inaccuracy_value * 0.25, oCrosshair.y + inaccuracy_value * 0.25) - DeltaY;

				if (KickBack == kb_phase_2) {
					DeltaX = random_range(oCrosshair.x - inaccuracy_value * 0.25, oCrosshair.x + inaccuracy_value * 0.25) - ShotX;
					DeltaY = random_range(oCrosshair.y - inaccuracy_value * 0.25, oCrosshair.y + inaccuracy_value * 0.25) - ShotY;
				}
			}
		}
		#endregion
					
		#region Tracer
		BulletTracer = instance_create_depth(Weapon.x + lengthdir_x(32, RotationAngle), Weapon.y + lengthdir_y(32, RotationAngle), -99, oBulletTracer);
		BulletTracer.BulletTracerX = BulletTracer.x;
		BulletTracer.BulletTracerY = BulletTracer.y;
		BulletTracer.ShotX = ShotX;
		BulletTracer.ShotY = ShotY;
		BulletTracer.image_angle = point_direction(BulletTracer.x, BulletTracer.y, ShotX, ShotY);
		BulletTracer.direction = BulletTracer.image_angle;
		BulletTracer.Weapon = global.weapon_id[min(WeaponID, 2)];
		BulletTracer.Object = id;
						
		if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.WeaponTypeClass] == "Anti-tank missile"){
			BulletTracer.NearestEnemy = instance_nearest(oCrosshair.x, oCrosshair.y, oEnemy);
			BulletTracer.direction = 0;
			BulletTracer.speed = 25;
			BulletTracer.image_index = 1;
		}
		#endregion
					
	}	
	
}