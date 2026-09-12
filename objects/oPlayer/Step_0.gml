event_inherited();

if (is_local && dilatation_timer > -1) {
	dilatation_timer -= 1;
	if (dilatation_timer <= 0) {
		dilatation_timer = -1;
		global.time_step = 1;
	}
}

var reload_time_scale = (global.time_step == 1) ? 1 : 0.5;
var reload_frame_step = max(0, delta_time * game_get_speed(gamespeed_fps) / 1000000) * reload_time_scale;

var current_character_seed = (IS_NET && network_id >= 0) ? network_id : global.player_character_seed;
if (character_sprite_team != stats.Team || character_sprite_seed != current_character_seed) {
	character_sprite_team = stats.Team;
	character_sprite_seed = current_character_seed;
	sprite_index = get_player_team_sprite(character_sprite_team, character_sprite_seed);
}

if(is_local){
	#region Running and walking input
	var can_change_move_speed = !global.my_console[? "active"]
		&& moving_state == STATES_PLAYER.none_state
		&& !shield_equip;
	var movement_key_down = keyboard_check(global.KeyBinds[| KEY.Up])
		|| keyboard_check(global.KeyBinds[| KEY.Left])
		|| keyboard_check(global.KeyBinds[| KEY.Down])
		|| keyboard_check(global.KeyBinds[| KEY.Right]);
	var run_key = real(global.KeyBinds[| KEY.Run]);
	var run_key_down = run_key == vk_lcontrol
		? keyboard_check_direct(vk_lcontrol)
		: keyboard_check(run_key);
	walking = can_change_move_speed && movement_key_down && keyboard_check(global.KeyBinds[| KEY.Walk]);
	running = can_change_move_speed && movement_key_down && !walking && stats.Stamina_points > 0 && run_key_down;
	#endregion

	if(keyboard_check(global.KeyBinds[| KEY.Scoreboard])){
		statistics_table_open();
	}else{
		statistics_table_close();
	}

	var bot_info_allowed = real(global.KeyBinds[| KEY.BotInfo]) != real(global.KeyBinds[| KEY.Walk])
		|| !movement_key_down;
	if(bot_info_allowed && keyboard_check_pressed(global.KeyBinds[| KEY.BotInfo]) && instance_exists(oCrosshair)){
		if(instance_exists(oBotTab)){
			with(oBotTab) zui_destroy();
		}else if(!global.my_console[? "active"] && instance_exists(oDraw) && !oDraw.PauseMenu && !oDraw.RespawnMenu && !oDraw.GameEndMenu){
			var info_bot = collision_point(oCrosshair.x, oCrosshair.y, oBot, true, true);
			if(instance_exists(info_bot) && info_bot.Visible && (info_bot.stats.Team == stats.Team || global.sudo)){
				var bot_tab_x = (oCrosshair.x + oCrosshair.x_offset - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
				var bot_tab_y = (oCrosshair.y + oCrosshair.y_offset - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
				with(zui_main()){
					var bot_tab = zui_create(bot_tab_x, bot_tab_y, oBotTab, -2000);
					bot_tab.target_bot = info_bot;
				}
			}
		}
	}
}

wpn_id = global.Inventory[# WeaponID, Index.slot_id];

#region Remote player
/* Player Object - Step Event */

if (is_remote) {
	wpn_id = network_weapon_id;
	moving_state = network_moving_state;
	if (network_item_action_timer > -1) {
		network_item_action_timer -= global.time_step;
		if (network_item_action_timer <= 0) {
			network_item_action_timer = -1;
			network_item_use_id = network_item_use_restore_id;
		}
	}

	if(network_shoot_timer == 0){
		create_shooting_effects(id);
	}
	
	if (network_shoot_timer > -1) {
	    network_shoot_timer--;
	}
	Moving = (network_bit_state & PLAYER_FLAGS.MOVING) != 0;
	Reloading = (network_bit_state & PLAYER_FLAGS.RELOADING) != 0;
	Flashed = (network_bit_state & PLAYER_FLAGS.FLASHED) != 0;
	planting = (network_bit_state & PLAYER_FLAGS.PLANTING) != 0;
	defusing = (network_bit_state & PLAYER_FLAGS.DEFUSING) != 0;
	walking = (network_bit_state & PLAYER_FLAGS.WALKING) != 0;
	running = (network_bit_state & PLAYER_FLAGS.RUNNING) != 0;
	var was_healing = Healing;
	Healing = (network_bit_state & PLAYER_FLAGS.HEALING) != 0;
	if (Healing) {
		if (!was_healing) HealingTime = 0;
		HealingItemId = Item.HealingKit;
		HealingTime = min(global.ItemIndex[# Item.HealingKit, ItemStat.ReloadSpeed], HealingTime + global.time_step);
	} else if (was_healing) {
		HealingTime = -1;
		HealingItemId = Item.None;
	}
	if (planting) {
		planting_value = min(planting_max, planting_value + global.time_step);
	} else {
		planting_value = 0;
	}
	var remote_leg_speed = walking ? (WALK_SPD * Legs.spd) : (running ? (RUN_SPD * Legs.spd) : (1.0 * Legs.spd));
	Legs.image_speed = Moving ? (remote_leg_speed * global.time_step) : 0;
			
	if(network_shoot_timer > -1){
		Weapon.KickBackEffect = global.ItemIndex[# wpn_id, ItemStat.KickBackPower];
	}
	
	
	
	if(Weapon != noone && (wpn_id != Item.None && (global.Inventory[# item_use_position, Index.slot_id] == Item.None || is_remote))){
		var suppressor_len = 1;
		if(network_suppressor != Item.None){
			suppressor_len = 1.1;
		}
		FlashLightX = Weapon.x + lengthdir_x(WeaponDistance * suppressor_len, RotationAngle); FlashLightY = Weapon.y + lengthdir_y(WeaponDistance * suppressor_len, RotationAngle);
	}else{
		FlashLightX = x; FlashLightY = y;
	}
	
	if(FlashLight != undefined){
		FlashLight.angle = RotationAngle; FlashLight.x = FlashLightX; FlashLight.y = FlashLightY;
	}

	var remote_reload_duration = max(1, global.ItemIndex[# wpn_id, ItemStat.ReloadSpeed]);
	if (Reloading) {
		if (!remote_reload_active) {
			remote_reload_active = true;
			remote_reload_effect_played = false;
			ReloadTime = 0;
		}
		ReloadTime = min(remote_reload_duration, ReloadTime + reload_frame_step);
		ReloadTimer = max(0, remote_reload_duration - ReloadTime);
	} else {
		remote_reload_active = false;
		remote_reload_effect_played = false;
		ReloadTime = 0;
		ReloadTimer = -1;
	}
	
	if (wpn_id != Item.None && wpn_id != Item.Javelin && ReloadTimer == 0 && !remote_reload_effect_played) {
		remote_reload_effect_played = true;
		if(wpn_id != Item.Javelin){
			particle_create(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
			random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#wpn_id, ItemStat.AmmoSpriteID], x, y);		
		}
	}

    x = lerp(x, target_x, INTERPOLATION_SPD);
    y = lerp(y, target_y, INTERPOLATION_SPD);
	var remote_rotation_delta = ((target_direction - RotationAngle + 540) mod 360) - 180;
	RotationAngle = (RotationAngle + remote_rotation_delta * INTERPOLATION_SPD + 360) mod 360;
	Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
	KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);

	// Remote players keep the same hitbox set as local players. Prone animation
	// and collision code expects LegHB to remain alive.
	if (!instance_exists(LegHB)) {
		LegHB = instance_create_depth(x, y, depth - 1, oHitBox);
		LegHB.image_index = HITBOX.LegProne;
		LegHB.MainObject = id;
	}

	var remote_is_prone = moving_state == STATES_PLAYER.prone_state;
	LegHB.visible = remote_is_prone;
	if (instance_exists(Legs)) {
		Legs.visible = !remote_is_prone;
	}
	WX = remote_is_prone ? 64 : 8;
	WY = remote_is_prone ? 64 : 8;

	Weapon.x = x + lengthdir_x(WX, RotationAngle) - lengthdir_x(Weapon.KickBackEffect, RotationAngle);
	Weapon.y = y + lengthdir_y(WY, RotationAngle) - lengthdir_y(Weapon.KickBackEffect, RotationAngle);
	Weapon.image_angle = RotationAngle + KickBackAngle * .5;
	
}

#endregion

if (instance_exists(oDraw) && stats.Health_points > 0){
	
	#region Bomb region
	can_plant = is_local
		&& stats.Team == TEAM.TERRORIST
		&& position_in_bomb_area(x, y);
	#endregion

	#region Shield
	if(global.ItemIndex[# wpn_id, ItemStat.Type] == "Shield"){
		shield_equip = true;	
		Shield.image_index = (wpn_id == Item.kevlar_shield) ? 1 : ((wpn_id == Item.military_shield) ? 2 : 3);
	}else{
		shield_equip = false;
		Shield.image_index = 0;
	}
	#endregion

	var equipped_use_item_id = is_remote ? network_item_use_id : global.Inventory[# item_use_position, Index.slot_id];
	if (!is_remote && Healing && HealingItemId != Item.None) {
		equipped_use_item_id = HealingItemId;
	}

	#region Weapon texture
	var weapon_index = global.ItemIndex[# wpn_id, ItemStat.AmmoSpriteID] + 1;		
	Weapon.image_index = wpn_id != Item.None ? weapon_index : 0;		
	if(equipped_use_item_id != Item.None || shield_equip == true){ Weapon.image_index = 0; }
	#endregion

	#region Player texture
	
	if(equipped_use_item_id == Item.None && stats.Health_points > 0 && shield_equip == false){
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
				if(global.ItemIndex[# wpn_id, ItemStat.WeaponTypeClass] != WEAPON_CLASS.SUBMACHINE_GUN){
					WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * 0.95;
				}
			break;
	
			case WEAPON_CLASS.PISTOL:
				if(moving_state == STATES_PLAYER.prone_state){
					apply_prone_texture();
				}else{
					apply_weapon_texture(TEXTURES.pistol, HITBOX.BodyPistol, HITBOX.ArmPistol);
				}
				WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * 0.75;
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
					    moving_timer -= global.time_step;

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
				    moving_timer -= global.time_step;

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
				
				WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .75;
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
			    moving_timer -= global.time_step;

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

	#region Defusing
	if (is_local) {
		var was_defusing = defusing;
		var planted_bomb = instance_find(oBomb, 0);
		var common_interaction_allowed = stats.Team == TEAM.POLICE
			&& stats.Health_points > 0
			&& !Healing
			&& !planting
			&& !planting_pending
			&& !Reloading;
		var can_defuse_bomb = common_interaction_allowed
			&& instance_exists(planted_bomb)
			&& global.bomb_planted
			&& point_distance(x, y, planted_bomb.x, planted_bomb.y) <= HOSTAGE_RANGE / 2;

		if (defusing_target != DEFUSE_TARGET.HOSTAGE
		|| !instance_exists(defusing_hostage)
		|| defusing_hostage.rescuing) {
			defusing_hostage = find_nearest_available_hostage(x, y);
		}
		var can_take_hostage = common_interaction_allowed
			&& instance_exists(defusing_hostage)
			&& !defusing_hostage.rescuing
			&& point_distance(x, y, defusing_hostage.x, defusing_hostage.y) <= HOSTAGE_RANGE;

		var requested_target = DEFUSE_TARGET.NONE;
		if (can_defuse_bomb && keyboard_check(global.KeyBinds[| KEY.Defuse])) {
			requested_target = DEFUSE_TARGET.BOMB;
		} else if (can_take_hostage && keyboard_check(global.KeyBinds[| KEY.HostageTake])) {
			requested_target = DEFUSE_TARGET.HOSTAGE;
		}

		if (requested_target != defusing_target) {
			defusing_time = 0;
		}
		defusing_target = requested_target;
		defusing = defusing_target != DEFUSE_TARGET.NONE;

		if (defusing) {
			if (defusing_target == DEFUSE_TARGET.BOMB) {
				var has_defuse_kit = find_item(Item.DefuseKit) != -1;
				defusing_max = DEFUSE_TIME * (has_defuse_kit ? 1 : 2);
			} else {
				defusing_max = DEFUSE_TIME;
			}
			CanShoot = false;
			player_can_shoot = false;
			Moving = false;
			RelativeSpeedX = 0;
			RelativeSpeedY = 0;
			XSpeed = 0;
			YSpeed = 0;
			Legs.image_speed = 0;

			if (!IS_NET) {
				defusing_time = min(defusing_max, defusing_time + global.time_step);
				if (defusing_time >= defusing_max) {
					defusing = false;
					defusing_time = 0;
					if (defusing_target == DEFUSE_TARGET.HOSTAGE) {
						if (instance_exists(defusing_hostage)) {
							defusing_hostage.rescuing = true;
							defusing_hostage.rescuing_player = id;
						}
						CanShoot = ShootTimer <= 0;
						player_can_shoot = true;
					} else {
						if (instance_exists(oGameController)) {
							oGameController.bomb_defused = true;
						}
						global.bomb_planted = false;
						global.bomb_timer = 0;
						global.bomb_planter_pid = -1;
						with (oBomb) instance_destroy();
						round_end("Win", TEAM.POLICE);
					}
					defusing_target = DEFUSE_TARGET.NONE;
				}
			}
		} else {
			defusing_time = 0;
			defusing_target = DEFUSE_TARGET.NONE;
			if (was_defusing) {
				CanShoot = ShootTimer <= 0;
				player_can_shoot = true;
			}
		}
	}
	#endregion
			
	if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false){
	
		if(is_local == true){
			
			
			#region Timers and variables
			stats.Health_points = clamp(stats.Health_points, -1, global.player_stats.Max_health);
			stats.Damage_health_points = clamp(stats.Damage_health_points, 1, global.player_stats.Max_health);
			stats.Stamina_points = clamp(stats.Stamina_points, 0, global.player_stats.Max_stamina);
			stats.Damage_stamina_points = clamp(stats.Damage_stamina_points, 0, global.player_stats.Max_stamina);
			ShootTimer = max(ShootTimer, -1);
			if(HPTimer > 0){HPTimer -= global.time_step;}
			if(StaminaTimer > 0){StaminaTimer -= global.time_step;}
			if(HPHealingTimer > -1){HPHealingTimer -= global.time_step;}
			if(StaminaHealingTimer > -1){StaminaHealingTimer -= global.time_step;}
			if(knife_attack_timer > -1){knife_attack_timer -= global.time_step;}
			if(player_can_shoot == false){RelativeSpeedX = 0; RelativeSpeedY = 0; XSpeed = 0; YSpeed = 0; Moving = false; Legs.image_speed = 0;}
			if(global.Inventory[# item_use_position, Index.slot_id] != Item.None && Reloading){Reloading = false; ReloadTime = 0;}
			if(item_equip_timer > -1){item_equip_timer -= global.time_step;}
			if(FootStepTimer > -1) { FootStepTimer -= global.time_step; }
			if(ScopeInaccuracyTimer > -1){ScopeInaccuracyTimer -= global.time_step;}
			if(EquippedGrenadeTimer > -1){EquippedGrenadeTimer -= global.time_step;}
			if(near_explosion_timer > -1){near_explosion_timer -= global.time_step;}
			if(shooting_reset_timer > -1){shooting_reset_timer -= global.time_step;}
			if(burst_fire_timer > -1){burst_fire_timer -= global.time_step;}
			if(ShootTimer > -1){ShootTimer -= global.time_step;}
			if(ShootTimer <= 0){CanShoot = true;}
			if(kick_back_timer > -1){kick_back_timer -= global.time_step;}
			if(MovingStabilizationTimer > -1){MovingStabilizationTimer -= (global.time_step == 1 ? 1 : 0.5); }
			if(equip_timer > -1){equip_time += (global.time_step == 1 ? 1 : 0.5); equip_timer -= (global.time_step == 1 ? 1 : 0.5); }
			if(ReloadTimer > 0){ReloadTimer = max(0, ReloadTimer - reload_frame_step);}
			MovingStabilizationTimer = max(MovingStabilizationTimer, -1); // Kvůli problémum s časováním global.time_step (bullet time efekt)
			ReloadTimer = clamp(ReloadTimer, -1, global.ItemIndex[# wpn_id, ItemStat.ReloadSpeed]); ///Kvůli problémum s bullet time efektem
			
			if(FlashedAlpha > 0.075 || near_explosion_timer > -1 || stats.Health_points <= 0){
				muffled_sounds = MUFFLE_VALUE;	
				if(stats.Health_points > 0){
					if!(audio_is_playing(snd_EarRing)){ audio_play_sound(snd_EarRing, 0, false); }
				}
			}else{ muffled_sounds = 1; audio_stop_sound(snd_EarRing); }
	
			if(HPTimer == 0){
				var points = stats.Health_points - attack_damage;
			    if(stats.Damage_health_points > points){
			        stats.Damage_health_points -= max(global.player_stats.Max_health/100, .25);
			    }else{ HPTimer = -1;}
			}
	
			if(StaminaTimer == 0){
				var points = stats.Stamina_points - attack_damage;
			    if(stats.Damage_health_points > points){
			        stats.Damage_health_points -= max(global.player_stats.Max_stamina/100, .25);
			    }else{ StaminaTimer = -1;}
			}
	
			if(!IS_NET && HPHealingTimer == -1){
				if(HPTimer == -1){
					if(stats.Health_points >= 0 && stats.Health_points < global.player_stats.Max_health){
						var HealingPower = BaseHealingPower;
						stats.Health_points += HealingPower;	
						stats.Damage_health_points = stats.Health_points;
						HPHealingTimer = HealingTimer;
					}
				}
			}	
	
			if(StaminaHealingTimer == -1){
				if(stats.Stamina_points >= 0 && stats.Stamina_points < global.player_stats.Max_stamina){
					var stamina_healing_power = round(global.player_stats.Max_stamina/50);
					if(moving_state == STATES_PLAYER.prone_state){
						stamina_healing_power = round(global.player_stats.Max_stamina/10);
					}
					if(stats.Stamina_points <= global.player_stats.Max_stamina - stamina_healing_power){
						stats.Stamina_points += stamina_healing_power;
					}else{
						stats.Stamina_points += (global.player_stats.Max_stamina - stats.Stamina_points);
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
			if(array_length(command) < 4){
				command = array_create(4, -1);
			}

			if(keyboard_check_pressed(global.KeyBinds[| KEY.SelectBot])){
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

			    // Keep only living bots from the player's stats.Team.
			    for(var i = bot_count - 1; i >= 0; i--){
			        var bot = bot_select_list[| i];
			        if(!instance_exists(bot) || bot.stats.Team != stats.Team || bot.stats.Health_points <= 0){
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
			}else if(selected_bot.stats.Team != stats.Team || selected_bot.stats.Health_points <= 0){
			    selected_bot = noone;
			    bot_select_index = -1;
			}
			
			if(keyboard_check_pressed(global.KeyBinds[| KEY.CommandBot])){
			    if(selected_bot != noone){
					command[0] = oCrosshair.x;
					command[1] = oCrosshair.y;
					command[2] = 0.1;
					command[3] = 5 * game_get_speed(gamespeed_fps);
			        with(selected_bot){
						set_state(STATES.MoveCommand);
						target_x = other.command[0];
						target_y = other.command[1];
						command_timer = command_time;
						command_stuck_timer = command_stuck_time;
						command_last_x = x;
						command_last_y = y;
						mv_timer = 0;
						MoveTime = 0;
			        }
			    }
			}
			
			if(command[0] != -1 && command[3] > -1){
				command[3] -= global.time_step;
				if(command[3] <= 0){
					command = array_create(array_length(command), -1);
				}
			}

			if(command[0] != -1 && command[2] > 0){
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
			    in_water_timer -= global.time_step; in_water = (in_water_timer > -1);
			}
			#endregion
	
			#region Drop weapon
			if(keyboard_check_pressed(global.KeyBinds[| KEY.DropWeapon]) && player_can_shoot == true && !global.my_console[? "active"] && !is_inventory_full() && moving_state != STATES_PLAYER.machine_gun_state){
				player_has_scope = -1; ScopeIn = false;	
				gain_item(
					wpn_id, 1, global.Inventory[# WeaponID, Index.slot_ammo], global.Inventory[# WeaponID, Index.slot_clip_ammo], 
					global.Inventory[# WeaponID, Index.slot_durability], global.Inventory[# WeaponID, Index.slot_scope], global.Inventory[# WeaponID, Index.slot_barrel],
					global.Inventory[# WeaponID, Index.slot_grip], global.Inventory[# WeaponID, Index.slot_suppressor], false
				);
				WeaponDrop(WeaponID, id);
			}
			#endregion	
	
	
			#region Legs animation
			var leg_movement_speed = walking ? (WALK_SPD * Legs.spd) : (running ? (RUN_SPD * Legs.spd) : (1.0 * Legs.spd));
			Legs.image_speed = (global.my_console[$ "active"] || moving_state == STATES_PLAYER.prone_state || moving_state == STATES_PLAYER.machine_gun_state || 
			moving_state == STATES_PLAYER.mortar_state || instance_exists(oInventory) || Moving == false) ? 0 : (global.time_step == 1 ? leg_movement_speed : leg_movement_speed * 0.5);
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
				var AimPunchStrength = 2;
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
					if(stats.Stamina_points <= global.player_stats.Max_stamina * .75){
						LowStaminaViewAngleFrequency = 2 - ((stats.Stamina_points/global.player_stats.Max_stamina));
						ViewAngleAmplitude += 1 - (stats.Stamina_points/global.player_stats.Max_stamina);
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
					if(stats.Health_points <= round(global.player_stats.Max_health/2)){
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
						} else if (keyboard_check(ord(" s"))) {
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
					suppressor_len = 1.1;
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
			ax = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.visual_x, oCrosshair.visual_y) - global.FieldOfView);
			ay = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.visual_x, oCrosshair.visual_y) - global.FieldOfView);
			bx = cx + triangle_point_distance * dcos(point_direction(cx, cy, oCrosshair.visual_x, oCrosshair.visual_y) + global.FieldOfView);
			by = cy - triangle_point_distance * dsin(point_direction(cx, cy, oCrosshair.visual_x, oCrosshair.visual_y) + global.FieldOfView);
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
	
			if(keyboard_check_pressed(global.KeyBinds[| KEY.ChangeMode]) && shooting == false){
				var list_size = ds_list_size(global.ItemIndex[#wpn_id, ItemStat.ShootingMode]);
				if(weapon_shooting_mode < list_size){ weapon_shooting_mode = (weapon_shooting_mode + 1) % list_size; }
			}
	
			if(shooting_mode == "Auto"){	
				if(KickBack > 1){ 
					KickBackTime = round(.08 * game_get_speed(gamespeed_fps) * global.ItemIndex[#wpn_id, ItemStat.KBResetMultiplier]);
				}else{
					KickBackTime = round(.5 * game_get_speed(gamespeed_fps) * global.ItemIndex[#wpn_id, ItemStat.KBResetMultiplier]);
				}
				Shoot = input_check(global.KeyBinds[| KEY.ShootMouse]);
				if(input_check(global.KeyBinds[| KEY.ShootMouse], false, true) || (global.Inventory[# WeaponID, Index.slot_ammo] <= 0 && shooting == true)){
					kick_back_timer = KickBackTime; shooting = false; crosshair_position[0] = oCrosshair.x; crosshair_position[1] = oCrosshair.y;
				}
			}else if(shooting_mode == "Semi" || shooting_mode == "Burst"){
				KickBackTime = round(.25 * game_get_speed(gamespeed_fps) * global.ItemIndex[#wpn_id, ItemStat.KBResetMultiplier]);
				Shoot = input_check(global.KeyBinds[| KEY.ShootMouse], true);
				/* Jelikož se při auto modu vždycky resetne "shooting" na false po tom co hráč releasne tlačítko na střílení, musel jsem přidat "shooting_reset_timer" */
				if(input_check(global.KeyBinds[| KEY.ShootMouse], false, false) && shooting_reset_timer == -1){
					shooting_reset_timer = KickBackTime;
				}
				if((input_check(global.KeyBinds[| KEY.ShootMouse], false, true) && global.Inventory[# WeaponID, Index.slot_ammo] > 0) || (global.Inventory[# WeaponID, Index.slot_ammo] <= 0 && shooting == true && shooting_reset_timer == -1)){
					shooting_reset_timer = KickBackTime; kick_back_timer = KickBackTime; crosshair_position[0] = oCrosshair.x; crosshair_position[1] = oCrosshair.y;
				}
				
				if(shooting_reset_timer == 0){ shooting = false; }
			}
	
			#endregion	
	
			#region Burst fire
			var adaptive = 
			has_attachment(Item.adaptive_chambering, Index.slot_barrel) 
			? global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_barrel], ItemStat.ShootTimer] : 1;								
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
						if(input_check(global.KeyBinds[| KEY.ShootMouse], true, false) && global.Inventory[# WeaponID, Index.slot_ammo] <= 0){
							play_sound(x, y, snd_empty_magazine);
						}
					    if(Shoot == 1 && (Reloading == false || (Reloading == true && global.ItemIndex[# wpn_id, ItemStat.BaseDurability] == 1))){
				
							if(global.Inventory[# WeaponID, Index.slot_ammo] > 0){
								shooting = true;
				
								#region Fractionating reloading stop
								if(global.ItemIndex[#wpn_id, ItemStat.BaseDurability] == 1){
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
									global.ItemIndex[#wpn_id, ItemStat.Defense] == 0){
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

			#endregion

			#region Movement
			if(player_can_shoot == true && !global.my_console[? "active"] && moving_state < STATES_PLAYER.machine_gun_state){
				var Up = keyboard_check(global.KeyBinds[| KEY.Up]);
				var Right = keyboard_check(global.KeyBinds[| KEY.Right]);
				var Left = keyboard_check(global.KeyBinds[| KEY.Left]);
				var Down = keyboard_check(global.KeyBinds[| KEY.Down]);
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
				var WeightSpeedMultiplier = 1 / (global.player_stats.Weight/75 + 1);
				var WeaponSpeedMultiplier = 1;
				
				if(AimPunchTimer == -1){ aimpunch_speed_multiplier = 1; }
				if(CanShoot == false && ShootTimer >= global.ItemIndex[#wpn_id, ItemStat.ShootTimer]/2){ ShootingSpeedMultiplier = global.ItemIndex[#wpn_id, ItemStat.ShootSpdMul]; }
				if(Reloading == true){ ReloadingSpeedMultiplier = global.ItemIndex[#wpn_id, ItemStat.ReloadSpdMul]; }
				if(moving_state == STATES_PLAYER.prone_state){
					moving_speed_multiplier = PRONE_SPD;
				}else if(walking){
					moving_speed_multiplier = WALK_SPD;
				}else if(running){
					moving_speed_multiplier = RUN_SPD;
				}
	
				if(global.ItemIndex[#wpn_id, ItemStat.MovingSpdMul] != 0 && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
					WeaponSpeedMultiplier = global.ItemIndex[#wpn_id, ItemStat.MovingSpdMul];
				}
	
				SpeedMul = ReloadingSpeedMultiplier * ShootingSpeedMultiplier * aimpunch_speed_multiplier * moving_speed_multiplier * WeightSpeedMultiplier *
						   WeaponSpeedMultiplier / (ScopeIn + 1) * (game_get_speed(gamespeed_fps)/60) / (Healing + 1) * min(global.time_step * 2, 1);

				#endregion

				if(Left || Right || Down || Up){
				    Moving = true;
				} else {
					if(MovingStabilizationTimer == -1 && Moving == true){
						MovingStabilizationTimer = MovingStabilizationTime;
					}
				}

				if(MovingStabilizationTimer == 0){ Moving = false; }

				if!(Left || Right){ RelativeSpeedX = max(0, RelativeSpeedX - (RelativeSpeedValue * 2)); }

				if!(Up || Down){ RelativeSpeedY = max(0, RelativeSpeedY - (RelativeSpeedValue * 2)); }

				if(Moving == true){
					if(walking){
						FootSteps = 0;
						FootStepTimer = -1;
					}else if(moving_state != STATES_PLAYER.prone_state){
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
						if(moving_state != STATES_PLAYER.prone_state && !walking && Visible == true){
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
						if(moving_state != STATES_PLAYER.prone_state && !walking && Visible == true){
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
			if(!instance_exists(oInventory) && keyboard_check_pressed(global.KeyBinds[| KEY.Door])){
				var nearby_door = instance_nearest(x, y, oDoor);
				var has_key = false;
				if(instance_exists(nearby_door)){
					switch(nearby_door.image_index){
						case 0: has_key = find_item(Item.gold_card) != -1; break;
						case 1: has_key = find_item(Item.magenta_card) != -1; break;
						case 2: has_key = find_item(Item.red_card) != -1; break;
						case 3: has_key = find_item(Item.aqua_card) != -1; break;
						case 4: has_key = find_item(Item.green_card) != -1; break;
						case 5: has_key = find_item(Item.black_card) != -1; break;
						case 6: has_key = find_item(Item.white_card) != -1; break;
					}
				}

				if(instance_exists(nearby_door) && point_distance(x, y, nearby_door.x, nearby_door.y) <= 128 && has_key == true){
					with(nearby_door){
						var previous_angle = image_angle;
						var target_angle = main_angle;

						if(!opened){
							var door_center_x = (bbox_left + bbox_right) * 0.5;
							var door_center_y = (bbox_top + bbox_bottom) * 0.5;
							var dx = other.x - door_center_x;
							var dy = other.y - door_center_y;

							if(main_angle == 0 || main_angle == 180){
								target_angle = dy < 0 ? 270 : 90;
							}else{
								target_angle = dx < 0 ? 0 : 180;
							}
						}

						image_angle = target_angle;
						var blocked = place_meeting(x, y, oPlayer) || place_meeting(x, y, oBot);

						if(blocked){
							image_angle = previous_angle;
						}else{
							opened = !opened;
							if(door_light != undefined){
								door_light.blend = opened ? c_lime : c_red;
							}
							if(opened){
								var beep_x = x + lengthdir_x(49 * image_xscale, image_angle);
								var beep_y = y + lengthdir_y(49 * image_xscale, image_angle);
								play_sound(beep_x, beep_y, snd_Beep);
							}
						}
					}
				}
			}

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
				if(input_check(global.KeyBinds[| KEY.KnifeLight], true, false) && stats.Stamina_points >= STAMINA_KNIFE_LIGHT){
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
				if(input_check(global.KeyBinds[| KEY.KnifeHeavy], true, false) && stats.Stamina_points >= STAMINA_KNIFE_HEAVY){
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
			var objects = [oBot, oBird, oHostage];
			
			if(player_can_shoot == true){
				for(var i = 0;i < array_length(objects); i ++){
					if(place_meeting(x, y, objects[i]) && moving_state != STATES_PLAYER.machine_gun_state) {
					    var obj = instance_nearest(x, y, objects[i]);
						var dir = point_direction(obj.x, obj.y, x, y);
					
						if(obj.object_index != oBird){
							if(obj.object_index != oHostage){
								AccelX = 2 * cos(degtorad(dir));
								AccelY = -2 * sin(degtorad(dir));
							}
							AccelX = 0.5 * cos(degtorad(dir));
							AccelY = -0.5 * sin(degtorad(dir));
						}else if(obj.state == 0){
							AccelX = 1 * cos(degtorad(dir));
							AccelY = -1 * sin(degtorad(dir));
						}
					}
				}

				if (IS_NET && moving_state != STATES_PLAYER.machine_gun_state) {
					var remote_player = instance_place(x, y, oPlayer);
					if (instance_exists(remote_player) && remote_player.is_remote) {
						var remote_dir = point_direction(remote_player.x, remote_player.y, x, y);
						AccelX = 2 * cos(degtorad(remote_dir));
						AccelY = -2 * sin(degtorad(remote_dir));
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

			#region Running, walking, prone and machine gun
			if(!global.my_console[? "active"] && shield_equip == false){
				if(running){
					statistics_hit("Stamina", STAMINA_RUN_VALUE, id);
				}
	
				if(keyboard_check_pressed(global.KeyBinds[| KEY.Prone]) && Moving == false){
					if(moving_state == STATES_PLAYER.none_state){
						moving_state = STATES_PLAYER.prone_state;
					}else if(moving_state == STATES_PLAYER.prone_state){
						moving_state = STATES_PLAYER.none_state;
					}
				}
		
				if(instance_exists(oMortar) && !instance_exists(oInventory) && !instance_exists(oWeaponAttachments)){
					var mortar = instance_nearest(x, y, oMortar);		
					if(distance_to_object(mortar) <= PickUpDistance){
						if(keyboard_check_pressed(global.KeyBinds[| KEY.PickUp])){
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
	
				if (instance_exists(oMachineGun) && keyboard_check_pressed(global.KeyBinds[| KEY.PickUp])) {
					var machine_gun = instance_nearest(x, y, oMachineGun);
					var mounted_machine_gun = IS_NET ? find_machine_gun_by_pid(network_id) : noone;
					if (!IS_NET && moving_state == STATES_PLAYER.machine_gun_state && machine_gun.stats.Object == id) {
						mounted_machine_gun = machine_gun;
					}

					if (instance_exists(mounted_machine_gun)) {
						if (IS_NET) {
							if (oNetworkManager.is_server) {
								server_release_machine_gun(network_id);
							} else {
								send_machine_gun_request_client(MACHINE_GUN_SYNC_ACTION.REQUEST_DISMOUNT, mounted_machine_gun);
							}
						} else {
							dismount_local_player_from_machine_gun(id, mounted_machine_gun);
						}
					} else if (distance_to_object(machine_gun) <= PickUpDistance
					&& moving_state == STATES_PLAYER.none_state
					&& global.Inventory[# OtherSlot.Primary, Index.slot_id] == Item.None
					&& !instance_exists(machine_gun.stats.Object)) {
						if (IS_NET) {
							if (oNetworkManager.is_server) {
								server_mount_machine_gun(network_id, machine_gun.x, machine_gun.y);
							} else {
								send_machine_gun_request_client(MACHINE_GUN_SYNC_ACTION.REQUEST_MOUNT, machine_gun);
							}
						} else {
							mount_local_player_to_machine_gun(id, machine_gun);
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
					var pointdir = point_direction(x, y, oCrosshair.aim_x, oCrosshair.aim_y);
					Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
					Weapon.x = x + lengthdir_x(WX, RotationAngle) - lengthdir_x(Weapon.KickBackEffect, RotationAngle);
					Weapon.y = y + lengthdir_y(WY, RotationAngle) - lengthdir_y(Weapon.KickBackEffect, RotationAngle);
					Shield.x = x + lengthdir_x(WX, RotationAngle);
					Shield.y = y + lengthdir_y(WY, RotationAngle);
					RotationAngle += sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 45);
					RotationAngle = (RotationAngle % 360 + 360) % 360;
					Weapon.image_angle = RotationAngle + KickBackAngle * .5;
					Shield.image_angle = RotationAngle;
					Knife.image_angle = RotationAngle;
					Weapon.RotationAngle = Weapon.image_angle;
	
				}
			}
			#endregion
	
			#region Toggle night vision and infrared vision
			if(global.Inventory[# OtherSlot.Helmet, Index.slot_id] == Item.None){
				if(ToggleNightVision == true){
					play_sound(x, y, snd_Beep);
					ToggleNightVision = false;	
				}
				if(ToggleInfraVision == true){
					play_sound(x, y, snd_Beep);
					ToggleInfraVision = false;	
				}
			}
	
			if(keyboard_check_pressed(global.KeyBinds[| KEY.ToggleNightVision]) && !global.my_console[? "active"]){
				if(global.Inventory[# OtherSlot.Helmet, Index.slot_durability] > 0){
					if(string_pos("night vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
						play_sound(x, y, snd_Beep);
						ToggleNightVision = !ToggleNightVision;	
					}else if(string_pos("Infrared vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
						play_sound(x, y, snd_Beep);
						ToggleInfraVision = !ToggleInfraVision;	
					}
				}
			}
	
			if(global.Inventory[# OtherSlot.Helmet, Index.slot_durability] <= 0 && (ToggleNightVision == true || ToggleInfraVision == true)){
				if(string_pos("night vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
					play_sound(x, y, snd_Beep);
					ToggleNightVision = false;	
				}if(string_pos("Infrared vision", global.ItemIndex[#global.Inventory[# OtherSlot.Helmet, Index.slot_id], ItemStat.Name]) > 0){
						play_sound(x, y, snd_Beep);
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
				if (!healing_pending) {
					HealingTime += global.time_step;
				} else {
					healing_request_timer -= global.time_step;
					if (healing_request_timer <= 0 && IS_NET && !oNetworkManager.is_server && oNetworkManager.is_connected) {
						send_item_action_complete_client(HealingItemId);
						healing_request_timer = 0.25 * game_get_speed(gamespeed_fps);
					}
				}
			}
			if(HealingTime >= global.ItemIndex[#HealingItemId, ItemStat.ReloadSpeed]){
				if (!IS_NET) {
					var healing_amount = min(global.ItemIndex[#HealingItemId, ItemStat.Damage], global.player_stats.Max_health - stats.Health_points);
					stats.Health_points += healing_amount;
					stats.Damage_health_points = stats.Health_points;
					damage_indicator("+" + string(round(healing_amount)), x, y - 30, c_green, spr_Icons, ICON.health);
					CanShoot = true;
				} else if (oNetworkManager.is_server) {
					server_process_item_action(network_id, HealingItemId);
				} else if (oNetworkManager.is_connected) {
					if (!healing_pending) {
						healing_pending = true;
						healing_request_timer = 0;
					}
				}

				if (!healing_pending) {
					Healing = false;
					HealingTime = -1;
					HealingItemId = Item.None;
				}
			}
			#endregion

			#region Bomb planting
			if (planting_pending && IS_NET && !oNetworkManager.is_server && !global.bomb_planted) {
				CanShoot = false;
				player_can_shoot = false;
				Moving = false;
				RelativeSpeedX = 0;
				RelativeSpeedY = 0;
				XSpeed = 0;
				YSpeed = 0;
				Legs.image_speed = 0;
				planting_request_timer -= global.time_step;
				if (planting_request_timer <= 0) {
					send_bomb_plant_request(planting_x, planting_y);
					planting_request_timer = 0.25 * game_get_speed(gamespeed_fps);
				}
			}

			if (planting) {
				var planting_item_valid = planting_slot >= 0
					&& global.Inventory[# planting_slot, Index.slot_id] == Item.Bomb
					&& item_use_position == planting_slot
					&& stats.Team == TEAM.TERRORIST
					&& !global.bomb_planted;

				if (!planting_item_valid) {
					planting = false;
					planting_value = 0;
					planting_slot = -1;
					CanShoot = true;
					player_can_shoot = true;
				} else {
					CanShoot = false;
					player_can_shoot = false;
					Moving = false;
					RelativeSpeedX = 0;
					RelativeSpeedY = 0;
					XSpeed = 0;
					YSpeed = 0;
					Legs.image_speed = 0;
					planting_value = min(planting_max, planting_value + global.time_step);

					if (planting_value >= planting_max) {
						planting = false;
						planting_value = planting_max;
						CanShoot = true;
						player_can_shoot = true;

						if (!IS_NET) {
							var bomb = instance_create_layer(x, y, "ItemsO", oBomb);
							bomb.image_angle = random(359);
							ItemAmountSubstract(planting_slot, 1);
							planting_slot = -1;
						} else if (oNetworkManager.is_server) {
							if (server_process_bomb_plant(0, x, y)) {
								ItemAmountSubstract(planting_slot, 1);
							}
							planting_slot = -1;
						} else {
							planting_pending = true;
							planting_x = x;
							planting_y = y;
							planting_request_timer = 0;
						}
					}
				}

			}
			#endregion

			#region Level
			if(global.player_stats.Xp >= global.player_stats.Max_xp){
				damage_indicator("Level up!", x - string_width("Level up!")/2, y, MAIN_COLOR, spr_Icons, 0, set_font("Title"));
				global.player_stats.Xp = 0;
				global.player_stats.Lvl ++;
				global.player_stats.Max_stamina *= power(STATS_LVL_UP, ln(global.player_stats.Lvl));
				global.player_stats.Max_health *= power(STATS_LVL_UP, ln(global.player_stats.Lvl));
				global.player_stats.Max_xp *= XP_LVL_UP_MUL;
			}
			#endregion

			if(!global.my_console[? "active"] && !instance_exists(oBuyMenu) && moving_state != STATES_PLAYER.mortar_state){
		
				#region Inventory
				if(!defusing && keyboard_check_pressed(global.KeyBinds[| KEY.Inventory])){
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
					if(!defusing && keyboard_check_pressed(global.KeyBinds[| KEY.PickUp])){
				            with(Items){
				                gain_item(image_index, Amount, Ammo, ClipAmmo, Durability, scope_attachment, barrel_attachment, grip_attachment, suppressor_attachment);
				            }
				        }
				    }
				}
				#endregion
				
				#region Item cycling
				if(!defusing && keyboard_check_pressed(global.KeyBinds[| KEY.CycleRight])){
					if (planting) {
						planting = false;
						planting_value = 0;
						planting_slot = -1;
						CanShoot = true;
						player_can_shoot = true;
					}
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
						healing_pending = false;
					}
					item_use_position ++;
					if(item_use_position > HOTBAR_SIZE - 1){
						item_use_position = 0;
					}
					item_use_position = max(item_use_position, 0);
				}			
				if(!defusing && keyboard_check_pressed(global.KeyBinds[| KEY.CycleLeft])){
					if (planting) {
						planting = false;
						planting_value = 0;
						planting_slot = -1;
						CanShoot = true;
						player_can_shoot = true;
					}
					if(Healing == true){
						HealingTime = 0;
						Healing = false;
						healing_pending = false;
					}
					if(item_use_position == 0){ 
						item_use_position = HOTBAR_SIZE - 1;
					}else{
						item_use_position --;
					}
					item_use_position = min(item_use_position, HOTBAR_SIZE - 1);
				}
				#endregion

				if(input_check(global.KeyBinds[| KEY.UseItem], true, false) && !instance_exists(oInventory) && moving_state != STATES_PLAYER.machine_gun_state
				 && !instance_exists(oWeaponAttachments) && !defusing){
					item_equip(item_use_position, "item_use_position", WeaponID);
				 }
		
				#region Scope
				var ScopeButton = input_check(global.KeyBinds[| KEY.Scope], true, false);
				if!(instance_exists(oInventory)){
					if(global.Inventory[# WeaponID, Index.slot_scope] != Item.None && CanShoot == true && global.Inventory[# item_use_position, Index.slot_id] == Item.None){
						if(ScopeButton){
							if(ScopeIn == false){
								if(global.Inventory[# WeaponID, Index.slot_scope] == Item.two_scope){
									ScopeInaccuracyTimer = global.ItemIndex[#wpn_id, ItemStat.ScopeInaccuracyResetTimer];
								}
								ScopeIn = true;	
							}else{
								ScopeIn = false;
							}
						}
					}
				}
				#endregion
	
			}

			#region Weapon cycling
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
					var weaponSlot = OtherSlot.Primary;

					switch (WeaponNumber) {
					    case 0: weaponSlot = OtherSlot.Primary; break;
					    case 1: weaponSlot = OtherSlot.Secondary; break;
					    case 2: weaponSlot = OtherSlot.Knife; break;
					    case 3: weaponSlot = OtherSlot.Shield; break;
					}

					var equipTime = global.ItemIndex[# global.Inventory[# weaponSlot, Index.slot_id], ItemStat.EquipTime];
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
				Range = point_distance(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), oCrosshair.aim_x, oCrosshair.aim_y);
			}
			#endregion

			#region Reloading	
			if(global.Inventory[# item_use_position, Index.slot_id] != Item.None){
				ReloadTimer = -1;
			}
	
			if(ReloadTimer == 0){
				ReloadTimer = -1;
				if(global.ItemIndex[#wpn_id, ItemStat.BaseDurability] != 1){
			
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

				if (IS_NET && oNetworkManager.is_server && wpn_id == Item.basic_machine_gun) {
					server_machine_gun_ammo_changed(network_id,
						global.Inventory[# WeaponID, Index.slot_ammo],
						global.Inventory[# WeaponID, Index.slot_clip_ammo]);
				}
			}
	
			if (global.Inventory[# WeaponID, Index.slot_id] != -1) {
			  if (global.Inventory[# WeaponID, Index.slot_ammo] > global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo]) {
			    global.Inventory[# WeaponID, Index.slot_ammo] = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_id], ItemStat.MaxAmmo];
			  }
			 AmmoNeeded = global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] - global.Inventory[# WeaponID, Index.slot_ammo];

			  if (global.Inventory[# WeaponID, Index.slot_ammo] < global.ItemIndex[# wpn_id, ItemStat.MaxAmmo] && global.Inventory[# WeaponID, Index.slot_clip_ammo] > 0 && Reloading == false && !defusing && keyboard_check_pressed(global.KeyBinds[| KEY.Reload]) && shooting == false && !global.my_console[? "active"] && global.Inventory[# item_use_position, Index.slot_id] == Item.None && FlashedAlpha <= 0){
			    Reloading = true;
			    ReloadTimer = global.ItemIndex[#wpn_id, ItemStat.ReloadSpeed];
			  }
			}

			if(Reloading == true){
				var local_reload_duration = max(1, global.ItemIndex[# wpn_id, ItemStat.ReloadSpeed]);
			    ReloadTime = min(local_reload_duration, ReloadTime + reload_frame_step);
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
			instance_activate_object(oGameController);
			instance_activate_object(oNetworkManager);
			instance_activate_object(obj_hazeC);
			instance_activate_object(oParentTile);
			instance_activate_object(objUITextInput);
			instance_activate_object(oMortarMenu);
			instance_activate_object(oWeaponAttachments);
			instance_activate_object(oBuyMenuDescription);
			instance_activate_object(oBotTab);
			instance_activate_object(objUIImage);
			instance_activate_object(oBuyMenu);
			instance_activate_object(oWeaponDescription);
			instance_activate_object(oLightRenderer);
			instance_activate_object(oDamageTable);
			instance_activate_object(oStatisticsTable);
			instance_activate_object(oBotTab);
			instance_activate_object(oItemDescription);
			instance_activate_object(objUIWindowCaption);
			instance_activate_object(objZUIMain);
			instance_activate_object(objUIButton);
			instance_activate_object(objUILabel);
			instance_activate_object(objUIGrid);
			instance_activate_object(oArmourDescription);
			instance_activate_object(oUsableItemDescription);
			instance_activate_object(oCrosshair);
			instance_activate_object(oDamageIndicator);
			instance_activate_object(oDraw);
			instance_activate_object(oBulletTracer);
			instance_activate_object(oBullet);
			instance_activate_object(oParticleSystem);
			instance_activate_object(oParticle);
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
			instance_activate_object(oBomb);
			instance_activate_object(oBombArea);
			#endregion
		
		}
	
	}
}

#region Death
var should_handle_death = false;
if (!IS_NET) {
    if (stats.Health_points <= 0 && !death_handled) {
        should_handle_death = true;
    }
} else {
    if (death_from_server && !death_handled) {
        should_handle_death = true;
        death_from_server = false;
    }
}


if (should_handle_death) {
    death_handled = true;
    if(is_local){
		if(instance_exists(oTerminal)){
			with(oTerminal) zui_destroy();
		}
        with (oInventory) instance_destroy();
        with (oSlot) instance_destroy();
        item_description_destroy();

		ds_grid_clear(global.Inventory, 0);
		ds_grid_clear(global.MouseSlot, 0);
		global.player_stats.Weight = 0;

        audio_stop_sound(snd_EarRing);
        muffled_sounds = 1;
		near_explosion_timer = -1;
		ViewAngle = 0;
		ViewShake = false;
		ViewShakeTimer = -1;
		ViewShakeMagnitude = 0;
		ViewShakeValuePower = 0;
		CrosshairShake = 0;
		AimPunchTimer = -1;
		AimPunchMultiplier = 1;
		rotation_angle = 0;
		rotation_target = 0;
		rotation_direction = 1;
		camera_set_view_angle(CAM, 0);

		stats.Deaths++;
		if(!IS_NET){
			global.game_struct.Match_deaths++;
			if(global.ranked_game){
				global.player_stats.Deaths++;
			}
		}
	}

    oDraw.KilledByWeapon = KilledByWeapon;
    oDraw.KilledByName = KilledByName;
    Weapon.image_index = 0;
    image_index = 3;
	if(instance_exists(Legs)){
		Legs.Visible = false;
		Legs.image_speed = 0;
		Legs.image_index = Legs.first_frame;
		Legs.footstep_progress = 0;
	}
	ScopeIn = false;
	depth += 1;
	player_can_shoot = false;
	Moving = false;
	planting = false;
	planting_pending = false;
	planting_value = 0;
	planting_slot = -1;
	defusing = false;
	defusing_time = 0;
	defusing_target = DEFUSE_TARGET.NONE;
	defusing_hostage = noone;
	Healing = false;
	HealingTime = -1;
	HealingItemId = Item.None;
	healing_pending = false;
	healing_request_timer = 0;

	with(oBuyMenuDescription){
		zui_destroy();	
	}

	play_sound(x, y, choose(snd_Death1, snd_Death2));

	if(!IS_NET){
		if (!oDraw.bomb_detonation_pending) {
			global.bomb_planted = false;
			global.bomb_timer = 0;
			global.bomb_planter_pid = -1;
			oDraw.round_end_timer = -1;
			with (oBomb) instance_destroy();
			round_end("Loss");
		}
	}else if(is_local){
		var teammate = find_living_player_teammate(stats.Team, id);
		var round_already_resolved = oNetworkManager.round_resolved;

		if (!round_already_resolved) {
			oDraw.RespawnMenu = true;
			oDraw.GameEndMenu = false;
		}

		if (instance_exists(teammate) && !round_already_resolved) {
			oDraw.spectating = true;
			oDraw.spectate_target = teammate;
		} else if (!round_already_resolved) {
			oDraw.spectating = false;
			oDraw.spectate_target = noone;
		}
	}
}
#endregion
