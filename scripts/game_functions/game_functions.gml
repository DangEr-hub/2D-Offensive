function array_min(arr) {
    var min_value = arr[0];
    for (var i = 1; i < array_length(arr); i++) {
        if (arr[i] < min_value) {
            min_value = arr[i];
        }
    }
    return min_value;
}
	
function window_resize(){
	var window_h_before = window_get_height();
	var display_h_before = display_get_height();
	var extra_h = display_h_before - window_h_before; // Výška titulku a okrajů
	var window_scale = 2;
	
	if(window_get_fullscreen() == true){
		extra_h = 0;
	}

	// Nastavit velikost okna tak, aby vnitřní část byla přesně velikost displeje
	window_set_size(global.window_width, global.window_height + extra_h);
	window_set_rectangle(0, extra_h, global.window_width, global.window_height + extra_h);
	surface_resize(application_surface, global.CameraWidth*window_scale, global.CameraHeight*window_scale + extra_h);
	display_set_gui_size(global.window_width, global.window_height + extra_h);
	camera_set_view_size(CAMERA, global.CameraWidth, global.CameraHeight);	
	window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
}

function array_max(arr) {
    var max_value = arr[0];
    for (var i = 1; i < array_length(arr); i++) {
        if (arr[i] > max_value) {
            max_value = arr[i];
        }
    }
    return max_value;
}

