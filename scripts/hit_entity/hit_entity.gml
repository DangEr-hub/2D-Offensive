// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function hit_entity(hit_object, Damage, BodyPart, WeaponID, EnemyID, ObjectPenetrationPower, ObjectPenetrationDamage, ArmourID, HelmetID, BloodSplashX = other.x, BloodSplashY = other.y){
	if(hit_object.stats.Health_points > 0 && ((hit_object.object_index == oPlayer && global.GodMode == false) || hit_object.object_index != oPlayer)){
		if(BodyPart >= HitBox.LegProne){
			DamageMultiplier = .7;
			BloodColor = c_red;
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.ArmWithoutWeapon){
			DamageMultiplier = .9;
			BloodColor = c_red;
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.BodyWithoutWeapon){
			DamageMultiplier = 1.1;
			BloodColor = c_red;
			hit_object.attack_damage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if((hit_object.object_index == oPlayer && global.ArmourDurability[0] > 0) || hit_object.ArmourDurability[0] > 0){
				if(global.ItemIndex[#ArmourID, ItemStat.Defense] <= .9){
					hit_object.attack_damage = Damage * global.ItemIndex[#ArmourID, ItemStat.Defense] * ObjectPenetrationPower;
				}
			}
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.Head){
			DamageMultiplier = 5;
			BloodColor = c_maroon;
			hit_object.attack_damage = Damage;	
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#HelmetID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if((hit_object.object_index == oPlayer && global.ArmourDurability[1] > 0) || hit_object.ArmourDurability[1] > 0){
				if(global.ItemIndex[#HelmetID, ItemStat.Defense] <= .9){
					hit_object.attack_damage = Damage * global.ItemIndex[#HelmetID, ItemStat.Defense] * ObjectPenetrationPower;
				}
			}
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 4;	
			}
		}
		
		hit_object.attack_damage *= DamageMultiplier / (ObjectPenetrationDamage + 1);
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
		
		// If the Object hasn't interacted with this EnemyID yet, initialize the data
		if (!hit_object.HitMap[? EnemyID]) {
		    hit_object.EnemyStatsMap = ds_map_create();
		    hit_object.EnemyStatsMap[? "HitsReceived"] = 0;
		    hit_object.EnemyStatsMap[? "DamageReceived"] = 0;
		    hit_object.EnemyStatsMap[? "HitsGiven"] = 0;
		    hit_object.EnemyStatsMap[? "DamageGiven"] = 0;
		    hit_object.HitMap[? EnemyID] = hit_object.EnemyStatsMap;
		}

		// Update the data for the damage received
		hit_object.HitMap[? EnemyID][? "HitsReceived"] += 1;
		hit_object.HitMap[? EnemyID][? "DamageReceived"] += hit_object.attack_damage;

		// If the EnemyID hasn't interacted with this Object yet, initialize the data
		if !(EnemyID.HitMap[? hit_object.id]) {
		    hit_object.EnemyStatsMap = ds_map_create();
		    hit_object.EnemyStatsMap[? "HitsReceived"] = 0;
		    hit_object.EnemyStatsMap[? "DamageReceived"] = 0;
		    hit_object.EnemyStatsMap[? "HitsGiven"] = 0;
		    hit_object.EnemyStatsMap[? "DamageGiven"] = 0;
		    EnemyID.HitMap[? hit_object.id] = hit_object.EnemyStatsMap;
		}

		// Update the data for the damage given by the EnemyID
		EnemyID.HitMap[? hit_object.id][? "HitsGiven"] += 1;
		EnemyID.HitMap[? hit_object.id][? "DamageGiven"] += hit_object.attack_damage;
		
		randomize();
		if(hit_object.stats.Health_points <= hit_object.attack_damage){
			if(hit_object.object_index == oEnemy){
				show_debug_message(BodyPart);
				if(BodyPart <= HitBox.HeadProne){
					if(global.ranked_game == true){
						oEggyEloRatingSystem.headshots ++;
					}
				}else{
					if(global.ranked_game == true){
						oEggyEloRatingSystem.kills ++;
					}
				}
			}	
			var death_sound_effect = choose(snd_Death1, snd_Death2);
			if!(audio_is_playing(death_sound_effect)){
				play_sound(BloodSplashX, BloodSplashY, death_sound_effect, hit_object);
			}
			hit_object.KilledBy = EnemyID;
			if(WeaponID != -1){
				hit_object.KilledBy.KilledByWeapon = global.ItemIndex[#WeaponID, ItemStat.Name];
			}else if(other.object_index == oShrapnel){
				hit_object.KilledBy.KilledByWeapon = "shrapnel";
			}
			hit_object.stats.Health_points = -1;
		}else{
			statistics_hit("Health", hit_object.attack_damage, hit_object);
		}
		BloodSplashNumber = ceil(hit_object.attack_damage / 5);
		BloodParticleNumber = ceil(hit_object.attack_damage / 2);

	
		if(hit_object.object_index == oPlayer){
			if(global.ranked_game == true){
				global.player_stats_struct.Hit_shots ++;
				oEggyEloRatingSystem.hit_shots ++;
			}
			hit_object.AimPunchDir = irandom(3);
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
					play_sound(BloodSplashX, BloodSplashY, sound_effect, hit_object);
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
					play_sound(BloodSplashX, BloodSplashY, sound_effect, hit_object);
				}
			}
		}else{
			if(global.ItemIndex[#HelmetID, ItemStat.Defense] > .9 || helmet_durability <= 0){
				var sound_effect = snd_HeadShot;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, hit_object);
				}
			}else{
				if(hit_object.object_index == oPlayer){
					global.ArmourDurability[1] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];	
					global.ArmourDurability[1] = max(global.ArmourDurability[1], 0);
				}else{
					hit_object.ArmourDurability[1] -= hit_object.attack_damage/5010/global.ItemIndex[#HelmetID, ItemStat.Defense];
					hit_object.ArmourDurability[1] = max(hit_object.ArmourDurability[1], 0);
				}
				if(instance_exists(oParticleSystem)){
					part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(hit_object.attack_damage/5));
				}
				var sound_effect = snd_HeadShotHelmet;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, hit_object);
				}
			}
		}
		damage_indicator("-" + string(hit_object.attack_damage), BloodSplashX, BloodSplashY, c_white, spr_Icons, icons.health);
		hit_object.attack_damage = 0; ///Nezapomenout vynulovat!!!!!
	}
}