function buy_item(ItemID, PositionX, PositionY){
	if(global.player_stats_struct.Money >= global.ItemIndex[#ItemID, ItemStat.Cost]){
		global.player_stats_struct.Money -= global.ItemIndex[#ItemID, ItemStat.Cost];
		ItemDrop(
			ItemID,
			PositionX,
			PositionY,
			100		
		);
	}
}

function create_bullet_tracer(BX, BY, BulletShotX, BulletShotY, BulletImage, BulletItemID, BulletDirection, BS, BulletDistance, BulletObject, BulletDamage, ObjectIndex, ObjectName, BNE, BPD){
	if(instance_exists(BulletObject)){
		if(instance_exists(oParticleSystem) && BulletObject.Visible == true){
			part_type_size(oParticleSystem.Spark, .05, .1,0,.1);
			part_particles_create(global.ParticleSystem, BX, BY, oParticleSystem.Spark, BulletDamage/5);
			part_type_size(oParticleSystem.Spark, .1,.25,0,.1)
		}
	}
	var bullet_tracer = instance_create_layer(BX, BY, "ItemsO", oBulletTracer);
	bullet_tracer.stats = {
		"Speed": BS,
		"Shot_x": BulletShotX,
		"Shot_y": BulletShotY,
		"Damage": BulletDamage,
		"Starting_x": BX,
		"Starting_y": BY,
		"Object": BulletObject,
		"Item_id": BulletItemID,
		"Penetration_damage": BPD,
		"Object_index": ObjectIndex,
		"Object_name": ObjectName,
		"Distance": BulletDistance,
		"Nearest_enemy": BNE
	};
	with(bullet_tracer){
		image_index = BulletImage;
		image_angle = BulletDirection;
		LightObject = new BulbLight(oLightRenderer.lighting, sLightTracer, 0, x, y); 
		LightObject.angle = BulletDirection;
		LightObject.castShadows = false;
		move_towards_point(BulletShotX, BulletShotY, BS);	
	}
}

function create_bullet(BulletX, BulletY, BulletDamage, BulletStartingX, BulletStartingY, BulletObject, BulletItemID, BulletPenetrationDamage, TracerImage, ObjectIndex, ObjectName, BulletDirection){
	var Bullet = instance_create_layer(BulletX, BulletY, "ItemsO", oBullet);
	Bullet.direction = BulletDirection;
	Bullet.stats = {
		"Damage": BulletDamage,
		"Starting_x": BulletStartingX,
		"Starting_y": BulletStartingY,
		"Object": BulletObject,
		"Item_id": BulletItemID,
		"Penetration_damage": BulletPenetrationDamage,
		"Tracer_image": TracerImage,
		"Object_index": ObjectIndex,
		"Object_name": ObjectName
	};
	if(instance_number(oFog) < 10){
		Fog = instance_create_layer(BulletX, BulletY, "OtherO", oFog);
		with(Fog){
			smoke_effect_create(
				BulletDamage/10,
				random(360),
				0.1,
				random_range(.1, .5),
				clamp(ceil(BulletDamage/10), 5, 7.5),
				clamp(BulletDamage/50, .5, .9),
				clamp(BulletDamage/50, .1, .75),
				2 * game_get_speed(gamespeed_fps)
			);	
		}
	}
}

function process_bullet_collision(starting_x, starting_y, current_x, current_y, target_x, target_y, object_type, single_hit) {
    var collision_info = find_collision_point(starting_x, starting_y, target_x, target_y, object_type);
    if (array_length(collision_info) > 0) {
        var collision_details = {
            "x": collision_info[0],
            "y": collision_info[1],
            "instance_id": collision_info[2]
        };
        
        var bullet_distance = point_distance(starting_x, starting_y, current_x, current_y);
        var collision_distance = point_distance(starting_x, starting_y, collision_details.x, collision_details.y);
        
        // Check collision based on single_hit flag
        if ((single_hit && point_distance(current_x, current_y, collision_details.x, collision_details.y) <= speed) ||
            (!single_hit && bullet_distance >= collision_distance)) {
            return collision_details;
        }
    }
    
    return noone;
}

function find_collision_point(x1, y1, x2, y2, object) {
    var tolerance = 1;
    var startX = x1;
    var startY = y1;
    var endX = x2;
    var endY = y2;
    var collidedInstance = noone;

    collidedInstance = collision_line(startX, startY, endX, endY, object, true, false);
    if (collidedInstance == noone) {
        return [];
    }

    // Binary search for the precise collision point
    while (point_distance(startX, startY, endX, endY) > tolerance) {
        var midX = (startX + endX) / 2;
        var midY = (startY + endY) / 2;
        var midCollision = collision_line(x1, y1, midX, midY, object, true, false);

        if (midCollision != noone) {
            // Collision detected; narrow down the search to the first half
            endX = midX;
            endY = midY;
            collidedInstance = midCollision; // Update the collided instance
        } else {
            // No collision detected; narrow down the search to the second half
            startX = midX;
            startY = midY;
        }
    }

    // Check if the collided instance still exists
    if (instance_exists(collidedInstance)) {
        return [endX, endY, collidedInstance];
    } else {
        return [];
    }
}

function item_description_destroy(){
	with(oItemDescription){
		zui_destroy();
	}
	with(oWeaponDescription){
		zui_destroy();
	}	
	with(oArmourDescription){
		zui_destroy();
	}
}

function shouldExplode(ObjectType, Placer) {
    var instance_to_check = instance_nearest(x, y, ObjectType);

    if (instance_exists(instance_to_check)) {
        var isWithinExplosionDistance = distance_to_object(instance_to_check) <= explosion_distance;
        var isNotPlacer = (Placer == noone || instance_to_check != Placer);

        return isWithinExplosionDistance && isNotPlacer;
    }

    return false;
}

function ds_list_to_array(list) {
    var array = [];
    for (var i = 0; i < ds_list_size(list); i++) {
        array_push(array, ds_list_find_value(list, i));
    }
    return array;
}

function Approach(argument0, argument1, argument2) {
	if (argument0 < argument1){
	    return min(argument0 + argument2,argument1); 
	}else{
	    return max(argument0 - argument2,argument1);
	}
}

function camera_set_xy(argument0, argument1, argument2, argument3, argument4) {
	Dist = point_distance(argument0,argument1,argument2,argument3) * argument4;
	Dir = point_direction(argument0,argument1,argument2,argument3);
	x = argument0 + lengthdir_x(Dist,Dir);
	y = argument1 + lengthdir_y(Dist,Dir);
}

function get_angle(desiredDirection, maxTurn) {
    var currentDirection = direction;
    // Normalize angles to range [0, 360)
    var normDesiredDirection = (desiredDirection + 360) % 360;
    var normCurrentDirection = (currentDirection + 360) % 360;
    // Calculate the shortest direction to turn (clockwise or counter-clockwise)
    var diff = normDesiredDirection - normCurrentDirection;
    if (diff > 180) {
        diff -= 360;
    } else if (diff < -180) {
        diff += 360;
    }
    // Clamp the direction change to the maximum turn rate
    // This ensures the projectile turns by at most maxTurn degrees
    if (diff > maxTurn) {
        diff = maxTurn;
    } else if (diff < -maxTurn) {
        diff = -maxTurn;
    }
    return diff;
}

function percent_chance(argument0) {
	randomize();
	return (random(100) <= argument0);
}
	
function statistics_hit(Type, Damage, ObjectType){
	switch(Type){
		case "Health":
			ObjectType.stats.Health_points -= Damage;
			if(ObjectType.HPTimer == -1){
				ObjectType.HPTimer = game_get_speed(gamespeed_fps)*.5;
			}
		break;
		
		case "Stamina":
			ObjectType.StaminaDamage = Damage;
			ObjectType.stats.Stamina_points -= StaminaDamage;
			if(ObjectType.StaminaTimer == -1){
				ObjectType.StaminaTimer = game_get_speed(gamespeed_fps)*.5;	
			}
		break;
	}
}

function average(array, count_zero = true){
    var array_sum = 0;
    var count = 0;

    for(var i = 0; i < array_length(array); i++){
        if(count_zero == true || (array[i] != 0 && count_zero == false)){
            array_sum += array[i];
            count += 1;
        }
    }
    
    if(count == 0){
        return 0;
    }

    return array_sum / count;
}


function sum(array){	
	var array_sum = 0;
	for(var i = 0;i<array_length(array);i++){
		array_sum += array[i];	
	}
	
	return array_sum;
}

function player_shooting(){
	
	if(global.ranked_game == true){
		global.player_stats_struct.All_shots ++;
		oEggyEloRatingSystem.all_shots ++;
	}
	
	#region Create smoke effect
	if(instance_number(oFog) < 10){
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
	}
	#endregion
						
	#region Create bullet casing
	if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.BulletCasingID] != -1){
		ParticleCreate(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
		0, point_direction(oPlayer.x, oPlayer.y, oCrosshair.x, oCrosshair.y) - 180, 0, false, true, global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.BulletCasingID], x, y, 1, 60);
	}
	#endregion
				
	#region Create flash effect
	if(stats.Health_points > 0){
		if(DestroyTimer == -1){
			DestroyTimer = ceil(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer] * 2);
			MuzzleFlashLight = new BulbLight(oLightRenderer.lighting, sLightTorch, 0, FlashLightX, FlashLightY);
			MuzzleFlashLight.angle = RotationAngle;
			MuzzleFlashLight.alpha = FLASHLIGHT_ALPHA * 2;
			MuzzleFlashLight.blend = c_red;
		}
	}
	#endregion
								
	for(i=0;i<global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Bullets];i++){
						
		#region Determine shot position
							
		var prone_kickback = 1;
		if(moving_state == player_states.prone_state){
			prone_kickback = .5;
		}
		var suppressor_multiplier = 1;
		if(global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_suppressor] != Item.None){
			suppressor_multiplier = global.ItemIndex[#global.weapon_attachments[min(WeaponID, 1)][weapon_attachments.weapon_suppressor], ItemStat.Defense];	
		}
		var current_weapon_id = global.weapon_id[min(WeaponID, 2)];
		var inaccuracy_value = global.ItemIndex[# current_weapon_id, ItemStat.Inaccuracy];
		var inaccuracy_calculation = inaccuracy_formula(current_weapon_id, id);
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
			
		if(global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.WeaponTypeClass] == "Anti-tank missile"){
			create_bullet_tracer(
				Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),
				Weapon.y + lengthdir_y(32, RotationAngle),
				ShotX,
				ShotY,
				1,
				global.weapon_id[min(WeaponID, 2)],
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), ShotX, ShotY),
				25,
				-1,
				id,
				global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Damage] * suppressor_multiplier,
				object_index,
				stats.Name,
				instance_nearest(oCrosshair.x, oCrosshair.y, oEnemy),
				0
			);
		}else{
			create_bullet_tracer(
				Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),
				Weapon.y + lengthdir_y(32, RotationAngle),
				ShotX,
				ShotY,
				0,
				global.weapon_id[min(WeaponID, 2)],
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), ShotX, ShotY),
				global.BulletSpeed,
				-1,
				id,
				global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.Damage] * suppressor_multiplier,
				object_index,
				stats.Name,
				noone,
				0
			);
		}
					
	}	
	
}
	
