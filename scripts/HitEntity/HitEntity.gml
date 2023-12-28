// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function HitEntity(hit_object, Damage, BodyPart, WeaponID, EnemyID, ObjectPenetrationPower, ObjectPenetrationDamage, ArmourID, HelmetID, BloodSplashX = other.x, BloodSplashY = other.y){
	if(hit_object.HP > 0 && ((hit_object.object_index == oPlayer && global.GodMode == false) || hit_object.object_index != oPlayer)){
		if(BodyPart >= HitBox.LegProne){
			DamageMultiplier = .7;
			BloodColor = c_red;
			hit_object.AttackDamage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.ArmWithoutWeapon){
			DamageMultiplier = .9;
			BloodColor = c_red;
			hit_object.AttackDamage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.BodyWithoutWeapon){
			DamageMultiplier = 1.1;
			BloodColor = c_red;
			hit_object.AttackDamage = Damage;
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if((hit_object.object_index == oPlayer && global.ArmourDurability[0] > 0) || hit_object.ArmourDurability[0] > 0){
				if(global.ItemIndex[#ArmourID, ItemStat.Defense] <= .9){
					hit_object.AttackDamage = Damage * global.ItemIndex[#ArmourID, ItemStat.Defense] * ObjectPenetrationPower;
				}
			}
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.Head){
			DamageMultiplier = 5;
			BloodColor = c_maroon;
			hit_object.AttackDamage = Damage;	
			hit_object.AimPunchTimer = hit_object.AimPunchTime;
			hit_object.AimPunchMultiplier = global.ItemIndex[#HelmetID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if((hit_object.object_index == oPlayer && global.ArmourDurability[1] > 0) || hit_object.ArmourDurability[1] > 0){
				if(global.ItemIndex[#HelmetID, ItemStat.Defense] <= .9){
					hit_object.AttackDamage = Damage * global.ItemIndex[#HelmetID, ItemStat.Defense] * ObjectPenetrationPower;
				}
			}
			if(hit_object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 4;	
			}
		}
		
		hit_object.AttackDamage *= DamageMultiplier / (ObjectPenetrationDamage + 1);
		hit_object.AttackDamage = ceil(hit_object.AttackDamage);
		
		var armour_durability, helmet_durability;
		if(hit_object.object_index == oEnemy){
			helmet_durability = hit_object.ArmourDurability[1];
			armour_durability = hit_object.ArmourDurability[0];
			hit_object.enemy_aimpunch = hit_object.AttackDamage;
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
		hit_object.HitMap[? EnemyID][? "DamageReceived"] += hit_object.AttackDamage;

		// If the EnemyID hasn't interacted with this Object yet, initialize the data
		if (!EnemyID.HitMap[? hit_object.id]) {
		    hit_object.EnemyStatsMap = ds_map_create();
		    hit_object.EnemyStatsMap[? "HitsReceived"] = 0;
		    hit_object.EnemyStatsMap[? "DamageReceived"] = 0;
		    hit_object.EnemyStatsMap[? "HitsGiven"] = 0;
		    hit_object.EnemyStatsMap[? "DamageGiven"] = 0;
		    EnemyID.HitMap[? hit_object.id] = hit_object.EnemyStatsMap;
		}

		// Update the data for the damage given by the EnemyID
		EnemyID.HitMap[? hit_object.id][? "HitsGiven"] += 1;
		EnemyID.HitMap[? hit_object.id][? "DamageGiven"] += hit_object.AttackDamage;
		
		randomize();
		if(hit_object.HP <= hit_object.AttackDamage){
			hit_object.HP = -1;
			PlaySound(BloodSplashX, BloodSplashY, choose(snd_Death1, snd_Death2), hit_object);
			hit_object.KilledBy = EnemyID;
			if(WeaponID != -1){
				hit_object.KilledBy.KilledByWeapon = global.ItemIndex[#WeaponID, ItemStat.Name];
			}else if(other.object_index == oShrapnel){
				hit_object.KilledBy.KilledByWeapon = "shrapnel";
			}
		}else{
			with(hit_object){
				statistics_hit("HP", AttackDamage);
			}
		}
		BloodSplashNumber = ceil(hit_object.AttackDamage / 5);
		BloodParticleNumber = ceil(hit_object.AttackDamage / 2);

	
		if(hit_object.object_index == oPlayer){
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
				PlaySound(BloodSplashX, BloodSplashY, choose(snd_BulletHit1, snd_BulletHit2), hit_object);
			}else{
				if(hit_object.object_index == oPlayer){
					global.ArmourDurability[0] -= hit_object.AttackDamage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];	
					global.ArmourDurability[0] = max(global.ArmourDurability[0], 0);
				}else{
					hit_object.ArmourDurability[0] -= hit_object.AttackDamage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];
					hit_object.ArmourDurability[0] = max(hit_object.ArmourDurability[0], 0);
				}
				part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(hit_object.AttackDamage/5));
				PlaySound(BloodSplashX, BloodSplashY, choose(snd_BulletHitArmour1, snd_BulletHitArmour2), hit_object);	
			}
		}else{
			if(global.ItemIndex[#HelmetID, ItemStat.Defense] > .9 || helmet_durability <= 0){
				PlaySound(BloodSplashX, BloodSplashY, snd_HeadShot, hit_object);
			}else{
				if(hit_object.object_index == oPlayer){
					global.ArmourDurability[1] -= hit_object.AttackDamage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];	
					global.ArmourDurability[1] = max(global.ArmourDurability[1], 0);
				}else{
					hit_object.ArmourDurability[1] -= hit_object.AttackDamage/5010/global.ItemIndex[#HelmetID, ItemStat.Defense];
					hit_object.ArmourDurability[1] = max(hit_object.ArmourDurability[1], 0);
				}
				part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(hit_object.AttackDamage/5));
				PlaySound(BloodSplashX, BloodSplashY, snd_HeadShotHelmet, hit_object);	
			}
		}
		DamageIndicator("-" + string(hit_object.AttackDamage), BloodSplashX, BloodSplashY, c_white, spr_Icons, 0);
		hit_object.AttackDamage = 0; ///Nezapomenout vynulovat!!!!!
	}
}