function player_has_machine_gun(){
	return global.Inventory[# OtherSlot.Primary, Index.slot_id] == Item.basic_machine_gun;
}
	
function create_haze_effect(pos_x, pos_y, haze_timer, haze_follow_object, haze_type = "Circle", update_haze_pos = true, haze_width = 64, haze_height = 64){
	var haze = instance_create_layer(pos_x, pos_y, "OtherO", oHazeObject);	
	haze.stats.haze_type = haze_type;
	haze.stats.update_haze_pos = update_haze_pos;
	haze.stats.haze_width = haze_width;
	haze.stats.haze_height = haze_height;
	haze.stats.timer = haze_timer;
	haze.stats.follow_object = haze_follow_object;
}

function buy_item(ItemID){
	if(global.player_stats_struct.Money >= global.ItemIndex[#ItemID, ItemStat.Cost] && !is_inventory_full(ItemID)){
		global.player_stats_struct.Money -= global.ItemIndex[#ItemID, ItemStat.Cost];
		GainItem(
			ItemID,
			1,
			global.ItemIndex[#ItemID, ItemStat.Ammo], 
			global.ItemIndex[#ItemID, ItemStat.ClipAmmo], 
			global.ItemIndex[#ItemID, ItemStat.BaseDurability],
			global.ItemIndex[#ItemID, ItemStat.has_scope],
			global.ItemIndex[#ItemID, ItemStat.has_barrel],
			global.ItemIndex[#ItemID, ItemStat.has_grip],
			global.ItemIndex[#ItemID, ItemStat.has_suppressor],
			false
		);
	}
}

function create_bullet_tracer(BX, BY, BulletShotX, BulletShotY, BulletImage, BulletItemID, BulletDirection, BS, BulletDistance, BulletObject, BulletDamage, ObjectIndex, ObjectName, BNE, BPD, BOPosition){
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
		"Nearest_enemy": BNE,
		"Object_x": BOPosition[0],
		"Object_y": BOPosition[1]
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
	var particles_number = global.ItemIndex[#BulletItemID, ItemStat.Damage]/5;
	if(BulletItemID == Item.base_explosion || BulletItemID == Item.HEGrenade || BulletItemID == Item.StickyGrenade
	|| BulletItemID == Item.CELandMine || BulletItemID == Item.HELandMine
	|| BulletItemID == Item.LELandMine || BulletItemID == Item.nuclear_explosion){
		particles_number = 1;
	}
	
	particle_create(
		particles_number, 
		.8, 
		random(360), 
		spr_MovementParticle, 
		particles_number, 
		random_range(-90, 90),
		random(360),
		1,
		choose(true, false),
		false,
		0,
		BulletX,
		BulletY
	);
	if(instance_exists(oParticleSystem)){
		part_particles_create(global.ParticleSystem, BulletX, BulletY, oParticleSystem.Spark, ceil(particles_number));
		var posX = BulletX;
		var posY = BulletY;
		var partSystem = global.ParticleSystem;
		var partType = oParticleSystem.headshot_particle;
		for (var i = 0; i < ceil(particles_number); i++) {
			var randomDirection = random_range(BulletDirection - 180 - 90, BulletDirection - 180 + 90);
			part_type_color1(partType, c_gray);
			part_type_direction(partType, randomDirection, randomDirection, 0, 0);
			part_type_orientation(partType, randomDirection, randomDirection, 0, 0, false);
			part_particles_create(partSystem, posX, posY, partType, 1);
			part_type_color1(partType, c_white);
		}
	}
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
	if(instance_exists(oItemDescription)){
		with(oItemDescription){
			zui_destroy();
		}
	}
	if(instance_exists(oWeaponDescription)){
		with(oWeaponDescription){
			zui_destroy();
		}	
	}
	if(oArmourDescription){
		with(oArmourDescription){
			zui_destroy();
		}
	}
	if(oUsableItemDescription){
		with(oUsableItemDescription){
			zui_destroy();
		}
	}
}

function shouldExplode(ObjectType, Placer) {
    var instance_to_check = instance_nearest(x, y, ObjectType);

    if (instance_exists(instance_to_check)) {
        var isWithinExplosionDistance = distance_to_object(instance_to_check) <= explosion_distance;
        var isNotPlacer = (Placer == noone || !instance_exists(Placer) || instance_to_check != Placer);

        // Use the landmine's stats.Object_index to determine behavior
        var landminePlacerType = stats.Object_index;

        // Additional check: if the landmine is placed by an enemy, do not trigger for other enemies
        if (landminePlacerType == oEnemy && instance_to_check.object_index == oEnemy) {
            isNotPlacer = false;
        }

        // Check for grenade specific conditions
        if (ObjectType == oGrenade) {
            if (landminePlacerType == oEnemy && instance_to_check.stats.Object_index != oPlayer) {
                return false;
            }
            if (landminePlacerType == oPlayer && instance_to_check.stats.Object_index != oEnemy) {
                return false;
            }
        }

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
	
	return (random(100) <= argument0);
}
	
function statistics_hit(Type, Damage, ObjectType){
	switch(Type){
		case "Health":
			if(ObjectType.stats.Health_points >= ceil(Damage)){
				ObjectType.attack_damage = ceil(Damage);
				ObjectType.stats.Health_points -= ceil(Damage);
			}else{
				ObjectType.attack_damage = ObjectType.stats.Health_points;
				ObjectType.stats.Health_points = 0;
			}
			if(ObjectType.HPTimer == -1){
				ObjectType.HPTimer = game_get_speed(gamespeed_fps)*.5;
			}
		break;
		
		case "Stamina":
			if(ObjectType.stats.Stamina_points >= Damage){
				ObjectType.StaminaDamage = Damage;
				ObjectType.stats.Stamina_points -= Damage;
			}else{
				ObjectType.StaminaDamage = ObjectType.stats.Stamina_points;
				ObjectType.stats.Stamina_points = 0;
			}
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
	if(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.BulletCasingID] != -1){
		particle_create(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
		0, point_direction(oPlayer.x, oPlayer.y, oCrosshair.x, oCrosshair.y) - 180, 0, true, true, global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.BulletCasingID], x, y, 1, 60);
	}
	#endregion
				
	#region Create flash effect
	if(stats.Health_points > 0){
		if(DestroyTimer == -1){
			DestroyTimer = ceil(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.ShootTimer] * 2);
			MuzzleFlashLight = new BulbLight(oLightRenderer.lighting, sLightTorch, 0, FlashLightX, FlashLightY);
			MuzzleFlashLight.angle = RotationAngle;
			MuzzleFlashLight.alpha = FLASHLIGHT_ALPHA * 2;
			MuzzleFlashLight.blend = c_red;
		}
	}
	#endregion
								
	for(i=0;i<global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Bullets];i++){
						
		#region Determine shot position
							
		var prone_kickback = 1;
		if(moving_state == player_states.prone_state){
			prone_kickback = .5;
		}
		var suppressor_multiplier = 1;
		if(global.Inventory[# WeaponID, Index.slot_suppressor] != Item.None){
			suppressor_multiplier = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_suppressor], ItemStat.Defense];	
		}
		var current_weapon_id = global.Inventory[# WeaponID, Index.slot_id];
		var kb_phase_1 = global.ItemIndex[# current_weapon_id, ItemStat.KBPhase1] * prone_kickback;
		var kb_phase_2 = global.ItemIndex[# current_weapon_id, ItemStat.KBPhase2] * prone_kickback;
		var recoil_offset_x = global.ItemIndex[# current_weapon_id, ItemStat.RecoilOffsetX];
		var recoil_offset_y = global.ItemIndex[# current_weapon_id, ItemStat.RecoilOffsetY];
		var horizontal_recoil_multiplier = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_grip], ItemStat.KickBackInaccuracyMultiplier];
		var vertical_recoil_multiplier = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_grip], ItemStat.KickBackPower];		

		if (global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.random_bullet_spread] == true) {
			ShotX = random_range(
				oCrosshair.x - inaccuracy_formula(current_weapon_id, id), 
				oCrosshair.x + inaccuracy_formula(current_weapon_id, id)
			);
			ShotY = random_range(
				oCrosshair.y - inaccuracy_formula(current_weapon_id, id), 
				oCrosshair.y + inaccuracy_formula(current_weapon_id, id)
			);
		} else {
			if (KickBack <= kb_phase_1) {
				ShotX = random_range(oCrosshair.x - inaccuracy_formula(current_weapon_id, id), oCrosshair.x + inaccuracy_formula(current_weapon_id, id)) - KickBack * recoil_offset_x * vertical_recoil_multiplier;
				ShotY = random_range(oCrosshair.y - inaccuracy_formula(current_weapon_id, id), oCrosshair.y + inaccuracy_formula(current_weapon_id, id)) - KickBack * recoil_offset_y * horizontal_recoil_multiplier;

				if (KickBack == kb_phase_1) {
					DeltaX = random_range(oCrosshair.x - inaccuracy_formula(current_weapon_id, id), oCrosshair.x + inaccuracy_formula(current_weapon_id, id)) - ShotX;
					DeltaY = random_range(oCrosshair.y - inaccuracy_formula(current_weapon_id, id), oCrosshair.y + inaccuracy_formula(current_weapon_id, id)) - ShotY;
				}
			} else {
				ShotX = random_range(oCrosshair.x - inaccuracy_formula(current_weapon_id, id) * 0.25, oCrosshair.x + inaccuracy_formula(current_weapon_id, id) * 0.25) - DeltaX;
				ShotY = random_range(oCrosshair.y - inaccuracy_formula(current_weapon_id, id) * 0.25, oCrosshair.y + inaccuracy_formula(current_weapon_id, id) * 0.25) - DeltaY;

				if (KickBack == kb_phase_2) {
					DeltaX = random_range(oCrosshair.x - inaccuracy_formula(current_weapon_id, id) * 0.25, oCrosshair.x + inaccuracy_formula(current_weapon_id, id) * 0.25) - ShotX;
					DeltaY = random_range(oCrosshair.y - inaccuracy_formula(current_weapon_id, id) * 0.25, oCrosshair.y + inaccuracy_formula(current_weapon_id, id) * 0.25) - ShotY;
				}
			}
		}
		#endregion
			
		if(global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] == "Anti-tank missile"){
			create_bullet_tracer(
				Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),
				Weapon.y + lengthdir_y(WeaponDistance, RotationAngle),
				ShotX,
				ShotY,
				1,
				global.Inventory[# WeaponID, Index.slot_id],
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), ShotX, ShotY),
				25,
				-1,
				id,
				global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage] * suppressor_multiplier,
				object_index,
				stats.Name,
				instance_nearest(oCrosshair.x, oCrosshair.y, oEnemy),
				0,
				[id.x, id.y]
			);
		}else{
			create_bullet_tracer(
				Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),
				Weapon.y + lengthdir_y(WeaponDistance, RotationAngle),
				ShotX,
				ShotY,
				0,
				global.Inventory[# WeaponID, Index.slot_id],
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), ShotX, ShotY),
				global.BulletSpeed,
				-1,
				id,
				global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_id], ItemStat.Damage] * suppressor_multiplier,
				object_index,
				stats.Name,
				noone,
				0,
				[id.x, id.y]
			);
		}
					
	}	
	
}
	
