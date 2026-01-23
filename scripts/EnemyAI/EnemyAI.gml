// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function decide_movement() {
    if (hidden == false) {
        handle_basic_movement();
    } else {
        handle_smoke_movement();
   }
}

function handle_basic_movement(){
	var rng = random(100);
	var t1 = 20 * rank_less;
	var t2 =  t1 + (20 * rank_boost);
	var t3 =  t2 + (25 * rank_less);
	var t4 = t3 + (30 * rank_less);
	if(rng < t1){
		set_state(STATES.Move);
	}else if(rng < t2){
		set_state(STATES.MoveShoot);
	}else if(rng < t3){
		set_state(STATES.MoveToward);
	}else if(rng < t4){
		set_state(STATES.MovePredictive);
	}else{
		choose_offensive_action();
	}
}

function handle_smoke_movement() {
	var rng = random(100);
	var t1 = 50 * rank_boost;
	var t2 = t1 + (10 * rank_less);
	if(rng < t1){
		set_state(STATES.MoveInSmoke);
    } else if (rng < t2) {
		set_state(STATES.MoveAway);
    } else {
		set_state(STATES.MoveShoot);
    }
}

function choose_offensive_action() {
    if (percent_chance(50)) {
        ThrowGrenadeAI();
    } else {
        LayDownLandMineAI();
    }
}


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
		
		if(team == TEAM.POLICE && (instance_exists(inst.ChasingObject) && inst.ChasingObject.object_index == oPlayer)){
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
        if (team == TEAM.TERRORIST && inst.object_index == oPlayer){
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

function try_shoot(base){
    var shoot_timer = min(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer], 30);
    var gain = (base / shoot_timer) * rank_boost / 10;

    shoot_accumulator += gain;

    var chance = min(shoot_accumulator * 100, 100);
	
	var shotgun_shoot = false;
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Defense] != 1){
		shotgun_shoot = true;
	}else if(Ammo[WeaponPositionID] >= MaxAmmo[WeaponPositionID] || !Reloading) {	
		shotgun_shoot = true;
	}

    if(percent_chance(chance) && shotgun_shoot){
        EnemyShooting(ChasingObject.headshot_x, ChasingObject.headshot_y);
        shoot_accumulator = 0;
    }
}

function bot_bullet_create(DangerShotX, DangerShotY){
	
	var weapon = WeaponID[WeaponPositionID];
	var shoot_inaccuracy = .5;
	if(collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false)){
		shoot_inaccuracy = random_range(5, 7) * rank_less;
	}
	
	var suppressor_dmg_mul = 1;
	var suppressor_accuracy_mul = 1;
	if(has_suppressor){
		suppressor_dmg_mul = global.ItemIndex[# attachments[WeaponPositionID, ATTACHMENTS.slot_suppressor], ItemStat.Defense];	
		suppressor_accuracy_mul = global.ItemIndex[# attachments[WeaponPositionID, ATTACHMENTS.slot_suppressor], ItemStat.KickBackPower];	
	}
	
	var EnemyShotX = random_range(
					DangerShotX - inaccuracy_formula(weapon, id) * rank_less * shoot_inaccuracy,
					DangerShotX + inaccuracy_formula(weapon, id) * rank_less * shoot_inaccuracy
				);
	var EnemyShotY = random_range(
					DangerShotY - inaccuracy_formula(weapon, id) * rank_less * shoot_inaccuracy, 
					DangerShotY + inaccuracy_formula(weapon, id) * rank_less * shoot_inaccuracy
				);
	
	
	with(id){
		create_bullet_tracer(
			[Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle)],
			[EnemyShotX, EnemyShotY],
			0,
			[
				weapon,
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), EnemyShotX, EnemyShotY),
				BULLET_SPEED,
				global.ItemIndex[# weapon, ItemStat.Range]
			],
			id,
			global.ItemIndex[#weapon, ItemStat.Damage] * suppressor_dmg_mul,
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
	
	if!(instance_exists(ChasingObject)){
		return;
	}
    var rotation = false;
    var enemy_x = EnemyObject.x;
    var enemy_y = EnemyObject.y;
        
    var angle_to_target = point_direction(enemy_x, enemy_y, ChasingObject.x, ChasingObject.y);
    var angle_diff = angle_to_target - EnemyObject.RotationAngle;
    angle_diff = angle_diff % 360;
    if (angle_diff > 180) angle_diff -= 360;
    if (angle_diff < -180) angle_diff += 360;

    if (angle_diff > -100 && angle_diff < 100) {
        rotation = true;
    }	
	
	return rotation;
}
	
function check_if_available(ObjectType) {
    if!(instance_exists(ObjectType)) { return; }
	var shoot_chance = 100;
	var collision_tile = collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false);
	var collision = false;
	if(collision_tile){
		collision = true;
		if(collision_tile.object_index == oMachineGunFloor || collision_tile.transparent == true){
			collision = false;
		}
	}	
    return 
    (collision == false && distance_to_object(ObjectType) <= ChasingDistance && ObjectType.hidden == false && 
    check_enemy_rotation(id, ObjectType) == true);
}
	
function ChasingObjectSpot(Time){
	if(ChasingObjectSpotted == false){
		ReactionTimer = ReactionTime;
	}
	ChasingObjectSpotted = true;
	alarm[2] = Time;	
}

function EnemyShooting(DangerX, DangerY){
	if(CanShoot == true && ChasingObjectSpotted == true && distance_to_object(ChasingObject) <= ChasingDistance && Ammo[WeaponPositionID] > 0){

		if(Visible == true && Ammo[WeaponPositionID] % 2 == 0){
		
			#region Create smoke effect
			create_fog(FlashLightX, FlashLightY, 20, other.RotationAngle - 180, 5, 5, 10, .1, .75, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer],
				[lengthdir_x(5, RotationAngle - 180), lengthdir_y(5, RotationAngle - 180), true]
			);
			#endregion
		
		}
		
		particle_create(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
		0, RotationAngle - 180, 0, false, true, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.BulletCasingID], x, y, 1, 60);
		Weapon.KickBackEffect = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.KickBackPower];
		KickBackAngle = random_range(-Weapon.KickBackEffect, Weapon.KickBackEffect);	
		for(i=0;i<global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets];i++){	
			bot_bullet_create(DangerX, DangerY);
		}
		
		#region Create flash effect
		if(flash_effect_timer == -1){
			flash_effect_timer = round(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer] * .75);
			if(Ammo[WeaponPositionID] % 2 == 0){
				var MuzzleFlashLight = new BulbLight(oLightRenderer.lighting, sLightTorch, 0, FlashLightX, FlashLightY);
				MuzzleFlashLight.angle = RotationAngle;
				MuzzleFlashLight.alpha = 1;
				MuzzleFlashLight.blend = c_red;
			}
		}
		#endregion
		
		var adaptive = 
		has_attachment(Item.adaptive_chambering, ATTACHMENTS.slot_barrel, id, WeaponPositionID) 
		? global.ItemIndex[# attachments[WeaponPositionID][ATTACHMENTS.slot_barrel], ItemStat.ShootTimer] 
		: 1;
		
		Ammo[WeaponPositionID] --;
		ShootTimer = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer] * adaptive;
		alarm[3] = ShootTimer;
		CanShoot = false;
	}
}

