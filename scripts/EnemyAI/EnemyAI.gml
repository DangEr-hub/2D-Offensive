// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bot_bullet_create(DangerShotX, DangerShotY, EnemyWeaponID, Type = "Enemy"){
	
	var shoot_inaccuracy = 1;
	if(Type == "Enemy"){
		if(collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false)){
			shoot_inaccuracy = random_range(5, 7) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		}
	}
	
	var rank_less = get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	if(Type == "Friend"){
		rank_less = 0;
	}
	
	EnemyInaccuracyMultiplier = inaccuracy_formula(WeaponID[WeaponPositionID], id) * rank_less * .5 * shoot_inaccuracy;
	EnemyShotX = random_range(
					DangerShotX - global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Inaccuracy] * EnemyInaccuracyMultiplier, 
					DangerShotX + global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Inaccuracy] * EnemyInaccuracyMultiplier
				);
	EnemyShotY = random_range(
					DangerShotY - global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Inaccuracy] * EnemyInaccuracyMultiplier, 
					DangerShotY + global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Inaccuracy] * EnemyInaccuracyMultiplier
				);
	
	
	var suppressor_multiplier = 1;
	if(global.ItemIndex[#EnemyWeaponID, ItemStat.has_suppressor] != Item.None){
		suppressor_multiplier = global.ItemIndex[#global.ItemIndex[#EnemyWeaponID, ItemStat.Defense], ItemStat.Defense];	
	}
	
	create_bullet_tracer(
		Weapon.x + lengthdir_x(32, RotationAngle),
		Weapon.y + lengthdir_y(32, RotationAngle),
		EnemyShotX,
		EnemyShotY,
		0,
		EnemyWeaponID,
		point_direction(Weapon.x + lengthdir_x(32, RotationAngle), Weapon.y + lengthdir_y(32, RotationAngle), EnemyShotX, EnemyShotY),
		global.BulletSpeed,
		-1,
		id,
		global.ItemIndex[#EnemyWeaponID, ItemStat.Damage] * suppressor_multiplier,
		object_index,
		stats.Name,
		noone,
		0
	);
}

function check_if_available(ObjectType){
	if(instance_exists(ObjectType) && ObjectType != noone){
		return 
		(!collision_line(x, y, ObjectType.x, ObjectType.y, oParentTile, true, false) && distance_to_object(ObjectType) <= ChasingDistance && ObjectType.InSmoke == false)
	}else{
		return false;
	}
}

function MoveRunAway(DangerX, DangerY){
	DangerDistance = point_distance(x, y, DangerX, DangerY);
	MoveDirection = point_direction(x, y, DangerX, DangerY) + (180 + random_range(-45, 45));
	XSpeed += lengthdir_x(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	Speed = sqrt(power(XSpeed, 2) + power(YSpeed, 2));
	MoveTime = ceil(random_range(DangerDistance/Speed, DangerDistance/Speed));
}

function ChasingObjectSpot(Time){
	ChasingObjectSpotted = true;
	if(alarm[2] == -1){
		alarm[2] = Time;	
	}
}

function bot_move_shooting(DangerX, DangerY){
	randomize();
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Assault rifle"){
		SideStepMin = 45;
		SideStepMax = 180 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(50, 90) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Pistol"){
		SideStepMin = 0;
		SideStepMax = 180 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(100, 180) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);	
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		SideStepMin = 90;
		SideStepMax = 90 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(100, 180) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);	
		alarm[0] = MoveTime * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Submachine gun"){
		SideStepMin = 0;
		SideStepMax = 30 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection);
		MoveTime = random_range(50, 90) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);	
		alarm[0] = MoveTime * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	}
}

function EnemyShooting(DangerX, DangerY){
	var shoot_chance = 100;
	
	if(collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false)){
		shoot_chance = 33 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	}
	
	if(CanShoot == true && ChasingObjectSpotted == true && distance_to_object(ChasingObject) <= ChasingDistance && Ammo[WeaponPositionID] > 0 && percent_chance(shoot_chance)){
		
		var sound_id = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.SoundID];
		if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.has_suppressor] != Item.None){
			sound_id = snd_Silencer;
		}

		if(Visible == true){
		
		#region Create smoke effect
		Fog = instance_create_layer(FlashLightX, FlashLightY, "OtherO", oFog);
		Fog.moving = true;
		Fog.moving_x = lengthdir_x(5, RotationAngle - 180);
		Fog.moving_y = lengthdir_y(5, RotationAngle - 180);
		Fog.shoot_timer = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer];
		with(Fog){
			smoke_effect_create(
				20,
				other.RotationAngle - 180,
				5,
				5,
				10,
				.1,
				.75,
				shoot_timer
			);	
		}
		//part_particles_create(global.ParticleSystem, FlashLightX, FlashLightY, oParticleSystem.dust_particle, random_range(1, 10));
		#endregion
		
		}
		
		play_sound(x, y, sound_id);
		ParticleCreate(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
		0, RotationAngle - 180, 0, false, true, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.BulletCasingID], x, y, 1, 60);
		Weapon.KickBackEffect = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.KickBackPower];
		KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);	
		for(i=0;i<global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets];i++){	
			bot_bullet_create(DangerX, DangerY, WeaponID[WeaponPositionID]);
		}
		
		#region Create flash effect
		if(DestroyTimer == -1){
			DestroyTimer = ceil(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer] * 2);
			MuzzleFlashLight = new BulbLight(oLightRenderer.lighting, sLightTorch, 0, FlashLightX, FlashLightY);
			MuzzleFlashLight.angle = RotationAngle;
			MuzzleFlashLight.alpha = FLASHLIGHT_ALPHA * 2;
			MuzzleFlashLight.blend = c_red;
		}
		#endregion
		
		Ammo[WeaponPositionID] --;
		ShootTimer = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer];
		alarm[3] = ShootTimer;
		CanShoot = false;
	}
}
	
