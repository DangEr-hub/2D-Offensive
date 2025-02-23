function enemy_initalized(hitObj, enemyId) {
    var enemyStatsMap;
	if(instance_exists(enemyId)){
	    if (!ds_map_exists(hitObj.HitMap, enemyId)) {
	        enemyStatsMap = ds_map_create();
	        ds_map_add(enemyStatsMap, "Name", enemyId.stats.Name);
	        ds_map_add(enemyStatsMap, "HitsReceived", 0);
	        ds_map_add(enemyStatsMap, "DamageReceived", 0);
	        ds_map_add(enemyStatsMap, "HitsGiven", 0);
	        ds_map_add(enemyStatsMap, "DamageGiven", 0);
	        hitObj.HitMap[? enemyId] = enemyStatsMap;
	    } else {
	        enemyStatsMap = hitObj.HitMap[? enemyId];
	    }
	    return enemyStatsMap;
	}else{
		return false;
	}
}

function hit_living_object(hit_object, BodyPart, Bullet, ArmourID, HelmetID, BloodSplashX = other.x, BloodSplashY = other.y){
	if(hit_object.stats.Health_points > 0 && ((hit_object.object_index == oPlayer && global.GodMode == false) || hit_object.object_index != oPlayer) && instance_exists(hit_object)){
		var Damage = Bullet.stats.Damage * power(1 - global.ItemIndex[#Bullet.stats.Item_id, ItemStat.DamageDrop], point_distance(x, y, Bullet.stats.Starting_x, Bullet.stats.Starting_y));
		if(hit_object.object_index == oEnemy){
			with(hit_object){
				if(ChasingObjectSpotted == false){
					ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])));
				}
			}
		}
		
		if(hit_object.object_index == oPlayer){
			Damage *= (1 - global.player_stats_struct.Armour);
		}
		if(BodyPart >= HitBox.LegProne){
			DamageMultiplier = LEG_MULTIPLIER;
			BloodColor = c_red;
			hit_object.aimpunch_speed_multiplier = min(1, (1 - (global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1))) / (1 - global.player_stats_struct.Armour) / global.ItemIndex[#ArmourID, ItemStat.Defense]);
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.ArmWithoutWeapon){
			DamageMultiplier = ARM_MULTIPLIER;
			BloodColor = c_red;
			hit_object.aimpunch_speed_multiplier = min(1, (1 - (global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1))) / (1 - global.player_stats_struct.Armour) / global.ItemIndex[#ArmourID, ItemStat.Defense]);
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if((hit_object.object_index == oPlayer && global.Inventory[# OtherSlot.Armour, Index.slot_durability] > 0) || hit_object.ArmourDurability[0] > 0){
				if(global.ItemIndex[#ArmourID, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[#ArmourID, ItemStat.Defense] * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.BodyWithoutWeapon){
			DamageMultiplier = BODY_MULTIPLIER;
			BloodColor = c_red;
			hit_object.aimpunch_speed_multiplier = min(1, (1 - (global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1))) / (1 - global.player_stats_struct.Armour) / global.ItemIndex[#ArmourID, ItemStat.Defense]);
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if((hit_object.object_index == oPlayer && global.Inventory[# OtherSlot.Armour, Index.slot_durability] > 0) || hit_object.ArmourDurability[0] > 0){
				if(global.ItemIndex[#ArmourID, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[#ArmourID, ItemStat.Defense] * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.Head){
			DamageMultiplier = HEADSHOT_MULTIPLIER;
			BloodColor = c_maroon;
			hit_object.aimpunch_speed_multiplier = min(1, (1 - (global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1))) / (1 - global.player_stats_struct.Armour) / global.ItemIndex[#HelmetID, ItemStat.Defense]);
			hit_object.attack_damage = Damage;	
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#HelmetID, ItemStat.Defense]/2 * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if((hit_object.object_index == oPlayer && global.Inventory[# OtherSlot.Helmet, Index.slot_durability] > 0) || hit_object.ArmourDurability[1] > 0){
				if(global.ItemIndex[#HelmetID, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[#HelmetID, ItemStat.Defense] * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 4;	
			}
		}
		
		hit_object.attack_damage *= DamageMultiplier / (Bullet.stats.Penetration_damage + 1);
		hit_object.attack_damage = ceil(hit_object.attack_damage);
		
		var armour_durability, helmet_durability;
		if(hit_object.object_index == oEnemy){
			helmet_durability = hit_object.ArmourDurability[1];
			armour_durability = hit_object.ArmourDurability[0];
			hit_object.enemy_aimpunch = hit_object.attack_damage;
		}else{
			helmet_durability = global.Inventory[# OtherSlot.Helmet, Index.slot_durability];
			armour_durability = global.Inventory[# OtherSlot.Armour, Index.slot_durability];
		}
		
	// When an enemy hits the hit_object
	if(instance_exists(Bullet.stats.Object) && instance_exists(hit_object)){
		var enemyStatsMap = enemy_initalized(hit_object, Bullet.stats.Object);
		ds_map_replace(enemyStatsMap, "HitsReceived", ds_map_find_value(enemyStatsMap, "HitsReceived") + 1);
		ds_map_replace(enemyStatsMap, "DamageReceived", ds_map_find_value(enemyStatsMap, "DamageReceived") + hit_object.attack_damage);

		// When the hit_object hits back the Bullet.stats.Object
		var hitObjectStatsMap = enemy_initalized(Bullet.stats.Object, hit_object.id);
		ds_map_replace(hitObjectStatsMap, "HitsGiven", ds_map_find_value(hitObjectStatsMap, "HitsGiven") + 1);
		ds_map_replace(hitObjectStatsMap, "DamageGiven", ds_map_find_value(hitObjectStatsMap, "DamageGiven") + hit_object.attack_damage);
	}
		
		
		if(hit_object.stats.Health_points <= hit_object.attack_damage){
			if(hit_object.object_index == oEnemy){
				global.player_stats_struct.Money += global.ItemIndex[#Bullet.stats.Item_id, ItemStat.reward];
				if(BodyPart <= HitBox.HeadProne){
					if(global.ranked_game == true){
						global.player_stats_struct.Headshots ++;
						oEggyEloRatingSystem.headshots ++;
					}
				}
				if(global.ranked_game == true){
					global.player_stats_struct.Kills ++;
					oEggyEloRatingSystem.kills ++;
				}
			}	
			//var death_sound_effect = choose(snd_Death1, snd_Death2);
			//if!(audio_is_playing(death_sound_effect)){
			//	play_sound(BloodSplashX, BloodSplashY, death_sound_effect, Bullet.stats.Object);
			//}
			hit_object.KilledByName = Bullet.stats.Object_name;
			hit_object.KilledByWeapon = global.ItemIndex[#Bullet.stats.Item_id, ItemStat.Name];
			hit_object.stats.Health_points = -1;
		}else{
			statistics_hit("Health", hit_object.attack_damage, hit_object);
		}
		BloodSplashNumber = ceil(hit_object.attack_damage / 5);
		BloodParticleNumber = ceil(hit_object.attack_damage / 2);

	
		if(hit_object.object_index == oPlayer){
			hit_object.AimPunchDir = irandom(sprite_get_number(spr_AimPunch) - 1);
		}else{
			if(global.ranked_game == true){
				global.player_stats_struct.Hit_shots ++;
				oEggyEloRatingSystem.hit_shots ++;
			}
		}

		repeat(BloodSplashNumber){
			BloodSplash = instance_create_layer(BloodSplashX, BloodSplashY, "ItemsO", oBloodSplash);
			BloodSplash.image_blend = BloodColor;
		}
		if(instance_exists(oParticleSystem)){
			part_type_color1(oParticleSystem.BloodParticle, BloodColor);
			part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.BloodParticle, BloodParticleNumber);
		}
		if(BodyPart != HitBox.Head){
			if(global.ItemIndex[#ArmourID, ItemStat.Defense] > .95 || armour_durability <= 0 || BodyPart == HitBox.ArmWithAssaultRifle || BodyPart == HitBox.ArmWithoutWeapon || BodyPart == HitBox.ArmWithPistol || BodyPart == HitBox.LegProne){
				var sound_effect = snd_BulletHit;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}else{
				if(hit_object.object_index == oPlayer){
					global.Inventory[# OtherSlot.Armour, Index.slot_durability] -= hit_object.attack_damage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];	
					global.Inventory[# OtherSlot.Armour, Index.slot_durability] = max(global.Inventory[# OtherSlot.Armour, Index.slot_durability], 0);
				}else{
					hit_object.ArmourDurability[0] -= hit_object.attack_damage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];
					hit_object.ArmourDurability[0] = max(hit_object.ArmourDurability[0], 0);
				}
				if(instance_exists(oParticleSystem) && instance_exists(Bullet.stats.Object)){
					var posX = BloodSplashX;
					var posY = BloodSplashY;
					var partSystem = global.ParticleSystem;
					var partType = oParticleSystem.headshot_particle;
					var numParticles = ceil(max(hit_object.attack_damage / 5, 10));

					for (var i = 0; i < numParticles; i++) {
					    var randomDirection = random_range(Bullet.stats.Object.RotationAngle - 180 - 90, Bullet.stats.Object.RotationAngle - 180 + 90);
						part_type_color1(partType, c_gray);
					    part_type_direction(partType, randomDirection, randomDirection, 0, 0);
					    part_type_orientation(partType, randomDirection, randomDirection, 0, 0, false);
					    part_particles_create(partSystem, posX, posY, partType, 1);
						part_type_color1(partType, c_white);
					}
				}
				var sound_effect = choose(snd_BulletHitArmour1, snd_BulletHitArmour2);
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}
		}else{
			if(instance_exists(oParticleSystem) && instance_exists(Bullet.stats.Object)){
				var posX = BloodSplashX;
				var posY = BloodSplashY;
				var partSystem = global.ParticleSystem;
				var partType = oParticleSystem.headshot_particle;
				var numParticles = ceil(max(hit_object.attack_damage / 5, 10));

				for (var i = 0; i < numParticles; i++) {
				    var randomDirection = random_range(Bullet.stats.Object.RotationAngle - 180 - 90, Bullet.stats.Object.RotationAngle - 180 + 90);
				    part_type_direction(partType, randomDirection, randomDirection, 0, 0);
				    part_type_orientation(partType, randomDirection, randomDirection, 0, 0, false);
				    part_particles_create(partSystem, posX, posY, partType, 1);
				}
			}
			if(global.ItemIndex[#HelmetID, ItemStat.Defense] > .95 || helmet_durability <= 0){
				var sound_effect = choose(snd_HeadShot1, snd_HeadShot2);
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}else{
				if(hit_object.object_index == oPlayer){
					global.Inventory[# OtherSlot.Helmet, Index.slot_durability] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];	
					global.Inventory[# OtherSlot.Helmet, Index.slot_durability] = max(global.Inventory[# OtherSlot.Helmet, Index.slot_durability], 0);
				}else{
					hit_object.ArmourDurability[1] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];
					hit_object.ArmourDurability[1] = max(hit_object.ArmourDurability[1], 0);
				}
				var sound_effect = snd_HeadShotHelmet;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}
		}
		damage_indicator("-" + string(ceil(hit_object.attack_damage)), BloodSplashX, BloodSplashY, c_white, spr_Icons, icons.health);
		hit_object.attack_damage = 0; ///Nezapomenout vynulovat!!!!!
	}
}