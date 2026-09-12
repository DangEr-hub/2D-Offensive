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
	var can_walk = State == STATES.Idle
		|| State == STATES.Move
		|| State == STATES.MoveShoot
		|| State == STATES.MoveToward
		|| State == STATES.MovePredictive
		|| State == STATES.MoveInSmoke
		|| State == STATES.Walk;
	if(!chasing_available && can_walk && percent_chance(clamp(20 * rank_boost, 10, 35))){
		set_state(STATES.Walk);
		return;
	}

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
	set_state(STATES.Walk);
}

function choose_offensive_action() {
    if (percent_chance(50)) {
        ThrowGrenadeAI();
    } else {
        LayDownLandMineAI();
    }
}

function bot_target_is_enemy(_target) {
	if (!instance_exists(_target) || !variable_instance_exists(_target, "stats")) {
		return false;
	}

	var target_stats = _target.stats;
	if (!is_struct(target_stats)
	|| !variable_struct_exists(target_stats, "Health_points")
	|| !variable_struct_exists(target_stats, "Team")) {
		return false;
	}

	return target_stats.Health_points > 0 && target_stats.Team != stats.Team;
}

function target_is_prone(_target) {
	if(!instance_exists(_target)) return false;

	return (_target.object_index == oPlayer
		&& _target.moving_state == STATES_PLAYER.prone_state)
		|| (_target.object_index == oBot
		&& _target.State == STATES.Prone);
}

