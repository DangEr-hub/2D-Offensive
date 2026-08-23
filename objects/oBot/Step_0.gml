/* Step */
event_inherited();

#region Death
if(stats.Health_points <= 0){
	var death_sound_effect = choose(snd_Death1, snd_Death2);
	play_sound(x, y, death_sound_effect);
    if (instance_exists(ChasingObject) && ChasingObject.HitMap[? id]) {
        ds_map_delete(ChasingObject.HitMap, id);
    }
	depth += 1;
	XSpeed = 0;
	YSpeed = 0;	
	instance_destroy(Weapon);
	instance_destroy(HeadHB);
	instance_destroy(BodyHB);
	instance_destroy(ArmHB);
	instance_destroy(Legs);
	drop_experience(1, xp_value, x, y, sprite_width/4);
	if(percent_chance(100)){
		ItemDrop(
			WeaponID[WeaponPositionID], 
			x + lengthdir_x(WeaponDistance, RotationAngle), 
			y + lengthdir_y(WeaponDistance, RotationAngle), 
			Ammo[WeaponPositionID],
			ClipAmmo[WeaponPositionID],
			0,
			1,
			attachments[WeaponPositionID][ATTACHMENTS.slot_scope],
			attachments[WeaponPositionID][ATTACHMENTS.slot_barrel],
			attachments[WeaponPositionID][ATTACHMENTS.slot_grip],
			attachments[WeaponPositionID][ATTACHMENTS.slot_suppressor]
		);
	}
	if(ArmourID != Item.None){
		if(percent_chance(10)){
			ItemDrop(
				ArmourID, 
				random_range(x - sprite_width/2, x + sprite_width/2), 
				random_range(y - sprite_height/2, y + sprite_height/2), 
				0, 
				0,
				ArmourDurability[0]
			);
		}
	}
	if(HelmetID != Item.None){
		if(percent_chance(10)){
			ItemDrop(
				HelmetID, 
				random_range(x - sprite_width/2, x + sprite_width/2), 
				random_range(y - sprite_height/2, y + sprite_height/2), 
				0, 
				0,
				ArmourDurability[1]
			);
		}
	}
	var EnemyDead = instance_create_depth(x, y, depth, oEnemyDead);
	EnemyDead.mask_index = spr_BotDead;
	EnemyDead.sprite_index = sprite_index;
	EnemyDead.image_index = 3;
	EnemyDead.image_angle = RotationAngle % 360;
	instance_destroy();
	exit;
}

#endregion

#region Texture
if(EquippedGrenadeTimer == -1 && EquippedLandMineTimer == -1 && trigger_texture_timer > -1){
	
	#region Weapon texture
	
	var weapon_index = global.ItemIndex[# WeaponID[WeaponPositionID], ItemStat.AmmoSpriteID] + 1;		
	Weapon.image_index = WeaponID[WeaponPositionID] != Item.None ? weapon_index : 0;		
	#endregion
	
	#region Enemy texture
	switch(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass]){
		case WEAPON_CLASS.ASSAULT_RIFLE:
		case WEAPON_CLASS.SUBMACHINE_GUN:
		case WEAPON_CLASS.SNIPER_RIFLE:
		case WEAPON_CLASS.SHOTGUN:
		case WEAPON_CLASS.MISSILE:
			apply_weapon_texture(TEXTURES.assault_rifle, HITBOX.BodyAR, HITBOX.ArmAR);
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
		break;
	
		case WEAPON_CLASS.PISTOL:
			apply_weapon_texture(TEXTURES.pistol, HITBOX.BodyPistol, HITBOX.ArmPistol);
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .775;
		break;

		default:
			BodyHB.image_index = HITBOX.BodyNoWeapon;
			if(FlashedTimer <= FlashedTime * .25){
				image_index = TEXTURES.no_weapon;
				ArmHB.image_index = HITBOX.ArmNoWeapon;
			}else{
				image_index = TEXTURES.flashed_no_weapon;
				ArmHB.image_index = HITBOX.ArmFlashedNoWeapon;
			}
			WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
		break;
	}
	#endregion
}
if!(EquippedGrenadeTimer == -1){
	
	#region Grenade texture
	image_index = TEXTURES.reload;
	BodyHB.image_index = HITBOX.BodyThrowReload;
	ArmHB.image_index = HITBOX.ArmThrowReload;
	WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
	#endregion
	
}else if!(EquippedLandMineTimer == -1){
	#region Landmine texture
	image_index = TEXTURES.no_weapon;
	BodyHB.image_index = HITBOX.BodyNoWeapon;
	ArmHB.image_index = HITBOX.ArmNoWeapon;
	WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
	#endregion
}
#endregion
	
