// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pick_chasing_object(range){
    var best_target = noone;
    var best_importance = -100000;

    var list = ds_list_create();
    var count = collision_circle_list(
        x, y,
        range,
        oParentLivingObject,
        false, true,
        list,
        false
    );

    for (var i = 0; i < count; i++){
        var inst = list[| i];
        if (!instance_exists(inst)) continue;
        if (inst == id) continue;
        if (inst.team == team) continue;
        if (inst.stats.Health_points <= 0) continue;

        var dist = point_distance(x, y, inst.x, inst.y);
        if (dist > range) continue;

        var importance = 0;

        // 1) vzdálenost (blíž = lepší)
        importance += (range - dist);

        // 2) držení současného cíle
        if (inst == ChasingObject){
            importance += 100;
		}
		
		if(team == TEAM.FRIENDLY && (instance_exists(inst.ChasingObject) && inst.ChasingObject.object_index == oPlayer)){
			importance += 300;
		}

        // 3) viditelnost
        if (inst.Visible){
            importance += 200;
		}else{
            importance -= 300;
		}

        // 4) hrozba – tenhle cíl po mně jde
        if (inst.ChasingObject == id){
            importance += 350;
		}

        // 5) dorážení zraněných
		var max_hp = global.player_stats_struct.Max_health;
		if(inst.object_index != oPlayer){
			max_hp = inst.stats.Max_health_points;
		}
        importance += (max_hp - inst.stats.Health_points) * 1.5;

        // 6) typová preference
        if (team == TEAM.ENEMIES && inst.object_index == oPlayer){
            importance += 200;
		}


        if (importance > best_importance){
            best_importance = importance;
            best_target = inst;
        }
    }
	

    ds_list_destroy(list);
    return best_target;
}




function bot_bullet_create(DangerShotX, DangerShotY, EnemyWeaponID, Type = "Enemy"){
	
	var shoot_inaccuracy = .5;
	if(Type == "Enemy"){
		if(collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false)){
			shoot_inaccuracy = random_range(5, 7) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		}
	}
	
	var rank_less = get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	if(Type == TEAM.FRIENDLY){
		rank_less = 0;
	}
	
	EnemyShotX = random_range(
					DangerShotX - inaccuracy_formula(WeaponID[WeaponPositionID], id) * rank_less * shoot_inaccuracy,
					DangerShotX + inaccuracy_formula(WeaponID[WeaponPositionID], id) * rank_less * shoot_inaccuracy
				);
	EnemyShotY = random_range(
					DangerShotY - inaccuracy_formula(WeaponID[WeaponPositionID], id) * rank_less * shoot_inaccuracy, 
					DangerShotY + inaccuracy_formula(WeaponID[WeaponPositionID], id) * rank_less * shoot_inaccuracy
				);
	
	
	var suppressor_multiplier = 1;
	if(global.ItemIndex[#EnemyWeaponID, ItemStat.has_suppressor] != Item.None){
		suppressor_multiplier = global.ItemIndex[#global.ItemIndex[#EnemyWeaponID, ItemStat.Defense], ItemStat.Defense];	
	}
	
	with(id){
		create_bullet_tracer(
			[Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle)],
			[EnemyShotX, EnemyShotY],
			0,
			[
				EnemyWeaponID,
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), EnemyShotX, EnemyShotY),
				BULLET_SPEED,
				global.ItemIndex[# EnemyWeaponID, ItemStat.Range]
			],
			id,
			global.ItemIndex[#EnemyWeaponID, ItemStat.Damage] * suppressor_multiplier,
			object_index,
			[stats.Name, Visible],
			noone,
			[id.x, id.y],
			false
		);
	}
}

