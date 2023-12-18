// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function HitEntity(Object, Damage, BodyPart, WeaponID, EnemyID, ObjectPenetrationPower, ObjectPenetrationDamage, ArmourID, HelmetID, BloodSplashX = other.x, BloodSplashY = other.y){
	if(Object.HP > 0 && ((Object.object_index == oPlayer && global.GodMode == false) || Object.object_index != oPlayer)){
		if(BodyPart >= HitBox.LegProne){
			DamageMultiplier = .7;
			BloodColor = c_red;
			Object.AttackDamage = Damage;
			Object.AimPunchTimer = Object.AimPunchTime;
			Object.AimPunchMultiplier = ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if(Object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.ArmWithoutWeapon){
			DamageMultiplier = .9;
			BloodColor = c_red;
			Object.AttackDamage = Damage;
			Object.AimPunchTimer = Object.AimPunchTime;
			Object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if(Object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.BodyWithoutWeapon){
			DamageMultiplier = 1.1;
			BloodColor = c_red;
			Object.AttackDamage = Damage;
			Object.AimPunchTimer = Object.AimPunchTime;
			Object.AimPunchMultiplier = global.ItemIndex[#ArmourID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if((Object.object_index == oPlayer && global.ArmourDurability[0] > 0) || Object.ArmourDurability[0] > 0){
				if(global.ItemIndex[#ArmourID, ItemStat.Defense] <= .9){
					Object.AttackDamage = Damage * global.ItemIndex[#ArmourID, ItemStat.Defense] * ObjectPenetrationPower;
				}
			}
			if(Object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 0;	
			}
		}else if(BodyPart >= HitBox.Head){
			DamageMultiplier = 5;
			BloodColor = c_maroon;
			Object.AttackDamage = Damage;	
			Object.AimPunchTimer = Object.AimPunchTime;
			Object.AimPunchMultiplier = global.ItemIndex[#HelmetID, ItemStat.Defense]/2 * ObjectPenetrationPower / (ObjectPenetrationDamage + 1);
			if((Object.object_index == oPlayer && global.ArmourDurability[1] > 0) || Object.ArmourDurability[1] > 0){
				if(global.ItemIndex[#HelmetID, ItemStat.Defense] <= .9){
					Object.AttackDamage = Damage * global.ItemIndex[#HelmetID, ItemStat.Defense] * ObjectPenetrationPower;
				}
			}
			if(Object.object_index != oPlayer && EnemyID.object_index == oPlayer){
				oCrosshair.HitMarker = 4;	
			}
		}
		
		Object.AttackDamage *= DamageMultiplier / (ObjectPenetrationDamage + 1);
		Object.AttackDamage = ceil(Object.AttackDamage);	
		
		// If the Object hasn't interacted with this EnemyID yet, initialize the data
		if (!Object.HitMap[? EnemyID]) {
		    Object.EnemyStatsMap = ds_map_create();
		    Object.EnemyStatsMap[? "HitsReceived"] = 0;
		    Object.EnemyStatsMap[? "DamageReceived"] = 0;
		    Object.EnemyStatsMap[? "HitsGiven"] = 0;
		    Object.EnemyStatsMap[? "DamageGiven"] = 0;
		    Object.HitMap[? EnemyID] = Object.EnemyStatsMap;
		}

		// Update the data for the damage received
		Object.HitMap[? EnemyID][? "HitsReceived"] += 1;
		Object.HitMap[? EnemyID][? "DamageReceived"] += Object.AttackDamage;

		// If the EnemyID hasn't interacted with this Object yet, initialize the data
		if (!EnemyID.HitMap[? Object.id]) {
		    Object.EnemyStatsMap = ds_map_create();
		    Object.EnemyStatsMap[? "HitsReceived"] = 0;
		    Object.EnemyStatsMap[? "DamageReceived"] = 0;
		    Object.EnemyStatsMap[? "HitsGiven"] = 0;
		    Object.EnemyStatsMap[? "DamageGiven"] = 0;
		    EnemyID.HitMap[? Object.id] = Object.EnemyStatsMap;
		}

		// Update the data for the damage given by the EnemyID
		EnemyID.HitMap[? Object.id][? "HitsGiven"] += 1;
		EnemyID.HitMap[? Object.id][? "DamageGiven"] += Object.AttackDamage;
		
		randomize();
		if(Object.HP <= Object.AttackDamage){
			Object.HP = -1;
			PlaySound(BloodSplashX, BloodSplashY, choose(snd_Death1, snd_Death2), Object);
			Object.KilledBy = EnemyID;
			if(WeaponID != -1){
				Object.KilledBy.KilledByWeapon = global.ItemIndex[#WeaponID, ItemStat.Name];
			}else if(other.object_index == oShrapnel){
				Object.KilledBy.KilledByWeapon = "shrapnel";
			}
		}else{
			with(Object){
				statistics_hit("HP", AttackDamage);
			}
		}
		BloodSplashNumber = ceil(Object.AttackDamage / 5);
		BloodParticleNumber = ceil(Object.AttackDamage / 2);

	
		if(Object.object_index == oPlayer){
			Object.AimPunchDir = irandom(3);
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
			if(global.ItemIndex[#ArmourID, ItemStat.Defense] > .9 || BodyPart == HitBox.ArmWithAssaultRifle || BodyPart == HitBox.ArmWithoutWeapon || BodyPart == HitBox.ArmWithPistol || BodyPart == HitBox.LegProne){
				PlaySound(BloodSplashX, BloodSplashY, choose(snd_BulletHit1, snd_BulletHit2), Object);
			}else{
				if(Object.object_index == oPlayer){
					global.ArmourDurability[0] -= Object.AttackDamage/10/global.ItemIndex[#ArmourID, ItemStat.Defense];	
					global.ArmourDurability[0] = max(global.ArmourDurability[0], 0);
				}else{
					Object.ArmourDurability[0] -= Object.AttackDamage/10/global.ItemIndex[#ArmourID, ItemStat.Defense];
					Object.ArmourDurability[0] = max(Object.ArmourDurability[0], 0);
				}
				part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(Object.AttackDamage/5));
				PlaySound(BloodSplashX, BloodSplashY, choose(snd_BulletHitArmour1, snd_BulletHitArmour2), Object);	
			}
		}else{
			if(global.ItemIndex[#HelmetID, ItemStat.Defense] > .9){
				PlaySound(BloodSplashX, BloodSplashY, snd_HeadShot, Object);
			}else{
				if(Object.object_index == oPlayer){
					global.ArmourDurability[1] -= Object.AttackDamage/10/global.ItemIndex[#HelmetID, ItemStat.Defense];	
					global.ArmourDurability[1] = max(global.ArmourDurability[1], 0);
				}else{
					Object.ArmourDurability[1] -= Object.AttackDamage/10/global.ItemIndex[#HelmetID, ItemStat.Defense];
					Object.ArmourDurability[1] = max(Object.ArmourDurability[1], 0);
				}
				part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.Spark, ceil(Object.AttackDamage/5));
				PlaySound(BloodSplashX, BloodSplashY, snd_HeadShotHelmet, Object);	
			}
		}
		DamageIndicator("-" + string(Object.AttackDamage), BloodSplashX, BloodSplashY, c_white, spr_Icons, 0);
		Object.AttackDamage = 0; ///Nezapomenout vynulovat!!!!!
	}
}