function tile_blocks_target_view(_x1, _y1, _x2, _y2, _target, _ignore_machine_gun_floor = false, _observer = noone) {
	var collision_list = ds_list_create();
	var collision_count = collision_line_list(
		_x1, _y1, _x2, _y2,
		oParentTile,
		true, false,
		collision_list,
		false
	);
	var low_cover_blocks = target_is_prone(_target) || target_is_prone(_observer);
	var blocked = false;

	for(var i = 0; i < collision_count; i++){
		var obstacle = collision_list[| i];
		if(!instance_exists(obstacle)) continue;
		if(_ignore_machine_gun_floor && obstacle.object_index == oMachineGunFloor) continue;
		if(obstacle.transparent) continue;
		if(obstacle.hideable && !low_cover_blocks) continue;

		blocked = true;
		break;
	}

	ds_list_destroy(collision_list);
	return blocked;
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
        if (!bot_target_is_enemy(inst)) continue;

        var dist = point_distance(x, y, inst.x, inst.y);
        if (dist > range) continue;

        var importance = 0;

        // 1) vzdálenost (blíž = lepší)
        importance += (range - dist);

        // 2) držení současného cíle
        if (inst == ChasingObject){
            importance += 100;
		}
		
		if(stats.Team == TEAM.POLICE && (instance_exists(inst.ChasingObject) && inst.ChasingObject.object_index == oPlayer)){
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
		var max_hp = global.player_stats.Max_health;
		if(inst.object_index != oPlayer){
			max_hp = inst.stats.Max_health_points;
		}
        importance += (max_hp - inst.stats.Health_points) * 1.5;

        // 6) typová preference
        if (stats.Team == TEAM.TERRORIST && inst.object_index == oPlayer){
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
	if (!bot_target_is_enemy(ChasingObject)) {
		shoot_accumulator = 0;
		return;
	}

    var shoot_timer = min(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer], 30);
    var gain = (base / shoot_timer) * rank_boost / 10;

    shoot_accumulator += gain * global.time_step;

    var chance = min(shoot_accumulator * 100, 100);
	
	var shotgun_shoot = false;
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.BaseDurability] != 1){
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
	if (!bot_target_is_enemy(ChasingObject)) {
		return;
	}

	
	var weapon = WeaponID[WeaponPositionID];
	var shoot_inaccuracy = 1;
	if(tile_blocks_target_view(x, y, ChasingObject.x, ChasingObject.y, ChasingObject, false, id)){
		shoot_inaccuracy = random_range(7, 9) * rank_less;
	}
	if(State == STATES.Prone){
		shoot_inaccuracy *= 0.5;
	}
	
	var suppressor_dmg_mul = 1;
	var suppressor_accuracy_mul = 1;
	if(has_suppressor){
		suppressor_dmg_mul = global.ItemIndex[# attachments[WeaponPositionID, ATTACHMENTS.slot_suppressor], ItemStat.Defense];	
		suppressor_accuracy_mul = global.ItemIndex[# attachments[WeaponPositionID, ATTACHMENTS.slot_suppressor], ItemStat.KickBackPower];	
	}
	
	var inaccuracy = inaccuracy_formula(weapon, id);
	
	var EnemyShotX = random_range(
					DangerShotX - (inaccuracy * rank_less * shoot_inaccuracy),
					DangerShotX + (inaccuracy * rank_less * shoot_inaccuracy)
				);
	var EnemyShotY = random_range(
					DangerShotY - (inaccuracy * rank_less * shoot_inaccuracy), 
					DangerShotY + (inaccuracy * rank_less * shoot_inaccuracy)
				);

	var projectile_image = 0;
	var projectile_speed = BULLET_SPEED * global.time_step;
	var homing_target = noone;
	if(global.ItemIndex[# weapon, ItemStat.WeaponTypeClass] == WEAPON_CLASS.MISSILE){
		projectile_image = 1;
		projectile_speed = 25;
		homing_target = ChasingObject;
	}
	
	with(id){
		create_bullet_tracer(
			[Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle)],
			[EnemyShotX, EnemyShotY],
			projectile_image,
			[
				weapon,
				point_direction(Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), EnemyShotX, EnemyShotY),
				projectile_speed,
				global.ItemIndex[# weapon, ItemStat.Range]
			],
			id,
			global.ItemIndex[#weapon, ItemStat.Damage] * suppressor_dmg_mul,
			object_index,
			[stats.Name, Visible],
			homing_target,
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
	if (!bot_target_is_enemy(ObjectType)) { return false; }
	var shoot_chance = 100;
	var collision = tile_blocks_target_view(
		x, y,
		ObjectType.x, ObjectType.y,
		ObjectType,
		true,
		id
	);
    return 
    (collision == false && distance_to_object(ObjectType) <= ChasingDistance && ObjectType.hidden == false && 
    check_enemy_rotation(id, ObjectType) == true);
}
	
function ChasingObjectSpot(Time){
	if(ChasingObjectSpotted == false){
		ReactionTimer = ReactionTime;
	}
	ChasingObjectSpotted = true;
	chasing_timer = Time;	
}

function alert_bots_near_shot(shooter, shot_x, shot_y, target_x, target_y, suppressed){
	if(!instance_exists(shooter) || !variable_instance_exists(shooter, "stats")) return;
	if(current_time < shooter.next_shot_intel_time) return;
	shooter.next_shot_intel_time = current_time + 250;

	var line_x = target_x - shot_x;
	var line_y = target_y - shot_y;
	var line_length_squared = line_x * line_x + line_y * line_y;
	if(line_length_squared <= 0) return;

	var base_chance = suppressed ? 5 : 40;
	var bot_count = instance_number(oBot);
	for(var i = 0; i < bot_count; i++){
		var bot = instance_find(oBot, i);
		if(!instance_exists(bot) || bot == shooter || bot.stats.Health_points <= 0) continue;
		if(bot.stats.Team == shooter.stats.Team || bot.ChasingObjectSpotted) continue;

		var line_position = clamp(
			((bot.x - shot_x) * line_x + (bot.y - shot_y) * line_y) / line_length_squared,
			0,
			1
		);
		var nearest_x = shot_x + line_x * line_position;
		var nearest_y = shot_y + line_y * line_position;
		if(point_distance(bot.x, bot.y, nearest_x, nearest_y) > 256) continue;

		if(percent_chance(clamp(base_chance * bot.rank_boost, 1, 95))){
			bot.ChasingObject = shooter;
			with(bot){
				ChasingObjectSpot(chasing_time);
			}
		}
	}
}

function EnemyShooting(DangerX, DangerY){
	if (!bot_target_is_enemy(ChasingObject)) {
		shoot_accumulator = 0;
		return;
	}
	has_suppressor = attachments[WeaponPositionID][ATTACHMENTS.slot_suppressor] == Item.advanced_suppressor;

	if(CanShoot == true && ChasingObjectSpotted == true && distance_to_object(ChasingObject) <= ChasingDistance && Ammo[WeaponPositionID] > 0){

		if(Visible == true && Ammo[WeaponPositionID] % 2 == 0){
		
			#region Create smoke effect
			create_fog(FlashLightX, FlashLightY, 20, other.RotationAngle - 180, 5, 5, 10, .1, .75, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer],
				[lengthdir_x(5, RotationAngle - 180), lengthdir_y(5, RotationAngle - 180), true]
			);
			#endregion
		
		}
		
		if(global.ItemIndex[# WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] != WEAPON_CLASS.MISSILE){
			particle_create(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Bullets], 0.75, random(360), spr_BulletCasing, random_range(10, 30),
			0, RotationAngle - 180, 0, false, true, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.BulletCasingID], x, y, 1, 60);
		}
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
	if(State == STATES.MACHINE_GUN && state != STATES.MACHINE_GUN){
		return;
	}
	if(State != state){State = state; }
}

function bot_mount_machine_gun(_machine_gun){
	if(State == STATES.MACHINE_GUN || !instance_exists(_machine_gun)){
		return false;
	}
	if(instance_exists(_machine_gun.stats.Object)){
		return false;
	}

	machine_gun_object = _machine_gun;
	machine_gun_slot = WeaponPositionID;
	machine_gun_previous_weapon_number = WeaponNumber;
	machine_gun_previous_id = WeaponID[machine_gun_slot];
	machine_gun_previous_ammo = Ammo[machine_gun_slot];
	machine_gun_previous_clip_ammo = ClipAmmo[machine_gun_slot];
	machine_gun_previous_max_ammo = MaxAmmo[machine_gun_slot];
	machine_gun_previous_scope = attachments[machine_gun_slot][ATTACHMENTS.slot_scope];
	machine_gun_previous_barrel = attachments[machine_gun_slot][ATTACHMENTS.slot_barrel];
	machine_gun_previous_grip = attachments[machine_gun_slot][ATTACHMENTS.slot_grip];
	machine_gun_previous_suppressor = attachments[machine_gun_slot][ATTACHMENTS.slot_suppressor];

	WeaponID[machine_gun_slot] = _machine_gun.stats.Id;
	Ammo[machine_gun_slot] = _machine_gun.stats.Ammo;
	ClipAmmo[machine_gun_slot] = _machine_gun.stats.Clip_ammo;
	MaxAmmo[machine_gun_slot] = global.ItemIndex[# _machine_gun.stats.Id, ItemStat.MaxAmmo];
	attachments[machine_gun_slot][ATTACHMENTS.slot_scope] = _machine_gun.stats.Slot_scope;
	attachments[machine_gun_slot][ATTACHMENTS.slot_barrel] = _machine_gun.stats.Slot_barrel;
	attachments[machine_gun_slot][ATTACHMENTS.slot_grip] = _machine_gun.stats.Slot_grip;
	attachments[machine_gun_slot][ATTACHMENTS.slot_suppressor] = _machine_gun.stats.Slot_suppressor;
	_machine_gun.stats.Object = id;
	WeaponNumber = machine_gun_slot;
	WeaponPositionID = machine_gun_slot;

	var mount_position = local_to_world(0, 96, _machine_gun.image_angle, _machine_gun);
	machine_gun_mount_x = mount_position[0];
	machine_gun_mount_y = mount_position[1];
	x = machine_gun_mount_x;
	y = machine_gun_mount_y;
	RotationAngle = _machine_gun.image_angle;
	MoveDirection = RotationAngle;
	MoveTime = 0;
	mv_timer = 0;
	XSpeed = 0;
	YSpeed = 0;
	VelocityX = 0;
	VelocityY = 0;
	Reloading = false;
	ReloadTime = 0;
	reload_timer = -1;
	CanShoot = true;
	set_state(STATES.MACHINE_GUN);
	return true;
}

function bot_release_machine_gun(){
	if(instance_exists(machine_gun_object)){
		machine_gun_object.stats.Ammo = Ammo[machine_gun_slot];
		machine_gun_object.stats.Clip_ammo = ClipAmmo[machine_gun_slot];
		machine_gun_object.stats.Slot_scope = attachments[machine_gun_slot][ATTACHMENTS.slot_scope];
		machine_gun_object.stats.Slot_barrel = attachments[machine_gun_slot][ATTACHMENTS.slot_barrel];
		machine_gun_object.stats.Slot_grip = attachments[machine_gun_slot][ATTACHMENTS.slot_grip];
		machine_gun_object.stats.Slot_suppressor = attachments[machine_gun_slot][ATTACHMENTS.slot_suppressor];
		if(machine_gun_object.stats.Object == id){
			machine_gun_object.stats.Object = noone;
		}
	}

	WeaponID[machine_gun_slot] = machine_gun_previous_id;
	Ammo[machine_gun_slot] = machine_gun_previous_ammo;
	ClipAmmo[machine_gun_slot] = machine_gun_previous_clip_ammo;
	MaxAmmo[machine_gun_slot] = machine_gun_previous_max_ammo;
	attachments[machine_gun_slot][ATTACHMENTS.slot_scope] = machine_gun_previous_scope;
	attachments[machine_gun_slot][ATTACHMENTS.slot_barrel] = machine_gun_previous_barrel;
	attachments[machine_gun_slot][ATTACHMENTS.slot_grip] = machine_gun_previous_grip;
	attachments[machine_gun_slot][ATTACHMENTS.slot_suppressor] = machine_gun_previous_suppressor;
	WeaponNumber = machine_gun_previous_weapon_number;
	WeaponPositionID = min(WeaponNumber, 1);
	machine_gun_object = noone;
	machine_gun_candidate = noone;
	State = STATES.Idle;
	Reloading = false;
	ReloadTime = 0;
	reload_timer = -1;
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

function find_bot_danger(){
	var best_danger = noone;
	var best_urgency = 0;
	var base_radius = 224 * clamp(rank_boost, .8, 1.35);

	for(var i = 0; i < instance_number(oGrenade); i++){
		var grenade = instance_find(oGrenade, i);
		if(!instance_exists(grenade)) continue;

		var grenade_distance = point_distance(x, y, grenade.x, grenade.y);
		var grenade_urgency = base_radius - grenade_distance;
		if(grenade_urgency > best_urgency){
			best_urgency = grenade_urgency;
			best_danger = {
				source: grenade,
				x: grenade.x,
				y: grenade.y
			};
		}
	}

	for(var i = 0; i < instance_number(oMolotovImpact); i++){
		var molotov = instance_find(oMolotovImpact, i);
		if(!instance_exists(molotov)) continue;

		var fire_safe_radius = molotov.max_radius * .75 + 72;
		var fire_distance = point_distance(x, y, molotov.x, molotov.y);
		var fire_urgency = fire_safe_radius - fire_distance;
		if(fire_urgency > best_urgency){
			best_urgency = fire_urgency;
			best_danger = {
				source: molotov,
				x: molotov.x,
				y: molotov.y
			};
		}
	}

	var static_danger_types = [oLandMine, oMissile];
	for(var type_index = 0; type_index < array_length(static_danger_types); type_index++){
		var danger_type = static_danger_types[type_index];
		for(var i = 0; i < instance_number(danger_type); i++){
			var static_danger = instance_find(danger_type, i);
			if(!instance_exists(static_danger)) continue;

			var danger_owner_type = -1;
			if(is_struct(static_danger.stats) && variable_struct_exists(static_danger.stats, "Object_index")){
				danger_owner_type = static_danger.stats.Object_index;
			}
			if(danger_owner_type == oBot) continue;

			var static_distance = point_distance(x, y, static_danger.x, static_danger.y);
			var static_urgency = base_radius - static_distance;
			if(static_urgency > best_urgency){
				best_urgency = static_urgency;
				best_danger = {
					source: static_danger,
					x: static_danger.x,
					y: static_danger.y
				};
			}
		}
	}

	return best_danger;
}

function bot_flee_from_danger(danger_x, danger_y){
	var away_direction = point_direction(danger_x, danger_y, x, y);
	var direction_offsets = [0, 35, -35, 70, -70, 105, -105, 145, -145];
	var best_direction = away_direction;
	var best_clearance = -1;

	for(var i = 0; i < array_length(direction_offsets); i++){
		var candidate_direction = away_direction + direction_offsets[i];
		var clearance = 0;

		for(var probe_distance = 16; probe_distance <= 64; probe_distance += 16){
			var probe_x = x + lengthdir_x(probe_distance, candidate_direction);
			var probe_y = y + lengthdir_y(probe_distance, candidate_direction);
			if(place_meeting(probe_x, probe_y, oParentTile)) break;
			clearance += 1;
		}

		var direction_score = clearance * 100 - abs(direction_offsets[i]);
		if(direction_score > best_clearance){
			best_clearance = direction_score;
			best_direction = candidate_direction;
		}
	}

	MoveDirection = best_direction;
	MoveTime = round(random_range(20, 32));
	XSpeed += lengthdir_x(Acceleration * 3, MoveDirection) * (game_get_speed(gamespeed_fps) / 60);
	YSpeed += lengthdir_y(Acceleration * 3, MoveDirection) * (game_get_speed(gamespeed_fps) / 60);
}

function bot_move_shooting(DangerX, DangerY){
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.ASSAULT_RIFLE){
		SideStepMin = 45;
		SideStepMax = 180 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(70, 110) * rank_less;
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
		SideStepMin = 0;
		SideStepMax = 180 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(120, 200) * rank_less;	
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
		SideStepMin = 90;
		SideStepMax = 90 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		MoveTime = random_range(150, 230) * random_range(2, 3) * rank_less;	
		if(mv_timer == 0){ mv_timer = MoveTime * rank_less; }
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SUBMACHINE_GUN){
		SideStepMin = 0;
		SideStepMax = 30 * rank_less;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
		XSpeed += lengthdir_x(Acceleration*2, MoveDirection);
		YSpeed += lengthdir_y(Acceleration*2, MoveDirection);
		MoveTime = random_range(110, 150) * random_range(2, 3) * rank_less;	
		if(mv_timer == 0){ mv_timer = MoveTime * rank_less; }
	}
}
	
function MoveRandom(){
	
	if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.ASSAULT_RIFLE){
		MoveDirection = random(360);
		MoveTime = random_range(70, 110) * rank_less;
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(1, 2) * rank_less; }
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
		MoveDirection = random(360);
		MoveTime = random_range(120, 200) * rank_less;
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(1, 2) * rank_less; }
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
		MoveDirection = random(360);
		MoveTime = random_range(150, 230) * rank_less;
		if(mv_timer == 0){ mv_timer = MoveTime * rank_less; }
		XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SUBMACHINE_GUN){
		MoveDirection = random(360);
		MoveTime = random_range(110, 150) * rank_less;
		if(mv_timer == 0){ mv_timer = MoveTime * rank_less; }
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
	if(mv_timer == 0){ mv_timer = MoveTime * rank_less; }
	
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
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.PISTOL){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.33), -random_range(SideStepMin, SideStepMax*.33));
		MoveTime = random_range(70, 110);
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SNIPER_RIFLE){
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin*45, SideStepMax), -random_range(SideStepMin*45, SideStepMax));
		MoveTime = random_range(150, 230);
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
		XSpeed += lengthdir_x(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.WeaponTypeClass] == WEAPON_CLASS.SUBMACHINE_GUN){
		SideStepMin = 0;
		SideStepMax = 15;
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.1), -random_range(SideStepMin, SideStepMax*.1));
		MoveTime = random_range(150, 220);
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else{
		MoveDirection = point_direction(x, y, DangerX, DangerY) + choose(random_range(SideStepMin, SideStepMax*.33), -random_range(SideStepMin, SideStepMax*.33));
		MoveTime = random_range(55, 90);
		if(mv_timer == 0){ mv_timer = MoveTime * random_range(2, 3) * rank_less; }
		XSpeed += lengthdir_x(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel*2, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}
}

