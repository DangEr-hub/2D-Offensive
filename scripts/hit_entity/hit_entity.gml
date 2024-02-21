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

function hit_entity(hit_object, /*Bullet.stats.Damage,*/ BodyPart, /*Bullet.stats.Item_id, Bullet.stats.Object,*/ Bullet, /*global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower], Bullet.stats.Penetration_damage*//*,*/ ArmourID, HelmetID, BloodSplashX = other.x, BloodSplashY = other.y){
	if(hit_object.stats.Health_points > 0 && ((hit_object.object_index == oPlayer && global.GodMode == false) || hit_object.object_index != oPlayer)){
		var Damage = Bullet.stats.Damage * power(1 - global.ItemIndex[#Bullet.stats.Item_id, ItemStat.DamageDrop], point_distance(x, y, Bullet.stats.Starting_x, Bullet.stats.Starting_y));
		if(hit_object.object_index == oPlayer){
			Damage *= (1 - global.player_stats_struct.Armour);
		}
		if(BodyPart >= HitBox.LegProne){
			DamageMultiplier = .7;
			BloodColor = c_red;
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.ArmWithoutWeapon){
			DamageMultiplier = .9;
			BloodColor = c_red;
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.BodyWithoutWeapon){
			DamageMultiplier = 1.1;
			BloodColor = c_red;
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if((hit_object.object_index == oPlayer && global.ArmourDurability[0] > 0) || hit_object.ArmourDurability[0] > 0){
				if(global.ItemIndex[#ArmourID, ItemStat.Defense] <= .9){
					hit_object.attack_damage = Damage * global.ItemIndex[#ArmourID, ItemStat.Defense] * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
			if(hit_object.object_index != oPlayer && Bullet.stats.Object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.Head){
			DamageMultiplier = 5;
			BloodColor = c_maroon;
			hit_object.attack_damage = Damage;	
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#HelmetID, ItemStat.Defense]/2 * global.ItemIndex[#Bullet.stats.Item_id, ItemStat.PenetrationPower] / (Bullet.stats.Penetration_damage + 1);
			if((hit_object.object_index == oPlayer && global.ArmourDurability[1] > 0) || hit_object.ArmourDurability[1] > 0){
				if(global.ItemIndex[#HelmetID, ItemStat.Defense] <= .9){
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
			helmet_durability = global.ArmourDurability[1];
			armour_durability = global.ArmourDurability[0];
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
		
		randomize();
		if(hit_object.stats.Health_points <= hit_object.attack_damage){
			if(hit_object.object_index == oEnemy){
				if(BodyPart <= HitBox.HeadProne){
					if(global.ranked_game == true){
						global.player_stats_struct.Headshots ++;
						oEggyEloRatingSystem.headshots ++;
					}
				}else{
					if(global.ranked_game == true){
						global.player_stats_struct.Kills ++;
						oEggyEloRatingSystem.kills ++;
					}
				}
			}	
			var death_sound_effect = choose(snd_Death1, snd_Death2);
			if!(audio_is_playing(death_sound_effect)){
				play_sound(BloodSplashX, BloodSplashY, death_sound_effect, Bullet.stats.Object);
			}
			hit_object.KilledByName = Bullet.stats.Object_name;
			hit_object.KilledByWeapon = global.ItemIndex[#Bullet.stats.Item_id, ItemStat.Name];
			hit_object.stats.Health_points = -1;
		}else{
			statistics_hit("Health", hit_object.attack_damage, hit_object);
		}
		BloodSplashNumber = ceil(hit_object.attack_damage / 5);
		BloodParticleNumber = ceil(hit_object.attack_damage / 2);

	
		if(hit_object.object_index == oPlayer){
			hit_object.AimPunchDir = irandom(3);
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
			if(global.ItemIndex[#ArmourID, ItemStat.Defense] > .9 || armour_durability <= 0 || BodyPart == HitBox.ArmWithAssaultRifle || BodyPart == HitBox.ArmWithoutWeapon || BodyPart == HitBox.ArmWithPistol || BodyPart == HitBox.LegProne){
				var sound_effect = choose(snd_BulletHit1, snd_BulletHit2);
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}else{
				if(hit_object.object_index == oPlayer){
					global.ArmourDurability[0] -= hit_object.attack_damage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];	
					global.ArmourDurability[0] = max(global.ArmourDurability[0], 0);
				}else{
					hit_object.ArmourDurability[0] -= hit_object.attack_damage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];
					hit_object.ArmourDurability[0] = max(hit_object.ArmourDurability[0], 0);
				}
				if(instance_exists(oParticleSystem)){
					part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(hit_object.attack_damage/5));
				}
				var sound_effect = choose(snd_BulletHitArmour1, snd_BulletHitArmour2);
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}
		}else{
			if(global.ItemIndex[#HelmetID, ItemStat.Defense] > .9 || helmet_durability <= 0){
				var sound_effect = snd_HeadShot;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}else{
				if(hit_object.object_index == oPlayer){
					global.ArmourDurability[1] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];	
					global.ArmourDurability[1] = max(global.ArmourDurability[1], 0);
				}else{
					hit_object.ArmourDurability[1] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];
					hit_object.ArmourDurability[1] = max(hit_object.ArmourDurability[1], 0);
				}
				if(instance_exists(oParticleSystem)){
					part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(hit_object.attack_damage/5));
				}
				var sound_effect = snd_HeadShotHelmet;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, Bullet.stats.Object);
				}
			}
		}
		damage_indicator("-" + string(hit_object.attack_damage), BloodSplashX, BloodSplashY, c_white, spr_Icons, icons.health);
		hit_object.attack_damage = 0; ///Nezapomenout vynulovat!!!!!
	}
}