function check_enemy_rotation(EnemyObject, ChasingObject){
	// return true - enemy vidí chasing object
	// return false - enemy nevidí chasing object
    var rotation = false;
    var enemy_x = EnemyObject.x;
    var enemy_y = EnemyObject.y;
        
    var angle_to_target = point_direction(enemy_x, enemy_y, ChasingObject.x, ChasingObject.y);
    var angle_diff = angle_to_target - EnemyObject.RotationAngle;
    angle_diff = angle_diff % 360;
    if (angle_diff > 180) angle_diff -= 360;
    if (angle_diff < -180) angle_diff += 360;

    if (angle_diff > -90 && angle_diff < 90) {
        rotation = true;
    }	
	
	return rotation;
}
	
function check_if_available(ObjectType) {
    if (instance_exists(ObjectType) && ObjectType != noone) {	       
        return 
        (!collision_line(x, y, ObjectType.x, ObjectType.y, oParentTile, true, false) && distance_to_object(ObjectType) <= ChasingDistance && ObjectType.hidden == false && 
        check_enemy_rotation(id, ObjectType) == true);
    }
	return false;
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
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Assault rifle"){
		SideStepMin = 45;
		SideStepMax = 180 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(50, 90) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Pistol"){
		SideStepMin = 0;
		SideStepMax = 180 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(100, 180) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);	
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		SideStepMin = 90;
		SideStepMax = 90 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(100, 180) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);	
		alarm[0] = MoveTime * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Submachine gun"){
		SideStepMin = 0;
		SideStepMax = 30 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection);
		MoveTime = random_range(50, 90) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);	
		alarm[0] = MoveTime * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	}
}

function try_shoot(base){
    var shoot_timer = min(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer], 30);
    var gain = (base / shoot_timer) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]) / 10;

    shoot_accumulator += gain;

    var chance = min(shoot_accumulator * 100, 100);

    if(percent_chance(chance)){
        EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
        shoot_accumulator = 0;
    }
}

function EnemyShooting(DangerX, DangerY){
	var shoot_chance = 100;
	var collision_tile = collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false);
	if(collision_tile){
		if(collision_tile.object_index != oMachineGunFloor){
			shoot_chance = 33 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		}else{
			shoot_chance = 100;	
		}
	}
	
	if(CanShoot == true && ChasingObjectSpotted == true && distance_to_object(ChasingObject) <= ChasingDistance && Ammo[WeaponPositionID] > 0 && percent_chance(shoot_chance)){

		if(Visible == true){
		
			#region Create smoke effect
			if(instance_number(oFog) < 10){
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
			}
		#endregion
		
		}
		
		particle_create(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
		0, RotationAngle - 180, 0, false, true, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.BulletCasingID], x, y, 1, 60);
		Weapon.KickBackEffect = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.KickBackPower];
		KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);	
		for(i=0;i<global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets];i++){	
			bot_bullet_create(DangerX, DangerY, WeaponID[WeaponPositionID]);
		}
		
		#region Create flash effect
		if(flash_effect_timer == -1){
			flash_effect_timer = ceil(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer] * 2);
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
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Assault rifle"){
		MoveDirection = random(360);
		MoveTime = random_range(50, 90) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Pistol"){
		MoveDirection = random(360);
		MoveTime = random_range(100, 180) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		MoveDirection = random(360);
		MoveTime = random_range(100, 180) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		alarm[0] = MoveTime * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		MoveDirection = random(360);
		MoveTime = random_range(50, 90) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		alarm[0] = MoveTime * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function move_predictive(PositionX, PositionY) {
    var chasing_object_direction = point_direction(x, y, PositionX, PositionY);
    var wall_between = collision_line(x, y, PositionX, PositionY, oParentTile, false, true);

    if (wall_between) {
        // Determine the relative positions of the wall to the bot
        var wall_direction = point_direction(x, y, wall_between.x, wall_between.y);

        // Compare wall direction to determine side of obstruction relative to bot
        if (angle_difference(wall_direction, chasing_object_direction) > 0) {
            // Wall is on the right of the line from bot to player, move left
            MoveDirection = chasing_object_direction - 90;
        } else {
            // Wall is on the left of the line from bot to player, move right
            MoveDirection = chasing_object_direction + 90;
        }
    } else {
        // No wall directly between bot and player, choose a random side to move towards
        MoveDirection = choose(chasing_object_direction - 90, chasing_object_direction + 90);
    }

    MoveTime = random_range(50, 90) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
    alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
    XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps) / 60);
    YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps) / 60);
}