function inaccuracy_formula(WID, ObjectType){
	if(instance_exists(ObjectType)){
		if(ObjectType.object_index == oPlayer){
			if(instance_exists(oPlayer)){
				var MovingIn = 1;
				var KickBackIn = 1 + (ObjectType.KickBack * global.ItemIndex[#WID, ItemStat.KickBackInaccuracyMultiplier]);
				var range_inaccuracy = 1 + (ObjectType.Range * global.ItemIndex[#WID, ItemStat.RangeInaccuracyMultiplier]);
				var moving_state_inaccuracy = 1;
	
				if(ObjectType.moving_state == player_states.prone_state){
					moving_state_inaccuracy = .5;	
				}
	
				if(ObjectType.Moving == true){
					MovingIn = global.ItemIndex[#WID, ItemStat.MovingInaccuracyMultiplier];
				}
			
				var ScopeTimerInaccuracy = 1;
				var ScopeInaccuracy = 1;
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
				return
				min(global.ItemIndex[#WID, ItemStat.Inaccuracy] *
				(KickBackIn * MovingIn * range_inaccuracy * ScopeInaccuracy * global.PlayerInaccuracy * moving_state_inaccuracy  * global.ItemIndex[# global.weapon_attachments[min(ObjectType.WeaponID, 1)][weapon_attachments.weapon_suppressor], ItemStat.KickBackPower] * max(ScopeTimerInaccuracy, 1) * ObjectType.stamina_inaccuracy), 175);
			}
		}else if(ObjectType.object_index == oEnemy){
			if(instance_exists(oEnemy)){
				var behind_smoke_inaccuracy = 1;
				var FlashedInaccuracy = 1;
				var InSmokeInaccuracy = 1;
				var EnemyMovingInaccuracy = 1;
				var EnemyRangeInaccuracy = 1 + (point_distance(ObjectType.x, ObjectType.y, ObjectType.ChasingObject.headshot_x, ObjectType.ChasingObject.headshot_x) * 
				global.ItemIndex[#WID, ItemStat.RangeInaccuracyMultiplier]);

				var smoke_list = ds_list_create();
				var smoke_number = collision_line_list(ObjectType.x, ObjectType.y, ObjectType.ChasingObject.headshot_x, ObjectType.ChasingObject.headshot_x, oSmokeTile, true, false, smoke_list, false);
				behind_smoke_inaccuracy = 5 * smoke_number + 1;
				ds_list_destroy(smoke_list);

				if(ObjectType.ChasingObject.hidden == true){
					InSmokeInaccuracy = 5;
				}
			
				if(ObjectType.Flashed == true){
					FlashedInaccuracy = 10;
				}
			
				if(sqrt(power(ObjectType.XSpeed, 2) + power(ObjectType.YSpeed, 2)) > ObjectType.MaxSpeed/2){
					EnemyMovingInaccuracy = global.ItemIndex[#WID, ItemStat.MovingInaccuracyMultiplier];
				}
				
				var inaccuracy_value = min(global.ItemIndex[#WID, ItemStat.Inaccuracy] *
				EnemyMovingInaccuracy * EnemyRangeInaccuracy * (global.ItemIndex[#WID, ItemStat.EnemyInaccuracyCompensation] + 1) * (ObjectType.AimPunchMultiplier + 1) * InSmokeInaccuracy * FlashedInaccuracy * behind_smoke_inaccuracy, 350);
				//show_debug_message(inaccuracy_value);
				return inaccuracy_value;

			}
		}else if(ObjectType.object_index == oFriend){
			if(instance_exists(oFriend)){
				
			}
		}
	}else{
		return 0;	
	}
}

function play_sound(PositionX, PositionY, Sound, instance_id = id, falloff_ref_dist = 100, falloff_max_dist = 2500, falloff_factor = 1.5, Priority = 0) {
	if(instance_exists(instance_id)){
	    var playerInstance = instance_find(oPlayer, 0);
		audio_emitter_gain(instance_id.Emitter, playerInstance.flashed_muffled_sounds);
		audio_emitter_pitch(instance_id.Emitter, playerInstance.flashed_muffled_sounds);
	    audio_emitter_position(instance_id.Emitter, playerInstance.x - (PositionX - playerInstance.x), PositionY, 0);
	    audio_emitter_falloff(instance_id.Emitter, falloff_ref_dist, falloff_max_dist, falloff_factor);
	    audio_play_sound_on(instance_id.Emitter, Sound, Priority, false);
	}
}
	
function smoke_effect_create(Radius, MoveDirection, MoveSpeed, RotateSpeed, Num, Alpha, Fade, Time){
	if(Radius >= 96){
		smoke_tile = instance_create_layer(x, y, "OtherO", oSmokeTile);
		smoke_tile.image_xscale = Radius/smoke_tile.sprite_width*2;
		smoke_tile.image_yscale = Radius/smoke_tile.sprite_height*2;
	}
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
	//part_particles_clear(global.ParticleSystem);
	if(instance_exists(oWeaponAttachments)){
		oPlayer.player_can_shoot = true;
		with(oWeaponAttachments){
			zui_destroy();
		}
	}
	if(instance_exists(oBuyMenu)){
		oPlayer.player_can_shoot = true;
		with(oBuyMenuDescription){
			zui_destroy();
		}
		with(oBuyMenu){
			zui_destroy();
		}
	}
	with(zui_main()){
		zui_create(0, 0, objUIBlack, -1000);
		with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oPause, -1000)) {
			alpha = global.GUIHUDAlpha * 2.25; alpha_value = 0;
			window_id = id;
		}
	}
	camera_set_view_angle(CAMERA, 0);
	ObjectType.alarm[0] = 1;
	window_resize();
}

function unpause(ObjectType){
	with(zui_main()){
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
	if(instance_exists(oWeaponAttachments)){
		with(oWeaponAttachments){
			zui_destroy();
		}
		instance_destroy(objZUIMain);
		with(zui_main()){
			with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
			}
		}
	}
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
						zui_create(0, 0, objUIBlack, -1000);
						with (zui_create(zui_get_width() * 0.5, zui_get_height() * .5, oGameEndMenu, -1000)) {
							alpha_value = 0;
							alpha = global.GUIHUDAlpha * 2.25; 
							window_id = id;
						}
					}else{
						zui_create(0, 0, objUIBlack, -1000);
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
					var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
					if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oArmourDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oItemDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oWeaponDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}else if(global.ItemIndex[#Id, ItemStat.Type] == "Grenade" || global.ItemIndex[#Id, ItemStat.Type] == "Landmine"){
						with(zui_create(zui_get_width() * .5, zui_get_width() * .1, oUsableItemDescription)){
							alpha = global.GUIHUDAlpha * 3;
						}
					}
				}
			}
		}
	}
}
	
function damage_indicator(DamageIndicatorString, PositionX, PositionY, DamageIndicatorColor, DamageIndicatorSprite, DamageIndicatorSpriteID, DamageIndicatorFont = set_font("Console")) {
	if(object_index == oEnemy){
		if(Visible == true){
			Indicator = instance_create_depth(PositionX, PositionY, -100, oDamageIndicator);
			Indicator.Font = DamageIndicatorFont;
			Indicator.Damage_Indicator = DamageIndicatorString;
			Indicator.Color = DamageIndicatorColor;
			Indicator.Sprite = DamageIndicatorSprite;
			Indicator.SpriteID = DamageIndicatorSpriteID;
		}
	}else{
		Indicator = instance_create_depth(PositionX, PositionY, -100, oDamageIndicator);
		Indicator.Font = DamageIndicatorFont;
		Indicator.Damage_Indicator = DamageIndicatorString;
		Indicator.Color = DamageIndicatorColor;
		Indicator.Sprite = DamageIndicatorSprite;
		Indicator.SpriteID = DamageIndicatorSpriteID;
	}
}
