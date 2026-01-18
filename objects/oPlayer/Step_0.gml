event_inherited();

wpn_id = global.Inventory[# WeaponID, Index.slot_id];

#region Remote player
/* Player Object - Step Event */

if (is_remote) {
	wpn_id = network_weapon_id;
	
	if(network_shoot_timer == 0){
		create_shooting_effects(id);
	}
	
	if (network_shoot_timer > -1) {
	    network_shoot_timer--;
	}
	Moving = (network_bit_state & PLAYER_FLAGS.MOVING) != 0;
	Reloading = (network_bit_state & PLAYER_FLAGS.RELOADING) != 0;
	Flashed = (network_bit_state & PLAYER_FLAGS.FLASHED) != 0;
	Legs.image_speed = Moving ? 1 : 0;
			
	if(network_shoot_timer > -1){
		Weapon.KickBackEffect = global.ItemIndex[# wpn_id, ItemStat.KickBackPower];
	}
	
	
	
	if(Weapon != noone && (wpn_id != Item.None && (global.Inventory[# item_use_position, Index.slot_id] == Item.None || is_remote))){
		var suppressor_len = 1;
		if(network_suppressor != Item.None){
			suppressor_len = 1.25;
		}
		FlashLightX = Weapon.x + lengthdir_x(WeaponDistance * suppressor_len, RotationAngle); FlashLightY = Weapon.y + lengthdir_y(WeaponDistance * suppressor_len, RotationAngle);
	}else{
		FlashLightX = x; FlashLightY = y;
	}
	
	if(FlashLight != undefined){
		FlashLight.angle = RotationAngle; FlashLight.x = FlashLightX; FlashLight.y = FlashLightY;
	}

	if(ReloadTimer > -1){
		ReloadTimer --;	
	}
	
	
	if(Reloading == true){
		if(ReloadTimer == -1) { ReloadTimer = global.ItemIndex[#wpn_id, ItemStat.ReloadSpeed]; }
		ReloadTime ++;
	}else{
		ReloadTime = 0;
	}
	
	if(wpn_id != Item.None && wpn_id != Item.Javelin && ReloadTimer == 0){
		if(wpn_id != Item.Javelin){
			particle_create(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
			random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#wpn_id, ItemStat.AmmoSpriteID], x, y);		
		}
	}

    x = lerp(x, target_x, INTERPOLATION_SPD);
    y = lerp(y, target_y, INTERPOLATION_SPD);
    RotationAngle = lerp(RotationAngle, target_direction, INTERPOLATION_SPD);
	Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
	KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);
	Weapon.x = x + lengthdir_x(WX, RotationAngle) - lengthdir_x(Weapon.KickBackEffect, RotationAngle);
	Weapon.y = y + lengthdir_y(WY, RotationAngle) - lengthdir_y(Weapon.KickBackEffect, RotationAngle);
	Weapon.image_angle = RotationAngle + KickBackAngle * .5;
	instance_destroy(LegHB);
	
}

#endregion

if (instance_exists(oDraw) && stats.Health_points > 0){
	
	#region Weapon texture
	var weapon_indexes = { "AKM":1, "Desert Eagle":2, "Spas-12":3, "SSG 08":4, "MAC11":5, "SIG SG550":6, "FGM-148":7,"Glock-17":8, 
							"M4A1":9, "AWM":10, "USP":11, "Galil":12, "P250":13, "MK18":14,"FAMAS":15, "TEC-9":16, "Dragunov": 17};
		
		
	Weapon.image_index = weapon_indexes[$ global.ItemIndex[# wpn_id, ItemStat.Name]] ?? 0;		
	if(global.Inventory[# item_use_position, Index.slot_id] != Item.None && is_local){ Weapon.image_index = 0; }
	#endregion

	#region Player texture
	
	if(global.Inventory[# item_use_position, Index.slot_id] == Item.None || is_remote && stats.Health_points > 0){
		switch(global.ItemIndex[# wpn_id, ItemStat.WeaponTypeClass]){
			
			case WEAPON_CLASS.ASSAULT_RIFLE:
			case WEAPON_CLASS.SUBMACHINE_GUN:
			case WEAPON_CLASS.SNIPER_RIFLE:
			case WEAPON_CLASS.SHOTGUN:
			case WEAPON_CLASS.MISSILE:
				if(moving_state == STATES_PLAYER.prone_state){
					apply_prone_texture();
				}else{
					apply_weapon_texture(TEXTURES.assault_rifle, HITBOX.BodyAR, HITBOX.ArmAR);
				}
				WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * 0.85;
			break;
	
			case WEAPON_CLASS.PISTOL:
				if(moving_state == STATES_PLAYER.prone_state){
					apply_prone_texture();
				}else{
					apply_weapon_texture(TEXTURES.pistol, HITBOX.BodyPistol, HITBOX.ArmPistol);
				}
				WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * 0.775;
			break;
			
			#region Machine gun texture
			case WEAPON_CLASS.MACHINE_GUN:
				HeadHB.image_index = HITBOX.Head;
				BodyHB.image_index = HITBOX.BodyNoWeapon;
				if(Flashed == false){
					if!(ReloadTime >= global.ItemIndex[#wpn_id, ItemStat.ReloadSpeed]*.95){
						image_index = TEXTURES.no_weapon;
						BodyHB.image_index = HITBOX.BodyAR;
						ArmHB.image_index = HITBOX.ArmNoWeapon;
					}else{
						image_index = TEXTURES.reload;
						ArmHB.image_index = HITBOX.ArmThrowReload;
					}
				}else{
					image_index = TEXTURES.flashed_no_weapon;
					ArmHB.image_index = HITBOX.ArmFlashedNoWeapon;
					HeadHB.image_index = HITBOX.HeadFlashed;
					BodyHB.image_index = HITBOX.BodyFlashedNoWeapon;
				}
				
				WeaponDistance = 150;
			break;
			#endregion
				
			#region Knife texture
			case WEAPON_CLASS.KNIFE:
				if!(moving_state == STATES_PLAYER.prone_state){
					HeadHB.image_index = HITBOX.Head;
					if(Flashed == false){
						if(knife_attack_timer == -1){
							image_index = TEXTURES.no_weapon;
							ArmHB.image_index = HITBOX.ArmNoWeapon;
							BodyHB.image_index = HITBOX.BodyNoWeapon;
						}else{
							image_index = TEXTURES.knife_attack;
							ArmHB.image_index = HITBOX.ArmKnife;
							BodyHB.image_index = HITBOX.BodyThrowReload;
						}
					}else{
						image_index = TEXTURES.flashed_no_weapon;
						ArmHB.image_index = HITBOX.ArmFlashedNoWeapon;
						HeadHB.image_index = HITBOX.HeadFlashed;
						BodyHB.image_index = HITBOX.BodyFlashedNoWeapon;
					}
				}else{
					HeadHB.image_index = HITBOX.HeadProne;
					BodyHB.image_index = HITBOX.BodyProne;
					if(Flashed == false){
						if(knife_attack_timer == -1){
							anim_base = TEXTURES.prone;
							ArmHB.image_index = HITBOX.ArmProne;
						}else{
							anim_base = TEXTURES.knife_prone;
							ArmHB.image_index = HITBOX.ArmProneKnife;
						}
					}else{
					    anim_base = TEXTURES.flashed_prone;
					    ArmHB.image_index = HITBOX.ArmProneFlashed;
					}
			
					if(anim_base != prev_anim_base){
					    image_index = anim_base;
					    LegHB.image_index = HITBOX.LegProne;
					    prev_anim_base = anim_base;
					}
					
					#region Leg animation mechanics
					if(Moving){
					    moving_timer --;

					    if(moving_timer <= -1){
					        image_index++;
					        LegHB.image_index++;

					        if(image_index >= anim_base + 2){
					            image_index = anim_base;
					            LegHB.image_index = HITBOX.LegProne;
					        }

					        moving_timer = 10;
					    }
					}else{
					    image_index = anim_base;
					    LegHB.image_index = HITBOX.LegProne;
					    moving_timer = -1;
					}
					#endregion
				}
				
				WeaponDistance = 0;
			break;
			#endregion

			#region Default texture
			default:
				if(moving_state != STATES_PLAYER.prone_state){
					HeadHB.image_index = HITBOX.Head;
					BodyHB.image_index = HITBOX.BodyNoWeapon;
					ArmHB.image_index = HITBOX.ArmNoWeapon;
					image_index = TEXTURES.no_weapon;
					if(Flashed == true){
						image_index = TEXTURES.flashed_no_weapon;
						ArmHB.image_index = HITBOX.ArmFlashedNoWeapon;
						HeadHB.image_index = HITBOX.HeadFlashed;
						BodyHB.image_index = HITBOX.BodyFlashedNoWeapon;
					}
			}else{
				HeadHB.image_index = HITBOX.HeadProne;
				BodyHB.image_index = HITBOX.BodyProne;
				if(Flashed == false){
				    anim_base = TEXTURES.prone;
				    ArmHB.image_index = HITBOX.ArmProne;
				}else{
				    anim_base = TEXTURES.flashed_prone;
				    ArmHB.image_index = HITBOX.ArmProneFlashed;
				}
			
				if(anim_base != prev_anim_base){
				    image_index = anim_base;
				    LegHB.image_index = HITBOX.LegProne;
				    prev_anim_base = anim_base;
				}
					
				#region Leg animation mechanics
				if(Moving){
				    moving_timer --;

				    if(moving_timer <= -1){
				        image_index++;
				        LegHB.image_index++;

				        if(image_index >= anim_base + 2){
				            image_index = anim_base;
				            LegHB.image_index = HITBOX.LegProne;
				        }

				        moving_timer = 10;
				    }
				}else{
				    image_index = anim_base;
				    LegHB.image_index = HITBOX.LegProne;
				    moving_timer = -1;
				}
				#endregion
					
			}
				
				WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
			break;
			#endregion
			
		}
	}else{
			
		#region No weapon texture
		if(moving_state != STATES_PLAYER.prone_state){
			HeadHB.image_index = HITBOX.Head;
			BodyHB.image_index = HITBOX.BodyNoWeapon;
			if(Flashed == false){
				if(throwing_grenade()){
					image_index = TEXTURES.grenade_throw;
					BodyHB.image_index = HITBOX.BodyThrowReload;
					ArmHB.image_index = HITBOX.ArmThrowReload;
				}else{
					image_index = TEXTURES.no_weapon;
					ArmHB.image_index = HITBOX.ArmNoWeapon;
				}
			}else{
				image_index = TEXTURES.flashed_no_weapon;
				ArmHB.image_index = HITBOX.ArmFlashedNoWeapon;
				BodyHB.image_index = HITBOX.BodyFlashedNoWeapon;
			}
		}else{
			HeadHB.image_index = HITBOX.HeadProne;
			BodyHB.image_index = HITBOX.BodyProne;
			if(Flashed == false){
			    if(throwing_grenade()){
			        anim_base = TEXTURES.grenade_prone;
			        ArmHB.image_index = HITBOX.ArmProneGrenade;
			    }else{
			        anim_base = TEXTURES.prone;
			        ArmHB.image_index = HITBOX.ArmProne;
			    }
			}else{
			    anim_base = TEXTURES.flashed_prone;
			    ArmHB.image_index = HITBOX.ArmProneFlashed;
			}
			
			if(anim_base != prev_anim_base){
			    image_index = anim_base;
			    LegHB.image_index = HITBOX.LegProne;
			    prev_anim_base = anim_base;
			}
					
			#region Leg animation mechanics
			if(Moving){
			    moving_timer --;

			    if(moving_timer <= -1){
			        image_index++;
			        LegHB.image_index++;

			        if(image_index >= anim_base + 2){
			            image_index = anim_base;
			            LegHB.image_index = HITBOX.LegProne;
			        }

			        moving_timer = 10;
			    }
			}else{
			    image_index = anim_base;
			    LegHB.image_index = HITBOX.LegProne;
			    moving_timer = -1;
			}
			#endregion
					
		}
		#endregion
			
	}
	#endregion
			
	if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false){
	
		if(is_local == true){
			
			#region Timers and variables
			stats.Health_points = clamp(stats.Health_points, -1, global.player_stats_struct.Max_health);
			stats.Damage_health_points = clamp(stats.Damage_health_points, 1, global.player_stats_struct.Max_health);
			stats.Stamina_points = clamp(stats.Stamina_points, 0, global.player_stats_struct.Max_stamina);
			stats.Damage_stamina_points = clamp(stats.Damage_stamina_points, 0, global.player_stats_struct.Max_stamina);
			ShootTimer = max(ShootTimer, -1);
			audio_listener_position(x, y, 0);
			if(HPTimer > 0){HPTimer --;}	
			if(StaminaTimer > 0){StaminaTimer --;}	
			if(HPHealingTimer > -1){HPHealingTimer --;}
			if(StaminaHealingTimer > -1){StaminaHealingTimer --;}
			if(knife_attack_timer > -1){knife_attack_timer --;}
			if (player_can_shoot == false) { RelativeSpeedX = 0;  RelativeSpeedY = 0; XSpeed = 0; YSpeed = 0; Moving = false; Legs.image_speed = 0; }
			if (global.Inventory[# item_use_position, Index.slot_id] != Item.None && Reloading) { Reloading = false; ReloadTime = 0; }
			if (item_equip_timer > -1) item_equip_timer--;
			if (FootStepTimer > -1) FootStepTimer--;
			if (ScopeInaccuracyTimer > -1) ScopeInaccuracyTimer--;
			if (EquippedGrenadeTimer > -1) EquippedGrenadeTimer--;
			if (near_explosion_timer > -1) near_explosion_timer--;
			
			if(FlashedAlpha > 0.075 || near_explosion_timer > -1 || stats.Health_points <= 0){
				muffled_sounds = MUFFLE_VALUE;	
				if(stats.Health_points > 0){
					if!(audio_is_playing(snd_EarRing)){ audio_play_sound(snd_EarRing, 0, false); }
				}
			}else{ muffled_sounds = 1; audio_stop_sound(snd_EarRing); }
	
			if(HPTimer == 0){
				var points = stats.Health_points - attack_damage;
			    if(stats.Damage_health_points > points){
			        stats.Damage_health_points -= max(global.player_stats_struct.Max_health/100, .25);
			    }else{ HPTimer = -1;}
			}
	
			if(StaminaTimer == 0){
				var points = stats.Stamina_points - attack_damage;
			    if(stats.Damage_health_points > points){
			        stats.Damage_health_points -= max(global.player_stats_struct.Max_stamina/100, .25);
			    }else{ StaminaTimer = -1;}
			}
	
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
	
			if(StaminaHealingTimer == -1){
				if(stats.Stamina_points >= 0 && stats.Stamina_points < global.player_stats_struct.Max_stamina){
					var stamina_healing_power = ceil(global.player_stats_struct.Max_stamina/50);
					if(moving_state == STATES_PLAYER.prone_state){
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
	
			if(instance_exists(oBulletTracer)){
				var BulletTracerNearby = instance_nearest(x, y, oBulletTracer);
				if(BulletTracerNearby.stats.Object != noone){
					if(BulletTracerNearby.stats.Object != id && distance_to_object(BulletTracerNearby) <= 64){
						play_sound(BulletTracerNearby.x, BulletTracerNearby.y, choose(snd_BulletTor1, snd_BulletTor2, snd_BulletTor3));	
					}
				}
			}
			#endregion
			
			#region Bot selection and command
			if(keyboard_check_pressed(global.KeyBinds[| KEY.KeySelectBot])){
			    ds_list_clear(bot_select_list);


			    var bot_count = collision_circle_list(
			        x,
			        y,
			        BOT_SELECT_RADIUS,
			        oBot,
			        false,
			        false,
			        bot_select_list,
			        true
			    );

			    // filtr POLICE botů
			    for(var i = bot_count - 1; i >= 0; i--){
			        var bot = bot_select_list[| i];
			        if(!instance_exists(bot) || bot.team != TEAM.POLICE){
			            ds_list_delete(bot_select_list, i);
			        }
			    }
				
				bot_count = ds_list_size(bot_select_list);
				
			    if(bot_count > 0){
			        bot_select_index++;
			        if(bot_select_index >= bot_count){ bot_select_index = 0; }

			        selected_bot = bot_select_list[| bot_select_index];
			    }else{
			        selected_bot = noone;
			        bot_select_index = -1;
			    }
			}
			
			if(!instance_exists(selected_bot)){
			    selected_bot = noone;
			    bot_select_index = -1;
			}
			
			if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyCommandBot])){
			    if(selected_bot != noone){
					command[0] = oCrosshair.x;
					command[1] = oCrosshair.y;
					command[2] = 0.1;
			        with(selected_bot){
						set_state(STATES.MoveCommand);
						target_x = oCrosshair.x;
						target_y = oCrosshair.y;
			        }
			    }
			}
			
			if(command[2] > 0){
				command[2] = min(command[2] + .01, 1);	
			}
			#endregion
	
			#region Hidden flag
			var hidden_in_smoke = false;
			var hidden_in_grass = place_meeting(x, y, oGrass);
			var fog = instance_nearest(x, y, oFog);

			if (fog) {
			    if (fog.radius > 100 && distance_to_object(fog) <= fog.radius && fog.alarm[0] > 1) {
			        hidden_in_smoke = true;
			    }
			}

			hidden = hidden_in_smoke || hidden_in_grass;
			#endregion
	
			#region In water logic
			if (place_meeting(x, y, oWater)) {
			    in_water = true; in_water_timer = game_get_speed(gamespeed_fps);
			} else {
			    in_water_timer--; in_water = (in_water_timer > -1);
			}
			#endregion
	
			#region Drop weapon
			if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyDropWeapon]) && player_can_shoot == true && !global.my_console[? "active"] && !is_inventory_full() && moving_state != STATES_PLAYER.machine_gun_state){
				player_has_scope = -1; ScopeIn = false;	
				gain_item(
					wpn_id, 1, global.Inventory[# WeaponID, Index.slot_ammo], global.Inventory[# WeaponID, Index.slot_clip_ammo], 
					global.Inventory[# WeaponID, Index.slot_durability], global.Inventory[# WeaponID, Index.slot_scope], global.Inventory[# WeaponID, Index.slot_barrel],
					global.Inventory[# WeaponID, Index.slot_grip], global.Inventory[# WeaponID, Index.slot_suppressor], false
				);
				WeaponDrop(WeaponID, id);
			}
			#endregion	
	
			#region Hold stamina
			stamina_inaccuracy = 1;
			if (!global.my_console[? "active"] && wpn_id != Item.None){
				if(keyboard_check(global.KeyBinds[| KEY.KeyHoldStamina]) && stats.Stamina_points > 0){
					statistics_hit("Stamina", STAMINA_HOLD_VALUE, id);
					stamina_inaccuracy = .5;
				}
			}
			#endregion
	
			#region Legs animation
			Legs.image_speed = (global.my_console[$ "active"] || moving_state == STATES_PLAYER.prone_state || moving_state == STATES_PLAYER.machine_gun_state || 
			moving_state == STATES_PLAYER.mortar_state || instance_exists(oInventory) || Moving == false) ? 0 : 1;
			#endregion
	
			#region Buy menu
			if (!global.my_console[? "active"] && !instance_exists(oInventory) && moving_state != STATES_PLAYER.mortar_state && 
			keyboard_check_pressed(global.KeyBinds[| KEY.KeyBuyMenu])) {
			    if (instance_exists(oBuyMenu)) {
			        player_can_shoot = true;
			        with (oBuyMenuDescription) zui_destroy();
			        with (oBuyMenu) zui_destroy();
			    } else {
			        player_can_shoot = false;
			        with (zui_main()) zui_create(zui_get_width()*.5, zui_get_height()*.5, oBuyMenu);
			    }
			}
			#endregion
	
			#region Scope attachments
			switch(global.Inventory[# WeaponID, Index.slot_scope]){
				case Item.two_scope:player_has_scope = 0;break;
				case Item.red_dot_scope:player_has_scope = 1;break;
				default:player_has_scope = -1;break;
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
					if(knife_attack_timer >= global.ItemIndex[# wpn_id, ItemStat.ReloadSpeed] * .5){
						GunCrossShake = global.ItemIndex[#wpn_id, ItemStat.CrosshairShake];
					    ViewAngleAmplitude += global.ItemIndex[#wpn_id, ItemStat.CameraShake];
					    GunViewAngleFrequency = global.ItemIndex[#wpn_id, ItemStat.CameraShake];
					}
					#endregion
		
					#region Low stamina camera shake
					if(stats.Stamina_points <= global.player_stats_struct.Max_stamina * .75){
						LowStaminaViewAngleFrequency = 2 - ((stats.Stamina_points/global.player_stats_struct.Max_stamina));
						ViewAngleAmplitude += 1 - (stats.Stamina_points/global.player_stats_struct.Max_stamina);
					}
					#endregion
		
					#region Gun camera shake
					if (CanShoot == false && ShootTimer >= global.ItemIndex[#wpn_id, ItemStat.ShootTimer]/2) {
						GunCrossShake = global.ItemIndex[#wpn_id, ItemStat.CrosshairShake];
					    ViewAngleAmplitude += global.ItemIndex[#wpn_id, ItemStat.CameraShake];
					    GunViewAngleFrequency = global.ItemIndex[#wpn_id, ItemStat.CameraShake];
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
					var explosion = instance_nearest(x, y, oExplosion);
					var max_dist = 512;
					var d = clamp(distance_to_object(explosion), 0, max_dist);
					var t = 1 - (d / max_dist);
					if(distance_to_object(explosion) <= max_dist && explosion.alarm[1] > explosion.explosion_timer*.75){
						if(near_explosion_timer <= -1){
							var max_time = 4 * game_get_speed(gamespeed_fps);
							var min_time = 0.25 * game_get_speed(gamespeed_fps);

							near_explosion_timer = lerp(min_time, max_time, power(t, 2));
						}
						ExplosionCrossShake = max(10 * (1 - distance_to_object(explosion)/max_dist), 5);
						ViewAngleAmplitude += max(10 * (1 - distance_to_object(explosion)/max_dist), 5);
						ExplosionViewAngleFrequency = 1;
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
				if(CanShoot == false && ShootTimer >= global.ItemIndex[#wpn_id, ItemStat.ShootTimer]/2){
					if(ViewShake == false){
						ViewShakeMagnitude = choose(
													-global.ItemIndex[#wpn_id, ItemStat.CrosshairShake], 
													global.ItemIndex[#wpn_id, ItemStat.CrosshairShake]
											);
						ViewShakeTimer = global.ItemIndex[#wpn_id, ItemStat.ShootTimer];
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
				camera_set_view_angle(CAM, ViewAngle);
				camera_set_view_pos(CAM, camera_get_view_x(CAM) + ViewShakeValuePower, camera_get_view_y(CAM) + ViewShakeValuePower); 
				#endregion
		
				#region Moving camera shake (different approach)
				if (player_can_shoot == true && !global.my_console[? "active"]) {
					rotation_increment = PlayerVelocity/5000;
					max_rotation = PlayerVelocity/750;
					if(moving_state == STATES_PLAYER.none_state || moving_state == STATES_PLAYER.prone_state){
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
			if(Weapon != noone && (wpn_id != Item.None && global.Inventory[# item_use_position, Index.slot_id] == Item.None)){
				var suppressor_len = 1;
				if(global.Inventory[# WeaponID, Index.slot_suppressor] != Item.None){
					suppressor_len = 1.25;
				}
				FlashLightX = Weapon.x + lengthdir_x(WeaponDistance * suppressor_len, RotationAngle); FlashLightY = Weapon.y + lengthdir_y(WeaponDistance * suppressor_len, RotationAngle);
			}else{
				FlashLightX = x; FlashLightY = y;
			}
			if(FlashLight != undefined){
				FlashLight.angle = RotationAngle; FlashLight.x = FlashLightX; FlashLight.y = FlashLightY;
			}
			Weapon.FlashLightX = FlashLightX; Weapon.FlashLightY = FlashLightY;
			cx = Weapon.FlashLightX; cy = Weapon.FlashLightY;
			ax = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) - global.FieldOfView);
			ay = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) - global.FieldOfView);
			bx = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) + global.FieldOfView);
			by = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.x + oCrosshair.x_offset, oCrosshair.y + oCrosshair.y_offset) + global.FieldOfView);	
			#endregion
	
			#region Knife texture
			if (WeaponID != OtherSlot.Knife || global.Inventory[# item_use_position, Index.slot_id] != Item.None) {
				Knife.image_index = 0;
			} else {
				Knife.image_index = (global.ItemIndex[# wpn_id, ItemStat.Name] == "Steel knife") ? 1 : 0;
			}
			#endregion
	
			#region Shooting mode
			var Shoot = -1; var shooting_mode = ds_list_find_value(global.ItemIndex[#wpn_id, ItemStat.ShootingMode], weapon_shooting_mode);
	
			if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyChangeMode]) && shooting == false){
				var list_size = ds_list_size(global.ItemIndex[#wpn_id, ItemStat.ShootingMode]);
				if(weapon_shooting_mode < list_size){ weapon_shooting_mode = (weapon_shooting_mode + 1) % list_size; }
			}
	
			if(shooting_reset_timer > -1){ shooting_reset_timer --; }
	
			if(shooting_mode == "Auto"){	
				if(KickBack > 1){ 
					KickBackTime = round(.08 * game_get_speed(gamespeed_fps) * global.ItemIndex[#wpn_id, ItemStat.KBResetMultiplier]);
				}else{
					KickBackTime = round(.5 * game_get_speed(gamespeed_fps) * global.ItemIndex[#wpn_id, ItemStat.KBResetMultiplier]);
				}
				Shoot = input_check(global.KeyBinds[| KEY.KeyShootMouse]);
				if(input_check(global.KeyBinds[| KEY.KeyShootMouse], false, true) || (global.Inventory[# WeaponID, Index.slot_ammo] <= 0 && shooting == true)){
					kick_back_timer = KickBackTime; shooting = false; crosshair_position[0] = oCrosshair.x; crosshair_position[1] = oCrosshair.y;
				}
			}else if(shooting_mode == "Semi" || shooting_mode == "Burst"){
				KickBackTime = round(.25 * game_get_speed(gamespeed_fps) * global.ItemIndex[#wpn_id, ItemStat.KBResetMultiplier]);
				Shoot = input_check(global.KeyBinds[| KEY.KeyShootMouse], true);
				/* Jelikož se při auto modu vždycky resetne "shooting" na false po tom co hráč releasne tlačítko na střílení, musel jsem přidat "shooting_reset_timer" */
				if(input_check(global.KeyBinds[| KEY.KeyShootMouse], false, false) && shooting_reset_timer == -1){
					shooting_reset_timer = KickBackTime;
				}
				if((input_check(global.KeyBinds[| KEY.KeyShootMouse], false, true) && global.Inventory[# WeaponID, Index.slot_ammo] > 0) || (global.Inventory[# WeaponID, Index.slot_ammo] <= 0 && shooting == true && shooting_reset_timer == -1)){
					shooting_reset_timer = KickBackTime; kick_back_timer = KickBackTime; crosshair_position[0] = oCrosshair.x; crosshair_position[1] = oCrosshair.y;
				}
				
				if(shooting_reset_timer == 0){ shooting = false; }
			}
	
			#endregion	
	
			#region Burst fire
			var adaptive = 
			has_attachment(Item.adaptive_chambering, Index.slot_barrel) 
			? global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_barrel], ItemStat.ShootTimer] : 1;								
			if(burst_fire_timer > -1){ burst_fire_timer --; }
			if (burst_fire == true) {
				if (burst_fire_timer <= 0) {
					if (burst_shots_fired < burst_shot_limit) {		
						ShootTimer = global.ItemIndex[# wpn_id, ItemStat.ShootTimer] * adaptive;
						player_shooting();		
						Weapon.KickBackEffect = global.ItemIndex[#wpn_id, ItemStat.KickBackPower];
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
			if!(global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] == -1){
				if(wpn_id != Item.None && global.Inventory[# item_use_position, Index.slot_id] == Item.None && moving_state != STATES_PLAYER.mortar_state && item_equip_timer == -1){
					if (player_can_shoot == true && !global.my_console[? "active"]) {
						if(input_check(global.KeyBinds[| KEY.KeyShootMouse], true, false) && global.Inventory[# WeaponID, Index.slot_ammo] <= 0){
							play_sound(x, y, snd_empty_magazine);
						}
					    if(Shoot == 1 && (Reloading == false || (Reloading == true && global.ItemIndex[# wpn_id, ItemStat.Defense] == 1))){
				
							if(global.Inventory[# WeaponID, Index.slot_ammo] > 0){
								shooting = true;
				
								#region Fractionating reloading stop
								if(global.ItemIndex[#wpn_id, ItemStat.Defense] == 1){
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
								            burst_fire_timer = max(global.ItemIndex[#wpn_id, ItemStat.ShootTimer]/2, 5);
								        }
										#endregion
						
									}else{
						
										#region Normal fire
										ShootTimer = global.ItemIndex[#wpn_id, ItemStat.ShootTimer] * adaptive;					
										player_shooting();
										Weapon.KickBackEffect = global.ItemIndex[#wpn_id, ItemStat.KickBackPower];
										KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);
										KickBack ++;
										global.Inventory[# WeaponID, Index.slot_ammo] --;
										CanShoot = false;
										#endregion
						
									}
					
									#region Scope in logic
									if(global.ItemIndex[#wpn_id, ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE &&
									global.ItemIndex[#wpn_id, ItemStat.Defense] == 1){
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
					KickBack = max(0, KickBack - (global.ItemIndex[#wpn_id, ItemStat.KBStabilization] + 1));
					KickBackAngle = 0;
				}
			}

			if(ShootTimer > -1){ShootTimer --;}
			if(ShootTimer <= 0){CanShoot = true;}
			if(kick_back_timer > -1){kick_back_timer --;}

			#endregion

			#region Movement
			if(player_can_shoot == true && !global.my_console[? "active"] && moving_state < STATES_PLAYER.machine_gun_state){
				var Up = keyboard_check(global.KeyBinds[| KEY.KeyUp]);
				var Right = keyboard_check(global.KeyBinds[| KEY.KeyRight]);
				var Left = keyboard_check(global.KeyBinds[| KEY.KeyLeft]);
				var Down = keyboard_check(global.KeyBinds[| KEY.KeyDown]);
				MoveDirection = point_direction(Left, Up, Right, Down);
				var Delta = delta_time / 1000000;
				var xpos = Right - Left;
				var ypos = Down - Up;
				var move_xpos = abs(xpos);
				var move_ypos = abs(ypos);
	
				#region Move speed multiplier
				var ShootingSpeedMultiplier = 1;
				var ReloadingSpeedMultiplier = 1;
				var moving_speed_multiplier = 1;
				var WeightSpeedMultiplier = 1 / (global.player_stats_struct.Weight/50 + 1);
				var WeaponSpeedMultiplier = 1;
				
				if(AimPunchTimer == -1){ aimpunch_speed_multiplier = 1; }
				if(CanShoot == false && ShootTimer >= global.ItemIndex[#wpn_id, ItemStat.ShootTimer]/2){ ShootingSpeedMultiplier = global.ItemIndex[#wpn_id, ItemStat.ShootSpdMul]; }
				if(Reloading == true){ ReloadingSpeedMultiplier = global.ItemIndex[#wpn_id, ItemStat.ReloadSpdMul]; }
				if(moving_state == STATES_PLAYER.prone_state){ moving_speed_multiplier = .135; }
	
				if(global.ItemIndex[#wpn_id, ItemStat.MovingSpdMul] != 0 && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
					WeaponSpeedMultiplier = global.ItemIndex[#wpn_id, ItemStat.MovingSpdMul];
				}
	
				SpeedMul = ReloadingSpeedMultiplier * ShootingSpeedMultiplier * aimpunch_speed_multiplier * moving_speed_multiplier * WeightSpeedMultiplier *
						   WeaponSpeedMultiplier / (ScopeIn + 1) * (game_get_speed(gamespeed_fps)/60) / (Healing + 1);

				#endregion

				if(Left || Right || Down || Up){
				    Moving = true;
				} else {
					if(MovingStabilizationTimer == -1){
						MovingStabilizationTimer = MovingStabilizationTime;
					}
				}

				if(MovingStabilizationTimer > -1){ MovingStabilizationTimer --; }

				if(MovingStabilizationTimer == 0){ Moving = false; }

				if!(Left || Right){ RelativeSpeedX = max(0, RelativeSpeedX - (RelativeSpeedValue * 2)); }

				if!(Up || Down){ RelativeSpeedY = max(0, RelativeSpeedY - (RelativeSpeedValue * 2)); }

				if(Moving == true){
					if(moving_state != STATES_PLAYER.prone_state){
						if(FootStepTimer == -1){
							FootStepTimer = 5; FootSteps ++;
						}
						if(FootStepTimer == 0 && Visible == true){
							particle_create(1, 0, RotationAngle, spr_FootSteps, 0, 0, RotationAngle, 0, false, false, FootSteps % 2, x, y, .5, 1.5 * game_get_speed(gamespeed_fps));
						}
					}
				    if(move_xpos){
						XSpeed = RelativeSpeedX * dcos(MoveDirection) * Delta * SpeedMul;
				        if (place_meeting(x + XSpeed, y, oParentTile)){
				            while (!place_meeting(x + sign(XSpeed),y,oParentTile))
								x += sign(XSpeed); XSpeed = 0;
						}else{
							if(RelativeSpeedX < MOVE_SPD){ RelativeSpeedX += RelativeSpeedValue; }
							x += min(XSpeed, MOVE_SPD);
						}
						if(moving_state != STATES_PLAYER.prone_state && Visible == true){
							particle_create(round(abs(XSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(XSpeed) * -1, abs(XSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
						}
				
				    }
				    if(move_ypos){
						YSpeed =  RelativeSpeedY * -dsin(MoveDirection) * Delta * SpeedMul;
				        if(place_meeting(x, y + YSpeed, oParentTile)){
				            while (!place_meeting(x,y + sign(YSpeed),oParentTile))
								y += sign(YSpeed); YSpeed = 0;
						}else{
							if(RelativeSpeedY < MOVE_SPD){ RelativeSpeedY += RelativeSpeedValue; }
							y += min(YSpeed, MOVE_SPD);
						}
						if(moving_state != STATES_PLAYER.prone_state && Visible == true){
							particle_create(round(abs(YSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(YSpeed) * -1, abs(YSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
						}
					}
				}else{
					FootSteps = 0; FootStepTimer = -1;
		
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

				x = clamp(x,0,room_width);
				y = clamp(y,0,room_height);
			}

			#endregion
			
			#region Door logic
			if(door_cooldown > 0){ door_cooldown--; }
			var door = collision_line(xprevious, yprevious, x, y, oRoofTrigger, false, true);

			if(door != noone && door_cooldown <= 0){
				var w = door.bbox_right - door.bbox_left;
				var h = door.bbox_bottom - door.bbox_top;
				var crossed = false;
				var cen_x = (door.bbox_left + door.bbox_right) * 0.5; ///středova osa horizontalni
				var cen_y = (door.bbox_top  + door.bbox_bottom) * 0.5; /// středova osa vertikalni

				if(w > h){
					// horizontální dveře → průchod NAHORU / DOLŮ
					var prev = sign(yprevious - cen_y);
					var curr = sign(y - cen_y);
					//když se prev a curr liší, prošel hráč skrze středovou osu
					if(prev != 0 && curr != 0){
						crossed = (prev * curr < 0);
					}
				}else{
					// vertikální dveře → průchod DOLEVA / DOPRAVA
					var prev = sign(xprevious - cen_x);
					var curr = sign(x - cen_x);
					//když se prev a curr liší, prošel hráč skrze středovou osu
					if(prev != 0 && curr != 0){
						crossed = (prev * curr < 0);
					}
				}

				if(crossed){
					if(current_building_id == door.building_id){
						current_building_id = -1; // výstup
					}else{
						current_building_id = door.building_id; // vstup
					}
					door_cooldown = 10;
				}
			}

			#endregion
	
			#region Knife
	
			if(Knife.image_index != 0){
		
				if(player_can_shoot == true){
			
				#region Light attack
				if(input_check(global.KeyBinds[| KEY.KeyKnifeLight], true, false) && stats.Stamina_points >= STAMINA_KNIFE_LIGHT){
					if(knife_attack_timer == -1){
						knife_attack_timer = global.ItemIndex[# wpn_id, ItemStat.ReloadSpeed];
						Knife.stats.Reward = global.ItemIndex[# wpn_id, ItemStat.reward];
						Knife.stats.Hit_timer = knife_attack_timer*2;
						Knife.stats.Damage = global.ItemIndex[# wpn_id, ItemStat.Damage];	
						Knife.stats.Item_id = wpn_id;
						statistics_hit("Stamina", STAMINA_KNIFE_LIGHT * global.ItemIndex[# wpn_id, ItemStat.ClipAmmo], id);
					}
				}
				#endregion
		
				#region Heavy attack
				if(input_check(global.KeyBinds[| KEY.KeyKnifeHeavy], true, false) && stats.Stamina_points >= STAMINA_KNIFE_HEAVY){
					if(knife_attack_timer == -1){
						knife_attack_timer = global.ItemIndex[# wpn_id, ItemStat.ReloadSpeed];
						Knife.stats.Reward = global.ItemIndex[# wpn_id, ItemStat.reward];
						Knife.stats.Hit_timer = knife_attack_timer*2;
						Knife.stats.Damage = global.ItemIndex[# wpn_id, ItemStat.Damage]*2;	
						Knife.stats.Item_id = wpn_id;
						statistics_hit("Stamina", STAMINA_KNIFE_HEAVY * global.ItemIndex[# wpn_id, ItemStat.ClipAmmo], id);
					}
				}
				#endregion
		
				}
		
			}
		
			#endregion
	
			#region Object push player
			var objects = [oBot, oBird];
			
			if(player_can_shoot == true){
				for(var i = 0;i < array_length(objects); i ++){
					if(place_meeting(x, y, objects[i]) && moving_state != STATES_PLAYER.machine_gun_state) {
					    var obj = instance_nearest(x, y, objects[i]);
						var dir = point_direction(obj.x, obj.y, x, y);
					
						if(obj.object_index != oBird){
							AccelX = 5 * cos(degtorad(dir));
							AccelY = -5 * sin(degtorad(dir));
						}else if(obj.state == 0){
							AccelX = 1 * cos(degtorad(dir));
							AccelY = -1 * sin(degtorad(dir));
						}
					}
				}
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
	
				if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyProne]) && Moving == false){
					if(moving_state == STATES_PLAYER.none_state){
						moving_state = STATES_PLAYER.prone_state;
					}else if(moving_state == STATES_PLAYER.prone_state){
						moving_state = STATES_PLAYER.none_state;
					}
				}
		
				if(instance_exists(oMortar) && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments)){
					var mortar = instance_nearest(x, y, oMortar);		
					if(distance_to_object(mortar) <= PickUpDistance){
						if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyPickUp])){
							if(moving_state == STATES_PLAYER.none_state){ /// Pokud neběži ani se neplazí
								player_can_shoot = false;
								with(zui_main()){
									with(zui_create(zui_get_width() * .75, zui_get_height() * .75, oMortarMenu)){
									}
								}
								moving_state = STATES_PLAYER.mortar_state;
							}else if(moving_state == STATES_PLAYER.mortar_state){
								player_can_shoot = true;
								with(oMortarMenu){
									zui_destroy();
								}
								moving_state = STATES_PLAYER.none_state;
							}
						}
					}
				}
	
				if(instance_exists(oMachineGun)){
					var machine_gun = instance_nearest(x, y, oMachineGun);		
					if(distance_to_object(machine_gun) <= PickUpDistance){
						if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyPickUp])){
							if(moving_state == STATES_PLAYER.none_state && global.Inventory[# OtherSlot.Primary, Index.slot_id] == Item.None){ /// Pokud neběži ani se neplazí
						
								#region Equip machine gun
								global.Inventory[# OtherSlot.Primary, Index.slot_id] = machine_gun.stats.Id;
								global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_scope] = machine_gun.stats.Slot_scope;
								global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_barrel] = machine_gun.stats.Slot_barrel;
								global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_grip] = machine_gun.stats.Slot_grip;
								global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_suppressor] = machine_gun.stats.Slot_suppressor;
								global.Inventory[# OtherSlot.Primary, Index.slot_ammo] = machine_gun.stats.Ammo;
								global.Inventory[# OtherSlot.Primary, Index.slot_clip_ammo] = machine_gun.stats.Clip_ammo;
								global.ItemIndex[# global.Inventory[# OtherSlot.Primary, Index.slot_id], ItemStat.MaxAmmo] = global.ItemIndex[#machine_gun.stats.Id, ItemStat.MaxAmmo];
								#endregion
						
								Moving = false;
								var m_pos = local_to_world(0, 96, machine_gun.image_angle, machine_gun);
								x = m_pos[0];
								y = m_pos[1];
								machine_gun.stats.Object = id;
								moving_state = STATES_PLAYER.machine_gun_state;	
							}else if(moving_state == STATES_PLAYER.machine_gun_state){
								ReloadTime = 0;
								moving_state = STATES_PLAYER.none_state;
								Reloading = false;
						
								#region Dequip machine gun
								global.Inventory[# OtherSlot.Primary, Index.slot_id] = Item.None;
								machine_gun.stats.Slot_scope = global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_scope];
								machine_gun.stats.Slot_barrel = global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_barrel];
								machine_gun.stats.Slot_grip = global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_grip];
								machine_gun.stats.Slot_suppressor = global.weapon_attachments[0][WPN_ATTACHMENTS.weapon_suppressor];
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
			if(moving_state == STATES_PLAYER.prone_state){
				LegHB.visible = true;
				RotationSpeed = 4.5;
				WX = 64;
				WY = 64;
				Legs.visible = false;	
			}else{
				LegHB.visible = false;
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
					RotationAngle = (RotationAngle % 360 + 360) % 360;
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
	
			if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyToggleNightVision]) && !global.my_console[? "active"]){
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
				FlashedAlpha = lerp(FlashedAlpha, 0, FLASH_LERP);	
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
				damage_indicator("+" + string(global.ItemIndex[#HealingItemId, ItemStat.Damage]), x, y - 30, c_green, spr_Icons, ICON.health);
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
				global.player_stats_struct.Xp = 0;
				global.player_stats_struct.Lvl ++;
				global.player_stats_struct.Max_stamina *= power(STATS_LVL_UP, ln(global.player_stats_struct.Lvl));
				global.player_stats_struct.Max_health *= power(STATS_LVL_UP, ln(global.player_stats_struct.Lvl));
				global.player_stats_struct.Max_xp *= XP_LVL_UP_MUL;
			}
			#endregion

			if(!global.my_console[? "active"] && !instance_exists(oBuyMenu) && moving_state != STATES_PLAYER.mortar_state){
		
				#region Inventory
				if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyInventory])){
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
				    var Items = instance_nearest(x, y, oItems);
				    if(distance_to_object(Items) <= PickUpDistance){   
				        if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyPickUp])){
				            with(Items){
				                gain_item(image_index, Amount, Ammo, ClipAmmo, Durability, scope_attachment, barrel_attachment, grip_attachment, suppressor_attachment);
								destroy_pickup_instance(id);
				            }
				        }
				    }
				}
				#endregion
				
				#region Item cycling
				if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyCycleRight])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					item_use_position ++;
					if(item_use_position > HOTBAR_SIZE - 1){
						item_use_position = 0;
					}
					item_use_position = max(item_use_position, 0);
				}			
				if(keyboard_check_pressed(global.KeyBinds[| KEY.KeyCycleLeft])){
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
					}
					if(item_use_position == 0){ 
						item_use_position = HOTBAR_SIZE - 1;
					}else{
						item_use_position --;
					}
					item_use_position = min(item_use_position, HOTBAR_SIZE - 1);
				}
				#endregion

				#region Item use
				if(input_check(global.KeyBinds[| KEY.KeyUseItem], true, false) && !instance_exists(oInventory) && moving_state != STATES_PLAYER.machine_gun_state
				 && !instance_exists(oWeaponAttachments) ){
					var Id = global.Inventory[# item_use_position, Index.slot_id];
			
					if(global.ItemIndex[#Id, ItemStat.Type] == "Grenade") {
				
						#region Grenade use
						if(EquippedGrenadeTimer == -1){
							create_grenade(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
							global.ItemIndex[#Id, ItemStat.BulletCasingID], global.ItemIndex[#Id, ItemStat.ReloadSpeed], oCrosshair.x, oCrosshair.y, Id);						
							ItemAmountSubstract(item_use_position, 1);
							EquippedGrenadeTimer = EquippedGrenadeTime;
							grenade_angle = random(360);
						}
						#endregion
				
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Landmine"){
				
						#region Landmine use
						landmine_create(x, y, Id);
						ItemAmountSubstract(item_use_position, 1);
						#endregion
				
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item"){
				
						#region Item use
						switch(Id){
							case Item.HealingKit:
								if(Healing == false && stats.Health_points < global.player_stats_struct.Max_health){
									item_equip_timer = item_equip_time;
									HealingItemId = Item.HealingKit;
									Healing = true;
									ItemAmountSubstract(item_use_position, 1);
								}
							break;	
							
							case Item.low_cal_box:
								if(global.ItemIndex[# wpn_id, ItemStat.caliber_type] == CALIBER.LOW){
									global.Inventory[# WeaponID, Index.slot_clip_ammo] += global.ItemIndex[# Id, ItemStat.MaxAmmo];	
									damage_indicator("+" + string(global.ItemIndex[# Id, ItemStat.MaxAmmo]), x, y, c_white, spr_Icons, ICON.ammo);
									ItemAmountSubstract(item_use_position, 1);
								}
							break;
							
							case Item.med_cal_box:
								if(global.ItemIndex[# wpn_id, ItemStat.caliber_type] == CALIBER.MEDIUM){
									global.Inventory[# WeaponID, Index.slot_clip_ammo] += global.ItemIndex[# Id, ItemStat.MaxAmmo];	
									damage_indicator("+" + string(global.ItemIndex[# Id, ItemStat.MaxAmmo]), x, y, c_white, spr_Icons, ICON.ammo);
									ItemAmountSubstract(item_use_position, 1);
								}
							break;
							
							case Item.high_cal_box:
								if(global.ItemIndex[# wpn_id, ItemStat.caliber_type] == CALIBER.HIGH){
									global.Inventory[# WeaponID, Index.slot_clip_ammo] += global.ItemIndex[# Id, ItemStat.MaxAmmo];	
									damage_indicator("+" + string(global.ItemIndex[# Id, ItemStat.MaxAmmo]), x, y, c_white, spr_Icons, ICON.ammo);
									ItemAmountSubstract(item_use_position, 1);
								}
							break;
							
							case Item.gauge_box:
								if(global.ItemIndex[# wpn_id, ItemStat.caliber_type] == CALIBER.GAUGES){
									global.Inventory[# WeaponID, Index.slot_clip_ammo] += global.ItemIndex[# Id, ItemStat.MaxAmmo];	
									damage_indicator("+" + string(global.ItemIndex[# Id, ItemStat.MaxAmmo]), x, y, c_white, spr_Icons, ICON.ammo);
									ItemAmountSubstract(item_use_position, 1);
								}
							break;
					
							case Item.red_dot_scope: weapon_attachment_equip(Id, Index.slot_scope); break;
							case Item.two_scope: weapon_attachment_equip(Id, Index.slot_scope); break;
							case Item.adaptive_chambering: weapon_attachment_equip(Id, Index.slot_barrel); break;	
							case Item.vertical_grip: weapon_attachment_equip(Id, Index.slot_grip); break;
							case Item.horizontal_grip: weapon_attachment_equip(Id, Index.slot_grip); break;
							case Item.advanced_suppressor: weapon_attachment_equip(Id, Index.slot_suppressor); break;	
							case Item.range_finder: weapon_attachment_equip(Id, Index.slot_barrel); break;
						}
						#endregion
				
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
								
						#region Primary equip and dequip
						var primary_slot_id = global.Inventory[# OtherSlot.Primary, Index.slot_id];
						if (primary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Primary")) {
							item_equip_timer = item_equip_time;
							item_swap("item_use_position", OtherSlot.Primary);
							primary_slot_id = Item.None;
							with(id){ weapon_network_propagate(); }
						} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Primary") {
							item_equip_timer = item_equip_time;
							item_swap("item_use_position", OtherSlot.Primary);
							with(id){ weapon_network_propagate(); }
						}
						#endregion
				
						#region Secondary equip and dequip
						var secondary_slot_id = global.Inventory[# OtherSlot.Secondary, Index.slot_id];
						if (secondary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Secondary")) {
							item_equip_timer = item_equip_time;
							item_swap("item_use_position", OtherSlot.Secondary);
							secondary_slot_id = Item.None;
							with(id){ weapon_network_propagate(); }
						} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Secondary") {
							item_equip_timer = item_equip_time;
							item_swap("item_use_position", OtherSlot.Secondary);
							with(id){ weapon_network_propagate(); }
						}
						#endregion
				
						#region Knife equip and dequip
						var tertiary_slot_id = global.Inventory[# OtherSlot.Knife, Index.slot_id];
						if (tertiary_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.WeaponType] == "Tertiary")) {
							item_equip_timer = item_equip_time;
							item_swap("item_use_position", OtherSlot.Knife);
							tertiary_slot_id = Item.None;
							with(id){ weapon_network_propagate(); }
						} else if (global.ItemIndex[# Id, ItemStat.WeaponType] == "Tertiary") {
							item_equip_timer = item_equip_time;
							item_swap("item_use_position", OtherSlot.Knife);
							with(id){ weapon_network_propagate(); }
						}
						#endregion
						
				
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Armour"){
				
						#region Armour equip and dequip
						var armour_slot_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
						if (armour_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Armour")) {
							item_equip_timer = item_equip_time;
							ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], armour_slot_id);
							item_swap("item_use_position", OtherSlot.Armour);
							armour_slot_id = Item.None;
							with(id){ equip_network_propagate(); }
						} else if (global.ItemIndex[# Id, ItemStat.Type] == "Armour") {
							item_equip_timer = item_equip_time;
							ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], armour_slot_id);
							item_swap("item_use_position", OtherSlot.Armour);
							with(id){ equip_network_propagate(); }
						}
						#endregion
				
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){
				
						#region Helmet equip and dequip
						var helmet_slot_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
						if (helmet_slot_id != Item.None && (Id == Item.None || global.ItemIndex[# Id, ItemStat.Type] == "Helmet")) {
							item_equip_timer = item_equip_time;
							ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], helmet_slot_id);
							item_swap("item_use_position", OtherSlot.Helmet);
							helmet_slot_id = Item.None;
							with(id){ equip_network_propagate(); }
						} else if (global.ItemIndex[# Id, ItemStat.Type] == "Helmet") {
							item_equip_timer = item_equip_time;
							ItemAddWeight(global.Inventory[# item_use_position, Index.slot_id], helmet_slot_id);
							item_swap("item_use_position", OtherSlot.Helmet);
							with(id){ equip_network_propagate(); }
						}
						#endregion
				
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Shield"){
				
						#region Shield use
						item_equip_timer = item_equip_time;
						#endregion
				
					}
				}
		
				#endregion
		
				#region Scope
				var ScopeButton = input_check(global.KeyBinds[| KEY.KeyScope], false, false);
				if!(instance_exists(oInventory)){
					if(global.Inventory[# WeaponID, Index.slot_scope] != Item.None && CanShoot == true && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
						if(ScopeButton){
							if(ScopeIn == false){
					
								if(global.Inventory[# WeaponID, Index.slot_scope] == Item.two_scope){
									ScopeInaccuracyTimer = global.ItemIndex[#wpn_id, ItemStat.ScopeInaccuracyResetTimer];
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
			if(equip_timer > -1){equip_time ++; equip_timer --;}
			if(equip_timer == 0){ switch_weapon_number();	}
	
			// Handle weapon switching logic
			if (equip_timer == -1 && player_can_shoot == true && shooting == false) {
			    var changeDetected = false;

			    if (mouse_wheel_down()) {
			        WeaponNumber = (WeaponNumber < WeaponNumberMax) ? WeaponNumber + 1 : 0;
			        changeDetected = true;
			    } else if (mouse_wheel_up()) {
			        WeaponNumber = (WeaponNumber != 0) ? WeaponNumber - 1 : WeaponNumberMax;
			        changeDetected = true;
			    }

			    // If there was a change in the weapon number
			    if (changeDetected) {
					var equipTime = global.ItemIndex[# global.Inventory[# WeaponNumber + OtherSlot.Primary, Index.slot_id], ItemStat.EquipTime];
			        if (equipTime > 0) {
						equip_time = 0;
						equip_timer = equipTime;
						equip_time_max = equip_timer;
			        } else {
			            switch_weapon_number();
			        }
			    }
			}

			#endregion

			#region Range 
			if(instance_exists(oCrosshair)){
				Range = point_distance(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), oCrosshair.x, oCrosshair.y);
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
				if(global.ItemIndex[#wpn_id, ItemStat.Defense] != 1){
			
					#region Normal reloading
					if(wpn_id != Item.Javelin){
						particle_create(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
						random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#wpn_id, ItemStat.AmmoSpriteID], x, y);		
					}
					Reloading = false;
					ReloadTime = 0;
					if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0) {
					    if (global.Inventory[# WeaponID, Index.slot_clip_ammo] >AmmoNeeded) {
							global.Inventory[# WeaponID, Index.slot_clip_ammo] -=AmmoNeeded;
							global.Inventory[# WeaponID, Index.slot_ammo] +=AmmoNeeded;
					    } else if (global.Inventory[# WeaponID, Index.slot_clip_ammo] <AmmoNeeded) {
							global.Inventory[# WeaponID, Index.slot_ammo] += global.Inventory[# WeaponID, Index.slot_clip_ammo];
							global.Inventory[# WeaponID, Index.slot_clip_ammo] -= global.Inventory[# WeaponID, Index.slot_clip_ammo];
					    } else if (global.Inventory[# WeaponID, Index.slot_ammo] + global.Inventory[# WeaponID, Index.slot_clip_ammo] = global.ItemIndex[# wpn_id, ItemStat.MaxAmmo]) {
							global.Inventory[# WeaponID, Index.slot_ammo] = global.ItemIndex[# wpn_id, ItemStat.MaxAmmo];
							global.Inventory[# WeaponID, Index.slot_clip_ammo] = 0;
					    }
					}
					#endregion
			
				}else{
			
					#region Fractionating reloading
					Reloading = false;
					ReloadTime = 0;
					if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0) {
						global.Inventory[# WeaponID, Index.slot_clip_ammo] -= 1;
						global.Inventory[# WeaponID, Index.slot_ammo] += 1;
					}
					if(global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# wpn_id, ItemStat.MaxAmmo]){
						Reloading = true;
						ReloadTimer = global.ItemIndex[#wpn_id, ItemStat.ReloadSpeed];
					}
					#endregion
			
				}
			}
	
			if (global.Inventory[# WeaponID, Index.slot_id] != -1) {
			  if (global.Inventory[# WeaponID, Index.slot_ammo] > global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo]) {
			    global.Inventory[# WeaponID, Index.slot_ammo] = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo];
			  }
			 AmmoNeeded = global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] - global.Inventory[# WeaponID, Index.slot_ammo];

			  if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0 && Reloading = false && keyboard_check_pressed(global.KeyBinds[| KEY.KeyReload]) && shooting == false && !global.my_console[? "active"] && global.Inventory[# item_use_position, Index.slot_id] == Item.None && FlashedAlpha <= 0){
			    Reloading = true;
			    ReloadTimer = global.ItemIndex[#wpn_id, ItemStat.ReloadSpeed];
			  }
			}

			if(Reloading == true){
			    ReloadTime ++;
			}
			#endregion
	
			#region Deactivate out of view
			var deactivateLeft = camera_get_view_x(CAM) - DEACTIVATE_MARGIN;
			var deactivateTop = camera_get_view_y(CAM) - DEACTIVATE_MARGIN;
			var deactivateRight = deactivateLeft + camera_get_view_width(CAM) + 2 * DEACTIVATE_MARGIN;
			var deactivateBottom = deactivateTop + camera_get_view_height(CAM) + 2 * DEACTIVATE_MARGIN;

			with (oBot) {
			    if (x < deactivateLeft || x > deactivateRight || y < deactivateTop || y > deactivateBottom) {
			        Visible = false;
					FlashLight.visible = false;
			    }
			}

			instance_deactivate_region(deactivateLeft, deactivateTop, deactivateRight - deactivateLeft, deactivateBottom - deactivateTop, false, true);
	

			// Activate instances within view ACTIVATE_MARGIN
			instance_activate_region(
				camera_get_view_x(CAM) - ACTIVATE_MARGIN,
				camera_get_view_y(CAM) - ACTIVATE_MARGIN,
				camera_get_view_width(CAM) + 2 * ACTIVATE_MARGIN,
				camera_get_view_height(CAM) + 2 * ACTIVATE_MARGIN,
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
			instance_activate_object(oAirPlane);
			instance_activate_object(oMissile);
			instance_activate_object(oBloodSplash);
			#endregion
		
		}
	
	}
}

#region Death
var should_handle_death = false;
if (!IS_NET) {
    if (stats.Health_points <= 0 && oDraw.RespawnMenu == false) {
        should_handle_death = true;
    }
} else {
    if (death_from_server) {
        should_handle_death = true;
        death_from_server = false;
    }
}


if (should_handle_death) {
    oDraw.KilledByWeapon = KilledByWeapon;
    oDraw.KilledByName = KilledByName;
    Weapon.image_index = 0;
    image_index = 3;
	ScopeIn = false;
	depth += 1;
	if(is_local || !IS_NET){
	    round_end("Loss");
	    camera_set_view_angle(CAM, 0);
	}

    play_sound(x, y, choose(snd_Death1, snd_Death2));
}
#endregion