function MoveRandom(){
	randomize();
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Assault rifle"){
		MoveDirection = random(360);
		MoveTime = random_range(50, 90) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Pistol"){
		MoveDirection = random(360);
		MoveTime = random_range(100, 180) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		MoveDirection = random(360);
		MoveTime = random_range(100, 180) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		alarm[0] = MoveTime * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		MoveDirection = random(360);
		MoveTime = random_range(50, 90) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		alarm[0] = MoveTime * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function MoveIdle(){
	randomize();
	var margin = 32;
	var distance = random_range(0, 128);
	MoveDirection = random(360);
	var px = x + lengthdir_x(distance, MoveDirection);
	var py = y + lengthdir_y(distance, MoveDirection); 
	
	if(point_distance(x, y, px, py) > margin){
		MoveTime = random_range(50, 90) * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else{
		XSpeed = 0;
		YSpeed = 0;
	}
}

function SetReactionTimer(Time){
	if(ReactionTimer == -1){
		ReactionTimer = Time;
	}
}

function set_state(state){
	if(State != state){
		State = state;
	}
}

function MoveTowards(DangerX, DangerY, Accel, SideStepMin = 1, SideStepMax = 90){	
	randomize();
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Assault rifle"){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		MoveTime = random_range(25, 45);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Pistol"){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.33), -random_range(SideStepMin, SideStepMax*.33));
		MoveTime = random_range(50, 90);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin*45, SideStepMax), -random_range(SideStepMin*45, SideStepMax));
		MoveTime = random_range(100, 180);
		alarm[0] = MoveTime * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Submachine gun"){
		SideStepMin = 0;
		SideStepMax = 15;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.1), -random_range(SideStepMin, SideStepMax*.1));
		MoveTime = random_range(100, 180);
		alarm[0] = MoveTime * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function healing_ai(){
	if(percent_chance(75 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
		if(State != States.MoveAway){
			SetReactionTimer(ceil(ReactionTime*.5));
			State = States.MoveAway;
		}
	}else{
		if(State != States.Move){
			SetReactionTimer(ceil(ReactionTime*.5));
			State = States.Move;
		}
	}
}

function reload_ai(){
	if(percent_chance(75 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
		if(State != States.MoveAway){
			SetReactionTimer(ceil(ReactionTime*.5));
			State = States.MoveAway;
		}
	}else if(percent_chance(50 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
		if(State != States.MoveShoot){
			SetReactionTimer(ceil(ReactionTime*.5));
			State = States.MoveShoot;	
		}
	}else{
		if(State != States.Move){
			SetReactionTimer(ceil(ReactionTime*.5));
			State = States.Move;
		}
	}	
}
	
function EnemyThrowGrenade(DangerX, DangerY){
	randomize();
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = point_direction(x, y, DangerX, DangerY) - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(50, 90);
	alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	XSpeed += lengthdir_x(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function EnemyLayDownLandMine(){
	randomize();
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = MoveDirection - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(50, 90);
	alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function ChooseGrenade(){
	randomize();
	Grenade = irandom(2);
	
	switch(Grenade){
		case 0: 
			EquippedGrenadeID = Item.HEGrenade;
		break;
		
		case 1:
			EquippedGrenadeID = Item.FlashBangGrenade;
		break;
		
		case 2:
			EquippedGrenadeID = Item.SmokeGrenade;
		break;
	}
	
	return Grenade;	
}

function ChooseLandMine(){
	randomize();
	LandMine = choose(0, 4, 8);
	
	switch(LandMine){
		case 0: 
			EquippedLandMineID = Item.HELandMine;
		break;
		
		case 4:
			EquippedLandMineID = Item.CELandMine;
		break;
		
		case 8:
			EquippedLandMineID = Item.LELandMine;
		break;
	}
	
	return LandMine;	
}

function ThrowGrenadeAI(){
	if(distance_to_object(ChasingObject) <= ChasingDistance*.5){
		if(instance_exists(oParentTile)){
			if(distance_to_object(oParentTile) >= 128){
				if(State !=	States.ThrowGrenade && EquippedGrenadeTimer == -1){
					EquippedGrenade = ChooseGrenade();
					if(Grenades[EquippedGrenade] > 0){
						State = States.ThrowGrenade;	
					}else{
						if(State != States.MoveShoot){
							State = States.MoveShoot;	
						}
					}
				}else{
					if(State != States.MoveShoot){
						State = States.MoveShoot;	
					}
				}
			}else{
				if(State != States.MoveShoot){
					State = States.MoveShoot;	
				}
			}
		}else{
			if(State != States.MoveShoot){
				State = States.MoveShoot;	
			}			
		}
	}else{
		if(State != States.MoveShoot){
			State = States.MoveShoot;	
		}
	}
}

function LayDownLandMineAI(){
	if(distance_to_object(ChasingObject) <= ChasingDistance*.5){
		if(State !=	States.LayDownLandMine && EquippedLandMineTimer == -1){
			EquippedLandMine = ChooseLandMine();
			if(LandMines[floor(EquippedLandMine/4)] > 0){
				State = States.LayDownLandMine;	
			}else{
				if(State != States.MoveShoot){
					State = States.MoveShoot;	
				}
			}
		}else{
			if(State != States.MoveShoot){
				State = States.MoveShoot;	
			}	
		}
	}else{
		if(State != States.MoveShoot){
			State = States.MoveShoot;	
		}
	}
}

function get_xp(value, type){
	return value * type;	
}













