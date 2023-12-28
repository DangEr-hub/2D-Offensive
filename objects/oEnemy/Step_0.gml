event_inherited();

#region Death
if(HP <= 0 && State != States.Death){
    if (ChasingObject.HitMap[? id]) {
        ds_map_delete(ChasingObject.HitMap, id);
    }
	depth += 1;
	Visible = true;
	MoveDirection = RotationAngle;
	XSpeed = 0;
	YSpeed = 0;
	image_angle = MoveDirection;
	mask_index = spr_EnemyBasicDead;	
	instance_destroy(FlashLight);
	instance_destroy(HeadHitBox);
	instance_destroy(BodyHitBox);
	instance_destroy(ArmHitBox);
	instance_destroy(Legs);
	ItemDrop(
		WeaponID[WeaponPositionID], 
		x + lengthdir_x(WeaponDistance, RotationAngle), 
		y + lengthdir_y(WeaponDistance, RotationAngle), 
		10, 
		Ammo[WeaponPositionID],
		ClipAmmo[WeaponPositionID]
	);
	if(ArmourID != Item.None){
		ItemDrop(
			ArmourID, 
			random_range(x - sprite_width/2, x + sprite_width/2), 
			random_range(y - sprite_height/2, y + sprite_height/2), 
			10, 
			0, 
			0,
			ArmourDurability[0]
		);
	}
	if(HelmetID != Item.None){
		ItemDrop(
			HelmetID, 
			random_range(x - sprite_width/2, x + sprite_width/2), 
			random_range(y - sprite_height/2, y + sprite_height/2), 
			10, 
			0, 
			0,
			ArmourDurability[1]
		);
	}
	alarm[4] = DeathTimer;
	State = States.Death;
}

#endregion