function SetReactionTimer(Time){
	if(ReactionTimer == -1){
		ReactionTimer = Time;
	}
}

function set_state(state){	
	if(State != state){State = state; }
}

function healing_ai(){
	if(percent_chance(75 * rank_boost)){
		if(State != STATES.MoveAway){
			SetReactionTimer(round(ReactionTime*.5));
			State = STATES.MoveAway;
		}
	}else{
		if(State != STATES.Move){
			SetReactionTimer(round(ReactionTime*.5));
			State = STATES.Move;
		}
	}
}

function reload_ai(){
	var rng = random(100);
	var t1 = 50 * rank_boost;
	var t2 = t1 + (10 * rank_boost);
	
	if(rng < t1){
		set_state(STATES.MoveAway);
	}else if(rng < t2){
		set_state(STATES.MoveShoot);
	}else{
		set_state(STATES.Move);
	}
}

function MoveRunAway(DangerX, DangerY){
	DangerDistance = point_distance(x, y, DangerX, DangerY);
	MoveDirection = point_direction(x, y, DangerX, DangerY) + (180 + random_range(-45, 45));
	XSpeed += lengthdir_x(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	Speed = sqrt(power(XSpeed, 2) + power(YSpeed, 2));
	MoveTime = round(random_range(DangerDistance/Speed, DangerDistance/Speed));
}

function bot_move_shooting(DangerX, DangerY){
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.ASSAULT_RIFLE){
		SideStepMin = 45;
		SideStepMax = 180 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(70, 110) * rank_less;
		if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
		SideStepMin = 0;
		SideStepMax = 180 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(120, 200) * rank_less;	
		if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
		SideStepMin = 90;
		SideStepMax = 90 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(150, 230) * rank_less;	
		if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SUBMACHINE_GUN){
		SideStepMin = 0;
		SideStepMax = 30 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection);
		MoveTime = random_range(70, 110) * rank_less;	
		if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
	}
}
	
