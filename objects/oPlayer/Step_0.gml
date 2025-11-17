event_inherited();

#region Networking
/* Player Object - Step Event */

if (is_remote) {
    // Smooth interpolation for remote players
    x = lerp(x, target_x, interpolation_speed);
    y = lerp(y, target_y, interpolation_speed);
    RotationAngle = lerp(RotationAngle, target_direction, interpolation_speed);
	instance_destroy(LegHitBox);
}

#endregion

if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false){
	
	if(is_local == true){
	
		#region Hidden flag boolean variable
		var hidden_in_smoke = false;
		if (instance_exists(oFog)) {
		    var smoke_object = instance_nearest(x, y, oFog);
		    if (distance_to_object(smoke_object) <= smoke_object.radius) {
				if(smoke_object.alarm[0] > 1){
					if(hidden_in_smoke == false){
						hidden_in_smoke = true;	
					}
				}else{
					if(hidden_in_smoke == true){
						hidden_in_smoke = false;
					}
				}
			}else{
				if(hidden_in_smoke == true){
					hidden_in_smoke = false;	
				}
			}
		}

		var hidden_in_grass = place_meeting(x, y, oGrass);
		hidden = hidden_in_smoke || hidden_in_grass;
		#endregion
	
		#region In water logic
		if(place_meeting(x, y, oWater)){
			in_water = true;
			in_water_timer = game_get_speed(gamespeed_fps);
		}else{
			if(in_water_timer > -1){
				in_water_timer --;
			}else{
				in_water = false;
			}
		}
		#endregion
	
		#region Drop weapon
		if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyDropWeapon]) && player_can_shoot == true && !global.my_console[? "active"] && !is_inventory_full() && moving_state != states_player.machine_gun_state){
			player_has_scope = -1;
			ScopeIn = false;	
			GainItem(
				global.Inventory[# WeaponID, Index.slot_id], 
				1,
				global.Inventory[# WeaponID, Index.slot_ammo], 
				global.Inventory[# WeaponID, Index.slot_clip_ammo], 
				global.Inventory[# WeaponID, Index.slot_durability],
				global.Inventory[# WeaponID, Index.slot_scope],
				global.Inventory[# WeaponID, Index.slot_barrel],
				global.Inventory[# WeaponID, Index.slot_grip],
				global.Inventory[# WeaponID, Index.slot_suppressor],
				false
			);
			WeaponDrop(WeaponID, id);
		}
		#endregion	
	
		#region Hold stamina
		stamina_inaccuracy = 1;
		if (!global.my_console[? "active"] && global.Inventory[# WeaponID, Index.slot_id] != Item.None){
			if(keyboard_check(global.KeyBinds[| KeyBind.KeyHoldStamina]) && stats.Stamina_points > 0){
				statistics_hit("Stamina", STAMINA_HOLD_VALUE, id);
				stamina_inaccuracy = .5;
			}
		}
		#endregion
	
		#region Legs animation
		if (global.my_console[? "active"] || moving_state == states_player.prone_state || moving_state == states_player.machine_gun_state || moving_state == states_player.mortar_state
		|| instance_exists(oInventory) || Moving == false) {
		    Legs.image_speed = 0;
		} else {
		    Legs.image_speed = 1;
		}
		#endregion
	
		#region Buy menu
		if(!global.my_console[? "active"] && !instance_exists(oInventory) && moving_state != states_player.mortar_state){
			if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyBuyMenu])){
				if(instance_exists(oBuyMenu)){
					player_can_shoot = true;
					with(oBuyMenuDescription){
						zui_destroy();
					}
					with(oBuyMenu){
						zui_destroy();
					}
				}else{
					player_can_shoot = false;
					with(zui_main()){
						zui_create(zui_get_width() * .5, zui_get_height() * .5, oBuyMenu);
					}
				}
			
				
			}
		}
		#endregion
	
		#region Friend command and go
		/*if!(global.my_console[? "active"]){
			if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCommand]) && instance_exists(oFriend)){
			    var botList = ds_list_create();
			    with (oFriend) {
			        ds_list_add(botList, id);
			    }

			    var currentIndex = -1;
			    if (ds_list_size(global.selected_bots) > 0) {
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
					set_state(States.MoveTowardPoint);
					StartX = x;
					StartY = y;
					PointX = oCrosshair.x;
					PointY = oCrosshair.y;
				}
			}
		}*/
		#endregion
	
		#region Timers and other
		stats.Health_points = clamp(stats.Health_points, -1, global.player_stats_struct.Max_health);
		stats.Damage_health_points = clamp(stats.Damage_health_points, 1, global.player_stats_struct.Max_health);
		stats.Stamina_points = clamp(stats.Stamina_points, 0, global.player_stats_struct.Max_stamina);
		stats.Damage_stamina_points = clamp(stats.Damage_stamina_points, 0, global.player_stats_struct.Max_stamina);
		headshot_x = x + 3;
		headshot_y = y - 17;
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
			if(stats.Stamina_points >= 0 && stats.Stamina_points < global.player_stats_struct.Max_stamina){
				var stamina_healing_power = ceil(global.player_stats_struct.Max_stamina/50);
				if(moving_state == states_player.prone_state){
					stamina_healing_power = ceil(global.player_stats_struct.Max_stamina/10);
				}
				if(stats.Stamina_points <= global.player_stats_struct.Max_stamina - stamina_healing_power){
					stats.Stamina_points += stamina_healing_power;
				}else{
					stats.Stamina_points += (global.player_stats_struct.Max_stamina - stats.Stamina_points);
				}
				stats.Damage_stamina_points = stats.Stamina_points;
				StaminaHealingTimer = HealingTimer;
			}
		}	
		if(StaminaHealingTimer > -1){
			StaminaHealingTimer --;	
		}
		#endregion
	
	
		if(knife_attack_timer > -1){
			knife_attack_timer --;	
		}
	
		if(player_can_shoot == false){
			RelativeSpeedX = 0;
			RelativeSpeedY = 0;
			Moving = false;
			Legs.image_speed = 0;
			XSpeed = 0;
			YSpeed = 0;
		}
	
		if(moving_state == states_player.prone_state){
			headshot_x = x + 67;
			headshot_y = y - 12;
		}
	
		if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
			if(Reloading == true){
				Reloading = false;
				ReloadTime = 0;
			}
		}
	
		if(item_equip_timer > -1){
			item_equip_timer --;
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
	
	
		if(instance_exists(oBulletTracer)){
			var BulletTracerNearby = instance_nearest(x, y, oBulletTracer);
			if(BulletTracerNearby.stats.Object != noone){
				if(BulletTracerNearby.stats.Object != id && distance_to_object(BulletTracerNearby) <= 64){
					play_sound(BulletTracerNearby.x, BulletTracerNearby.y, choose(snd_BulletTor1, snd_BulletTor2, snd_BulletTor3));	
				}
			}
		}
		#endregion
	
		#region Scope attachments
		switch(global.Inventory[# WeaponID, Index.slot_scope]){
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
		
			#region Camera shake variables
			var LowStaminaViewAngleFrequency = 0;
			var PlayerVelocity = sqrt(power(XSpeed, 2) + power(YSpeed, 2)) * game_get_speed(gamespeed_fps);
			var rotation_increment = 0;
			var max_rotation = 0;	
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
			#endregion
		
			#region Camera shake using camera angle
		
				#region Knife camera shake
				if(knife_attack_timer >= global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed] * .5){
					GunCrossShake = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CrosshairShake];
				    ViewAngleAmplitude += global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CameraShake];
				    GunViewAngleFrequency = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CameraShake];
				}
				#endregion
		
				#region Low stamina camera shake
				if(stats.Stamina_points <= global.player_stats_struct.Max_stamina * .75){
					LowStaminaViewAngleFrequency = 2 - ((stats.Stamina_points/global.player_stats_struct.Max_stamina));
					ViewAngleAmplitude += 1 - (stats.Stamina_points/global.player_stats_struct.Max_stamina);
				}
				#endregion
		
				#region Gun camera shake
				if (CanShoot == false && ShootTimer >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer]/2) {
					GunCrossShake = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CrosshairShake];
				    ViewAngleAmplitude += global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CameraShake];
				    GunViewAngleFrequency = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CameraShake];
				}
				#endregion
		
				#region Aimpunch camera shake
				if(AimPunchTimer > -1){
					AimPunchCrossShake = AimPunchStrength*5 * AimPunchMultiplier;
					ViewAngleAmplitude += AimPunchStrength * AimPunchMultiplier;
					AimPunchViewAngleFrequency = AimPunchStrength*.5 * AimPunchMultiplier;
				}
				#endregion
		
				#region Explosion camera shake
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
				#endregion
		
				#region Low health camera shake
				if(stats.Health_points <= ceil(global.player_stats_struct.Max_health/2)){
					LowHPCrossShake = 1;
					ViewAngleAmplitude += 0.5;
					LowHPViewAngleFrequency = 75;
				}
				#endregion
			
		
				#region Final calculation
				var ViewAngleFrequency = GunViewAngleFrequency + AimPunchViewAngleFrequency + ExplosionViewAngleFrequency + LowHPViewAngleFrequency + LowStaminaViewAngleFrequency;
				ViewAngleAmplitude *= ViewAngleDamping;
		
				if (ViewAngleAmplitude > 0.01) {
				    ViewAngleCurrent = ViewAngleAmplitude * sin(degtorad(current_time * ViewAngleFrequency));
				}else{
					ViewAngleFrequency = 0;
				    ViewAngleAmplitude = 0;
				    ViewAngleCurrent = 0;
				}
				#endregion
		
			#endregion
		
			#region Camera shake using camera position
			if(CanShoot == false && ShootTimer >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer]/2){
				if(ViewShake == false){
					ViewShakeMagnitude = choose(
												-global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CrosshairShake], 
												global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.CrosshairShake]
										);
					ViewShakeTimer = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer];
					ViewShake = true;
				}
			}
		
			if (ViewShake == true){ 
			   ViewShakeTimer -= 1; 
			   ViewShakeValuePower = lerp(ViewShakeValuePower, ViewShakeMagnitude, 0.75); 

			   if (ViewShakeTimer <= 0){ 
			      ViewShakeMagnitude -= 1; 

			      if (ViewShakeMagnitude <= 0){ 
					  ViewShakeMagnitude = 0;
			         ViewShake = false; 
			      } 
			   } 
			}else{
				ViewShakeValuePower = lerp(ViewShakeValuePower, 0, 0.75);
			}
			#endregion
		
			#region Final formula
			if (abs(ViewShakeValuePower) < 1) {
			    ViewShakeValuePower = 0;
			}
			CrosshairShake = GunCrossShake + AimPunchCrossShake + ExplosionCrossShake + LowHPCrossShake;
			ViewAngle = ViewAngleCurrent;
			camera_set_view_angle(CAMERA, ViewAngle);
			camera_set_view_pos(CAMERA, camera_get_view_x(CAMERA) + ViewShakeValuePower, camera_get_view_y(CAMERA) + ViewShakeValuePower); 
			#endregion
		
			#region Moving camera shake (different approach)
			if (player_can_shoot == true && !global.my_console[? "active"]) {
				rotation_increment = PlayerVelocity/5000;
				max_rotation = PlayerVelocity/750;
				if(moving_state == states_player.none_state || moving_state == states_player.prone_state){
					if (keyboard_check(ord("A"))) {
						if (rotation_target > -max_rotation && rotation_direction == 1) {
							rotation_target -= rotation_increment;
							if (rotation_target <= -max_rotation) {
								rotation_direction = -1;
							}
						} else {
							rotation_target += rotation_increment;
							if (rotation_target >= max_rotation) {
								rotation_direction = 1;
							}
						}
					} else if (keyboard_check(ord("D"))) {
						if (rotation_target < max_rotation && rotation_direction == 1) {
							rotation_target += rotation_increment;
							if (rotation_target >= max_rotation) {
								rotation_direction = -1;
							}
						} else {
							rotation_target -= rotation_increment;
							if (rotation_target <= -max_rotation) {
								rotation_direction = 1;
							}
						}
					} else if (keyboard_check(ord("W"))) {
						if (rotation_target > -max_rotation && rotation_direction == 1) {
							rotation_target -= rotation_increment;
							if (rotation_target <= -max_rotation) {
								rotation_direction = -1;
							}
						} else {
							rotation_target += rotation_increment;
							if (rotation_target >= max_rotation) {
								rotation_direction = 1;
							}
						}
					} else if (keyboard_check(ord("S"))) {
						if (rotation_target < max_rotation && rotation_direction == 1) {
							rotation_target += rotation_increment;
							if (rotation_target >= max_rotation) {
								rotation_direction = -1;
							}
						} else {
							rotation_target -= rotation_increment;
							if (rotation_target <= -max_rotation) {
								rotation_direction = 1;
							}
						}
					} 
				}
			
				if(Moving == false){
					rotation_target = 0;
				}

				// Smooth rotation transition
				rotation_angle = lerp(rotation_angle, rotation_target, .5);
				camera_set_view_angle(view_camera[0], camera_get_view_angle(view_camera[0]) + rotation_angle);
			}
			#endregion
		
		}
		
		#endregion

		#region Flashlight
		if(Weapon != noone && (global.Inventory[# WeaponID, Index.slot_id] != Item.None && global.Inventory[# item_use_position, Index.slot_id] == Item.None)){
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
	
			#region Knife texture
			if(WeaponID != OtherSlot.Knife || global.Inventory[# item_use_position, Index.slot_id] != Item.None){
				Knife.image_index = 0;
			}else{		
				switch(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Name]){
					case "Steel knife":
						Knife.image_index = 1;
					break;
				
					default:
						Knife.image_index = 0;
					break;
				}
			}
			#endregion
		
			#region Weapon texture
			switch(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Name]){
				case "AKM":
					Weapon.image_index = 1;
				break;
			
				case "Desert Eagle":
					Weapon.image_index = 2;
				break;
			
				case "Spas-12":
					Weapon.image_index = 3;
				break;
			
				case "SSG 08":
					Weapon.image_index = 4;
				break;
			
				case "MAC11":
					Weapon.image_index = 5;
				break;
			
				case "SIG SG550":
					Weapon.image_index = 6;
				break;
			
				case "FGM-148":
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
			
				case "Galil":
					Weapon.image_index = 12;
				break;
			
				case "P250":
					Weapon.image_index = 13;
				break;
			
				case "MK18":
					Weapon.image_index = 14;
				break;
			
				case "FAMAS":
					Weapon.image_index = 15;
				break;
			
				case "TEC-9":
					Weapon.image_index = 16;
				break;
			
				default:
					Weapon.image_index = 0;
				break;
			}
		
			if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
				Weapon.image_index = 0;	
			}
			#endregion
		
			#region Player texture
			if(moving_timer > -1){
				moving_timer --;
			}
		
			if(global.Inventory[# item_use_position, Index.slot_id] == Item.None){
				switch(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.WeaponTypeClass]){
			
					#region Assault rifle texture
					case "Assault rifle":
						if(moving_state != states_player.prone_state){
							HeadHitBox.image_index = HitBox.Head;
							if(Flashed == false){
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
									image_index = player_textures.assault_rifle;
									BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
									ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
								}else{
									image_index = player_textures.reload;
									BodyHitBox.image_index = HitBox.BodyReloading;
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
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
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
				
						WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
					break;
					#endregion
	
					#region Pistol texture
					case "Pistol":
						if(moving_state != states_player.prone_state){
							HeadHitBox.image_index = HitBox.Head;
							if(Flashed == false){
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
									image_index = player_textures.pistol;
									BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
									ArmHitBox.image_index = HitBox.ArmWithPistol;
								}else{
									image_index = player_textures.reload;
									BodyHitBox.image_index = HitBox.BodyReloading;
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
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){	
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
	
						WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .8;
					break;
					#endregion
			
					#region Submachine gun texture
					case "Submachine gun":
						if(moving_state != states_player.prone_state){
							HeadHitBox.image_index = HitBox.Head;
							if(Flashed == false){
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
									image_index = player_textures.pistol;
									BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
									ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
								}else{
									image_index = player_textures.reload;
									BodyHitBox.image_index = HitBox.BodyReloading;
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
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
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
				
						WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .9;
					break;
					#endregion
	
					#region Sniper rifle texture
					case "Sniper rifle":
						if(moving_state != states_player.prone_state){
							HeadHitBox.image_index = HitBox.Head;
							if(Flashed == false){
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
									image_index = player_textures.assault_rifle;
									BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
									ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
								}else{
									image_index = player_textures.reload;
									BodyHitBox.image_index = HitBox.BodyReloading;
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
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
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
				
						WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
					break;
					#endregion
			
					#region Shotgun texture
					case "Shotgun":
						if(moving_state != states_player.prone_state){
							HeadHitBox.image_index = HitBox.Head;
							BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
							if(Flashed == false){
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
									image_index = player_textures.assault_rifle;
									ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
								}else{
									image_index = player_textures.reload;
									BodyHitBox.image_index = HitBox.BodyReloading;
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
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
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
				
						WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
					break;
					#endregion
			
					#region Anti-tank missile texture
					case "Anti-tank missile":
						if(moving_state != states_player.prone_state){
							HeadHitBox.image_index = HitBox.Head;
							BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
							if(Flashed == false){
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.75){
									image_index = player_textures.assault_rifle;
									ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
								}else{
									image_index = player_textures.reload;
									BodyHitBox.image_index = HitBox.BodyReloading;
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
								if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.75){
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
				
						WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
					break;
					#endregion
			
					#region Machine gun texture
					case "Machine gun":
						HeadHitBox.image_index = HitBox.Head;
						BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
						if(Flashed == false){
							if!(ReloadTime >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed]*.95){
								image_index = player_textures.no_weapon;
								ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
							}else{
								image_index = player_textures.reload;
								ArmHitBox.image_index = HitBox.ArmReloading;
							}
						}else{
							image_index = player_textures.flashed_no_weapon;
							ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
						}
				
						WeaponDistance = 150;
					break;
					#endregion
				
					#region Knife texture
					case "Knife":
						HeadHitBox.image_index = HitBox.Head;
						BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
						if(Flashed == false){
							if(knife_attack_timer == -1){
								image_index = player_textures.no_weapon;
								ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
							}else{
								image_index = player_textures.knife;
								ArmHitBox.image_index = HitBox.ArmKnife;
							}
						}else{
							image_index = player_textures.flashed_no_weapon;
							ArmHitBox.image_index = HitBox.ArmWithoutWeaponFlashed;
						}
				
						WeaponDistance = 0;
					break;
					#endregion

					#region Default texture
					default:
						if(moving_state != states_player.prone_state){
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
				
						WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
					break;
					#endregion
			
				}
			}else{
			
				#region No weapon texture
				if(moving_state != states_player.prone_state){
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
				#endregion
			
			}
			#endregion
		
		#endregion
	
		#region Shooting mode
		var Shoot = -1;
		var shooting_mode = ds_list_find_value(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootingMode], weapon_shooting_mode);
	
		if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyChangeMode]) && shooting == false){
			var list_size = ds_list_size(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootingMode]);
			if(weapon_shooting_mode < list_size){
				weapon_shooting_mode = (weapon_shooting_mode + 1) % list_size;
			}
		}
	
		if(shooting_reset_timer > -1){
			shooting_reset_timer --;
		}
	
		if(shooting_mode == "Auto"){	
			if(KickBack > 1){
				KickBackTime = round(.08 * game_get_speed(gamespeed_fps) * global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.KBResetMultiplier]);
			}else{
				KickBackTime = round(.5 * game_get_speed(gamespeed_fps) * global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.KBResetMultiplier]);
			}
			Shoot = mouse_check_button(global.KeyBinds[| KeyBind.KeyShootMouse]);
			if((mouse_check_button_released(global.KeyBinds[| KeyBind.KeyShootMouse])) || (global.Inventory[# WeaponID, Index.slot_ammo] <= 0 && shooting == true)){
				kick_back_timer = KickBackTime;
				shooting = false;
				crosshair_position[0] = oCrosshair.x;
				crosshair_position[1] = oCrosshair.y;
			}
		}else if(shooting_mode == "Semi" || shooting_mode == "Burst"){
			KickBackTime = round(.25 * game_get_speed(gamespeed_fps) * global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.KBResetMultiplier]);
			Shoot = mouse_check_button_pressed(global.KeyBinds[| KeyBind.KeyShootMouse]);
			/*
				Jelikož se při auto modu vždycky resetne "shooting" na false po tom co hráč releasne tlačítko na střílení, musel jsem přidat "shooting_reset_timer"
		
			*/
			if(mouse_check_button(global.KeyBinds[| KeyBind.KeyShootMouse]) && shooting_reset_timer == -1){
				shooting_reset_timer = KickBackTime;
			}
			if((mouse_check_button_released(global.KeyBinds[| KeyBind.KeyShootMouse]) && global.Inventory[# WeaponID, Index.slot_ammo] > 0) || (global.Inventory[# WeaponID, Index.slot_ammo] <= 0 && shooting == true && shooting_reset_timer == -1)){
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
					var sound_id = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.SoundID];
					if(global.Inventory[# WeaponID, Index.slot_suppressor] == Item.military_suppressor){
						sound_id = snd_Silencer;
					}
					ShootTimer = ceil(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer] * global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_barrel], ItemStat.ShootTimer]);
					player_shooting();		
					play_sound(x, y, sound_id);
					Weapon.KickBackEffect = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.KickBackPower];
					KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);
					KickBack ++;
					global.Inventory[# WeaponID, Index.slot_ammo] --;
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
		if!(global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo] == -1){
			if(global.Inventory[# WeaponID, Index.slot_id] != Item.None && global.Inventory[# item_use_position, Index.slot_id] == Item.None && moving_state != states_player.mortar_state && item_equip_timer == -1){
				if (player_can_shoot == true && !global.my_console[? "active"]) {
					if(mouse_check_button_pressed(global.KeyBinds[| KeyBind.KeyShootMouse]) && global.Inventory[# WeaponID, Index.slot_ammo] <= 0){
						play_sound(x, y, snd_empty_magazine);
					}
				    if(Shoot == 1 && (Reloading == false || (Reloading == true && global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Defense] == 1))){
				
						if(global.Inventory[# WeaponID, Index.slot_ammo] > 0){
							shooting = true;
				
							#region Fractionating reloading stop
							if(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Defense] == 1){
								ReloadTimer = -1;
								Reloading = false;
								ReloadTime = 0;
							}
							#endregion	
				
					        if(CanShoot == true){
					
							
					
								if(shooting_mode == "Burst"){
						
									#region Burstfire
							        if (burst_fire == false) {
							            burst_fire = true;
							            burst_shots_fired = 0;
							            burst_fire_timer = max(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer]/2, 5);
							        }
									#endregion
						
								}else{
						
									#region Normal fire
									var sound_id = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.SoundID];
									if(global.Inventory[# WeaponID, Index.slot_suppressor] == Item.military_suppressor){
										sound_id = snd_Silencer;
									}
									ShootTimer = ceil(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer] * global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_barrel], ItemStat.ShootTimer]);					
									player_shooting();
									play_sound(x, y, sound_id);
									Weapon.KickBackEffect = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.KickBackPower];
									KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);
									KickBack ++;
									global.Inventory[# WeaponID, Index.slot_ammo] --;
									CanShoot = false;
									#endregion
						
								}
					
								#region Scope in logic
								if(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == "Sniper rifle"){
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
		}
		if(shooting == false){
			if(kick_back_timer == -1){
				KickBack = max(0, KickBack - (global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.KBStabilization] + 1));
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
		if(player_can_shoot == true && !global.my_console[? "active"] && can_player_shoot()){
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
			if(AimPunchTimer == -1){
				aimpunch_speed_multiplier = 1;
			}
			var ShootingSpeedMultiplier = 1;
			if(CanShoot == false && ShootTimer >= global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer]/2){
				ShootingSpeedMultiplier = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootSpdMul];
			}
			var ReloadingSpeedMultiplier = 1;
			if(Reloading == true){
				ReloadingSpeedMultiplier = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpdMul];
			}
			var moving_speed_multiplier = 1;	
			if(moving_state == states_player.prone_state){
				moving_speed_multiplier	= .135;
			}
	
			var WeightSpeedMultiplier = 1 / (global.player_stats_struct.Weight/50 + 1);
	
			var WeaponSpeedMultiplier = 1;
			if(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.MovingSpdMul] != 0 && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
				WeaponSpeedMultiplier = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.MovingSpdMul];
			}
	
			SpeedMul = ReloadingSpeedMultiplier * ShootingSpeedMultiplier * aimpunch_speed_multiplier * moving_speed_multiplier * WeightSpeedMultiplier * WeaponSpeedMultiplier / (ScopeIn + 1) * (game_get_speed(gamespeed_fps)/60) / (Healing + 1);

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
				if(moving_state != states_player.prone_state){
					if(FootStepTimer == -1){
						FootStepTimer = 5;
						FootSteps ++;
					}
					if(FootStepTimer == 0 && Visible == true){
						particle_create(1, 0, RotationAngle, spr_FootSteps, 0, 0, RotationAngle, 0, false, false, FootSteps % 2, x, y, .5, 1.5 * game_get_speed(gamespeed_fps));
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
					if(moving_state != states_player.prone_state && Visible == true){
						particle_create(round(abs(XSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(XSpeed) * -1, abs(XSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
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
					if(moving_state != states_player.prone_state && Visible == true){
						particle_create(round(abs(YSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(YSpeed) * -1, abs(YSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
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
		
			}

			x = clamp(x,0,room_width-sprite_width);
			y = clamp(y,0,room_height-sprite_height);
		}

		#endregion
	
		#region Knife
	
		if(knife_attack_timer >= global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed] - 1 && global.Inventory[# WeaponID, Index.slot_id] != Item.None){
			Knife.stats.Item_id = global.Inventory[# WeaponID, Index.slot_id];
			Knife.stats.Damage = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage];
			var wall_object = instance_nearest(Knife.x, Knife.y, oParentTile);
			if(instance_exists(wall_object)){
				var hitbox_corners = get_hitbox_corners(Knife, 25, 50, 20, Knife.stats.Object.RotationAngle);
				var min_x = min(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
				var max_x = max(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
				var min_y = min(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);
				var max_y = max(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);

				 if (collision_rectangle(min_x, min_y, max_x, max_y, wall_object, true, false)) {
					var wall_sound = snd_BulletConcrete;
					var wall_particles = irandom_range(global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage], global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage]*2);
					if(wall_object.Type == "Metal"){
						wall_sound = snd_BulletMetal;
					}
					if!(audio_is_playing(wall_sound)){
						play_sound(Knife.x, Knife.y, wall_sound);
					}	
				}
			}
		}
	
		if(Knife.image_index != 0){
		
			if(player_can_shoot == true){
			
			#region Light attack
			if(mouse_check_button_pressed(mb_left) && stats.Stamina_points >= STAMINA_KNIFE_LIGHT){
				if(knife_attack_timer == -1){
					knife_attack_timer = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed];
					Knife.stats.Reward = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.reward];
					Knife.stats.Hit_timer = knife_attack_timer*2;
					Knife.stats.Damage = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage];	
					statistics_hit("Stamina", STAMINA_KNIFE_LIGHT * global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.ClipAmmo], id);
				}
			}
			#endregion
		
			#region Heavy attack
			if(mouse_check_button_pressed(mb_right) && stats.Stamina_points >= STAMINA_KNIFE_HEAVY){
				if(knife_attack_timer == -1){
					knife_attack_timer = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed];
					Knife.stats.Reward = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.reward];
					Knife.stats.Hit_timer = knife_attack_timer*2;
					Knife.stats.Damage = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage]*2;	
					statistics_hit("Stamina", STAMINA_KNIFE_HEAVY * global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.ClipAmmo], id);
				}
			}
			#endregion
		
			}
		
		}
		
		#endregion
	
		#region Object push player
		if(place_meeting(x, y, oEnemy)) {
		    var Enemy = instance_nearest(x, y, oEnemy);
			var dir = point_direction(Enemy.x, Enemy.y, x, y);
			AccelX = 5 * cos(degtorad(dir));
			AccelY = -5 * sin(degtorad(dir));
		}
	
		if(place_meeting(x, y, oMachineGunFloor)){
			var machine_gun_floor = instance_nearest(x, y, oMachineGunFloor);
			if(global.Inventory[# OtherSlot.Primary, Index.slot_id] != machine_gun_floor.stats.Id){
			var dir = point_direction(machine_gun_floor.x + lengthdir_x(-64, RotationAngle), machine_gun_floor.y + lengthdir_y(-64, RotationAngle), x, y);
			AccelX = 15 * cos(degtorad(dir));
			AccelY = -15 * sin(degtorad(dir));
			}
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

		#region Running and prone and machine gun
		if(!global.my_console[? "active"]){
	
			if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyProne]) && Moving == false){
				if(moving_state == states_player.none_state){
					moving_state = states_player.prone_state;
				}else if(moving_state == states_player.prone_state){
					moving_state = states_player.none_state;
				}
			}
		
			if(instance_exists(oMortar) && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments)){
				var mortar = instance_nearest(x, y, oMortar);		
				if(distance_to_object(mortar) <= PickUpDistance){
					if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPickUp])){
						if(moving_state == states_player.none_state){ /// Pokud neběži ani se neplazí
							player_can_shoot = false;
							with(zui_main()){
								with(zui_create(zui_get_width() * .75, zui_get_height() * .75, oMortarMenu)){
								}
							}
							moving_state = states_player.mortar_state;
						}else if(moving_state == states_player.mortar_state){
							player_can_shoot = true;
							with(oMortarMenu){
								zui_destroy();
							}
							moving_state = states_player.none_state;
						}
					}
				}
			}
	
			if(instance_exists(oMachineGun)){
				var machine_gun = instance_nearest(x, y, oMachineGun);		
				if(distance_to_object(machine_gun) <= PickUpDistance){
					if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyPickUp])){
						if(moving_state == states_player.none_state && global.Inventory[# OtherSlot.Primary, Index.slot_id] == Item.None){ /// Pokud neběži ani se neplazí
						
							#region Equip machine gun
							global.Inventory[# OtherSlot.Primary, Index.slot_id] = machine_gun.stats.Id;
							global.weapon_attachments[0][weapon_attachments.weapon_scope] = machine_gun.stats.Slot_scope;
							global.weapon_attachments[0][weapon_attachments.weapon_barrel] = machine_gun.stats.Slot_barrel;
							global.weapon_attachments[0][weapon_attachments.weapon_grip] = machine_gun.stats.Slot_grip;
							global.weapon_attachments[0][weapon_attachments.weapon_suppressor] = machine_gun.stats.Slot_suppressor;
							global.Inventory[# OtherSlot.Primary, Index.slot_ammo] = machine_gun.stats.Ammo;
							global.Inventory[# OtherSlot.Primary, Index.slot_clip_ammo] = machine_gun.stats.Clip_ammo;
							global.ItemIndex[# global.Inventory[# OtherSlot.Primary, Index.slot_id], ItemStat.MaxAmmo] = global.ItemIndex[#machine_gun.stats.Id, ItemStat.MaxAmmo];
							#endregion
						
							x = machine_gun.x;
							y = machine_gun.y;
							machine_gun.stats.Object = id;
							moving_state = states_player.machine_gun_state;	
						}else if(moving_state == states_player.machine_gun_state){
							ReloadTime = 0;
							moving_state = states_player.none_state;
							Reloading = false;
						
							#region Dequip machine gun
							global.Inventory[# OtherSlot.Primary, Index.slot_id] = Item.None;
							machine_gun.stats.Slot_scope = global.weapon_attachments[0][weapon_attachments.weapon_scope];
							machine_gun.stats.Slot_barrel = global.weapon_attachments[0][weapon_attachments.weapon_barrel];
							machine_gun.stats.Slot_grip = global.weapon_attachments[0][weapon_attachments.weapon_grip];
							machine_gun.stats.Slot_suppressor = global.weapon_attachments[0][weapon_attachments.weapon_suppressor];
							machine_gun.stats.Ammo = global.Inventory[# OtherSlot.Primary, Index.slot_ammo];
							machine_gun.stats.Clip_ammo = global.Inventory[# OtherSlot.Primary, Index.slot_clip_ammo];
							if(oDraw.show_weapon_attachments == true){
								player_can_shoot = true;
								oDraw.show_weapon_attachments = false;
							}
							player_has_scope = -1;
							ScopeIn = false;	
							WeaponDrop(1, id);
							#endregion
						
						}
					}
				}
			}
		}
	
		var RotationSpeed = 9;
		if(moving_state == states_player.prone_state){
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
				Knife.image_angle = RotationAngle;
				Weapon.RotationAngle = Weapon.image_angle;
	
			}
		}
		#endregion
	
		#region Toggle night vision and infrared vision
		if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.None){
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
			if(global.Inventory[# OtherSlot.Helmet, Index.slot_durability] > 0){
				if(string_pos("night vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
					play_sound(x, y, snd_ToggleNightVision);
					ToggleNightVision = !ToggleNightVision;	
				}else if(string_pos("Infrared vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
					play_sound(x, y, snd_ToggleNightVision);
					ToggleInfraVision = !ToggleInfraVision;	
				}
			}
		}
	
		if(global.Inventory[# OtherSlot.Helmet, Index.slot_durability] <= 0 && (ToggleNightVision == true || ToggleInfraVision == true)){
			if(string_pos("night vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
				play_sound(x, y, snd_ToggleNightVision);
				ToggleNightVision = false;	
			}if(string_pos("Infrared vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
					play_sound(x, y, snd_ToggleNightVision);
					ToggleInfraVision = false;	
				}
		}
		#endregion
	
		#region Flashed
		if(Flashed == true){
			knife_attack_timer = -1;
			if(Reloading == true){
				ReloadTime = 0;
				Reloading = false;
			}
			FlashedAlpha = lerp(FlashedAlpha, 0, 0.01);	
		}
		if(FlashedAlpha <= 0.075){
			if(sprite_exists(FlashedBackGround) && FlashedBackGround != -1){sprite_delete(FlashedBackGround);}
			flashed_muffled_sounds = 1;
			FlashedAlpha = 0;
			Flashed = false;
			FlashedBackGround = -1;
		}else{
			flashed_muffled_sounds = lerp(flashed_muffled_sounds, FLASHED_MUFFLE_VALUE, 0.01);	
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
			global.player_stats_struct.Max_stamina *= power(STATS_LVL_UP, ln(global.player_stats_struct.Lvl));
			global.player_stats_struct.Max_health *= power(STATS_LVL_UP, ln(global.player_stats_struct.Lvl));
			global.player_stats_struct.Max_xp *= XP_LVL_UP_MUL;
		}
		#endregion

		if(!global.my_console[? "active"] && !instance_exists(oBuyMenu) && moving_state != states_player.mortar_state){
		
			#region Inventory
			if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyInventory])){
				if(player_can_shoot == true){
					instance_create_layer(x, y, "OtherO", oInventory);
					player_can_shoot = false;
					Moving = false;
					RelativeSpeedX = 0;
					RelativeSpeedY = 0;
				}else{
					if(oDraw.show_weapon_attachments == false){
						player_can_shoot = true;
					}
					item_description_destroy();
				    instance_destroy(oInventory);
				    instance_destroy(oSlot);
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

			if(instance_exists(oInventory)){
		
				#region Item cycling in inventory
				if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleInvRight])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					item_use_position ++;
					if(item_use_position > INVENTORY_SIZE - 1){
					    item_use_position = 0;
					}
				}
				if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleInvUp])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					if(item_use_position <= INVENTORY_ROW_SIZE - 1){
						item_use_position = item_use_position + (INVENTORY_SIZE - INVENTORY_ROW_SIZE);
					}else{
						item_use_position = item_use_position - INVENTORY_ROW_SIZE;
					}
				}
				if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleInvDown])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					if(item_use_position >= 2*INVENTORY_ROW_SIZE){
						item_use_position = item_use_position - (INVENTORY_SIZE - INVENTORY_ROW_SIZE);
					}else{
						item_use_position = item_use_position + INVENTORY_ROW_SIZE;
					}
				}
				if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleInvLeft])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					if(item_use_position == 0){ 
					    item_use_position = INVENTORY_SIZE - 1;
					}else{
					    item_use_position --;
					}
				}

			#endregion
		
			}else{
				
				#region Item cycling outside inventory
				if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleRight])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					item_use_position ++;
					if(item_use_position > INVENTORY_SIZE - 1){
					    item_use_position = 0;
					}
				}			
				if(keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyCycleLeft])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					if(item_use_position == 0){ 
						item_use_position = INVENTORY_SIZE - 1;
					}else{
						item_use_position --;
					}
				}
				#endregion
		
			}

			#region Item use
			if(mouse_check_button_pressed(mb_left) && !instance_exists(oInventory)){
				var Id = global.Inventory[# item_use_position, Index.slot_id];
			
				if(global.ItemIndex[#Id, ItemStat.Type] == "Grenade" && !instance_exists(oWeaponAttachments)){
				
					#region Grenade use
					if(EquippedGrenadeTimer == -1){
						create_grenade(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
						global.ItemIndex[#Id, ItemStat.BulletCasingID], global.ItemIndex[#Id, ItemStat.ReloadSpeed], oCrosshair.x, oCrosshair.y, Id);						
						ItemAmountSubstract(item_use_position, 1);
						EquippedGrenadeTimer = EquippedGrenadeTime;
					
						grenade_angle = random(360);
					}
					#endregion
				
				}else if(global.ItemIndex[#Id, ItemStat.Type] == "Landmine" && !instance_exists(oWeaponAttachments)){
				
					#region Landmine use
					landmine_create(
						x, 
						y, 
						Id
					);
					ItemAmountSubstract(item_use_position, 1);
					#endregion
				
				}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item"){
				
					#region Item use
					switch(Id){
						case Item.HealingKit:
							if(Healing == false && stats.Health_points < global.player_stats_struct.Max_health && !instance_exists(oWeaponAttachments)){
								item_equip_timer = item_equip_time;
								HealingItemId = Item.HealingKit;
								Healing = true;
								ItemAmountSubstract(item_use_position, 1);
							}
						break;		
					
						case Item.red_dot_scope:
							item_equip_timer = item_equip_time;
							weapon_attachment_equip(Id, Index.slot_scope);
						break;
						
						case Item.two_scope:
							item_equip_timer = item_equip_time;
							weapon_attachment_equip(Id, Index.slot_scope);
						break;
						
						case Item.adaptive_chambering:
							item_equip_timer = item_equip_time;
							weapon_attachment_equip(Id, Index.slot_barrel);
						break;
						
						case Item.vertical_grip:
							item_equip_timer = item_equip_time;
							weapon_attachment_equip(Id, Index.slot_grip);
						break;
						
						case Item.horizontal_grip:
							item_equip_timer = item_equip_time;
							weapon_attachment_equip(Id, Index.slot_grip);
						break;
						
						case Item.military_suppressor:
							item_equip_timer = item_equip_time;
							weapon_attachment_equip(Id, Index.slot_suppressor);
						break;						
					}
					#endregion
				
				}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon" && !instance_exists(oWeaponAttachments)){
								
					#region Primary equip and dequip
					var primary_slot_id = global.Inventory[# OtherSlot.Primary, Index.slot_id];
					if (primary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Primary")) {
						item_equip_timer = item_equip_time;
						item_swap("item_use_position", OtherSlot.Primary);
						primary_slot_id = Item.None;
					} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Primary") {
						item_equip_timer = item_equip_time;
						item_swap("item_use_position", OtherSlot.Primary);
					}
					#endregion
				
					#region Secondary equip and dequip
					var secondary_slot_id = global.Inventory[# OtherSlot.Secondary, Index.slot_id];
					if (secondary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Secondary")) {
						item_equip_timer = item_equip_time;
						item_swap("item_use_position", OtherSlot.Secondary);
						secondary_slot_id = Item.None;
					} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Secondary") {
						item_equip_timer = item_equip_time;
						item_swap("item_use_position", OtherSlot.Secondary);
					}
					#endregion
				
					#region Knife equip and dequip
					var tertiary_slot_id = global.Inventory[# OtherSlot.Knife, Index.slot_id];
					if (tertiary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Tertiary")) {
						item_equip_timer = item_equip_time;
						item_swap("item_use_position", OtherSlot.Knife);
						tertiary_slot_id = Item.None;
					} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Tertiary") {
						item_equip_timer = item_equip_time;
						item_swap("item_use_position", OtherSlot.Knife);
					}
					#endregion
						
				
				}else if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" && !instance_exists(oWeaponAttachments)){
				
					#region Armour equip and dequip
					var armour_slot_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
					if (armour_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Armour")) {
						item_equip_timer = item_equip_time;
						ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], armour_slot_id);
						item_swap("item_use_position", OtherSlot.Armour);
						armour_slot_id = Item.None;
						with(id){
							equip_network_propagate();
						}
					} else if (global.ItemIndex[# Id, ItemStat.Type] == "Armour") {
						item_equip_timer = item_equip_time;
						ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], armour_slot_id);
						item_swap("item_use_position", OtherSlot.Armour);
						with(id){
							equip_network_propagate();
						}
					}
					#endregion
				
				}else if(global.ItemIndex[#Id, ItemStat.Type] == "Helmet" && !instance_exists(oWeaponAttachments)){
				
					#region Helmet equip and dequip
					var helmet_slot_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
					if (helmet_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Helmet")) {
						item_equip_timer = item_equip_time;
						ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], helmet_slot_id);
						item_swap("item_use_position", OtherSlot.Helmet);
						helmet_slot_id = Item.None;
						with(id){
							equip_network_propagate();
						}
					} else if (global.ItemIndex[# Id, ItemStat.Type] == "Helmet") {
						item_equip_timer = item_equip_time;
						ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], helmet_slot_id);
						item_swap("item_use_position", OtherSlot.Helmet);
						with(id){
							equip_network_propagate();
						}
					}
					#endregion
				
				}else if(global.ItemIndex[#Id, ItemStat.Type] == "Shield" && !instance_exists(oWeaponAttachments)){
				
					#region Shield use
					item_equip_timer = item_equip_time;
					#endregion
				
				}
			}
		
			#endregion
		
			#region Scope
			var ScopeButton = mouse_check_button(mb_right);
			if!(instance_exists(oInventory)){
				if(global.Inventory[# WeaponID, Index.slot_scope] != Item.None && CanShoot == true && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
					if(ScopeButton){
						if(ScopeIn == false){
					
							if(global.Inventory[# WeaponID, Index.slot_scope] == Item.two_scope){
								ScopeInaccuracyTimer = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ScopeInaccuracyResetTimer];
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
					var equipTime = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.EquipTime];
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
		if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
			ReloadTimer = 0;
		}
	
		if(ReloadTimer > -1){
			ReloadTimer --;	
		}
	
		if(ReloadTimer == 0){
			if(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Defense] != 1){
			
				#region Normal reloading
				if(global.Inventory[# WeaponID, Index.slot_id] != Item.Javelin){
					particle_create(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
					random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.AmmoSpriteID], x, y);		
				}
				Reloading = false;
				ReloadTime = 0;
				if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0) {
				    if (global.Inventory[# WeaponID, Index.slot_clip_ammo] > global.AmmoNeeded) {
				    global.Inventory[# WeaponID, Index.slot_clip_ammo] -= global.AmmoNeeded;
				    global.Inventory[# WeaponID, Index.slot_ammo] += global.AmmoNeeded;
				    } else if (global.Inventory[# WeaponID, Index.slot_clip_ammo] < global.AmmoNeeded) {
				    global.Inventory[# WeaponID, Index.slot_ammo] += global.Inventory[# WeaponID, Index.slot_clip_ammo];
				    global.Inventory[# WeaponID, Index.slot_clip_ammo] -= global.Inventory[# WeaponID, Index.slot_clip_ammo];
				    } else if (global.Inventory[# WeaponID, Index.slot_ammo] + global.Inventory[# WeaponID, Index.slot_clip_ammo] = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo]) {
				    global.Inventory[# WeaponID, Index.slot_ammo] = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo];
				    global.Inventory[# WeaponID, Index.slot_clip_ammo] = 0;
				    }
				}
				#endregion
			
			}else{
			
				#region Fractionating reloading
				Reloading = false;
				ReloadTime = 0;
				if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0) {
					global.Inventory[# WeaponID, Index.slot_clip_ammo] -= 1;
					global.Inventory[# WeaponID, Index.slot_ammo] += 1;
				}
				if(global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo]){
					Reloading = true;
					ReloadTimer = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed];
				}
				#endregion
			
			}
		}
	
		if (global.Inventory[# WeaponID, Index.slot_id] != -1) {
		  if (global.Inventory[# WeaponID, Index.slot_ammo] > global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo]) {
		    global.Inventory[# WeaponID, Index.slot_ammo] = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo];
		  }
		  global.AmmoNeeded = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo] - global.Inventory[# WeaponID, Index.slot_ammo];

		  if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0 && Reloading = false && keyboard_check_pressed(global.KeyBinds[| KeyBind.KeyReload]) && shooting == false && !global.my_console[? "active"] && global.Inventory[# item_use_position, Index.slot_id] == Item.None && FlashedAlpha <= 0){
		    Reloading = true;
		    ReloadTimer = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ReloadSpeed];
		  }
		}

		if(Reloading == true){
		    ReloadTime ++;
		}
		#endregion
	
		#region Deactivate out of view
		var deactivateLeft = camera_get_view_x(CAMERA) - DEACTIVATE_MARGIN;
		var deactivateTop = camera_get_view_y(CAMERA) - DEACTIVATE_MARGIN;
		var deactivateRight = deactivateLeft + camera_get_view_width(CAMERA) + 2 * DEACTIVATE_MARGIN;
		var deactivateBottom = deactivateTop + camera_get_view_height(CAMERA) + 2 * DEACTIVATE_MARGIN;

		with (oEnemy) {
		    if (x < deactivateLeft || x > deactivateRight || y < deactivateTop || y > deactivateBottom) {
		        Visible = false;
				FlashLight.visible = false;
		    }
		}

		instance_deactivate_region(deactivateLeft, deactivateTop, deactivateRight - deactivateLeft, deactivateBottom - deactivateTop, false, true);
	

		// Activate instances within view ACTIVATE_MARGIN
		instance_activate_region(
			camera_get_view_x(CAMERA) - ACTIVATE_MARGIN,
			camera_get_view_y(CAMERA) - ACTIVATE_MARGIN,
			camera_get_view_width(CAMERA) + 2 * ACTIVATE_MARGIN,
			camera_get_view_height(CAMERA) + 2 * ACTIVATE_MARGIN,
			true
		);
		instance_activate_object(oNetworkManager);
		instance_activate_object(obj_hazeC);
		instance_activate_object(oParentTile);
		instance_activate_object(objUITextInput);
		instance_activate_object(oMortarMenu);
		instance_activate_object(oWeaponAttachments);
		instance_activate_object(oBuyMenuDescription);
		instance_activate_object(objUIImage);
		instance_activate_object(oBuyMenu);
		instance_activate_object(oWeaponDescription);
		instance_activate_object(oLightRenderer);
		instance_activate_object(oDamageTable);
		instance_activate_object(oItemDescription);
		instance_activate_object(objUIWindowCaption);
		instance_activate_object(objZUIMain);
		instance_activate_object(objUIButton);
		instance_activate_object(objUILabel);
		instance_activate_object(objUIGrid);
		instance_activate_object(oArmourDescription);
		instance_activate_object(oRatingController);
		instance_activate_object(oCrosshair);
		instance_activate_object(oDamageIndicator);
		instance_activate_object(oDraw);
		instance_activate_object(oBulletTracer);
		instance_activate_object(oBullet);
		instance_activate_object(oParticleSystem);
		instance_activate_object(oParticleSurface);
		instance_activate_object(oConsole);
		instance_activate_object(oCamera);
		instance_activate_object(oPlayer);
		instance_activate_object(oInventory);
		instance_activate_object(oGrenade);
		instance_activate_object(oExplosion);
		#endregion
		
	}
	
}

#region Death
if!(instance_exists(oNetworkManager)){
	if(stats.Health_points <= 0 && oDraw.RespawnMenu == false){
		flashed_muffled_sounds = 1;
		oDraw.KilledByWeapon = KilledByWeapon;
		oDraw.KilledByName = KilledByName;
		Weapon.image_index = 0;
		image_index = 3;
		round_end("Loss");
		camera_set_view_angle(CAMERA, 0);
	}
}else{
	if(stats.Health_points <= 0){
		stats.Health_points = 100;
	}
}
#endregion