function inaccuracy_formula(WID, ObjectType){
	if(instance_exists(ObjectType)){
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
		}else if(ObjectType.object_index == oFriend){
			if(instance_exists(oFriend)){
				FlashedInaccuracy = 1;
				InSmokeInaccuracy = 1;
				EnemyMovingInaccuracy = 1;
				EnemyRangeInaccuracy = 1 + (point_distance(ObjectType.x, ObjectType.y, ObjectType.ChasingObject.headshot_x, ObjectType.ChasingObject.headshot_x) * 
				global.ItemIndex[#WID, ItemStat.RangeInaccuracyMultiplier]);
			
				if(ObjectType.ChasingObject.InSmoke == true){
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
	}else{
		return 0;	
	}
}

function play_sound(PositionX, PositionY, Sound, instance_id = id, falloff_ref_dist = 100, falloff_max_dist = 2500, falloff_factor = 1.5, Priority = 0) {
	if(instance_exists(instance_id)){
	    //ds_map_add(global.sound_emitters, instance_id.Emitter, Sound);
	    var playerInstance = instance_find(oPlayer, 0);
	    audio_emitter_position(instance_id.Emitter, playerInstance.x - (PositionX - playerInstance.x), PositionY, 0);
	    audio_emitter_falloff(instance_id.Emitter, falloff_ref_dist, falloff_max_dist, falloff_factor);
	    audio_play_sound_on(instance_id.Emitter, Sound, Priority, false);
	    //var alarmTime = audio_sound_length(Sound) * game_get_speed(gamespeed_fps) / 1000;
		//instance_id.alarm[5] = alarmTime;
	}
}
	
function smoke_effect_create(Radius, MoveDirection, MoveSpeed, RotateSpeed, Num, Alpha, Fade, Time){
	radius = Radius;  //size of cloud
	move_dir = MoveDirection;  //movement of particles
	move_speed = MoveSpeed;  //movement of particles
	rotate_speed = RotateSpeed;
	num_cloud_particles = Num;
	cloud_particles[num_cloud_particles,9] = 0;
	image_alpha = Alpha; //cloud alpha
	cloud_fade = Fade;  //governs how quickly clouds particles fade in and out (should be near 1.0
	alarm[0] = Time;

	for (var i = 0; i < num_cloud_particles; i++)
	{
	    cloud_particles[i,0] = ((i / num_cloud_particles)*2-1)*radius;  //x position
	    cloud_particles[i,1] = random_range(-radius,radius)*0.8;  //y position
	    cloud_particles[i,2] = move_speed; //speed
	    cloud_particles[i,3] = image_alpha * power(1.0 - abs(cloud_particles[i,0] / radius),cloud_fade);
	    cloud_particles[i,4] = random(360); //image angle
	    cloud_particles[i,5] = random_range(-rotate_speed,rotate_speed); //rotation rate
	    cloud_particles[i,6] = random_range(5,7)*radius/300;
	    cloud_particles[i,7] = cloud_particles[i,6] * choose(-1,1);
	    cloud_particles[i,8] = irandom(4);
	    cloud_particles[i,9] = c_white;
	}
}
	
function array_shift_left(array, new_value) {
	///Shift all elements in an array to the left
    for (var i = 1; i < array_length(array); i++) {
        array[i - 1] = array[i];
    }
    
    array[array_length(array) - 1] = new_value;
    return array;
}
	
function drop_experience(number, value, xx, yy, position_range){
	for(var i=0;i<number;i++){
		var random_x = random_range(xx - position_range, xx + position_range);
		var random_y = random_range(yy - position_range, yy + position_range);
		var xp_object = instance_create_layer(random_x, random_y, "ItemsO", oExp);
		xp_object.value = value;
	}
}
	
function create_enemy(EnemyBaseHP, EnemyPhysical, EnemyAge, EnemyName, EnemyBaseStamina) {
    var height = EnemyPhysical[0];
    var weight = EnemyPhysical[1];
    var age = EnemyAge;
	
	var Stamina = ceil(EnemyBaseStamina * 1.1*exp(-(power(age - 40, 2)/2)));
    var Health = ceil(EnemyBaseHP + height / 10 + weight / 10 * 1.1 * exp(-(power(age - 40, 2) / 2)));

    var enemy_struct = {
        Health_points: Health,
        Height: height,
        Weight: weight,
        Age: age,
        Name: EnemyName, 
        Damage_health_points: Health,
        Max_health_points: Health,
		Stamina_points: Stamina,
		Damage_stamina_points: Stamina,
		Max_stamina_points: Stamina
    };
	
    return enemy_struct;
}

function create_player(PlayerHP, PlayerStamina, PlayerName){
    var player_struct = {
		Name: PlayerName,
        Health_points: PlayerHP,
		Damage_health_points: PlayerHP,
		Stamina_points: PlayerStamina,
		Damage_stamina_points: PlayerStamina
    };
	
    return player_struct;
}

function pause(ObjectType){
	with(zui_main()){
		with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oPause, -1000)) {
			alpha = global.GUIHUDAlpha * 2.25; alpha_value = 0;
			window_id = id;
		}
	}
	ObjectType.alarm[0] = 1;
}

function unpause(ObjectType){
	with(objZUIMain){
		zui_destroy();
	}
	with(ObjectType){
		PopupWindow = "";
		Alpha = 0;
		BackGround = -1;
		if(sprite_exists(BackGround) && BackGround != -1){sprite_delete(BackGround);}
		instance_activate_all();
	}
}

function set_crosshair_color(ColorString){
	if (string_length(ColorString) == 9) {
		var r = string_copy(ColorString, 1, 3);
		var g = string_copy(ColorString, 4, 3);
		var b = string_copy(ColorString, 7, 3);

		r = real(r);
		g = real(g);
		b = real(b);

		r = clamp(r, 0, 255);
		g = clamp(g, 0, 255);
		b = clamp(b, 0, 255);

		global.crosshair_color = make_color_rgb(r, g, b);
	}
}
	
function reset_gui(){		
	if(instance_exists(oInventory)){
		instance_destroy(oInventory);
		instance_destroy(oSlot);
		instance_create_layer(oPlayer.x, oPlayer.y, "OtherO", oInventory);
	}
	if(instance_exists(oController)){
		instance_destroy(oController);	
		instance_create_depth(0, 0, -1000, oController);
	}
	if(instance_exists(oBuyMenu)){
		with(oBuyMenu){
			zui_destroy();
		}
		instance_destroy(objZUIMain);
		with(zui_main()){
			zui_create(zui_get_width() * .5, zui_get_height() * .5, oBuyMenu);
		}
	}
	if(instance_exists(oDraw)){
		with(oDraw){
			if(PauseMenu == true){
				instance_destroy(objZUIMain);
				pause(id);
			}else if(RespawnMenu == true){
				instance_destroy(objZUIMain);
				with(zui_main()){
					if(other.GameEndMenu == true){
						show_debug_message(global.player_elo_struct.Headshots_per_round);
						with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.55, oGameEndMenu, -1000)) {
							alpha_value = 0;
							alpha = global.GUIHUDAlpha * 2.25; 
							window_id = id;
						}
					}else{
						with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oRoundEndMenu, -1000)) {
							alpha_value = 0;
							alpha = global.GUIHUDAlpha * 2.25; 
							window_id = id;
						}
					}
				}
				alarm[0] = 1;
			}
			
			if(oDraw.DrawInfo == true){
				instance_destroy(objZUIMain);
				with(zui_main()){
					var Id = global.Inventory[#oDraw.var_slot, InventoryIndex.SlotID];
					if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oArmourDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item" || global.ItemIndex[#Id, ItemStat.Type] == "Grenade"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oItemDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oWeaponDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}
				}
			}
		}
	}
}
	
function damage_indicator(DamageIndicatorString, PositionX, PositionY, DamageIndicatorColor, DamageIndicatorSprite, DamageIndicatorSpriteID, DamageIndicatorFont = set_font("Console")) {
	Indicator = instance_create_depth(PositionX, PositionY, -100, oDamageIndicator);
	Indicator.Font = DamageIndicatorFont;
	Indicator.Damage_Indicator = DamageIndicatorString;
	Indicator.Color = DamageIndicatorColor;
	Indicator.Sprite = DamageIndicatorSprite;
	Indicator.SpriteID = DamageIndicatorSpriteID;
}