#region Healing kit
if(healing == true){
	CanShoot = false;
	healing_time += global.time_step;
}
if(healing_time >= global.ItemIndex[#Item.HealingKit, ItemStat.ReloadSpeed]){
	damage_indicator("+" + string(global.ItemIndex[#Item.HealingKit, ItemStat.Damage]), x, y - 30, c_green, spr_Icons, ICON.health);
	healing = false;
	CanShoot = true;
	stats.Health_points += global.ItemIndex[#Item.HealingKit, ItemStat.Damage];
	stats.Damage_health_points = stats.Health_points;
	healing_time = -1;
}
#endregion

#region Danger reaction
if(danger_reaction_timer > 0){
	danger_reaction_timer = max(0, danger_reaction_timer - global.time_step);
}

if(check_danger_timer <= 0){
	check_danger_timer = check_danger_time;
	var nearby_danger = find_bot_danger();

	if(nearby_danger != noone){
		NearestDangerX = nearby_danger.x;
		NearestDangerY = nearby_danger.y;
		NearestDangerObject = nearby_danger.source;

		if(State == STATES.FleeDanger){
			SpottedDanger = true;
		}else{
			SpottedDanger = false;
			if(danger_reaction_source != nearby_danger.source){
				danger_reaction_source = nearby_danger.source;
				danger_reaction_timer = random_range(.35, .8)
					* game_get_speed(gamespeed_fps)
					* clamp(rank_less, .5, 1.5);
				var danger_flee_chance = clamp(15 + rank_boost * 50, 55, 95);
				danger_will_flee = percent_chance(danger_flee_chance);
			}
		}
	}else{
		NearestDangerX = -1;
		NearestDangerY = -1;
		NearestDangerObject = noone;
		SpottedDanger = false;
		danger_reaction_source = noone;
		danger_reaction_timer = -1;
		danger_will_flee = false;

		if(State == STATES.FleeDanger){
			var resume_state = danger_state_before_flee;
			if(Flashed){
				resume_state = STATES.MoveFlashed;
			}else if(resume_state == STATES.FleeDanger
			|| resume_state == STATES.ThrowGrenade
			|| resume_state == STATES.LayDownLandMine
			|| resume_state == STATES.NoMove){
				resume_state = STATES.Idle;
			}else if(resume_state == STATES.MoveCommand && command_timer == -1){
				resume_state = STATES.Idle;
			}

			MoveTime = 0;
			mv_timer = 0;
			set_state(resume_state);
		}
	}
}

if(State != STATES.FleeDanger
&& danger_reaction_timer == 0
&& instance_exists(danger_reaction_source)){
	danger_reaction_timer = -1;
	if(danger_will_flee){
		danger_state_before_flee = State;
		SpottedDanger = true;
		MoveTime = 0;
		mv_timer = 0;
		set_state(STATES.FleeDanger);
	}
}
#endregion

#region States 

if(State == STATES.MoveCommand && global.EnemyCanMove == true){
	MoveTowards(target_x, target_y, Acceleration*3, 0, 0);
}

if(State == STATES.FleeDanger && global.EnemyCanMove == true){
	if(MoveTime <= 0){
		bot_flee_from_danger(NearestDangerX, NearestDangerY);
	}
}else if(global.EnemyCanMove == true && mv_timer <= 1){
	
	if(instance_exists(ChasingObject) && State != STATES.MoveCommand){
		target_x = ChasingObject.x;
		target_y = ChasingObject.y;
	}
	
	#region States
	switch(State){
		case STATES.MoveAway:
			if(ReactionTimer <= 0){
				MoveRunAway(target_x, target_y);
			}
		break;
		
		case STATES.MoveShoot:
			if(ReactionTimer <= 0){
				bot_move_shooting(target_x, target_y);
			}
		break;
		
		case STATES.Move:
			if(ReactionTimer <= 0){
				MoveRandom();
			}
		break;
		
		case STATES.Idle:
			if(percent_chance(10 * rank_boost)){
				MoveIdle();
			}
		break;
		
		case STATES.MoveToward:
			if(ReactionTimer <= 0){
				MoveTowards(target_x, target_y, Acceleration);
			}
		break;
		
		case STATES.MoveAwayFromGrenade:
			if(ReactionTimer <= 0){
				MoveRunAway(NearestDangerX, NearestDangerY);
			}
		break;
		
		case STATES.ThrowGrenade:
			if(ReactionTimer <= 0){
				EnemyThrowGrenade(target_x, target_y);	
			}
		break;
	
		case STATES.LayDownLandMine:
			if(ReactionTimer <= 0){
				EnemyLayDownLandMine();	
			}
		break;
		
		case STATES.Chase:
			if(ReactionTimer <= 0){
				MoveTowards(target_x, target_y, Acceleration*2);
			}
		break;
		
		case STATES.MoveFlashed:
			if(ReactionTimer <= 0){
				if(percent_chance(50 * rank_boost)){
					MoveRunAway(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case STATES.MoveInSmoke:
			if(ReactionTimer <= 0){
				if(percent_chance(10 * rank_less)){
					MoveIdle();
				}
			}
		break;
		
		case STATES.MoveHealing:
			if(ReactionTimer <= 0){
				MoveRunAway(target_x, target_y);
			}
		break;
		
		case STATES.MovePredictive:
			if(ReactionTimer <= 0){
				move_predictive(target_x, target_y);
			}
		break;
	}
	#endregion	

}
#endregion

#region Command state
if(State == STATES.MoveCommand){
    if(point_distance(x, y, target_x, target_y) < 16){
		if(instance_exists(global.local_player) && global.local_player.selected_bot == id){
			global.local_player.command = array_create(array_length(global.local_player.command), -1);
		}
		command_timer = -1;
		command_stuck_timer = -1;
        set_state(STATES.Idle);
    }else{
		if(command_timer > -1){
			command_timer -= global.time_step;
		}
		if(command_stuck_timer > -1){
			command_stuck_timer -= global.time_step;
		}

		var command_failed = command_timer <= 0 && command_timer != -1;
		if(command_stuck_timer <= 0 && command_stuck_timer != -1){
			var command_progress = point_distance(x, y, command_last_x, command_last_y);
			if(command_progress < 2 && point_distance(x, y, target_x, target_y) > 24){
				command_failed = true;
			}else{
				command_last_x = x;
				command_last_y = y;
				command_stuck_timer = command_stuck_time;
			}
		}

		if(command_failed){
			if(instance_exists(global.local_player) && global.local_player.selected_bot == id){
				global.local_player.command = array_create(array_length(global.local_player.command), -1);
			}
			command_timer = -1;
			command_stuck_timer = -1;
			mv_timer = 0;
			MoveTime = 0;
			set_state(STATES.Idle);
		}
    }
}
#endregion
	
#region Shooting state
if (ChasingObject != noone && !bot_target_is_enemy(ChasingObject)) {
	ChasingObject = noone;
	ChasingObjectSpotted = false;
	chasing_available = false;
	shoot_accumulator = 0;
	search_timer = 1;
}

if(global.EnemyCanMove == true && bot_target_is_enemy(ChasingObject)){
    if(ReactionTimer <= 0){
		var shoot_chance = .1 * rank_boost;
		if(chasing_available == true){ shoot_chance = 1; }

        switch(State){
            case STATES.MoveAway:
            case STATES.MoveShoot:
            case STATES.Move:
            case STATES.MoveToward:
            case STATES.MoveAwayFromGrenade:
			case STATES.FleeDanger:
			case STATES.MovePredictive:
			case STATES.MoveCommand:
                try_shoot(0.15 * shoot_chance);
            break;

            case STATES.Chase:
            case STATES.MoveFlashed:
                try_shoot(0.25 * shoot_chance);
            break;

            case STATES.MoveInSmoke:
                try_shoot(0.075 * shoot_chance);
            break;
        }
    }
}
#endregion
	
#region Timers
enemy_aimpunch = lerp(enemy_aimpunch, 0, .5);
stats.Health_points = clamp(stats.Health_points, 0, stats.Max_health_points);
stats.Damage_health_points = clamp(stats.Damage_health_points, 0, stats.Max_health_points);
stats.Stamina_points = clamp(stats.Stamina_points, 0, stats.Max_stamina_points);
stats.Damage_stamina_points = clamp(stats.Damage_stamina_points, 0, stats.Max_stamina_points);
WeaponPositionID = min(WeaponNumber, 1);
has_suppressor = has_attachment(Item.advanced_suppressor, ATTACHMENTS.slot_suppressor, id, WeaponPositionID);
Weapon.x = x;
Weapon.y = y;

if (mv_timer > 0) { mv_timer -= global.time_step; }
if (HPTimer > 0) { HPTimer -= global.time_step; }
if (trigger_texture_timer > 0) { trigger_texture_timer -= global.time_step; }
if (check_danger_timer > 0) { check_danger_timer -= global.time_step; }
if (FlashedTimer > 0 || Reloading) { trigger_texture_timer = trigger_texture_time; }
if (StaminaTimer > 0) { StaminaTimer -= global.time_step; }
if (EquippedGrenadeTimer > -1) {EquippedGrenadeTimer -= global.time_step;}
if (EquippedLandMineTimer > -1) {EquippedLandMineTimer -= global.time_step;}
if (FootStepTimer > -1) {FootStepTimer -= global.time_step;}
if (ReactionTimer > -1) {ReactionTimer -= global.time_step;}
if (FlashedTimer > -1) {FlashedTimer -= global.time_step;}
if (search_timer > -1) {search_timer -= 1;}
if (chasing_timer > -1) {chasing_timer -= 1; }
if(reload_timer > 0){
	reload_timer = max(0, reload_timer - global.time_step);
}
if(Reloading == true){
	var active_reload_time = max(1, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]);
	ReloadTime = min(ReloadTime + global.time_step, active_reload_time);
}else{
	ReloadTime = 0;
	reload_timer = -1;
}

if(search_timer == 0){
	ChasingObject = pick_chasing_object(1024);
	search_timer = refresh_target_timer;
}

if(chasing_timer == 0){
	ChasingObjectSpotted = false;
}

if(instance_exists(ChasingObject)){
	FacingX = ChasingObject.x;
	FacingY = ChasingObject.y;
}


#region Health timer
if(HPTimer == 0){
	var Health = stats.Health_points - attack_damage;
	if(stats.Damage_health_points > Health){
	    stats.Damage_health_points -= stats.Max_health_points/100;
	}else{
	    HPTimer = -1;
	}
}

#endregion

#region Stamina timer
if(StaminaTimer == 0){
	var Stamina = stats.Stamina_points - attack_damage;
	if(stats.Damage_stamina_points > Stamina){
	    stats.Damage_stamina_points -= stats.Max_stamina/100;
	}else{
	    StaminaTimer = -1;
	}
}
#endregion
	
if (abs(enemy_aimpunch) < 0.01) {
	enemy_aimpunch = 0;
}
	
if(WeaponID[WeaponPositionID] == Item.None){
	WeaponPositionID = 1 - WeaponPositionID;
}


if(FlashedTimer == 0){
	Flashed = false;	
}

if(ArmourDurability[0] <= 0){
	ArmourID = Item.None;	
}

if(ArmourDurability[1] <= 0){
	HelmetID = Item.None;	
}

#endregion
	
#region Movement

if(mv_timer <= 0 && State != STATES.MoveCommand && State != STATES.FleeDanger){
	var rand = random(100);    
	if(ChasingObjectSpotted == true && Flashed == false){
		if(ReactionTimer <= 0){
			if(State != STATES.Chase){	
				if(SpottedDanger == false){
			
					#region Move away when low health
					if (stats.Health_points <= stats.Max_health_points / 3) {
						if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
							reload_ai();
						} else if (healing == false && rand < (50 * rank_boost)) {
							if (health_packs > 0) {
								healing_ai();
								healing = true;
								health_packs --;
							} else {
								decide_movement();
							}
						} else {
							decide_movement();
						}
					}
					#endregion
		
					#region Moving when not low health
					if(stats.Health_points > stats.Max_health_points/3){
				
						if(Ammo[WeaponPositionID] <= 0){
							if(Reloading == true){
								reload_ai();
							}				
						}else{	
							decide_movement();
						}
					}
					#endregion
				
				}else{
					
					#region Move away from grenade or landmine or bomb
						if(Ammo[WeaponPositionID] <= 0){
							if(Reloading == true){
								reload_ai();
							}				
						}else{
							
							#region Basic movement
							if(NearestDangerObject != id){
								var t1 = 50 * rank_boost;
								var t2 = t1 + (50 * rank_less);
								var t3 = t2 + 25; // grenade
								// zbytek = landmine

								if(rand < t1){
									if(State != STATES.MoveAwayFromGrenade){
										State = STATES.MoveAwayFromGrenade;
									}
								}else if(rand < t2){
									if(State != STATES.MoveShoot){
										State = STATES.MoveShoot;
									}
								}else if(rand < t3){
									ThrowGrenadeAI();
								}else{
									LayDownLandMineAI();
								}
							}else{
								set_state(STATES.MoveAwayFromGrenade);
							}
							#endregion
							
						}
					#endregion
				
				}	
			}else{	
				
				#region Chase when player has hostage
				if(Ammo[WeaponPositionID] <= 0){
					if(Reloading == true){
						reload_ai();
					}
			
				}
				#endregion
		
			}
		}
	}
	mv_timer = random_range(50, 100) * rank_less;
}
#endregion

#region Smoke
var fog = instance_nearest(x, y, oFog);
if(instance_exists(fog)){
	if(distance_to_object(fog) <= fog.radius && fog.radius >= 100){
		if(fog.alarm[0] > 1){
			if(hidden == false){
				hidden = true;	
			}
		}else{
			if(hidden == true){
				hidden = false;
			}
		}
	}else{
		if(hidden == true){
			hidden = false;	
		}
	}
}
#endregion
	
#region Enemy collision
if(place_meeting(x, y, oBot)) {
	var Enemy = instance_nearest(x, y, oBot); // Get nearest Enemy
	if(Enemy.id != id){
		var dir = point_direction(Enemy.x, Enemy.y, x, y); // Direction from Enemy to player
    
		// Bounce player smoothly by setting acceleration
		AccelX = 5 * cos(degtorad(dir));
		AccelY = -5 * sin(degtorad(dir));
	}
}

// Apply physics
VelocityX += AccelX;
VelocityY += AccelY;

// Wall collision check
var FutureX = x + VelocityX;
var FutureY = y + VelocityY;

if(place_meeting(FutureX, y, oParentTile)) {
	// Collision with wall in x-direction
	VelocityX = -VelocityX * 0.5; // Reflect x-velocity and reduce to simulate energy loss
}

if(place_meeting(x, FutureY, oParentTile)) {
	// Collision with wall in y-direction
	VelocityY = -VelocityY * 0.5; // Reflect y-velocity and reduce to simulate energy loss
}

x += VelocityX;
y += VelocityY;

// Apply friction to smoothly stop the player
VelocityX *= 0.8;
VelocityY *= 0.8;

// Reset acceleration each step to only apply it after collision
AccelX = 0;
AccelY = 0;		
#endregion
	
#region Reloading
if (WeaponID[WeaponPositionID] != Item.None) {
	if (Ammo[WeaponPositionID] > MaxAmmo[WeaponPositionID]) {
		Ammo[WeaponPositionID] = MaxAmmo[WeaponPositionID];
	}
	AmmoNeeded = MaxAmmo[WeaponPositionID] - Ammo[WeaponPositionID];
	  
	if (Ammo[WeaponPositionID] <= 0 && ClipAmmo[WeaponPositionID] > 0 && Reloading == false) {
		var should_reload = true;

		if (Ammo[1 - WeaponPositionID] > 0) {
		    if (percent_chance(50) || WeaponID[1 - WeaponPositionID] == Item.None) {
		        should_reload = true;
		    } else {
		        WeaponPositionID = 1 - WeaponPositionID;
				trigger_texture_timer = trigger_texture_time;
		        WeaponNumber = WeaponPositionID;
		        should_reload = false;
		    }
		}
			
		if (should_reload) {
			trigger_texture_timer = trigger_texture_time;
			ReloadTime = 0;
			Reloading = true;
			reload_timer = max(1, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]);
		}
	}
}

if(Reloading && reload_timer <= 0){
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.BaseDurability] != 1){
		
		#region Normal reloading
		if(WeaponID[WeaponPositionID] != Item.Spas && WeaponID[WeaponPositionID] != Item.Javelin){
			particle_create(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
			random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.AmmoSpriteID], x, y);		
		}
		if (Ammo[WeaponPositionID] < MaxAmmo[WeaponPositionID] && ClipAmmo[WeaponPositionID] > 0) {
			if (ClipAmmo[WeaponPositionID] > AmmoNeeded) {
				ClipAmmo[WeaponPositionID] -= AmmoNeeded;
				Ammo[WeaponPositionID] += AmmoNeeded;
			}else if (ClipAmmo[WeaponPositionID] < AmmoNeeded) {
				Ammo[WeaponPositionID] += ClipAmmo[WeaponPositionID];
				ClipAmmo[WeaponPositionID] -= ClipAmmo[WeaponPositionID];
			} else if (Ammo[WeaponPositionID] + ClipAmmo[WeaponPositionID] = MaxAmmo[WeaponPositionID]) {
				Ammo[WeaponPositionID] = MaxAmmo[WeaponPositionID];
				ClipAmmo[WeaponPositionID] = 0;
			}
		}
		Reloading = false;
		ReloadTime = 0;
		reload_timer = -1;
		#endregion
		
	}else{
		
		#region Fractionating reloading
		Reloading = false;
		ReloadTime = 0;
		if (Ammo[WeaponPositionID] < MaxAmmo[WeaponPositionID] && ClipAmmo[WeaponPositionID] > 0) {
			ClipAmmo[WeaponPositionID] -= 1;
			Ammo[WeaponPositionID] += 1;
		}
		if(Ammo[WeaponPositionID] < MaxAmmo[WeaponPositionID] && ClipAmmo[WeaponPositionID] > 0){
			Reloading = true;
			reload_timer = max(1, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]);
		}else{
			reload_timer = -1;
		}
		#endregion
		
	}
}

#endregion

#region Flashlight
if(FlashLight != undefined){
	if(Weapon != noone && WeaponID[WeaponPositionID] != -1){
		FlashLightX = Weapon.x + lengthdir_x(WeaponDistance, RotationAngle); 
		FlashLightY = Weapon.y + lengthdir_y(WeaponDistance, RotationAngle);
	}else{
		FlashLightX = x;
		FlashLightY = y;
	}
	FlashLight.angle = RotationAngle;
	FlashLight.x = FlashLightX;
	FlashLight.y = FlashLightY;
	Weapon.FlashLightX = FlashLightX;
	Weapon.FlashLightY = FlashLightY;
		
	if(Visible == false){
		FlashLight.visible = false;
	}else{
		FlashLight.visible = true;
	}
}
#endregion

#region Spot a chasing object
if!(instance_exists(ChasingObject)){
	if(search_timer == -1){ search_timer = 1; } /// pokud chasingObject neexistuje, zkus okamžitě hledat
	ChasingObjectSpotted = false;
}else if(chasing_available){
	ChasingObjectSpot(chasing_timer);
}else if(ChasingObjectSpotted == false && State != STATES.MoveCommand && State != STATES.FleeDanger){
	if(Flashed == false){
		set_state(STATES.Idle);			
	}else{
		set_state(STATES.MoveFlashed);	
	}
}

if(Flashed == true && State != STATES.FleeDanger){
	set_state(STATES.MoveFlashed);
}

var ChasingObjectBulletTracer = instance_nearest(x, y, oBulletTracer);
if(instance_exists(ChasingObjectBulletTracer) && instance_exists(ChasingObjectBulletTracer.stats.Object)){
	if(distance_to_object(ChasingObjectBulletTracer) <= 256 && ChasingObjectBulletTracer.stats.Object_index == ChasingObject){
		if(percent_chance(100 * global.ItemIndex[# global.weapon_attachments[min(ChasingObjectBulletTracer.stats.Object.WeaponID, 1)][WPN_ATTACHMENTS.weapon_suppressor], ItemStat.KickBackInaccuracyMultiplier])){
			if(ChasingObjectSpotted == false){
				ChasingObjectSpot(chasing_timer);
			}
		}
	}
}

var ChasingObjectBullet = instance_nearest(x, y, oBullet);
if(instance_exists(ChasingObjectBullet) && instance_exists(ChasingObjectBullet.stats.Object)){
	if(distance_to_object(ChasingObjectBullet) <= 256 && ChasingObjectBullet.stats.Object_index == ChasingObject){
		if(percent_chance(100 * global.ItemIndex[# global.weapon_attachments[min(ChasingObjectBullet.stats.Object.WeaponID, 1)][WPN_ATTACHMENTS.weapon_suppressor], ItemStat.KickBackInaccuracyMultiplier])){
			if(ChasingObjectSpotted == false){
				ChasingObjectSpot(chasing_timer);
			}
		}
	}
}

// Hear the target
if(instance_exists(ChasingObject) && ChasingObject.stats.Team != stats.Team && distance_to_object(ChasingObject) <= ChasingDistance){
	var velocity = sqrt(power(ChasingObject.XSpeed, 2) + power(ChasingObject.YSpeed, 2)) * game_get_speed(gamespeed_fps);
	if(ChasingObject.Moving == true && velocity >= MOVE_SPD/3 && percent_chance(1 * rank_boost)){
		if(ChasingObjectSpotted == false){
			ChasingObjectSpot(chasing_timer);
		}
	}
}
#endregion

#region Throw grenade or lay land mine
if(global.EnemyCanMove == true){
	if (State == STATES.ThrowGrenade && !bot_target_is_enemy(ChasingObject)) {
		EquippedGrenade = Item.None;
		EquippedGrenadeID = Item.None;
		EquippedGrenadeTimer = -1;
		set_state(STATES.Idle);
	}

	if(State == STATES.ThrowGrenade && EquippedGrenadeTimer == -1 && bot_target_is_enemy(ChasingObject)){
		var Target_x, Target_y, GrenadeSpd;
		switch(EquippedGrenadeID){
			case Item.HEGrenade:
				Target_x = ChasingObject.x;
				Target_y = ChasingObject.y;
				GrenadeSpd = 7;
			break;
		
			case Item.FlashBangGrenade:
				var behindAngle = RotationAngle + 180;
				Target_x = x + lengthdir_x(distance_to_object(ChasingObject), behindAngle);
				Target_y = y + lengthdir_y(distance_to_object(ChasingObject), behindAngle);
				GrenadeSpd = 5;
			break;
			
			case Item.SmokeGrenade:
				Target_x = random_range(x - sprite_width, x + sprite_width);
				Target_y = random_range(y - sprite_height, y + sprite_height);
				GrenadeSpd = 1;
			break;
		}
		create_grenade(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
		EquippedGrenade, GrenadeSpd, Target_x, Target_y, EquippedGrenadeID);
		trigger_texture_timer = trigger_texture_time;
		mv_timer = 1;
		grenade_angle = random(360);
		Grenades[EquippedGrenade] --;
		EquippedGrenadeTimer = EquippedGrenadeTime;
		trigger_texture_timer = trigger_texture_time;
	}
	
	if(State == STATES.LayDownLandMine && EquippedLandMineTimer == -1){
		landmine_create(
			x,
			y,
			EquippedLandMineID
		);
		State = STATES.MoveShoot;
		LandMineAngle = random(360);
		LandMines[floor(EquippedLandMine/4)] --;
		EquippedLandMineTimer = EquippedLandMineTime;
		trigger_texture_timer = trigger_texture_time;
	}
}

#endregion

#region Movement
if (--MoveTime > 0) {
	XSpeed += lengthdir_x(Acceleration * 2, MoveDirection);
	YSpeed += lengthdir_y(Acceleration * 2, MoveDirection);
		
	if(FootStepTimer == -1){
		FootStepTimer = 10;
		FootSteps ++;
	}
	if(FootStepTimer == 0){
		if(Visible == true){
			particle_create(round(abs(XSpeed) * random(2)), .8, random(360), spr_MovementParticle, random_range(abs(XSpeed) * -1, abs(XSpeed)), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
			particle_create(1, 0, RotationAngle, spr_FootSteps, 0, 0, RotationAngle, 0, false, false, FootSteps % 2, x, y, .5, 1.5 * game_get_speed(gamespeed_fps));
		}
	}
}
	
///Movement speed limitation
XSpeed = clamp(XSpeed, -MaxSpeed, MaxSpeed);
YSpeed = clamp(YSpeed, -MaxSpeed, MaxSpeed);
	
// Friction
XSpeed = approach(XSpeed, 0, Friction);
YSpeed = approach(YSpeed, 0, Friction);
	
if(XSpeed > 0 || YSpeed > 0){
	Legs.image_speed = 1 * global.time_step;
}else{
	Legs.image_speed = 0;
}
#endregion

#region Facing
var relative_direction = angle_difference(RotationAngle, enemy_aimpunch_direction);
var direction_sign = sign(relative_direction);
var rotation_adjustment = lerp(enemy_aimpunch * direction_sign, 0, .1);
var RotationSpeed = 9;
if(instance_exists(Weapon)){
	if(chasing_available || ChasingObjectSpotted == true){
		var pointdir = point_direction(x,y,FacingX, FacingY);
		Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
		Weapon.x = x;
		Weapon.y = y;
		RotationAngle += (sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 90) + rotation_adjustment) * global.time_step;
		Weapon.image_angle = RotationAngle + KickBackAngle * .5;
		Weapon.RotationAngle = Weapon.image_angle;
	}else{
		var pointdir = MoveDirection;
		Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
		Weapon.x = x;
		Weapon.y = y;
		RotationAngle += (sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 90) + rotation_adjustment) * global.time_step;
		Weapon.image_angle = RotationAngle + KickBackAngle * .5;
		Weapon.RotationAngle = Weapon.image_angle;
	}
	RotationAngle = (RotationAngle % 360 + 360) % 360;
}
#endregion