function MoveRandom(){
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.ASSAULT_RIFLE){
		MoveDirection = random(360);
		MoveTime = random_range(70, 110) * rank_less;
		if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
		MoveDirection = random(360);
		MoveTime = random_range(120, 200) * rank_less;
		if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
		MoveDirection = random(360);
		MoveTime = random_range(150, 230) * rank_less;
		if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SUBMACHINE_GUN){
		MoveDirection = random(360);
		MoveTime = random_range(70, 110) * rank_less;
		if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function move_predictive(PositionX, PositionY){
	
	var dir = point_direction(x, y, PositionX, PositionY);
	
	// občas změň stranu (predikce chování hráče)
	if(irandom(30) == 0){
		if(random(1) < 0.5){
			predictive_side = -1;
		}else{
			predictive_side = 1;
		}
	}
	
	// boční úhyb
	MoveDirection = dir + 90 * predictive_side;
	
	MoveTime = random_range(70, 110) * rank_less;
	if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
	
	XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function MoveIdle(){
	
	var margin = 32;
	var distance = random_range(0, 128);
	MoveDirection = random(360);
	var px = x + lengthdir_x(distance, MoveDirection);
	var py = y + lengthdir_y(distance, MoveDirection); 
	
	if(point_distance(x, y, px, py) > margin){
		MoveTime = random_range(70, 110) * rank_boost;
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else{
		XSpeed = 0;
		YSpeed = 0;
	}
}

function MoveTowards(DangerX, DangerY, Accel, SideStepMin = 1, SideStepMax = 90){	
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.ASSAULT_RIFLE){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		MoveTime = random_range(40, 55);
		if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.33), -random_range(SideStepMin, SideStepMax*.33));
		MoveTime = random_range(70, 110);
		if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin*45, SideStepMax), -random_range(SideStepMin*45, SideStepMax));
		MoveTime = random_range(150, 230);
		if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
		XSpeed += lengthdir_x(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SUBMACHINE_GUN){
		SideStepMin = 0;
		SideStepMax = 15;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.1), -random_range(SideStepMin, SideStepMax*.1));
		MoveTime = random_range(120, 200);
		if(alarm[0] == 0){ alarm[0] = MoveTime * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function EnemyThrowGrenade(DangerX, DangerY){
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = point_direction(x, y, DangerX, DangerY) - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(70, 110);
	if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
	XSpeed += lengthdir_x(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function EnemyLayDownLandMine(){
	
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = MoveDirection - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(70, 110);
	if(alarm[0] == 0){ alarm[0] = MoveTime * random_range(1, 2) * rank_less; }
	XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function ChooseGrenade(){
	Grenade = irandom(2);	
	switch(Grenade){
		case 0: EquippedGrenadeID = Item.HEGrenade; break;	
		case 1: EquippedGrenadeID = Item.FlashBangGrenade; break;	
		case 2: EquippedGrenadeID = Item.SmokeGrenade; break;
	}
	return Grenade;	
}

function ChooseLandMine(){
	LandMine = choose(0, 4, 8);
	switch(LandMine){
		case 0: EquippedLandMineID = Item.HELandMine; break;	
		case 4: EquippedLandMineID = Item.CELandMine; break;	
		case 8: EquippedLandMineID = Item.LELandMine; break;
	}
	return LandMine;	
}

function handle_offensive_movement(){
	if(stats.Health_points <= stats.Max_health_points / 3){
	    if (percent_chance(25 * rank_boost)) {
			set_state(STATES.MoveAway);
	    } else if (percent_chance(40 * rank_less)) {
			set_state(STATES.MoveShoot);
		}else{
			set_state(STATES.MovePredictive);
		}
	}else{
		if(percent_chance(10 * rank_less)){
			set_state(STATES.Move);
		}else if(percent_chance(10 * rank_boost)){
			set_state(STATES.MoveShoot);
		}else if(percent_chance(75 * rank_less)){
			set_state(STATES.MoveToward);
		}else{
			set_state(STATES.MovePredictive);
		}
	}
}

function ThrowGrenadeAI() {
    if (distance_to_object(ChasingObject) > ChasingDistance * 0.75) {
        //handle_offensive_movement();
        return;
    }

    if (collision_line(x, y, ChasingObject.x, ChasingObject.y, oParentTile, true, false) || collision_line(x, y, ChasingObject.x, ChasingObject.y, oBot, true, true)) {
        //handle_offensive_movement();
        return;
    }
	
    if (Grenades[EquippedGrenade] <= 0) {
       // handle_offensive_movement();
        return;
    }

    if (State != STATES.ThrowGrenade && EquippedGrenadeTimer == -1) {
        EquippedGrenade = ChooseGrenade();
        State = STATES.ThrowGrenade;
    }
}

function LayDownLandMineAI(){
	if(distance_to_object(ChasingObject) <= ChasingDistance*.5){
		if(State !=	STATES.LayDownLandMine && EquippedLandMineTimer == -1){
			EquippedLandMine = ChooseLandMine();
			if(LandMines[floor(EquippedLandMine/4)] > 0){
				State = STATES.LayDownLandMine;	
			}
		}
	}
	return;
}

function get_xp(value, type){
	return value * type;	
}