function MoveIdle(){
	
	var margin = 32;
	var distance = random_range(0, 128);
	MoveDirection = random(360);
	var px = x + lengthdir_x(distance, MoveDirection);
	var py = y + lengthdir_y(distance, MoveDirection); 
	
	if(point_distance(x, y, px, py) > margin){
		MoveTime = random_range(50, 90) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
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
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Assault rifle"){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		MoveTime = random_range(25, 45);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Pistol"){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.33), -random_range(SideStepMin, SideStepMax*.33));
		MoveTime = random_range(50, 90);
		alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Sniper rifle"){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin*45, SideStepMax), -random_range(SideStepMin*45, SideStepMax));
		MoveTime = random_range(100, 180);
		alarm[0] = MoveTime * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == "Submachine gun"){
		SideStepMin = 0;
		SideStepMax = 15;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.1), -random_range(SideStepMin, SideStepMax*.1));
		MoveTime = random_range(100, 180);
		alarm[0] = MoveTime * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function healing_ai(){
	if(percent_chance(75 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
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
	if(percent_chance(75 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
		if(State != States.MoveAway){
			SetReactionTimer(ceil(ReactionTime*.5));
			State = States.MoveAway;
		}
	}else if(percent_chance(50 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
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
	
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = point_direction(x, y, DangerX, DangerY) - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(50, 90);
	alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	XSpeed += lengthdir_x(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function EnemyLayDownLandMine(){
	
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = MoveDirection - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(50, 90);
	alarm[0] = MoveTime * random_range(1, 2) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function ChooseGrenade(){
	
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

function handle_offensive_movement(){
	if(stats.Health_points <= stats.Max_health_points / 3){
	    if (percent_chance(25 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))) {
			set_state(States.MoveAway);
	    } else if (percent_chance(40 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))) {
			set_state(States.MoveShoot);
		}else{
			set_state(States.MovePredictive);
		}
	}else{
		if(percent_chance(10 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.Move);
		}else if(percent_chance(10 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.MoveShoot);
		}else if(percent_chance(75 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.MoveToward);
		}else{
			set_state(States.MovePredictive);
		}
	}
}

function ThrowGrenadeAI() {
    if (distance_to_object(ChasingObject) > ChasingDistance * 0.5) {
        handle_offensive_movement();
        return;
    }

    if (!instance_exists(oParentTile) || collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false) || collision_line(x, y, ChasingObject.x, ChasingObject.y, oBot, true, true)) {
        handle_offensive_movement();
        return;
    }

    if (State != States.ThrowGrenade && EquippedGrenadeTimer == -1) {
        EquippedGrenade = ChooseGrenade();
        if (Grenades[EquippedGrenade] <= 0) {
            handle_offensive_movement();
            return;
        }
        State = States.ThrowGrenade;
    } else {
        handle_offensive_movement();
    }
}

function LayDownLandMineAI(){
	if(distance_to_object(ChasingObject) <= ChasingDistance*.5){
		if(State !=	States.LayDownLandMine && EquippedLandMineTimer == -1){
			EquippedLandMine = ChooseLandMine();
			if(LandMines[floor(EquippedLandMine/4)] > 0){
				State = States.LayDownLandMine;	
			}else{
				set_state(States.MoveShoot);
			}
		}else{
			set_state(States.MoveShoot);
		}
	}else{
		set_state(States.MoveShoot);
	}
}

function get_xp(value, type){
	return value * type;	
}