if(State != States.Death){
	
	#region Healing kit
	if(healing == true){
		CanShoot = false;
		healing_time ++;
	}
	if(healing_time >= global.ItemIndex[#Item.HealingKit, ItemStat.ReloadSpeed]){
		DamageIndicator("+" + string(global.ItemIndex[#Item.HealingKit, ItemStat.Damage]), x, y - 30, c_green, spr_Icons, 0);
		healing = false;
		CanShoot = true;
		HP += global.ItemIndex[#Item.HealingKit, ItemStat.Damage];
		DamageHP = HP;
		healing_time = -1;
	}
	#endregion
	
	#region Shooting state
	if(global.EnemyCanMove == true){
		var shooting_chance;
		switch(State){
			case States.MoveAway:
				if(ReactionTimer <= 0){
					shooting_chance = min(25 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.MoveShoot:
				if(ReactionTimer <= 0){
					shooting_chance = min(25 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.Move:
				if(ReactionTimer <= 0){
					shooting_chance = min(25 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.MoveToward:
				if(ReactionTimer <= 0){
					shooting_chance = min(25 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.MoveAwayFromGrenade:
				if(ReactionTimer <= 0){
					shooting_chance = min(25 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.Chase:
				if(ReactionTimer <= 0){
					shooting_chance = min(25 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.MoveFlashed:
				if(ReactionTimer <= 0){
					shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		
			case States.MoveInSmoke:
				if(ReactionTimer <= 0){
					shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/2) * global.RankIndex[#Rank, RankStat.BoostModifier], 100);
					if(PercentChance(shooting_chance)){
						EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
					}
				}
			break;
		}
	}
	#endregion
	
	#region Timers
	enemy_aimpunch = lerp(enemy_aimpunch, 0, .5);
	HP = clamp(HP, 0, MaxHP);
	DamageHP = clamp(DamageHP, 0, MaxHP);
	Stamina = clamp(Stamina, 0, MaxStamina);
	DamageStamina = clamp(DamageStamina, 0, MaxStamina);
	WeaponPositionID = min(WeaponNumber, 1);
	FacingX = ChasingObject.x;
	FacingY = ChasingObject.y;
	headshot_x = x - 20;
	headshot_y = y - 18;
	Weapon.x = x;
	Weapon.y = y;

	#region HP timer
	if(HPTimer == 0){
		var Health = HP - AttackDamage;
	    if(DamageHP > Health){
	        DamageHP -= MaxHP/100;
	    }else{
	        HPTimer = -1;
	    }
	}

	if(HPTimer > 0){
	    HPTimer --;
	}
	#endregion

	#region Stamina timer
	if(StaminaTimer == 0){
		var Health = Stamina - AttackDamage;
	    if(DamageStamina > Health){
	        DamageStamina -= MaxStamina/100;
	    }else{
	        StaminaTimer = -1;
	    }
	}

	if(StaminaTimer > 0){
	    StaminaTimer --;
	}
	#endregion
	
	if (abs(enemy_aimpunch) < 0.01) {
	    enemy_aimpunch = 0;
	}
	
	if(WeaponID[WeaponPositionID] == Item.None){
		WeaponPositionID = 1 - WeaponPositionID;
	}
	
	if(EquippedGrenadeTimer > -1){
		EquippedGrenadeTimer --;	
	}

	if(EquippedLandMineTimer > -1){
		EquippedLandMineTimer --;
	}

	if(FootStepTimer > -1){
		FootStepTimer --;	
	}

	if(ReactionTimer > -1){
		ReactionTimer --;
	}

	if(VisibilityTimer > -1){
		VisibilityTimer --;	
	}

	if(VisibilityTimer == 0){
		Visible = false;	
	}

	if(FlashedTimer > -1){
		FlashedTimer --;
	}

	if(FlashedTimer == 0){
		Flashed = false;	
	}

	if(InfraVisionIntensity < 1.25){
		if(instance_exists(infra_vision_light)){
			instance_destroy(infra_vision_light);
		}
	}

	if(ArmourDurability[0] <= 0){
		ArmourID = Item.None;	
	}

	if(ArmourDurability[1] <= 0){
		HelmetID = Item.None;	
	}

	if(ChasingObject != oPlayer){
		if!(instance_exists(ChasingObject)){
			ChasingObject = oPlayer;	
		}
	}

	#endregion
	
	#region In smoke
	if(instance_exists(oFog)){
		var NearestFog = instance_nearest(x, y, oFog);
		if(instance_exists(NearestFog)){
			if(distance_to_object(NearestFog) <= NearestFog.radius){
				if(NearestFog.alarm[0] > 1){
					if(InSmoke == false){
						InSmoke = true;	
					}
				}else{
					if(InSmoke == true){
						InSmoke = false;
					}
				}
			}else{
				if(InSmoke == true){
					InSmoke = false;	
				}
			}
		}
	}
	#endregion
	
	#region Infra vision
	if(oPlayer.ToggleInfraVision == true){
		if!(instance_exists(infra_vision_light)){
			infra_vision_light = instance_create_depth(headshot_x, headshot_y, depth, oObjectLightCircle);
			infra_vision_light.Object = self;
			
			with(infra_vision_light){
				light[| eLight.Color] = $FF0000FF;
			}
		}
		
		if(Visible == false){
			with(infra_vision_light){
				light[| eLight.Intensity] = 0;	
			}
		}else{
			with(infra_vision_light){
				light[| eLight.Intensity] = 1.5;	
			}
		}
		
	}else{
		if(instance_exists(infra_vision_light)){
			instance_destroy(infra_vision_light);
		}
	}	
	#endregion
	
	#region Enemy collision
	if(place_meeting(x, y, oEnemy)) {
	    var Enemy = instance_nearest(x, y, oEnemy); // Get nearest Enemy
		if(Enemy.State != States.Death && Enemy.id != id){
		    var dir = point_direction(Enemy.x, Enemy.y, x, y); // Direction from Enemy to player
    
			// Bounce player smoothly by setting acceleration
			AccelX = 5 * cos(degtorad(dir));
			AccelY = -5 * sin(degtorad(dir));  // Negative because GM's Y axis is inverted
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
	
	#region Visibility
	if(instance_exists(oPlayer)){
		if (
			point_in_triangle(bbox_left, bbox_top, oPlayer.ax, oPlayer.ay, 
			oPlayer.bx, oPlayer.by, 
			oPlayer.cx, oPlayer.cy) || 
			point_in_triangle(bbox_right, bbox_top, oPlayer.ax, oPlayer.ay, 
			oPlayer.bx, oPlayer.by, 
			oPlayer.cx, oPlayer.cy) || 
			point_in_triangle(bbox_left, bbox_bottom, oPlayer.ax, oPlayer.ay, 
			oPlayer.bx, oPlayer.by, 
			oPlayer.cx, oPlayer.cy) || 
			point_in_triangle(bbox_right, bbox_bottom, oPlayer.ax, oPlayer.ay, 
			oPlayer.bx, oPlayer.by, 
			oPlayer.cx, oPlayer.cy)
		|| 
			State == States.ThrowGrenade
		|| 
			HPTimer != -1
		){
			if(InSmoke == false){
				if!(collision_line(x, y, oPlayer.x, oPlayer.y, oParentTile, true, false)){
					Visible = true;
				}else{
					if(Visible == true){
						if(VisibilityTimer == -1){
							VisibilityTimer = VisibilityTime;
						}
					}
				}
			}else{
				if(Visible == true){
					if(VisibilityTimer == -1){
						VisibilityTimer = VisibilityTime;
					}
				}
			}
		}else{
			if(Visible == true){
				if(VisibilityTimer == -1){
					VisibilityTimer = VisibilityTime;
				}
			}
		}
	}
	
	if(Visible == false){
		HeadHitBox.Visible = false;
		BodyHitBox.Visible = false;
		ArmHitBox.Visible = false;
		Weapon.Visible = false;
		Legs.Visible = false;
		with(FlashLight){
			light[| eLight.Intensity] = 0;	
		}
	}else{
		HeadHitBox.Visible = true;
		BodyHitBox.Visible = true;
		ArmHitBox.Visible = true;
		Weapon.Visible = true;
		Legs.Visible = true;
		with(FlashLight){
			light[| eLight.Intensity] = 1.3;	
		}
	}
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
		        if (PercentChance(50) || WeaponID[1 - WeaponPositionID] == Item.None) {
		            should_reload = true;
		        } else {
		            WeaponPositionID = 1 - WeaponPositionID;
		            WeaponNumber = WeaponPositionID;
		            should_reload = false;
		        }
		    }
			
		    if (should_reload) {
		        Reloading = true;
		        alarm[4] = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed];
		    }
		}
	}

	if(Reloading == true){
	    ReloadTime ++;
	}
	#endregion

	#region Flashlight
	if(instance_exists(FlashLight)){
		if(Weapon != noone && WeaponID[WeaponPositionID] != -1){
			FlashLightX = Weapon.x + lengthdir_x(WeaponDistance, RotationAngle); 
			FlashLightY = Weapon.y + lengthdir_y(WeaponDistance, RotationAngle);
		}else{
			FlashLightX = x;
			FlashLightY = y;
		}
		Weapon.FlashLightX = FlashLightX;
		Weapon.FlashLightY = FlashLightY;
	
		if(Visible == false){
			with(FlashLight){
				light[| eLight.Intensity] = 0;
			}
		}else{
			with(FlashLight){
				light[| eLight.Intensity] = 1.3;
			}		
		}
	}
	#endregion

	#region Facing
	var relative_direction = angle_difference(RotationAngle, enemy_aimpunch_direction);
	var direction_sign = sign(relative_direction);
	var rotation_adjustment = lerp(enemy_aimpunch * direction_sign, 0, .1);
	var RotationSpeed = 9;
	if(CheckIfAvailable(ChasingObject) || ChasingObjectSpotted == true){
		pointdir = point_direction(x,y,FacingX, FacingY);
		Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
		Weapon.x = x;
		Weapon.y = y;
		RotationAngle += sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 90) + rotation_adjustment;
		Weapon.image_angle = RotationAngle + KickBackAngle * .5;
		Weapon.RotationAngle = Weapon.image_angle;
	}else{
		pointdir = MoveDirection;
		Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
		Weapon.x = x;
		Weapon.y = y;
		RotationAngle += sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 90) + rotation_adjustment;
		Weapon.image_angle = RotationAngle + KickBackAngle * .5;
		Weapon.RotationAngle = Weapon.image_angle;
	}
	#endregion

	#region Spot a chasing object
	if(instance_exists(oBulletTracer)){
		var ChasingObjectBullet = instance_nearest(x, y, oBulletTracer);
		if(distance_to_object(ChasingObjectBullet) <= 128 && ChasingObjectBullet.Object.object_index == ChasingObject){
			if(PercentChance(100 * global.ItemIndex[#global.weapon_attachments[min(ChasingObjectBullet.Object.WeaponID, 1)][weapon_attachments.weapon_suppressor], ItemStat.KickBackInaccuracyMultiplier])){
				if(ChasingObjectSpotted == false){
					ChasingObjectSpot(ceil(5 * room_speed * global.RankIndex[#Rank, RankStat.BoostModifier]));
				}
			}
		}
	}
	
	if(ChasingObject.HP <= 0 && instance_exists(oPlayer)){
		ChasingObject = oPlayer;	
	}
	#endregion

	#region Throw grenade or lay land mine
	if(State == States.ThrowGrenade && EquippedGrenadeTimer == -1){
		var Target_x, Target_y, GrenadeSpd;
		switch(EquippedGrenadeID){
			case Item.HEGrenade:
				Target_x = ChasingObject.x;
				Target_y = ChasingObject.y;
				GrenadeSpd = 3;
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
		GrenadeCreate(Weapon.x + lengthdir_x(WeaponDistance/2, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance/2, RotationAngle), 
		EquippedGrenade, GrenadeSpd, Target_x, Target_y, EquippedGrenadeID);	
		State = States.MoveShoot;
		grenade_angle = random(360);
		Grenades[EquippedGrenade] --;
		EquippedGrenadeTimer = EquippedGrenadeTime;
	}
	
	if(State == States.LayDownLandMine && EquippedLandMineTimer == -1){
		LandMineCreate(
			x,
			y,
			EquippedLandMineID
		);
		State = States.MoveShoot;
		LandMineAngle = random(360);
		LandMines[floor(EquippedLandMine/4)] --;
		EquippedLandMineTimer = EquippedLandMineTime;
	}

	#endregion

	#region Movement
	if(instance_exists(ChasingObject)){
		if (--MoveTime > 0) {
			XSpeed += lengthdir_x(Acceleration * 2, MoveDirection);
			YSpeed += lengthdir_y(Acceleration * 2, MoveDirection);
		
			if(FootStepTimer == -1){
				FootStepTimer = 5;
				FootSteps ++;
			}
			if(FootStepTimer == 0){
				if(Visible == true){
					ParticleCreate(1, 0, RotationAngle, spr_FootSteps, 0, 0, RotationAngle, 0, false, false, FootSteps % 2, x, y, .5, 1.5 * room_speed);
				}
			}
		}
	
		///Movement speed limitation
		XSpeed = clamp(XSpeed, -MaxSpeed, MaxSpeed);
		YSpeed = clamp(YSpeed, -MaxSpeed, MaxSpeed);
	
		// Friction
		XSpeed = Approach(XSpeed, 0, Friction);
		YSpeed = Approach(YSpeed, 0, Friction);
	
		if(XSpeed > 0 || YSpeed > 0){
			Legs.image_speed = 1;
		}else{
			Legs.image_speed = 0;
		}
	}
	#endregion

	#region Spot a grenade and landmine
	// Initialize variables to hold nearest instances and their distances
	var nearestGrenade, nearestLandMine;
	var distToGrenade = 10000, distToLandMine = 10000;

	if (instance_exists(oGrenade)) {
	    nearestGrenade = instance_nearest(x, y, oGrenade);
	    distToGrenade = distance_to_object(nearestGrenade);
	}

	if (instance_exists(oLandMine)) {
	    nearestLandMine = instance_nearest(x, y, oLandMine);
	    distToLandMine = distance_to_object(nearestLandMine);
	}

	if (distToGrenade <= 256 || distToLandMine <= 256) {
	    SpottedDanger = true;
    
	    // Check which danger is closer
	    if (distToGrenade <= distToLandMine) {
	        NearestDangerX = nearestGrenade.x;
	        NearestDangerY = nearestGrenade.y;
	        NearestDangerObject = nearestGrenade.Object;
	    } else {
	        NearestDangerX = nearestLandMine.x;
	        NearestDangerY = nearestLandMine.y;
	        NearestDangerObject = nearestLandMine.Object;
	    }

		if(NearestDangerObject != noone){
		    if (!ChasingObjectSpotted) {
		        ChasingObjectSpot(ceil(5 * room_speed * global.RankIndex[#Rank, RankStat.BoostModifier]));
		    }
		}
	}
	#endregion

	#region Texture
	if(EquippedGrenadeTimer == -1 && EquippedLandMineTimer == -1){
		switch(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Name]){
			case "AKM":
				Weapon.image_index = 1;
			break;
			
			case "IMI Desert eagle":
				Weapon.image_index = 2;
			break;
			
			case "Spas-12":
				Weapon.image_index = 3;
			break;
			
			case "Steyr SSG 08":
				Weapon.image_index = 4;
			break;
			
			case "MAC11":
				Weapon.image_index = 5;
			break;
			
			case "SIG SG550":
				Weapon.image_index = 6;
			break;
			
			case "FGM-148 Javelin":
				Weapon.image_index = 7;
			break;
			
			case "Glock-17":
				Weapon.image_index = 8;
			break;
			
			case "M4A1":
				Weapon.image_index = 9;
			break;
			
			case "AWM":
				Weapon.image_index = 10;
			break;
			
			default:
				Weapon.image_index = 0;
			break;
		}
		switch(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass]){
			case "Assault rifle":
				BodyHitBox.image_index = HitBox.BodyWithWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
						image_index = 2;
						ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
					}else{
						image_index = 6;
						ArmHitBox.image_index = HitBox.ArmReloading;
					}
				}else{
					image_index = 4;
					ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
				}
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .85;
			break;
	
			case "Pistol":
				BodyHitBox.image_index = HitBox.BodyWithWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
						image_index = 1;
						ArmHitBox.image_index = HitBox.ArmWithPistol;
					}else{
						image_index = 6;
						ArmHitBox.image_index = HitBox.ArmReloading;
					}
				}else{
					image_index = 4;
					ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
				}
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .75;
			break;
			
			case "Submachine gun":
				BodyHitBox.image_index = HitBox.BodyWithWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
						image_index = 1;
						ArmHitBox.image_index = HitBox.ArmWithPistol;
					}else{
						image_index = 6;
						ArmHitBox.image_index = HitBox.ArmReloading;
					}
				}else{
					image_index = 4;
					ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
				}
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .75;
			break;
	
			case "Sniper rifle":
				BodyHitBox.image_index = HitBox.BodyWithWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
						image_index = 2;
						ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
					}else{
						image_index = 6;
						ArmHitBox.image_index = HitBox.ArmReloading;
					}
				}else{
					image_index = 4;
					ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
				}
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .95;
			break;
			
			case "Shotgun":
				BodyHitBox.image_index = HitBox.BodyWithWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					image_index = 2;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 4;
					ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
				}
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .85;
			break;
			
			case "Anti-tank missile":
				BodyHitBox.image_index = HitBox.BodyWithWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					image_index = 2;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 4;
					ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
				}
				WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .85;
			break;

			default:
				BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
				if(FlashedTimer <= FlashedTime * .25){
					image_index = 0;
					ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
				}else{
					image_index = 5;
					ArmHitBox.image_index = HitBox.ArmWithoutWeaponFlashed;
				}
				WeaponDistance = sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon) * .85;
			break;
		}
	}else{
		BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
		Weapon.image_index = 0;
		if(FlashedTimer <= FlashedTime * .25){
			image_index = 0;
			ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
		}else{
			image_index = 5;
			ArmHitBox.image_index = HitBox.ArmWithoutWeaponFlashed;
		}
		WeaponDistance = (sprite_get_bbox_right(spr_DrawWeapon) - sprite_get_bbox_left(spr_DrawWeapon)) * .85;
	}
	#endregion

}else{
	InfraVisionIntensity = lerp(InfraVisionIntensity, 0, .005);	
	Weapon.image_index = 0;
	image_index = 3;	
	RotationAngle = MoveDirection;	
	Visible = true;
}