function EnemyThrowGrenade(DangerX, DangerY){
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = point_direction(x, y, DangerX, DangerY) - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(70, 110);
	if(mv_timer == 0){ mv_timer = MoveTime * random_range(1, 2) * rank_less; }
	XSpeed += lengthdir_x(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration*3, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function EnemyLayDownLandMine(){
	
	SideStepMin = 0;
	SideStepMax = 30;
	MoveDirection = MoveDirection - 180 + choose(random_range(SideStepMin, SideStepMax), -random_range(SideStepMin, SideStepMax));
	MoveTime = random_range(70, 110);
	if(mv_timer == 0){ mv_timer = MoveTime * random_range(1, 2) * rank_less; }
	XSpeed += lengthdir_x(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	YSpeed += lengthdir_y(Acceleration, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
}

function ChooseGrenade(){
	var first_grenade = irandom(2);
	for(var i = 0; i < 3; i++){
		Grenade = (first_grenade + i) mod 3;
		if(Grenades[Grenade] > 0){
			switch(Grenade){
				case 0: EquippedGrenadeID = Item.HEGrenade; break;	
				case 1: EquippedGrenadeID = Item.FlashBangGrenade; break;	
				case 2: EquippedGrenadeID = Item.SmokeGrenade; break;
			}
			return Grenade;
		}
	}

	EquippedGrenadeID = Item.None;
	return -1;
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

	if (tile_blocks_target_view(x, y, ChasingObject.x, ChasingObject.y, ChasingObject, false, id)
	|| collision_line(x, y, ChasingObject.x, ChasingObject.y, oBot, true, true)) {
        //handle_offensive_movement();
        return;
    }
    if (State != STATES.ThrowGrenade && EquippedGrenadeTimer == -1) {
		var selected_grenade = ChooseGrenade();
		if(selected_grenade != -1){
			EquippedGrenade = selected_grenade;
			set_state(STATES.ThrowGrenade);
		}
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
