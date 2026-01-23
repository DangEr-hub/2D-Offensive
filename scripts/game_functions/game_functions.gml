function apply_prone_texture(){
	/* player function */
	HeadHB.image_index = HITBOX.HeadProne;
	BodyHB.image_index = HITBOX.BodyProne;

	if(!Flashed){
		if!(ReloadTime >= global.ItemIndex[#wpn_id, ItemStat.ReloadSpeed] * .75){
			anim_base = TEXTURES.prone;
			ArmHB.image_index = HITBOX.ArmProne;
		}else{
			anim_base = TEXTURES.reload_prone;
			ArmHB.image_index = HITBOX.ArmProneReloading;
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

	if(Moving){
		moving_timer--;
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
}

function apply_weapon_texture(tex_normal, body_hb, arm_hb){
	/* player and enemy function */
	HeadHB.image_index = HITBOX.Head;
	var flashed_check = false;
	var wpn = Item.None;
	if(object_index == oPlayer){
		wpn = wpn_id;
		flashed_check = !Flashed;
	}else { flashed_check = (FlashedTimer <= FlashedTime * .25); wpn = WeaponID[WeaponPositionID]; }
	
	if(flashed_check){
		if!(ReloadTime >= global.ItemIndex[# wpn, ItemStat.ReloadSpeed] * .9){
			image_index = tex_normal;
			BodyHB.image_index = body_hb;
			ArmHB.image_index = arm_hb;
		}else{
			image_index = TEXTURES.reload;
			BodyHB.image_index = HITBOX.BodyThrowReload;
			ArmHB.image_index = HITBOX.ArmThrowReload;
		}
	}else{
		image_index = TEXTURES.flashed_weapon;
		ArmHB.image_index = HITBOX.ArmFlashedWeapon;
		HeadHB.image_index = HITBOX.HeadFlashed;
		BodyHB.image_index = HITBOX.BodyFlashedWeapon;
	}
}

function local_to_world(_lx, _ly, _ang = image_angle, obj = id){
    with(obj){
        var ox = (_lx - sprite_xoffset) * image_xscale;
        var oy = (_ly - sprite_yoffset) * image_yscale;

        var c = dcos(_ang);
        var s = dsin(_ang);

        // GML rotace (CW, Y dolů)
        return [
            x + ox * c + oy * s,
            y - ox * s + oy * c
        ];
    }
}

function get_wpn_type(item_id){
	var wpn_type = "Pistol";
	switch(global.ItemIndex[# item_id, ItemStat.WeaponTypeClass]){
		case WEAPON_CLASS.ASSAULT_RIFLE: wpn_type = "Assault rifle"; break;
		case WEAPON_CLASS.SHOTGUN: wpn_type = "Shotgun"; break;
		case WEAPON_CLASS.SNIPER_RIFLE: wpn_type = "Sniper rifle"; break;
		case WEAPON_CLASS.MACHINE_GUN: wpn_type = "Machine gun"; break;
		case WEAPON_CLASS.SUBMACHINE_GUN: wpn_type = "Submachine gun"; break;
		case WEAPON_CLASS.KNIFE: wpn_type = "Knife"; break;
		case WEAPON_CLASS.MISSILE: wpn_type = "Missile"; break;
	}
	return wpn_type;
}


function array_min(arr) {
    var min_value = arr[0];
    for (var i = 1; i < array_length(arr); i++) {
        if (arr[i] < min_value) {
            min_value = arr[i];
        }
    }
    return min_value;
}

function throwing_grenade(){	
	if(object_index == oPlayer){
		if(is_local == true){
			return (EquippedGrenadeTimer > -1);
		}else{
			return network_throw_grenade;	
		}
	}	
	return (EquippedGrenadeTimer > -1);
}

function input_check(keycode, pressed = false, release = false){
    var is_mouse =
        keycode == mb_left ||
        keycode == mb_right ||
        keycode == mb_middle;

    if(is_mouse){
        if(pressed){
            return mouse_check_button_pressed(keycode);
        }
        if(release){
            return mouse_check_button_released(keycode);
        }
        return mouse_check_button(keycode);
    }else{
        if(pressed){
            return keyboard_check_pressed(keycode);
        }
        if(release){
            return keyboard_check_released(keycode);
        }
        return keyboard_check(keycode);
    }
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
	if(global.player_stats_struct.Money >= global.ItemIndex[#ItemID, ItemStat.Cost] && !is_inventory_full(ItemID) && global.ItemIndex[#ItemID, ItemStat.is_locked] == false){
		global.player_stats_struct.Money -= global.ItemIndex[#ItemID, ItemStat.Cost];
		gain_item(
			ItemID,
			1,
			global.ItemIndex[#ItemID, ItemStat.MaxAmmo], 
			global.ItemIndex[#ItemID, ItemStat.ClipAmmo], 
			global.ItemIndex[#ItemID, ItemStat.BaseDurability],
			global.ItemIndex[#ItemID, ItemStat.preattached][$ "scope"] ?? Item.None,
            global.ItemIndex[#ItemID, ItemStat.preattached][$ "barrel"] ?? Item.None,
            global.ItemIndex[#ItemID, ItemStat.preattached][$ "grip"] ?? Item.None,
            global.ItemIndex[#ItemID, ItemStat.preattached][$ "suppressor"] ?? Item.None,
			false
		);
	}
}

function has_attachment(item_id, slot, object = global.local_player, which_slot = 0){
	if!(instance_exists(object)){
		return;
	}	
	var item = Item.None;
	if(object == global.local_player){
		item = global.Inventory[# global.local_player.WeaponID, slot];
	}else{
		item = object.attachments[which_slot][slot];	
	}
	
	with(object){
		return (item == item_id);	
	}
}

function create_bullet_tracer(pos, shot_pos, BulletImage, item_dir_spd_dist, BulletObject, BulletDamage, ObjectIndex, name_vis, BNE, BOPosition, remote = true, local_remote = [true, false], proj_own = [-1, -1], explosion = false){
	var bullet_tracer = instance_create_layer(pos[0], pos[1], "ItemsO", oBulletTracer);
	var bullet_x = shot_pos[0];
	var bullet_y = shot_pos[1];
	
	if(remote == false){
		var random_x = 0;
		var random_y = 0;
		if(point_distance(pos[0], pos[1], shot_pos[0], shot_pos[1]) > item_dir_spd_dist[3]){
			random_x = random_range(
				shot_pos[0] - inaccuracy_formula(item_dir_spd_dist[0], BulletObject), 
				shot_pos[0] + inaccuracy_formula(item_dir_spd_dist[0], BulletObject)
			);
			
			random_y = random_range(
				shot_pos[1] - inaccuracy_formula(item_dir_spd_dist[0], BulletObject), 
				shot_pos[1] + inaccuracy_formula(item_dir_spd_dist[0], BulletObject)
			);
			bullet_x = pos[0] +
			lengthdir_x(item_dir_spd_dist[3], point_direction(pos[0], pos[1], random_x, random_y));
			bullet_y = pos[1] + 
			lengthdir_y(item_dir_spd_dist[3], point_direction(pos[0], pos[1], random_x, random_y));	
		}
	   var proj_id = send_projectile_spawn(
		   [pos[0], pos[1]], 
		   [item_dir_spd_dist[1], item_dir_spd_dist[2], BulletImage, item_dir_spd_dist[3]], 
		   [bullet_x, bullet_y], 
		   BulletDamage, item_dir_spd_dist[0], name_vis[1], name_vis[0]
	   );
	    bullet_tracer.bullet_network_id = proj_id;
		
		if(IS_NET){
			bullet_tracer.stats.Owner_id = oNetworkManager.my_pid;
		}
	}else{
	    bullet_tracer.bullet_network_id = proj_own[0];
	    bullet_tracer.stats.Owner_id = proj_own[1];
	}
	bullet_tracer.stats.Speed = item_dir_spd_dist[2];
	bullet_tracer.stats.Shot_x = bullet_x;
	bullet_tracer.stats.Shot_y = bullet_y;
	bullet_tracer.stats.Damage = BulletDamage;
	bullet_tracer.stats.Starting_x = pos[0];
	bullet_tracer.stats.Starting_y = pos[1];
	bullet_tracer.stats.Object = BulletObject;
	bullet_tracer.stats.Item_id = item_dir_spd_dist[0];
	bullet_tracer.stats.Object_index = ObjectIndex;
	bullet_tracer.stats.Distance = item_dir_spd_dist[3];
	bullet_tracer.stats.Nearest_enemy = BNE;
	bullet_tracer.stats.Object_x = BOPosition[0];
	bullet_tracer.stats.Object_y = BOPosition[1]; 
	bullet_tracer.is_local  = local_remote[0];
	bullet_tracer.is_remote = local_remote[1];		   
	bullet_tracer.stats.Owner_name = name_vis[0];
	bullet_tracer.stats.Owner_visible = name_vis[1];
	
	with(bullet_tracer){
		image_index = BulletImage;
		image_angle = item_dir_spd_dist[1];
		LightObject = new BulbLight(oLightRenderer.lighting, sLightTracer, 0, x, y); 
		LightObject.angle = item_dir_spd_dist[1];
		LightObject.castShadows = false;
		move_towards_point(shot_pos[0], shot_pos[1], item_dir_spd_dist[2]);	
	}
	
	var sound_id = -1;
	var instance_emitter = bullet_tracer.stats.Object;
	var has_suppressor = false;
	
	if(global.ItemIndex[# bullet_tracer.stats.Item_id, ItemStat.Type] == "Weapon" && explosion == false){
		sound_id = global.ItemIndex[# bullet_tracer.stats.Item_id, ItemStat.SoundID];
	}

	if(instance_exists(instance_emitter)){
		if(instance_emitter.object_index == oPlayer){
			if(IS_NET){
			    instance_emitter = find_instance_by_network_id(oPlayer, bullet_tracer.stats.Owner_id);
			    if(bullet_tracer.stats.Owner_id == oNetworkManager.my_pid){
			        instance_emitter = global.local_player;
			    }
			    if(instance_emitter.is_local){
			        has_suppressor =
			            global.Inventory[# instance_emitter.WeaponID, Index.slot_suppressor] == Item.advanced_suppressor;
			    }else{
			        has_suppressor =
			            instance_emitter.network_suppressor == Item.advanced_suppressor;
			    }
			}else{
			    if(bullet_tracer.stats.Object_index == oPlayer){
			        has_suppressor =
			            global.Inventory[# instance_emitter.WeaponID, Index.slot_suppressor] == Item.advanced_suppressor;
			    }
			}
		
		}else if(instance_emitter.object_index == oBot){
			has_suppressor = instance_emitter.has_suppressor;	
		}

		if(has_suppressor){
		    sound_id = snd_Silencer;
		}
	
		if(sound_id != -1){
			play_sound(pos[0], pos[1], sound_id, instance_emitter);
		}
	}
	
	return bullet_tracer;
	
}

function create_bullet(BulletX, BulletY, BulletDamage, BulletStartingX, BulletStartingY, BulletObject, BulletItemID, BulletPenetrationDamage, TracerImage, ObjectIndex, ObjectName, BulletDirection, owner_id){
	var Bullet = instance_create_layer(BulletX, BulletY, "ItemsO", oBullet);
	var damage = BulletDamage * power(1 - global.ItemIndex[# BulletItemID, ItemStat.DamageDrop], point_distance(BulletX, BulletY, BulletStartingX, BulletStartingY)) / (BulletPenetrationDamage + 1);
	
	var particles_number = 1;
	if(TracerImage != 2){
		particles_number = round(damage/5);
		create_fog(BulletX, BulletY, damage/10, random(360), 0.1, random_range(.1, .5), 
			clamp(round(damage/10), 5, 7.5), clamp(damage/50, .5, .9), 
			clamp(damage/50, .1, .75), 2 * game_get_speed(gamespeed_fps)
		);	
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
		part_particles_create(global.ParticleSystem, BulletX, BulletY, oParticleSystem.Spark, particles_number);
		for (var i = 0; i < particles_number; i++) {
			var randomDirection = random_range(BulletDirection - 180 - 90, BulletDirection - 180 + 90);
			part_type_color1(oParticleSystem.headshot_particle, c_gray);
			part_type_direction(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0);
			part_type_orientation(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0, false);
			part_particles_create(global.ParticleSystem, BulletX, BulletY, oParticleSystem.headshot_particle, 1);
			part_type_color1(oParticleSystem.headshot_particle, c_white);
		}
	}
	Bullet.direction = BulletDirection;
	Bullet.stats.Damage = damage;
	Bullet.stats.Starting_x = BulletStartingX;
	Bullet.stats.Starting_y = BulletStartingY;
	Bullet.stats.Object = BulletObject;
	Bullet.stats.Item_id = BulletItemID;
	Bullet.stats.Penetration_damage = BulletPenetrationDamage;
	Bullet.stats.Tracer_image = TracerImage;
	Bullet.stats.Object_index = ObjectIndex;
	Bullet.stats.Owner_name = ObjectName;
	Bullet.stats.Owner_id = owner_id;
	return Bullet;
}
function process_bullet_collision(starting_x, starting_y, current_x, current_y, target_x, target_y, object_type, single_hit) {
    var collision_info = find_collision_point(starting_x, starting_y, target_x, target_y, object_type);
    if (array_length(collision_info) > 0) {
        var collision_details = {
            "xx": collision_info[0],
            "yy": collision_info[1],
            "inst_id": collision_info[2]
        };
        
        var bullet_distance = point_distance(starting_x, starting_y, current_x, current_y);
        var collision_distance = point_distance(starting_x, starting_y, collision_details.xx, collision_details.yy);
        
        // Check collision based on single_hit flag
        if ((single_hit && point_distance(current_x, current_y, collision_details.xx, collision_details.yy) <= speed) ||
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
	    var midCollision = collision_line(startX, startY, midX, midY, object, true, false);

	    if (midCollision != noone) {
	        endX = midX;
	        endY = midY;
	        collidedInstance = midCollision;
	    } else {
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

function should_explode(ObjectType, Placer) {
    var instance_to_check = instance_nearest(x, y, ObjectType);

    if (instance_exists(instance_to_check)) {
        var isWithinExplosionDistance = distance_to_object(instance_to_check) <= explosion_distance;
        var isNotPlacer = (Placer == noone || !instance_exists(Placer) || instance_to_check != Placer);

        // Use the landmine's stats.Object_index to determine behavior
        var landminePlacerType = stats.Object_index;

        // Additional check: if the landmine is placed by an enemy, do not trigger for other enemies
        if (landminePlacerType == oBot && instance_to_check.object_index == oBot) {
            isNotPlacer = false;
        }

        // Check for grenade specific conditions
        if (ObjectType == oGrenade) {
            if (landminePlacerType == oBot && instance_to_check.stats.Object_index != oPlayer) {
                return false;
            }
            if (landminePlacerType == oPlayer && instance_to_check.stats.Object_index != oBot) {
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

function approach(argument0, argument1, argument2) {
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
			if(ObjectType.stats.Health_points >= round(Damage)){
				ObjectType.attack_damage = round(Damage);
				ObjectType.stats.Health_points -= round(Damage);
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

function average(array, count_zero = true, weighted = false, weights = []) {
    var array_sum = 0;
    var weight_sum = 0;
    var count = 0;

    for (var i = 0; i < array_length(array); i++) {
        var val = array[i];
        if (count_zero == true || val != 0) {
            if (weighted && array_length(weights) == array_length(array)) {
                array_sum += val * weights[i];
                weight_sum += weights[i];
            } else {
                array_sum += val;
                count += 1;
            }
        }
    }

    if (weighted && weight_sum > 0) {
        return array_sum / weight_sum;
    } else if (!weighted && count > 0) {
        return array_sum / count;
    } else {
        return 0;
    }
}



function sum(array){	
	var array_sum = 0;
	for(var i = 0;i<array_length(array);i++){
		array_sum += array[i];	
	}
	
	return array_sum;
}

function create_shooting_effects(object){
	with(object){
		
		#region Create smoke effect
		create_fog(FlashLightX, FlashLightY, 20, other.RotationAngle - 180, 5, 5, 10, .1, .75, 
			clamp(global.ItemIndex[#other.wpn_id, ItemStat.ShootTimer], 10, 30),
			[lengthdir_x(5, RotationAngle - 180), lengthdir_y(5, RotationAngle - 180), true]
		);
		#endregion
						
		#region Create bullet casing
		if(global.ItemIndex[#wpn_id, ItemStat.BulletCasingID] != -1){
			particle_create(global.ItemIndex[#wpn_id, ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
			0, RotationAngle - 180, 0, true, true, global.ItemIndex[#wpn_id, ItemStat.BulletCasingID], x, y, 1, 60);
		}
		#endregion
				
		#region Create flash effect
		if(stats.Health_points > 0){
			if(flash_effect_timer == -1){
				flash_effect_timer = round(global.ItemIndex[#wpn_id, ItemStat.ShootTimer] * 2);
				MuzzleFlashLight = new BulbLight(oLightRenderer.lighting, sLightTorch, 0, FlashLightX, FlashLightY);
				MuzzleFlashLight.angle = RotationAngle;
				MuzzleFlashLight.alpha = FLASHLIGHT_ALPHA * 2;
				MuzzleFlashLight.blend = c_red;
			}
		}
		#endregion	
		
		if(instance_exists(oParticleSystem)){
			part_type_size(oParticleSystem.Spark, .05, .1,0,.1);
			part_particles_create(global.ParticleSystem, FlashLightX, FlashLightY, oParticleSystem.Spark, global.ItemIndex[# wpn_id, ItemStat.Damage]/5);
			part_type_size(oParticleSystem.Spark, .1,.25,0,.1)
		}
		
	}
}

function player_shooting(){
	
	if(global.ranked_game == true){
		global.player_stats_struct.All_shots ++;
		oRatingController.all_shots ++;
	}
	
	create_shooting_effects(id);
								
	for(i=0;i<global.ItemIndex[#wpn_id, ItemStat.Bullets];i++){
						
		#region Determine shot position
							
		var prone_kickback = 1;
		if(moving_state == STATES_PLAYER.prone_state){
			prone_kickback = .5;
		}
		var suppressor_multiplier = 1;
		if(global.Inventory[# WeaponID, Index.slot_suppressor] != Item.None){
			suppressor_multiplier = global.ItemIndex[#global.Inventory[# WeaponID, Index.slot_suppressor], ItemStat.Defense];	
		}
		var current_weapon_id = wpn_id;
		var kb_phase_1 = round(global.ItemIndex[# current_weapon_id, ItemStat.KBPhase1] * prone_kickback);
		var kb_phase_2 = round(global.ItemIndex[# current_weapon_id, ItemStat.KBPhase2] * prone_kickback);
		var recoil_offset_x = global.ItemIndex[# current_weapon_id, ItemStat.RecoilOffsetX];
		var recoil_offset_y = global.ItemIndex[# current_weapon_id, ItemStat.RecoilOffsetY];
		var horizontal_recoil_multiplier = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_grip], ItemStat.KickBackInaccuracyMultiplier];
		var vertical_recoil_multiplier = global.ItemIndex[# global.Inventory[# WeaponID, Index.slot_grip], ItemStat.KickBackPower];		

		if (global.ItemIndex[#wpn_id, ItemStat.random_bullet_spread] == true) {
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
			
		if(global.ItemIndex[#wpn_id, ItemStat.WeaponTypeClass] == WEAPON_CLASS.MISSILE){
			create_bullet_tracer(
				[Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),Weapon.y + lengthdir_y(WeaponDistance, RotationAngle)],
				[ShotX,ShotY],
				1,
				[
					wpn_id, 
					point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), ShotX, ShotY),
					25,
					global.ItemIndex[#wpn_id, ItemStat.Range]
				],
				id,
				global.ItemIndex[#wpn_id, ItemStat.Damage] * suppressor_multiplier,
				object_index,
				[stats.Name, Visible],
				instance_nearest(oCrosshair.x, oCrosshair.y, oBot),
				[id.x, id.y],
				false
			);
		}else{
			create_bullet_tracer(
				[Weapon.x + lengthdir_x(WeaponDistance, RotationAngle),Weapon.y + lengthdir_y(WeaponDistance, RotationAngle)],
				[ShotX,ShotY],
				0,
				[
					wpn_id, 
					point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), ShotX, ShotY),
					BULLET_SPEED,
					global.ItemIndex[#wpn_id, ItemStat.Range]
				],
				id,
				global.ItemIndex[#wpn_id, ItemStat.Damage] * suppressor_multiplier,
				object_index,
				[stats.Name, Visible],
				noone,
				[id.x, id.y],
				false
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
				var range_inaccuracy = 1 + (ObjectType.Range * global.ItemIndex[#WID, ItemStat.accuracy_drop]);
				var moving_state_inaccuracy = 1;
	
				if(ObjectType.moving_state == STATES_PLAYER.prone_state){
					moving_state_inaccuracy = .5;	
				}
	
				if(ObjectType.Moving == true){
					MovingIn = global.ItemIndex[#WID, ItemStat.MovingInaccuracyMultiplier];
				}
			
				var ScopeTimerInaccuracy = 1;
				var ScopeInaccuracy = 1;

				if(global.ItemIndex[# WID, ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
					if(ObjectType.ScopeIn == false){
						if(global.ItemIndex[# WID, ItemStat.Defense] == 1){ ///Klasické sniperky
							ScopeTimerInaccuracy = 50;
						}else{ ///Semi-automatické sniperky
							ScopeTimerInaccuracy = 10;	
						}
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
				(KickBackIn * MovingIn * range_inaccuracy * ScopeInaccuracy * global.PlayerInaccuracy * moving_state_inaccuracy  * global.ItemIndex[# global.weapon_attachments[min(ObjectType.WeaponID, 1)][WPN_ATTACHMENTS.weapon_suppressor], ItemStat.KickBackPower] * max(ScopeTimerInaccuracy, 1) * ObjectType.stamina_inaccuracy), 175);
			}
		}else if(ObjectType.object_index == oBot){
			if(instance_exists(oBot)){
				var behind_smoke_inaccuracy = 1;
				var FlashedInaccuracy = 1;
				var InSmokeInaccuracy = 1;
				var EnemyMovingInaccuracy = 1;
				var EnemyRangeInaccuracy = 1 + (point_distance(ObjectType.x, ObjectType.y, ObjectType.ChasingObject.headshot_x, ObjectType.ChasingObject.headshot_x) * 
				global.ItemIndex[#WID, ItemStat.accuracy_drop]);

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
				return inaccuracy_value;

			}
		}
	}	
	return 0;
}

function play_sound(PositionX, PositionY, Sound, inst_id = id, falloff_ref_dist = 100, falloff_max_dist = 2500, falloff_factor = 1.5, Priority = 0) {
	if(instance_exists(inst_id)){
	    var playerInstance = global.local_player;
		audio_emitter_gain(inst_id.Emitter, playerInstance.muffled_sounds);
		audio_emitter_pitch(inst_id.Emitter, playerInstance.muffled_sounds);
	    audio_emitter_position(inst_id.Emitter, playerInstance.x - (PositionX - playerInstance.x), PositionY, 0);
	    audio_emitter_falloff(inst_id.Emitter, falloff_ref_dist, falloff_max_dist, falloff_factor);
	    audio_play_sound_on(inst_id.Emitter, Sound, Priority, false);
	}
}
	
function smoke_setup(Radius, MoveDirection, MoveSpeed, RotateSpeed, Num, Alpha, Fade, Time, move = false){
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
	moving = move;

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
	
	var Stamina = round(EnemyBaseStamina * 1.1*exp(-(power(age - 40, 2)/2)));
    var Health = round(EnemyBaseHP + height / 10 + weight / 10 * 1.1 * exp(-(power(age - 40, 2) / 2)));

    var enemy_struct = {
        Health_points: Health,
        Height: height,
        Weight: weight,
        Age: age,
        Name: EnemyName, 
        Damage_health_points: Health,
		Stamina_points: Stamina,
		Damage_stamina_points: Stamina,
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
