event_inherited();
	
#region Healing kit
if(healing == true){
	CanShoot = false;
	healing_time ++;
}
if(healing_time >= global.ItemIndex[#Item.HealingKit, ItemStat.ReloadSpeed]){
	damage_indicator("+" + string(global.ItemIndex[#Item.HealingKit, ItemStat.Damage]), x, y - 30, c_green, spr_Icons, icons.health);
	healing = false;
	CanShoot = true;
	stats.Health_points += global.ItemIndex[#Item.HealingKit, ItemStat.Damage];
	stats.Damage_health_points = stats.Health_points;
	healing_time = -1;
}
#endregion
	
#region Shooting state
if(global.EnemyCanMove == true && instance_exists(ChasingObject)){
	var shooting_chance = 0;
	switch(State){
		case States.MoveAway:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveShoot:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.Move:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveToward:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveAwayFromGrenade:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.Chase:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveFlashed:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveInSmoke:
			if(ReactionTimer <= 0){
				shooting_chance = min(10 / (global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]), 100);
				if(percent_chance(shooting_chance)){
					EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
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
Weapon.x = x;
Weapon.y = y;

if(instance_exists(ChasingObject) && ChasingObject != noone){
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

if(HPTimer > 0){
	HPTimer --;
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

if(ArmourDurability[0] <= 0){
	ArmourID = Item.None;	
}

if(ArmourDurability[1] <= 0){
	HelmetID = Item.None;	
}

if(ChasingObject != oPlayer){
	if!(instance_exists(ChasingObject) && ChasingObject != noone){
		ChasingObject = oPlayer;	
	}
}

#endregion
	
#region Smoke
if(instance_exists(oFog)){
	var NearestFog = instance_nearest(x, y, oFog);
	if(instance_exists(NearestFog)){
		if(distance_to_object(NearestFog) <= NearestFog.radius){
			if(NearestFog.alarm[0] > 1){
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
}
#endregion
	
#region Enemy collision
if(place_meeting(x, y, oEnemy)) {
	var Enemy = instance_nearest(x, y, oEnemy); // Get nearest Enemy
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
	
#region Visibility
if(global.enemy_visibility == false){
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
		||
			State == States.LayDownLandMine
		){
			var collision_object = collision_line(x, y, oPlayer.x, oPlayer.y, oParentTile, true, false);
			if(collision_object || collision_line(x, y, oPlayer.x, oPlayer.y, oSmokeTile, true, false)){
				if!(oPlayer.moving_state == player_states.machine_gun_state && collision_object.object_index == oMachineGunFloor){
					if(Visible == true){
						if(VisibilityTimer == -1){
							VisibilityTimer = VisibilityTime;
						}
					}
				}else{
					Visible = true;	
				}
			}else{
				Visible = true;
			}
		}else{
			if(Visible == true){
				if(VisibilityTimer == -1){
					VisibilityTimer = VisibilityTime;
				}
			}
		}
	}
}else{
	Visible = true;
}
	
if(Visible == false){
	HeadHitBox.Visible = false;
	BodyHitBox.Visible = false;
	ArmHitBox.Visible = false;
	Weapon.Visible = false;
	Legs.Visible = false;
	//uls_set_light_alpha(FlashLight, 0);
}else{
	HeadHitBox.Visible = true;
	BodyHitBox.Visible = true;
	ArmHitBox.Visible = true;
	Weapon.Visible = true;
	Legs.Visible = true;
	//uls_set_light_alpha(FlashLight, FLASHLIGHT_ALPHA);
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
		    if (percent_chance(50) || WeaponID[1 - WeaponPositionID] == Item.None) {
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
if(instance_exists(oBulletTracer)){
	var ChasingObjectBullet = instance_nearest(x, y, oBulletTracer);
	if(instance_exists(ChasingObjectBullet) && instance_exists(ChasingObjectBullet.stats.Object)){
		if(distance_to_object(ChasingObjectBullet) <= 128 && ChasingObjectBullet.stats.Object_index == ChasingObject){
			if(percent_chance(100 * global.ItemIndex[#global.weapon_attachments[min(ChasingObjectBullet.stats.Object.WeaponID, 1)][weapon_attachments.weapon_suppressor], ItemStat.KickBackInaccuracyMultiplier])){
				if(ChasingObjectSpotted == false){
					ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
				}
			}
		}
	}
}

if(instance_exists(oBullet)){
	var ChasingObjectBullet = instance_nearest(x, y, oBullet);
	if(instance_exists(ChasingObjectBullet) && instance_exists(ChasingObjectBullet.stats.Object)){
		if(distance_to_object(ChasingObjectBullet) <= 128 && ChasingObjectBullet.stats.Object_index == ChasingObject){
			if(percent_chance(100 * global.ItemIndex[#global.weapon_attachments[min(ChasingObjectBullet.stats.Object.WeaponID, 1)][weapon_attachments.weapon_suppressor], ItemStat.KickBackInaccuracyMultiplier])){
				if(ChasingObjectSpotted == false){
					ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
				}
			}
		}
	}
}

// Hear the player
if(ChasingObject.object_index == oPlayer && distance_to_object(ChasingObject) <= ChasingDistance*.75){
	var PlayerVelocity = sqrt(power(ChasingObject.XSpeed, 2) + power(ChasingObject.YSpeed, 2)) * game_get_speed(gamespeed_fps);
	if(ChasingObject.Moving == true && PlayerVelocity >= ChasingObject.MoveSpeed/2 && percent_chance(1 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
		if(ChasingObjectSpotted == false){
			ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
		}
	}
}
	
if(ChasingObject.stats.Health_points <= 0){
	ChasingObject = instance_nearest(x, y, oPlayer);	
}
#endregion

#region Throw grenade or lay land mine
if(global.EnemyCanMove == true){
	if(State == States.ThrowGrenade && EquippedGrenadeTimer == -1){
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
		State = States.MoveShoot;
		grenade_angle = random(360);
		Grenades[EquippedGrenade] --;
		EquippedGrenadeTimer = EquippedGrenadeTime;
	}
	
	if(State == States.LayDownLandMine && EquippedLandMineTimer == -1){
		landmine_create(
			x,
			y,
			EquippedLandMineID
		);
		State = States.MoveShoot;
		LandMineAngle = random(360);
		LandMines[floor(EquippedLandMine/4)] --;
		EquippedLandMineTimer = EquippedLandMineTime;
	}
}

#endregion

#region Movement
if(instance_exists(ChasingObject) && ChasingObject != noone){
	if (--MoveTime > 0) {
		XSpeed += lengthdir_x(Acceleration * 2, MoveDirection);
		YSpeed += lengthdir_y(Acceleration * 2, MoveDirection);
		
		if(FootStepTimer == -1){
			FootStepTimer = 5;
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
NearestDangerX = -1;
NearestDangerX = -1;
var nearestGrenade = noone;
var nearestLandMine = noone;
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
    
	if (distToGrenade <= distToLandMine) {
		if(nearestGrenade.stats.Object_index != oEnemy){
			if (!ChasingObjectSpotted) {
				ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
			}
			SpottedDanger = true;
		    NearestDangerX = nearestGrenade.x;
		    NearestDangerY = nearestGrenade.y;
		    NearestDangerObject = nearestGrenade.stats.Object;
		}
	} else {
		if(nearestLandMine.stats.Object_index != oEnemy){
			if (!ChasingObjectSpotted) {
				ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
			}
			SpottedDanger = true;
			NearestDangerX = nearestLandMine.x;
			NearestDangerY = nearestLandMine.y;
			NearestDangerObject = nearestLandMine.stats.Object;
		}
	}
}else{
	SpottedDanger = false;	
}
#endregion

#region Texture
if(EquippedGrenadeTimer == -1 && EquippedLandMineTimer == -1){
	
	#region Weapon texture
	switch(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Name]){
		case "AKM":
			Weapon.image_index = 1;
		break;
			
		case "Desert Eagle":
			Weapon.image_index = 2;
		break;
			
		case "Spas-12":
			Weapon.image_index = 3;
		break;
			
		case "SSG 08":
			Weapon.image_index = 4;
		break;
			
		case "MAC11":
			Weapon.image_index = 5;
		break;
			
		case "SIG SG550":
			Weapon.image_index = 6;
		break;
			
		case "FGM-148":
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
			
		case "USP":
			Weapon.image_index = 11;
		break;
		
		case "Galil":
			Weapon.image_index = 12;
		break;
		
		case "P250":
			Weapon.image_index = 13;
		break;
			
		case "MK18":
			Weapon.image_index = 14;
		break;
			
		case "FAMAS":
			Weapon.image_index = 15;
		break;
		
		case "TEC-9":
			Weapon.image_index = 16;
		break;
			
		default:
			Weapon.image_index = 0;
		break;
	}
	#endregion
	
	#region Enemy texture
	switch(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass]){
		case "Assault rifle":
			if(FlashedTimer <= FlashedTime * .25){
				if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
					image_index = 2;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 6;
					BodyHitBox.image_index = HitBox.BodyReloading;
					ArmHitBox.image_index = HitBox.ArmReloading;
				}
			}else{
				image_index = 4;
				ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
			}
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
		break;
	
		case "Pistol":
			if(FlashedTimer <= FlashedTime * .25){
				if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
					image_index = 1;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					ArmHitBox.image_index = HitBox.ArmWithPistol;
				}else{
					image_index = 6;
					BodyHitBox.image_index = HitBox.BodyReloading;
					ArmHitBox.image_index = HitBox.ArmReloading;
				}
			}else{
				image_index = 4;
				ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
			}
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .75;
		break;
			
		case "Submachine gun":
			BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
			if(FlashedTimer <= FlashedTime * .25){
				if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
					image_index = 1;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 6;
					BodyHitBox.image_index = HitBox.BodyReloading;
					ArmHitBox.image_index = HitBox.ArmReloading;
				}
			}else{
				image_index = 4;
				ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
			}
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .75;
		break;
	
		case "Sniper rifle":
			BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
			if(FlashedTimer <= FlashedTime * .25){
				if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
					image_index = 2;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 6;
					BodyHitBox.image_index = HitBox.BodyReloading;
					ArmHitBox.image_index = HitBox.ArmReloading;
				}
			}else{
				image_index = 4;
				ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
			}
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .95;
		break;
			
		case "Shotgun":
			BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
			if(FlashedTimer <= FlashedTime * .25){
				if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
					image_index = 2;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 6;
					BodyHitBox.image_index = HitBox.BodyReloading;
					ArmHitBox.image_index = HitBox.ArmReloading;
				}
			}else{
				image_index = 4;
				ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
			}
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
		break;
			
		case "Anti-tank missile":
			BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
			if(FlashedTimer <= FlashedTime * .25){
				if!(ReloadTime >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed]*.95){
					image_index = 2;
					BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
					ArmHitBox.image_index = HitBox.ArmWithAssaultRifle;
				}else{
					image_index = 6;
					BodyHitBox.image_index = HitBox.BodyReloading;
					ArmHitBox.image_index = HitBox.ArmReloading;
				}
			}else{
				image_index = 4;
				ArmHitBox.image_index = HitBox.ArmWithWeaponFlashed;
			}
			WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
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
			WeaponDistance = sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon) * .85;
		break;
	}
	#endregion
	
}else{
	
	#region Default texture (landmine and grenade)
	BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
	Weapon.image_index = 0;
	if(FlashedTimer <= FlashedTime * .25){
		image_index = 0;
		ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
	}else{
		image_index = 5;
		ArmHitBox.image_index = HitBox.ArmWithoutWeaponFlashed;
	}
	WeaponDistance = (sprite_get_bbox_right(spr_Weapon) - sprite_get_bbox_left(spr_Weapon)) * .85;
	#endregion
	
}
#endregion

#region Death
if(stats.Health_points <= 0){
	var death_sound_effect = choose(snd_Death1, snd_Death2);
	play_sound(x, y, death_sound_effect);
    if (ChasingObject.HitMap[? id]) {
        ds_map_delete(ChasingObject.HitMap, id);
    }
	depth += 1;
	XSpeed = 0;
	YSpeed = 0;	
	instance_destroy(Weapon);
	instance_destroy(HeadHitBox);
	instance_destroy(BodyHitBox);
	instance_destroy(ArmHitBox);
	instance_destroy(Legs);
	drop_experience(1, xp_value, x, y, sqrt(power(sprite_width, 2) + power(sprite_height, 2))/4);
	ItemDrop(
		WeaponID[WeaponPositionID], 
		x + lengthdir_x(WeaponDistance, RotationAngle), 
		y + lengthdir_y(WeaponDistance, RotationAngle), 
		10,
		Ammo[WeaponPositionID],
		ClipAmmo[WeaponPositionID],
		0,
		1,
		global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.has_scope],
		global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.has_barrel],
		global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.has_grip],
		global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.has_suppressor]
		
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
	var EnemyDead = instance_create_depth(x, y, depth, oEnemyDead);
	EnemyDead.mask_index = spr_EnemyBasicDead;
	EnemyDead.sprite_index = sprite_index;
	EnemyDead.image_index = 3;
	EnemyDead.image_angle = RotationAngle % 360;
	instance_destroy();
}

#endregion

#region Facing
var relative_direction = angle_difference(RotationAngle, enemy_aimpunch_direction);
var direction_sign = sign(relative_direction);
var rotation_adjustment = lerp(enemy_aimpunch * direction_sign, 0, .1);
var RotationSpeed = 9;
if(instance_exists(Weapon)){
	if(check_if_available(ChasingObject) || ChasingObjectSpotted == true){
		var pointdir = point_direction(x,y,FacingX, FacingY);
		Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
		Weapon.x = x;
		Weapon.y = y;
		RotationAngle += sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 90) + rotation_adjustment;
		Weapon.image_angle = RotationAngle + KickBackAngle * .5;
		Weapon.RotationAngle = Weapon.image_angle;
	}else{
		var pointdir = MoveDirection;
		Weapon.KickBackEffect = max(0, Weapon.KickBackEffect - 1);
		Weapon.x = x;
		Weapon.y = y;
		RotationAngle += sin(degtorad(pointdir - RotationAngle)) * RotationSpeed + min(KickBackAngle, 90) + rotation_adjustment;
		Weapon.image_angle = RotationAngle + KickBackAngle * .5;
		Weapon.RotationAngle = Weapon.image_angle;
	}
}
#endregion
