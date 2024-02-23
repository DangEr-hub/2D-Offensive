event_inherited();
if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false){
	
	#region Friend command and go
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCommand])){
	    var botList = ds_list_create();
	    with (oFriend) {
	        ds_list_add(botList, id);
	    }

	    var currentIndex = -1;
	    if (ds_list_size(global.selected_bots) > 0) { // Correctly checking the size of the list
	        var lastSelectedBot = global.selected_bots[| ds_list_size(global.selected_bots)-1]; // Get the last selected bot
	        for (var i = 0; i < ds_list_size(botList); i++) {
	            if (botList[| i] == lastSelectedBot) {
	                currentIndex = i;
	                break;
	            }
	        }
	    }

	    // Select the next bot in the list
	    currentIndex = (currentIndex + 1) % ds_list_size(botList);
	    var nextBotId = botList[| currentIndex];

	    with (oFriend) {
	        selected = false;
	    }
	    with (nextBotId) {
	        selected = true;
	    }

	    if (ds_list_find_index(global.selected_bots, nextBotId) == -1) {
	        ds_list_add(global.selected_bots, nextBotId);
	    }

	    if (ds_list_size(global.selected_bots) >= instance_number(oFriend)) {
	        ds_list_clear(global.selected_bots);
	        ds_list_add(global.selected_bots, nextBotId);
	    }
		global.current_selected_bot = nextBotId;
	    ds_list_destroy(botList);
	}
	
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyGo])){
		with(global.current_selected_bot){
			MoveTowards(oCrosshair.x, oCrosshair.y, Acceleration, 0, 0);
		}
	}
	#endregion
	
	#region Timers
	stats.Health_points = clamp(stats.Health_points, -1, global.player_stats_struct.Max_health);
	stats.Damage_health_points = clamp(stats.Damage_health_points, 0, global.player_stats_struct.Max_health);
	stats.Stamina_points = clamp(stats.Stamina_points, 0, global.player_stats_struct.Max_stamina);
	stats.Damage_stamina_points = clamp(stats.Damage_stamina_points, 0, global.player_stats_struct.Max_stamina);
	headshot_x = x - 10;
	headshot_y = y - 18;
	audio_listener_position(x, y, 0);
	
	#region Health timer
	if(HPTimer == 0){
		var Health = stats.Health_points - attack_damage;
	    if(stats.Damage_health_points > Health){
	        stats.Damage_health_points -= max(global.player_stats_struct.Max_health/100, .25);
	    }else{
	        HPTimer = -1;
	    }
	}

	if(HPTimer > 0){
	    HPTimer --;
	}
	#endregion
	
	#region Stamina timer
	if(StaminaTimer == 0){
		var Health = stats.Stamina_points - StaminaDamage;
	    if(stats.Damage_stamina_points > Health){
	        stats.Damage_stamina_points -= max(global.player_stats_struct.Max_stamina/100, .25);
	    }else{
	        StaminaTimer = -1;
	    }
	}

	if(StaminaTimer > 0){
	    StaminaTimer --;
	}
	#endregion
	
	#region Healing timer
	if(HPHealingTimer == -1){
		if(HPTimer == -1){
			if(stats.Health_points >= 0 && stats.Health_points < global.player_stats_struct.Max_health){
				var HealingPower = BaseHealingPower;
				stats.Health_points += HealingPower;	
				stats.Damage_health_points = stats.Health_points;
				HPHealingTimer = HealingTimer;
			}
		}
	}	
	if(HPHealingTimer > -1){
		HPHealingTimer --;	
	}
	#endregion
	
	#region Stamina healing timer
	if(StaminaHealingTimer == -1){
		if(moving_state != player_states.running_state){
			if(stats.Stamina_points >= 0 && stats.Stamina_points < global.player_stats_struct.Max_stamina){
				var stamina_healing_power = ceil(global.player_stats_struct.Max_stamina/50);
				if(moving_state == player_states.prone_state){
					stamina_healing_power = ceil(global.player_stats_struct.Max_stamina/10);
				}
				stats.Stamina_points += stamina_healing_power;
				stats.Damage_stamina_points = stats.Stamina_points;
				StaminaHealingTimer = HealingTimer;
			}
		}
	}	
	if(StaminaHealingTimer > -1){
		StaminaHealingTimer --;	
	}
	#endregion
	
	if(equipped_usable_item()){
		if(Reloading == true){
			Reloading = false;
			ReloadTime = 0;
		}
	}

	if(FootStepTimer > -1){
		FootStepTimer --;	
	}
	
	if(ScopeInaccuracyTimer > -1){
		ScopeInaccuracyTimer --;
	}
	
	if(EquippedGrenadeTimer > -1){
		EquippedGrenadeTimer --;	
	}
	
	if(BloodTimer > -1){
		BloodTimer --;
	}
	
	if(EquipmentAlpha > 0){
		EquipmentAlpha -= .001;
	}
	
	if(instance_exists(oBulletTracer)){
		var BulletTracerNearby = instance_nearest(x, y, oBulletTracer);
		if(BulletTracerNearby.stats.Object != id && distance_to_object(BulletTracerNearby) <= 64){
			play_sound(BulletTracerNearby.x, BulletTracerNearby.y, choose(snd_BulletTor1, snd_BulletTor2, snd_BulletTor3));	
		}
	}
	#endregion
	
	#region Scope attachments
	switch(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_scope]){
		case Item.two_scope:
			player_has_scope = 0;
		break;
		
		case Item.red_dot_scope:
			player_has_scope = 1;
		break;
		
		default:
			player_has_scope = -1;
		break;
	}
	#endregion
	
	#region Camera shake
	if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && stats.Health_points > 0 && global.ViewShake == true){
		var ViewShakeMagnitude = 0;
		var LowHPViewAngleFrequency = 0;
		var ExplosionViewAngleFrequency = 0;
		var AimPunchStrength = 5;
		var GunCrossShake = 0;
		var AimPunchCrossShake = 0;
		var ExplosionCrossShake = 0;
		var LowHPCrossShake = 0;
		var ViewAngleAmplitude = 0;
		var ViewAngleDamping = 0.98;
		var ViewAngleCurrent = 0;
		var GunViewAngleFrequency = 0;
		var AimPunchViewAngleFrequency = 0;
		
		#region Camera shake using camera angle
		if (CanShoot == false && ShootTimer >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer]/2) {
			GunCrossShake = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.CrosshairShake];
		    ViewAngleAmplitude += global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.CameraShake];
		    GunViewAngleFrequency = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.CameraShake];
		}
		
		if(AimPunchTimer > -1){
			AimPunchCrossShake = AimPunchStrength*5 * AimPunchMultiplier;
			ViewAngleAmplitude += AimPunchStrength * AimPunchMultiplier;
			AimPunchViewAngleFrequency = AimPunchStrength*.5 * AimPunchMultiplier;
		}
		
		near_explosion = false;
		if(instance_exists(oGrenade)){
			var HEGrenade = instance_nearest(x, y, oGrenade);
			if(HEGrenade.stats.Item_id == Item.HEGrenade && HEGrenade.ExplosionTimer <= 11 && HEGrenade.ExplosionTimer > -1 && HEGrenade.stats.Speed < .1){
				if(distance_to_object(HEGrenade) <= 1024){
					near_explosion = true;
					ExplosionCrossShake = max(10 * (1 - distance_to_object(HEGrenade)/1024), 5);
					ViewAngleAmplitude += max(10 * (1 - distance_to_object(HEGrenade)/1024), 5);
					ExplosionViewAngleFrequency = 1;
				}
			}
		}
		
		if(stats.Health_points <= ceil(global.player_stats_struct.Max_health/3)){
			LowHPCrossShake = 1;
			ViewAngleAmplitude += 1;
			LowHPViewAngleFrequency = 100;
		}
		
		var ViewAngleFrequency = GunViewAngleFrequency + AimPunchViewAngleFrequency + ExplosionViewAngleFrequency + LowHPViewAngleFrequency;
		ViewAngleAmplitude *= ViewAngleDamping;
		
		if (ViewAngleAmplitude > 0.01) {
		    ViewAngleCurrent = ViewAngleAmplitude * sin(degtorad(current_time * ViewAngleFrequency));
		}else{
			ViewAngleFrequency = 0;
		    ViewAngleAmplitude = 0;
		    ViewAngleCurrent = 0;
		}
		#endregion
		
		#region Camera shake using camera position
		if(shooting == true){
			if(ViewShake == false){
				ViewShakeMagnitude = choose(
											-global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.CrosshairShake], 
											global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.CrosshairShake]
									);
				ViewShakeTimer = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer];
				ViewShake = true;
			}
		}
		
		if (ViewShake == true){ 
		   ViewShakeTimer -= 1; 
		   ViewShakeValuePower = lerp(ViewShakeValuePower, ViewShakeMagnitude, 0.75); 

		   if (ViewShakeTimer <= 0){ 
		      ViewShakeMagnitude -= 1; 

		      if (ViewShakeMagnitude <= 0){ 
		         ViewShake = false; 
		      } 
		   } 
		}else{
			ViewShakeValuePower = lerp(ViewShakeValuePower, 0, 0.75);
		}
		#endregion
		
		CrosshairShake = GunCrossShake + AimPunchCrossShake + ExplosionCrossShake + LowHPCrossShake;
		ViewAngle = ViewAngleCurrent;
		camera_set_view_angle(CAMERA, ViewAngle);
		camera_set_view_pos(CAMERA, camera_get_view_x(CAMERA) + ViewShakeValuePower, camera_get_view_y(CAMERA) + ViewShakeValuePower); 
	}
		
	#endregion

	#region Flashlight
	if(Weapon != noone && (global.weapon_id[min(WeaponID, 2)] != Item.None && !equipped_usable_item())){
		FlashLightX = Weapon.x + lengthdir_x(WeaponDistance, RotationAngle); 
		FlashLightY = Weapon.y + lengthdir_y(WeaponDistance, RotationAngle);
	}else{
		FlashLightX = x;
		FlashLightY = y;
	}
	if(FlashLight != undefined){
		FlashLight.angle = RotationAngle;
		FlashLight.x = FlashLightX;
		FlashLight.y = FlashLightY;
	}
	Weapon.FlashLightX = FlashLightX;
	Weapon.FlashLightY = FlashLightY;
	cx = Weapon.FlashLightX;
	cy = Weapon.FlashLightY;
	ax = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) - global.FieldOfView);
	ay = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) - global.FieldOfView);
	bx = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) + global.FieldOfView);
	by = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) + global.FieldOfView);	
	#endregion
	
	#region Texture
	if!(equipped_usable_item()){
		
		#region Weapon texture
		switch(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Name]){
			case "AKM":
				Weapon.image_index = 1;
			break;
			
			case "IMI Desert eagle":
				Weapon.image_index = 2;
			break;
			
			case "Spas-12":
				Weapon.image_index = 3;
			break;
			
			case "Steyr SSG 08":
				Weapon.image_index = 4;
			break;
			
			case "MAC11":
				Weapon.image_index = 5;
			break;
			
			case "SIG SG550":
				Weapon.image_index = 6;
			break;
			
			case "FGM-148 Javelin":
				Weapon.image_index = 7;
			break;
			
			case "Glock-17":
				Weapon.image_index = 8;
			break;
			
			case "M4A1":
				Weapon.image_index = 9;
			break;
			
			case "AWM":
				Weapon.image_index = 10;
			break;
			
			case "USP":
				Weapon.image_index = 11;
			break;
			
			default:
				Weapon.image_index = 0;
			break;
		}
		#endregion
		
		#region Player texture
		if(moving_timer > -1){
			moving_timer --;
		}
		switch(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.WeaponTypeClass]){
			
			#region Assault rifle texture
			case "Assault rifle":
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithWeapon;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index = player_textures.assault_rifle;
							ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
						}else{
							image_index = player_textures.reload;
							ArmHitBox.image_index = HitBox.ArmReloading;
						}
					}else{
						image_index = player_textures.flashed_weapon;
						ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index_variable = player_textures.prone;
							ArmHitBox.image_index = HitBox.ArmProne;		
						}else{
							image_index_variable = player_textures.reload_prone;
							ArmHitBox.image_index = HitBox.ArmProneReloading;
						}
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
				}
				
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .85;
			break;
			#endregion
	
			#region Pistol texture
			case "Pistol":
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithWeapon;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index = player_textures.pistol;
							ArmHitBox.image_index = HitBox.ArmWithPistol;
						}else{
							image_index = player_textures.reload;
							ArmHitBox.image_index = HitBox.ArmReloading;
						}
					}else{
						image_index = player_textures.flashed_weapon;
						ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){	
							image_index_variable = player_textures.prone;
							ArmHitBox.image_index = HitBox.ArmProne;
							
						}else{
							image_index_variable = player_textures.reload_prone;
							ArmHitBox.image_index = HitBox.ArmProneReloading;
						}
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
				}
	
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .8;
			break;
			#endregion
			
			#region Submachine gun texture
			case "Submachine gun":
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithWeapon;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index = player_textures.pistol;
							ArmHitBox.image_index = HitBox.ArmWithPistol;
						}else{
							image_index = player_textures.reload;
							ArmHitBox.image_index = HitBox.ArmReloading;
						}
					}else{
						image_index = player_textures.flashed_weapon;
						ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index_variable = player_textures.prone;
							ArmHitBox.image_index = HitBox.ArmProne;
						}else{
							image_index_variable = player_textures.reload_prone;
							ArmHitBox.image_index = HitBox.ArmProneReloading;
						}
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
				}
				
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .9;
			break;
			#endregion
	
			#region Sniper rifle texture
			case "Sniper rifle":
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithWeapon;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index = player_textures.assault_rifle;
							ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
						}else{
							image_index = player_textures.reload;
							ArmHitBox.image_index = HitBox.ArmReloading;
						}
					}else{
						image_index = player_textures.flashed_weapon;
						ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						if!(ReloadTime >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed]*.95){
							image_index_variable = player_textures.prone;
							ArmHitBox.image_index = HitBox.ArmProne;
						}else{
							image_index_variable = player_textures.reload_prone;
							ArmHitBox.image_index = HitBox.ArmProneReloading;
						}
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
				}
				
				WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
			break;
			#endregion
			
			#region Shotgun texture
			case "Shotgun":
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithWeapon;
					if(Flashed == false){
						image_index = player_textures.assault_rifle;
						ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
					}else{
						image_index = player_textures.flashed_weapon;
						ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						image_index_variable = player_textures.prone;
						ArmHitBox.image_index = HitBox.ArmProne;
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
				}
				
				WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
			break;
			#endregion
			
			#region Anti-tank missile texture
			case "Anti-tank missile":
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithWeapon;
					if(Flashed == false){
						image_index = player_textures.assault_rifle;
						ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
					}else{
						image_index = player_textures.flashed_weapon;
						ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						image_index_variable = player_textures.prone;
						ArmHitBox.image_index = HitBox.ArmProne;
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
				}
				
				WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
			break;
			#endregion

			#region Default texture
			default:
				if(moving_state != player_states.prone_state){
					HeadHitBox.image_index = HitBox.Head;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					if(Flashed == false){
						image_index = player_textures.no_weapon;
						ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
					}else{
						image_index = player_textures.flashed_no_weapon;
						ArmHitBox.image_index = HitBox.ArmWithoutWeaponFlashed;
					}
				}else{
					HeadHitBox.image_index = HitBox.HeadProne;
					BodyHitBox.image_index = HitBox.BodyProne;
					var image_index_variable;
					if(Flashed == false){
						image_index_variable = player_textures.prone;
						ArmHitBox.image_index = HitBox.ArmProne;
					}else{
						image_index_variable = player_textures.flashed_prone;
						ArmHitBox.image_index = HitBox.ArmProneFlashed;
					}
					
					#region Leg animation mechanics
					if(Moving == true){
						if(moving_timer == -1){
							if(image_index < image_index_variable + 2){	
								image_index += 1;
								LegHitBox.image_index += 1;
							}else{
								image_index = image_index_variable;	
								LegHitBox.image_index = HitBox.LegProne;
							}
							moving_timer = 10;
						}
					}else{
						moving_timer = -1;
						image_index = image_index_variable;
						LegHitBox.image_index = HitBox.LegProne;
					}
					#endregion
					
				}
				
				WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
			break;
			#endregion
			
		}
	}else{
		Weapon.image_index = 0;
		if(moving_state != player_states.prone_state){
			BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
			if(Flashed == false){
				image_index = player_textures.no_weapon;
				ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
			}else{
				image_index = player_textures.flashed_no_weapon;
				ArmHitBox.image_index = HitBox.ArmWithoutWeaponFlashed;
			}
			WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
		}else{
			HeadHitBox.image_index = HitBox.HeadProne;
			BodyHitBox.image_index = HitBox.BodyProne;
			if(Flashed == false){
				image_index = player_textures.prone;
				ArmHitBox.image_index = HitBox.ArmProne;
			}else{
				image_index = player_textures.flashed_prone;
				ArmHitBox.image_index = HitBox.ArmProneFlashed;
			}
			WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
		}
	}
	#endregion
		
	#endregion
	
	#region Shooting mode
	var Shoot = -1;
	var shooting_mode = ds_list_find_value(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootingMode], weapon_shooting_mode);
	
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyChangeMode]) && shooting == false){
		var list_size = ds_list_size(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootingMode]);
		if(weapon_shooting_mode < list_size){
			weapon_shooting_mode = (weapon_shooting_mode + 1) % list_size;
		}
	}
	
	if(shooting_reset_timer > -1){
		shooting_reset_timer --;
	}
	
	if(shooting_mode == "Auto"){	
		if(KickBack > 1){
			KickBackTime = round(.08 * game_get_speed(gamespeed_fps));
		}else{
			KickBackTime = round(.5 * game_get_speed(gamespeed_fps));
		}
		Shoot = mouse_check_button(global.KeyBinds[| KeyBind.KeyShootMouse]);
		if((mouse_check_button_released(global.KeyBinds[| KeyBind.KeyShootMouse])) || (global.Ammo[WeaponID] <= 0 && shooting == true)){
			kick_back_timer = KickBackTime;
			shooting = false;
			crosshair_position[0] = oCrosshair.x;
			crosshair_position[1] = oCrosshair.y;
		}
	}else if(shooting_mode == "Semi" || shooting_mode == "Burst"){
		KickBackTime = round(.25 * game_get_speed(gamespeed_fps));
		Shoot = mouse_check_button_pressed(global.KeyBinds[| KeyBind.KeyShootMouse]);
		/*
			Jelikož se při auto modu vždycky resetne "shooting" na false po tom co hráč releasne tlačítko na střílení, musel jsem přidat "shooting_reset_timer"
		
		*/
		if(mouse_check_button(global.KeyBinds[| KeyBind.KeyShootMouse]) && shooting_reset_timer == -1){
			shooting_reset_timer = KickBackTime;		
		}
		if((mouse_check_button_released(global.KeyBinds[| KeyBind.KeyShootMouse]) && global.Ammo[WeaponID] > 0) || (global.Ammo[WeaponID] <= 0 && shooting == true && shooting_reset_timer == -1)){
			shooting_reset_timer = KickBackTime;
			kick_back_timer = KickBackTime;
			crosshair_position[0] = oCrosshair.x;
			crosshair_position[1] = oCrosshair.y;
		}
		if(shooting_reset_timer == 0){
			shooting = false;
		}
	}
	
	#endregion	
	
	#region Burst fire
	if(burst_fire_timer > -1){
		burst_fire_timer --;
	}
	if (burst_fire == true) {
		if (burst_fire_timer <= 0) {
			if (burst_shots_fired < burst_shot_limit) {		
				var sound_id = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.SoundID];
				if(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_suppressor] == Item.military_suppressor){
					sound_id = snd_Silencer;
				}
				ShootTimer = ceil(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer] * global.ItemIndex[#global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_barrel], ItemStat.ShootTimer]);
				player_shooting();									
				audio_play_sound(sound_id, false, 0);
				Weapon.KickBackEffect = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.KickBackPower];
				KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);
				KickBack ++;
				global.Ammo[WeaponID] --;
				CanShoot = false;
				burst_shots_fired++;
				burst_fire_timer = max(ShootTimer/2, 5);
			} else {
				burst_fire = false;
			}
		}
	}
	#endregion

	#region Shooting
	if(global.weapon_id[min(WeaponID, 2)] != Item.None && !equipped_usable_item()){
		if (player_can_shoot == true && !global.my_console[? "active"]) {
			if(mouse_check_button_pressed(global.KeyBinds[| KeyBind.KeyShootMouse]) && global.Ammo[WeaponID] <= 0){
				audio_play_sound(snd_empty_magazine, 0, false);	
			}
		    if(Shoot == 1 && (Reloading == false || (Reloading == true && global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Defense] == 1))){
				
				if(global.Ammo[WeaponID] > 0){
					shooting = true;
				
					#region Fractionating reloading stop
					if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Defense] == 1){
						ReloadTimer = -1;
						Reloading = false;
						ReloadTime = 0;
					}
					#endregion
				
				
			        if(CanShoot == true){
					
						randomize();
					
						if(shooting_mode == "Burst"){
						
							#region Burstfire
					        if (burst_fire == false) {
					            burst_fire = true;
					            burst_shots_fired = 0;
					            burst_fire_timer = max(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer]/2, 5);
					        }
							#endregion
						
						}else{
						
							#region Normal fire
							var sound_id = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.SoundID];
							if(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_suppressor] == Item.military_suppressor){
								sound_id = snd_Silencer;
							}
							ShootTimer = ceil(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer] * global.ItemIndex[#global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_barrel], ItemStat.ShootTimer]);					
							player_shooting();
							audio_play_sound(sound_id, false, 0);
							Weapon.KickBackEffect = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.KickBackPower];
							KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);
							KickBack ++;
							global.Ammo[WeaponID] --;
							CanShoot = false;
							#endregion
						
						}
					
						#region Scope in logic
						if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.WeaponTypeClass] == "Sniper rifle"){
							if(ScopeIn == true){
								ScopeIn = false;
							}
						}
						#endregion
					
					}
				}
			}

		}
	}

	if(shooting == false){
		if(kick_back_timer == -1){
			KickBack = max(0, KickBack - KickBackStabilizationSpeed);
			KickBackAngle = 0;
		}
	}


	#region Timers
	if(ShootTimer > -1){
		ShootTimer --;	
	}
	if(ShootTimer == 0){
		CanShoot = true;	
	}
	if(kick_back_timer > -1){
		kick_back_timer --;
	}
	#endregion

	#endregion

	#region Movement
	if(player_can_shoot == true && !global.my_console[? "active"]){
		var Up = keyboard_check(global.KeyBinds[| KeyBind.KeyUp]);
		var Right = keyboard_check(global.KeyBinds[| KeyBind.KeyRight]);
		var Left = keyboard_check(global.KeyBinds[| KeyBind.KeyLeft]);
		var Down = keyboard_check(global.KeyBinds[| KeyBind.KeyDown]);
		var Delta = delta_time / 1000000;
		var xpos = Right - Left;
		var ypos = Down - Up;
		MoveDirection = point_direction(Left, Up, Right, Down);
		var move_xpos = abs(xpos);
		var move_ypos = abs(ypos);
	
		#region Move speed multiplier
		var AimPunchSpeedMultiplier = 1;
		if(AimPunchTimer > -1){
			AimPunchSpeedMultiplier = .1;
		}	
		var ShootingSpeedMultiplier = 1;
		if(shooting == true){
			ShootingSpeedMultiplier = global.ItemIndex[#global.weapon_id[min(oPlayer.WeaponID, 2)], ItemStat.ShootSpdMul];
		}
		var ReloadingSpeedMultiplier = 1;
		if(Reloading == true){
			ReloadingSpeedMultiplier = .5;
		}
		var moving_speed_multiplier = 1;	
		if(moving_state == player_states.running_state){
			if(stats.Stamina_points > 0){
				statistics_hit("Stamina", .1, id);
				moving_speed_multiplier = 1.25;	
			}
		}else if(moving_state == player_states.prone_state){
			moving_speed_multiplier	= .135;
		}
	
		var WeightSpeedMultiplier = 1 / (global.player_stats_struct.Weight/50 + 1);
	
		var WeaponSpeedMultiplier = 1;
		if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.MovingSpdMul] != 0){
			WeaponSpeedMultiplier = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.MovingSpdMul];
		}
	
		SpeedMul = ReloadingSpeedMultiplier * ShootingSpeedMultiplier * AimPunchSpeedMultiplier * moving_speed_multiplier * WeightSpeedMultiplier * WeaponSpeedMultiplier / (ScopeIn + 1) * (game_get_speed(gamespeed_fps)/60) / (Healing + 1);

		#endregion

		if(Left || Right || Down || Up){
		    Moving = true;
		} else {
			if(MovingStabilizationTimer == -1){
				MovingStabilizationTimer = MovingStabilizationTime;
			}
		}

		if(MovingStabilizationTimer > -1){
			MovingStabilizationTimer --;
		}

		if(MovingStabilizationTimer == 0){
			Moving = false;
		}

		if!(Left || Right){
			RelativeSpeedX = max(0, RelativeSpeedX - (RelativeSpeedValue * 2));
		}

		if!(Up || Down){
			RelativeSpeedY = max(0, RelativeSpeedY - (RelativeSpeedValue * 2));
		}

		if(Moving == true){
			if(moving_state != player_states.prone_state){
				Legs.image_speed = 1;
				if(FootStepTimer == -1){
					FootStepTimer = 5;
					FootSteps ++;
				}
				if(FootStepTimer == 0){
					if(BloodTimer == -1){
						ParticleCreate(1, 0, RotationAngle, spr_FootSteps, 0, 0, RotationAngle, 0, false, false, FootSteps % 2, x, y, .5, 1.5 * game_get_speed(gamespeed_fps));
					}
				}
			}
		    if(move_xpos){
				XSpeed = RelativeSpeedX * dcos(MoveDirection) * Delta * SpeedMul;
		        if (place_meeting(x + XSpeed, y, oParentTile)){
		            while (!place_meeting(x + sign(XSpeed),y,oParentTile))
						x += sign(XSpeed);
						XSpeed = 0;
				}else{
					if(RelativeSpeedX < MoveSpeed){
						RelativeSpeedX += RelativeSpeedValue;
					}
					x += min(XSpeed, MoveSpeed);
				}
				if(moving_state != player_states.prone_state){
					ParticleCreate(round(abs(XSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(XSpeed) * -1, abs(XSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
				}
				
		    }
		    if(move_ypos){
				YSpeed =  RelativeSpeedY * -dsin(MoveDirection) * Delta * SpeedMul;
		        if(place_meeting(x, y + YSpeed, oParentTile)){
		            while (!place_meeting(x,y + sign(YSpeed),oParentTile))
						y += sign(YSpeed);
						YSpeed = 0;
				}else{
					if(RelativeSpeedY < MoveSpeed){
						RelativeSpeedY += RelativeSpeedValue;
					}
					y += min(YSpeed, MoveSpeed);
				}
				if(moving_state != player_states.prone_state){
					ParticleCreate(round(abs(YSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(YSpeed) * -1, abs(YSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
				}
			}
		}else{
			FootSteps = 0;
			FootStepTimer = -1;
		
			#region Knockback
			XSpeed = -lengthdir_x(Weapon.KickBackEffect/10, RotationAngle);
		    if (place_meeting(x + XSpeed, y, oParentTile)){
		        while (!place_meeting(x + sign(XSpeed),y,oParentTile))
				x += sign(XSpeed);
				XSpeed = 0;
			}
			x += XSpeed;
			YSpeed = -lengthdir_y(Weapon.KickBackEffect/10, RotationAngle);
		    if(place_meeting(x, y + YSpeed, oParentTile)){
		        while (!place_meeting(x,y + sign(YSpeed),oParentTile))
				y += sign(YSpeed);
				YSpeed = 0;
			}
			y += YSpeed;
			#endregion
		
			Legs.image_speed = 0;
		
		}

		x = clamp(x,0,room_width-sprite_width);
		y = clamp(y,0,room_height-sprite_height);
	}

	#endregion
	
	#region Enemy collision
	if(place_meeting(x, y, oEnemy)) {
	    var Enemy = instance_nearest(x, y, oEnemy); // Get nearest Enemy
		var dir = point_direction(Enemy.x, Enemy.y, x, y); // Direction from Enemy to player
    
		// Bounce player smoothly by setting acceleration
		AccelX = 5 * cos(degtorad(dir));
		AccelY = -5 * sin(degtorad(dir));
	}

	// Apply physics
	VelocityX += AccelX;
	VelocityY += AccelY;

	// Wall collision check
	var FutureX = x + VelocityX;
	var FutureY = y + VelocityY;

	if(place_meeting(FutureX, y, oParentTile)) {
		VelocityX = -VelocityX * 0.5; // Reflect x-velocity and reduce to simulate energy loss
	}

	if(place_meeting(x, FutureY, oParentTile)) {
		VelocityY = -VelocityY * 0.5; // Reflect y-velocity and reduce to simulate energy loss
	}

	x += VelocityX;
	y += VelocityY;
	VelocityX *= 0.8;
	VelocityY *= 0.8;
	AccelX = 0;
	AccelY = 0;		
	#endregion

	#region Running and prone
	if(keyboard_check(global.KeyBinds[| KeyBind.KeyRunning]) && !global.my_console[? "active"] && Moving == true){
		if(moving_state == player_states.none_state /*|| moving_state == player_states.running_state*/){
			moving_state = player_states.running_state;
		}
	}
	
	if(moving_state == player_states.running_state){
		if(keyboard_check_released(global.KeyBinds[| KeyBind.KeyRunning])){
			moving_state = 	player_states.none_state;
		}
	}
	
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyProne]) && !global.my_console[? "active"] && Moving == false){
		if(moving_state == player_states.none_state){
			moving_state = player_states.prone_state;
		}else if(moving_state == player_states.prone_state){
			moving_state = player_states.none_state;
		}
	}
	
	var RotationSpeed = 9;
	if(moving_state == player_states.prone_state){
		LegHitBox.visible = true;
		RotationSpeed = 4.5;
		WX = 64;
		WY = 64;
		Legs.visible = false;	
	}else{
		LegHitBox.visible = false;
		WX = 8;
		WY = 8;
		Legs.visible = true;
	}
	#endregion

	#region Facing
	if(instance_exists(oCrosshair)){
		if(player_can_shoot == true){
			var pointdir = point_direction(x,y,oCrosshair.x,oCrosshair.y);
			Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
			Weapon.x = x + lengthdir_x(WX, RotationAngle) - lengthdir_x(Weapon.KickBackEffect, RotationAngle);
			Weapon.y = y + lengthdir_y(WY, RotationAngle) - lengthdir_y(Weapon.KickBackEffect, RotationAngle);
			RotationAngle += sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 45);
			Weapon.image_angle = RotationAngle + KickBackAngle * .5;
			Weapon.RotationAngle = Weapon.image_angle;
	
		}
	}
	#endregion
	
	#region Toggle night vision and infrared vision
	if(global.ArmourID[1] == Item.None){
		if(ToggleNightVision == true){
			play_sound(x, y, snd_ToggleNightVision);
			ToggleNightVision = false;	
		}
		if(ToggleInfraVision == true){
			play_sound(x, y, snd_ToggleNightVision);
			ToggleInfraVision = false;	
		}
	}
	
	if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyToggleNightVision]) && !global.my_console[? "active"]){
		if(global.ArmourDurability[1] > 0){
			if(string_pos("night vision", global.ItemIndex[#global.ArmourID[1], ItemStat.Name]) > 0){
				play_sound(x, y, snd_ToggleNightVision);
				ToggleNightVision = !ToggleNightVision;	
			}else if(string_pos("Infrared vision", global.ItemIndex[#global.ArmourID[1], ItemStat.Name]) > 0){
				play_sound(x, y, snd_ToggleNightVision);
				ToggleInfraVision = !ToggleInfraVision;	
			}
		}
	}
	
	if(global.ArmourDurability[1] <= 0 && (ToggleNightVision == true || ToggleInfraVision == true)){
		if(string_pos("night vision", global.ItemIndex[#global.ArmourID[1], ItemStat.Name]) > 0){
			play_sound(x, y, snd_ToggleNightVision);
			ToggleNightVision = false;	
		}if(string_pos("Infrared vision", global.ItemIndex[#global.ArmourID[1], ItemStat.Name]) > 0){
				play_sound(x, y, snd_ToggleNightVision);
				ToggleInfraVision = false;	
			}
	}
	#endregion
	
	#region Flashed
	if(Flashed == true){
		if(Reloading == true){
			ReloadTime = 0;
			Reloading = false;
		}
		FlashedAlpha = lerp(FlashedAlpha, 0, 0.01);	
	}
	if(FlashedAlpha <= 0.075){
		if(sprite_exists(FlashedBackGround) && FlashedBackGround != -1){sprite_delete(FlashedBackGround);}
		FlashedAlpha = 0;
		Flashed = false;
		FlashedBackGround = -1;
	}
	#endregion
	
	#region Healing kit
	if(Healing == true){
		CanShoot = false;
		HealingTime ++;
	}
	if(HealingTime >= global.ItemIndex[#HealingItemId, ItemStat.ReloadSpeed]){
		damage_indicator("+" + string(global.ItemIndex[#HealingItemId, ItemStat.Damage]), x, y - 30, c_green, spr_Icons, icons.health);
		CanShoot = true;
		stats.Health_points += min(global.ItemIndex[#HealingItemId, ItemStat.Damage], global.player_stats_struct.Max_health - stats.Health_points);
		stats.Damage_health_points = stats.Health_points;
		Healing = false;
		HealingTime = -1;
	}
	#endregion
	
	#region Level
	if(global.player_stats_struct.Xp >= global.player_stats_struct.Max_xp){
		damage_indicator("Level up!", x - string_width("Level up!")/2, y, MAIN_COLOR, spr_Icons, 0, set_font("Title"));
		if(instance_exists(oParticleSystem)){
			var particle_x = random_range(x - sprite_width/2, x + sprite_width/2);
			var particle_y = random_range(y - sprite_height/2, y + sprite_height/2);
			part_particles_create(global.ParticleSystem, particle_x, particle_y, oParticleSystem.level_up_particle, 50);
		}
		global.player_stats_struct.Xp = 0;
		global.player_stats_struct.Lvl ++;
		global.player_stats_struct.Armour += .01;
		global.player_stats_struct.Max_stamina *= power(1.25, ln(global.player_stats_struct.Lvl));
		global.player_stats_struct.Max_health *= power(1.25, ln(global.player_stats_struct.Lvl));
		global.player_stats_struct.Max_xp *= 2;
	}
	#endregion

	if(!global.my_console[? "active"]){
		
		#region Inventory
		if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyInventory])){
			if(player_can_shoot == true){
				instance_create_layer(x, y, "OtherO", oInventory);
				player_can_shoot = false;
				Moving = false;
				Legs.image_speed = 0;
				RelativeSpeedX = 0;
				RelativeSpeedY = 0;
			}else{
				if(oDraw.show_weapon_attachments == false){
					player_can_shoot = true;
				}
				item_description_destroy();
			    with(oInventory){
			        instance_destroy();
			    }
			    with(oSlot){
			        instance_destroy();
			    }
			}
		}
		#endregion

		#region Item pickup
		if(instance_exists(oItems)){
		    Items = instance_nearest(x, y, oItems);
		    if(distance_to_object(Items) <= PickUpDistance){   
		        if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPickUp])){
		            with(Items){
		                GainItem(image_index, Amount, Ammo, ClipAmmo, Durability, scope_attachment, barrel_attachment, grip_attachment, suppressor_attachment);
		            }
		        }
		    }
		}
		#endregion

		#region Item cycling
		if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleRight])){
			ItemUsePosition ++;
			if(ItemUsePosition > InventoryOtherSlot.ArmourSlot - 1){
			    ItemUsePosition = 0;
			}
		}
		if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleLeft])){
			if(ItemUsePosition == 0){ 
			    ItemUsePosition = InventoryOtherSlot.ArmourSlot - 1;
			}else{
			    ItemUsePosition --;
			}
		}

		#endregion

		#region Item use
		if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyUse])){
			if(global.Inventory[# ItemUsePosition, InventoryIndex.SlotAmount] <= 1){
				with(oWeaponDescription){
					zui_destroy();
				}
				with(oItemDescription){
					zui_destroy();
				}
				with(oArmourDescription){
					zui_destroy();
				}
			}
			Id = global.Inventory[# ItemUsePosition, InventoryIndex.SlotID];
			switch(global.ItemIndex[#Id, ItemStat.Type]){
				
			    case "Helmet":
				
					#region Helmet use
					if(global.ArmourID[1] == Item.None){
						if(oDraw.DrawInfo == true){
							if(instance_exists(oSlot)){
								oSlot.DrawItemInfo = false;
							}
							oDraw.DrawInfo = false;
						}
						EquipmentAlpha = global.GUIHUDAlpha;
						global.ArmourID[1] = global.Inventory[# ItemUsePosition, InventoryIndex.SlotID];
						global.ArmourDurability[1] = global.Inventory[# ItemUsePosition, InventoryIndex.SlotDurability];
						ItemAddWeight(ItemUsePosition);
						ItemAmountSubstract(ItemUsePosition, 1);
					}
					#endregion
					
			    break;  
				
			    case "Armour":
				
					#region Armour use
					if(global.ArmourID[0] == Item.None){
						if(oDraw.DrawInfo == true){
							if(instance_exists(oSlot)){
								oSlot.DrawItemInfo = false;
							}
							oDraw.DrawInfo = false;
						}
						EquipmentAlpha = global.GUIHUDAlpha;
						global.ArmourID[0] = global.Inventory[# ItemUsePosition, InventoryIndex.SlotID];
						global.ArmourDurability[0] = global.Inventory[# ItemUsePosition, InventoryIndex.SlotDurability];
						ItemAddWeight(ItemUsePosition);
						ItemAmountSubstract(ItemUsePosition, 1);
					}
					#endregion
					
			    break;  
				
			    case "Shield":
				
					ItemAmountSubstract(ItemUsePosition, 1);
					
			    break;
				
			    case "Weapon":
				
					#region Weapon use
					if(global.ItemIndex[#Id, ItemStat.WeaponType] == "Main"){
						i = 0;
					}else{
						i = 1;
					}
					if(global.weapon_id[i] == Item.None){
						if(oDraw.DrawInfo == true){
							if(instance_exists(oSlot)){
								oSlot.DrawItemInfo = false;
							}
							oDraw.DrawInfo = false;
						}
						EquipmentAlpha = global.GUIHUDAlpha;
						global.weapon_id[i] = Id;
						global.weapon_attachments[i][weapon_attachments.weapon_scope] = global.Inventory[# ItemUsePosition, InventoryIndex.slot_scope];
						global.weapon_attachments[i][weapon_attachments.weapon_barrel] = global.Inventory[# ItemUsePosition, InventoryIndex.slot_barrel];
						global.weapon_attachments[i][weapon_attachments.weapon_grip] = global.Inventory[# ItemUsePosition, InventoryIndex.slot_grip];
						global.weapon_attachments[i][weapon_attachments.weapon_suppressor] = global.Inventory[# ItemUsePosition, InventoryIndex.slot_suppressor];
						global.Ammo[i] = global.Inventory[# ItemUsePosition, 2];
						global.ClipAmmo[i] = global.Inventory[# ItemUsePosition, 3];
						global.MaxAmmo[i] = global.ItemIndex[#Id, ItemStat.MaxAmmo];
						global.HardRecoil[i] = global.ItemIndex[#Id, ItemStat.HardRecoil];
						ItemAmountSubstract(ItemUsePosition, 1);
					}
					#endregion
					
			    break;
				
				case "Item":
				
					#region Item use 
					if(global.Inventory[# ItemUsePosition, InventoryIndex.SlotAmount] <= 1){
						if(oDraw.DrawInfo == true){
							oDraw.DrawInfo = false;
							if(instance_exists(oSlot)){
								oSlot.DrawItemInfo = false;
							}
						}							
					}
					var Id = global.Inventory[# ItemUsePosition, InventoryIndex.SlotID];
					switch(Id){
						case Item.HealingKit:
							if(Healing == false && stats.Health_points < global.player_stats_struct.Max_health){
								HealingItemId = Item.HealingKit;
								Healing = true;
								ItemAmountSubstract(ItemUsePosition, 1);
							}
						break;
						
						case Item.red_dot_scope:
							weapon_attachment_equip(Id, weapon_attachments.weapon_scope);
						break;
						
						case Item.two_scope:
							weapon_attachment_equip(Id, weapon_attachments.weapon_scope);
						break;
						
						case Item.adaptive_chambering:
							weapon_attachment_equip(Id, weapon_attachments.weapon_barrel);
						break;
						
						case Item.vertical_grip:
							weapon_attachment_equip(Id, weapon_attachments.weapon_grip);
						break;
						
						case Item.horizontal_grip:
							weapon_attachment_equip(Id, weapon_attachments.weapon_grip);
						break;
						
						case Item.military_suppressor:
							weapon_attachment_equip(Id, weapon_attachments.weapon_suppressor);
						break;						
					}
					#endregion
					
				break;
				
				case "Grenade":
				
					#region Grenade use
					if(EquippedGrenadeTimer == -1){
						create_grenade(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
						global.ItemIndex[#Id, ItemStat.BulletCasingID], global.ItemIndex[#Id, ItemStat.ReloadSpeed], oCrosshair.x, oCrosshair.y, Id);						
						ItemAmountSubstract(ItemUsePosition, 1);
						EquippedGrenadeTimer = EquippedGrenadeTime;
						randomize();
						grenade_angle = random(360);
					}
					#endregion
					
				break;
				
				case "Landmine":
				
					#region Landmine use
					var Id = global.Inventory[# ItemUsePosition, InventoryIndex.SlotID];
					switch(Id){
						case Item.LELandMine:
							landmine_create(
								x, 
								y, 
								Id
							);
							ItemAmountSubstract(ItemUsePosition, 1);
						break;
						
						case Item.HELandMine:
							landmine_create(
								x, 
								y, 
								Id
							);
							ItemAmountSubstract(ItemUsePosition, 1);
						break;
						
						case Item.CELandMine:
							landmine_create(
								x, 
								y, 
								Id
							);
							ItemAmountSubstract(ItemUsePosition, 1);
						break;
					}
					#endregion
					
				
				break;
				
			}
		}
		#endregion
		
		#region Scope
		var ScopeButton = mouse_check_button(mb_right);
		if!(instance_exists(oInventory)){
			if(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_scope] != Item.None && CanShoot == true){
				if(ScopeButton){
					if(ScopeIn == false){
					
						if(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_scope] == Item.two_scope){
							ScopeInaccuracyTimer = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ScopeInaccuracyResetTimer];
						}
						ScopeIn = true;	
					}
				}else{
					if(ScopeIn = true){
						ScopeIn = false;
					}
				}
			}
		}
		#endregion
	
	}

	#region Weapon cycling
	if(equip_timer > -1){
		equip_time ++;
		equip_timer --;
	}
	
	if(equip_timer == 0){
		equip_time = 0;
		switch_weapon_number();	
	}
	
	// Handle weapon switching logic
	if (equip_timer == -1 && player_can_shoot == true && shooting == false) {
	    var changeDetected = false;

	    if (mouse_wheel_up()) {
	        WeaponNumber = (WeaponNumber < WeaponNumberMax) ? WeaponNumber + 1 : 0;
	        changeDetected = true;
	    } else if (mouse_wheel_down()) {
	        WeaponNumber = (WeaponNumber != 0) ? WeaponNumber - 1 : WeaponNumberMax;
	        changeDetected = true;
	    }

	    // If there was a change in the weapon number
	    if (changeDetected) {
	        if (WeaponNumber != 2) {
	            var weaponID = min(WeaponNumber, 2);
				var equipTime = global.ItemIndex[#global.weapon_id[weaponID], ItemStat.EquipTime];
	            if (equipTime > 0) {
	                equip_timer = equipTime;
	            } else {
	                switch_weapon_number();
	            }
	        } else {
	            switch_weapon_number();
	        }
	    }
	}

	#endregion

	#region Range 
	if(instance_exists(oCrosshair)){
		Range = point_distance(x, y, oCrosshair.x, oCrosshair.y);
	}
	#endregion

	#region Reloading	
	if(ReloadTimer > -1){
		ReloadTimer --;	
	}
	
	if(ReloadTimer == 0){
		if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Defense] != 1){
			
			#region Normal reloading
			if(global.weapon_id[min(WeaponID, 2)] != Item.Javelin){
				ParticleCreate(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
				random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.AmmoSpriteID], x, y);		
			}
			Reloading = false;
			ReloadTime = 0;
			if (global.Ammo[WeaponID] < global.MaxAmmo[WeaponID] && global.ClipAmmo[WeaponID] > 0) {
			    if (global.ClipAmmo[WeaponID] > global.AmmoNeeded) {
			    global.ClipAmmo[WeaponID] -= global.AmmoNeeded;
			    global.Ammo[WeaponID] += global.AmmoNeeded;
			    } else if (global.ClipAmmo[WeaponID] < global.AmmoNeeded) {
			    global.Ammo[WeaponID] += global.ClipAmmo[WeaponID];
			    global.ClipAmmo[WeaponID] -= global.ClipAmmo[WeaponID];
			    } else if (global.Ammo[WeaponID] + global.ClipAmmo[WeaponID] = global.MaxAmmo[WeaponID]) {
			    global.Ammo[WeaponID] = global.MaxAmmo[WeaponID];
			    global.ClipAmmo[WeaponID] = 0;
			    }
			}
			#endregion
			
		}else{
			
			#region Fractionating reloading
			Reloading = false;
			ReloadTime = 0;
			if (global.Ammo[WeaponID] < global.MaxAmmo[WeaponID] && global.ClipAmmo[WeaponID] > 0) {
				global.ClipAmmo[WeaponID] -= 1;
				global.Ammo[WeaponID] += 1;
			}
			if(global.Ammo[WeaponID] < global.MaxAmmo[WeaponID]){
				Reloading = true;
				ReloadTimer = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed];
			}
			#endregion
			
		}
	}
	
	if (global.weapon_id[min(WeaponID, 2)] != -1) {
	  if (global.Ammo[WeaponID] > global.MaxAmmo[WeaponID]) {
	    global.Ammo[WeaponID] = global.MaxAmmo[WeaponID];
	  }
	  global.AmmoNeeded = global.MaxAmmo[WeaponID] - global.Ammo[WeaponID];

	  if (global.Ammo[WeaponID] < global.MaxAmmo[WeaponID] && global.ClipAmmo[WeaponID] > 0 && Reloading = false && keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyReload]) && shooting == false && !global.my_console[? "active"] && !equipped_usable_item()){
	    Reloading = true;
	    ReloadTimer = global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ReloadSpeed];
	  }
	}

	if(Reloading == true){
	    ReloadTime ++;
	}
	#endregion
	
	#region Deactivate out of view
	var DeactivateMargin = 256;
	var ActivateMargin = 128;
	var deactivateLeft = camera_get_view_x(CAMERA) - DeactivateMargin;
	var deactivateTop = camera_get_view_y(CAMERA) - DeactivateMargin;
	var deactivateRight = deactivateLeft + camera_get_view_width(CAMERA) + 2 * DeactivateMargin;
	var deactivateBottom = deactivateTop + camera_get_view_height(CAMERA) + 2 * DeactivateMargin;

	with (oEnemy) {
	    if (x < deactivateLeft || x > deactivateRight || y < deactivateTop || y > deactivateBottom) {
	        Visible = false;
			FlashLight.visible = false;
	    }
	}

	instance_deactivate_region(deactivateLeft, deactivateTop, deactivateRight - deactivateLeft, deactivateBottom - deactivateTop, false, true);
	

	// Activate instances within view + ActivateMargin
	instance_activate_region(
		camera_get_view_x(CAMERA) - ActivateMargin,
		camera_get_view_y(CAMERA) - ActivateMargin,
		camera_get_view_width(CAMERA) + 2 * ActivateMargin,
		camera_get_view_height(CAMERA) + 2 * ActivateMargin,
		true
	);
	instance_activate_object(oWeaponDescription);
	instance_activate_object(oLightRenderer);
	instance_activate_object(oHazeController);
	instance_activate_object(oDamageTable);
	instance_activate_object(oItemDescription);
	instance_activate_object(objUIWindowCaption);
	instance_activate_object(objZUIMain);
	instance_activate_object(objUIButton);
	instance_activate_object(objUILabel);
	instance_activate_object(objUIGrid);
	instance_activate_object(oArmourDescription);
	instance_activate_object(oEggyEloRatingSystem);
	instance_activate_object(Legs);
	instance_activate_object(oCrosshair);
	instance_activate_object(oDamageIndicator);
	instance_activate_object(oDraw);
	instance_activate_object(oBulletTracer);
	instance_activate_object(oBullet);
	instance_activate_object(oParticleSystem);
	instance_activate_object(oParticleSurface);
	instance_activate_object(oConsole);
	instance_activate_object(oCamera);
	instance_activate_object(oInventory);
	instance_activate_object(oItems);
	//instance_activate_object(oShrapnel);
	instance_activate_object(oGrenade);
	instance_activate_object(oExplosion);
	#endregion
	
}

#region Death
if(stats.Health_points <= 0 && oDraw.RespawnMenu == false){
	oDraw.KilledByWeapon = KilledByWeapon;
	oDraw.KilledByName = KilledByName;
	Weapon.image_index = 0;
	image_index = 3;
	round_end("Loss");
	camera_set_view_angle(CAMERA, 0);
}
#endregion