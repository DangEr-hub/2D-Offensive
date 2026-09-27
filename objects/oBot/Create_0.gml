/* Create event */
event_inherited();
can_prone = true;
walking = false;
chasing_timer = -1;
reload_timer = -1;
death_timestamp = -1;
predictive_side = choose(-1, 1);
shoot_accumulator = 0;
chasing_available = false;
trigger_texture_timer = 1;
trigger_texture_time = 1 * game_get_speed(gamespeed_fps);
check_danger_timer = 0;
check_danger_time = .1 * game_get_speed(gamespeed_fps);
danger_state_before_flee = STATES.Idle;
danger_reaction_source = noone;
danger_reaction_timer = -1;
danger_will_flee = false;
target_x = x;
target_y = y;
command_time = 6 * game_get_speed(gamespeed_fps);
command_timer = -1;
command_stuck_time = 1 * game_get_speed(gamespeed_fps);
command_stuck_timer = -1;
command_last_x = x;
command_last_y = y;
has_suppressor = false;
refresh_target_timer = 5 * game_get_speed(gamespeed_fps);
search_timer = 1;
NearestDangerObject = noone;
AmmoNeeded = 0;
check_other_enemies_time = game_get_speed(gamespeed_fps);
alarm[5] = check_other_enemies_time;
hidden = false;
check_smokes_timer = -1;
EquippedLandMine = ITEM.None;
stats = {};
NearestDangerX = -1;
NearestDangerY = -1;
stats = create_enemy(88, [random_range(170, 200), random_range(70, 120)], irandom_range(25, 50), choose("John", "Joe", "Jorge de Guzman", "Lalo salamanca", "Elvis", "Stuart", "Lewis", "Tommy hilfiger", "Hector", "Cortez", "Rico", "Nico", "Leo"), 85);
stats.Max_health_points = stats.Health_points;
stats.Max_stamina_points = stats.Stamina_points;

stats.Kills = 0;
stats.Assists = 0;
stats.Deaths = 0;
stats.Money = ROUND_STARTING_MONEY;
stats.Team = choose(TEAM.TERRORIST, TEAM.POLICE);
has_defuse_kit = stats.Team == TEAM.POLICE && percent_chance(25);
stats.Room = room;
WeaponID = [0, 0];
WeaponDistance = 0;
Ammo = [0, 0];
ClipAmmo = [0, 0];
MaxAmmo = [0, 0];
Weapon = noone;
WeaponPositionID = choose(0, 1);
image_speed = 0;
RotationAngle = random(360);
crosshair_x = x + lengthdir_x(384, RotationAngle);
crosshair_y = y + lengthdir_y(384, RotationAngle);
cs_phase = random(360);
cs_focus_target = noone;
cs_start_angle = RotationAngle;
cs_last_step_time = current_time;
WX = 8;
WY = 8;
KickBackAngle = 0;
WeaponNumber = 0;
WeaponNumberMax = 2;
HPTimer = -1;
ChasingObjectSpotted = false;
State = STATES.Idle;
prone_previous_state = STATES.Idle;
prone_check_time = 10 * game_get_speed(gamespeed_fps);
prone_check_timer = irandom_range(1, prone_check_time);
prone_timer = -1;
machine_gun_object = noone;
machine_gun_candidate = noone;
machine_gun_check_time = .5 * game_get_speed(gamespeed_fps);
machine_gun_check_timer = irandom_range(3, max(3, machine_gun_check_time));
machine_gun_mount_x = x;
machine_gun_mount_y = y;
machine_gun_slot = 0;
machine_gun_previous_weapon_number = 0;
machine_gun_previous_id = ITEM.None;
machine_gun_previous_ammo = 0;
machine_gun_previous_clip_ammo = 0;
machine_gun_previous_max_ammo = 0;
machine_gun_previous_scope = ITEM.None;
machine_gun_previous_barrel = ITEM.None;
machine_gun_previous_grip = ITEM.None;
machine_gun_previous_suppressor = ITEM.None;
CanShoot = true;
ShootTimer = -1;
Inaccuracy = 0;
DeathTimer = 5 * game_get_speed(gamespeed_fps);
ReloadTime = 0;
Reloading = false;
SpottedDanger = false;
EquippedGrenade = ITEM.None;
EquippedGrenadeTimer = -1;
EquippedGrenadeTime = .25 * game_get_speed(gamespeed_fps);
FacingX = 0;
FacingY = 0;
EquippedGrenadeID = ITEM.None;
xp_value = 1;
grenade_angle = random(360);
enemy_aimpunch_direction = 0;
enemy_aimpunch = 0;
healing = false;
equip_time = 0;
equip_timer = -1;
healing_time = -1;
planting = false;
planting_value = 0;
planting_max = 3 * game_get_speed(gamespeed_fps);
health_packs = 3;
EquippedLandMineID = ITEM.None;
LandMineAngle = random(360);
EquippedLandMineTime = .25 * game_get_speed(gamespeed_fps);
EquippedLandMineTimer = -1;
LandMines = [3, 3, 3];
AccelX = 0;AccelY = 0;VelocityX = 0;VelocityY = 0;
Grenades = [3, 3, 3, 3]; //HEGrenades, FlashGrenades, SmokeGrenades, MolotovGrenades
GrenadeObject = noone;
check_chasing_timer = 1 * game_get_speed(gamespeed_fps);
alarm[6] = 1;
sprite_index = stats.Team == TEAM.TERRORIST ? choose(spr_TerroristChar, spr_TerroristChar3, spr_TerroristChar2, spr_TerroristChar4) : choose(spr_PoliceChar, spr_PoliceChar2, spr_PoliceChar3); ///fallback
mv_timer = 5;

enum EQUIPMENT_LEVEL {
    FIRST,
    LOW,
    MED,
    HIGH
}

equipment_level = 0;
alarm[0] = 2;
var primary_weapons = [ITEM.None];
var secondary_weapons = [];
for(var item_id = 1; item_id < ITEM.Total; item_id++){
	if(global.ItemIndex[# item_id, ITEMSTATS.Type] != "Weapon"
	|| global.ItemIndex[# item_id, ITEMSTATS.Cost] <= 0){
		continue;
	}

	if(global.ItemIndex[# item_id, ITEMSTATS.WeaponType] == WEAPON_TYPE.PRIMARY){
		array_push(primary_weapons, item_id);
	}else if(global.ItemIndex[# item_id, ITEMSTATS.WeaponType] == WEAPON_TYPE.SECONDARY){
		array_push(secondary_weapons, item_id);
	}
}

WeaponID[0] = primary_weapons[irandom(array_length(primary_weapons) - 1)];
WeaponID[1] = array_length(secondary_weapons) > 0
	? secondary_weapons[irandom(array_length(secondary_weapons) - 1)]
	: ITEM.None;
ArmourID = choose(ITEM.None, ITEM.KevlarVest, ITEM.MilitaryVest, ITEM.SpecOpsVest);
HelmetID = choose(ITEM.None, ITEM.KevlarHelm, ITEM.MilitaryHelm, ITEM.SpecOpsHelm);
ShieldID = ITEM.None;
Ammo[0] = global.ItemIndex[#WeaponID[0], ITEMSTATS.MaxAmmo];
ClipAmmo[0] = global.ItemIndex[#WeaponID[0], ITEMSTATS.ClipAmmo];
MaxAmmo[0] = global.ItemIndex[#WeaponID[0], ITEMSTATS.MaxAmmo];
Ammo[1] = global.ItemIndex[#WeaponID[1], ITEMSTATS.MaxAmmo];
ClipAmmo[1] = global.ItemIndex[#WeaponID[1], ITEMSTATS.ClipAmmo];
MaxAmmo[1] = global.ItemIndex[#WeaponID[1], ITEMSTATS.MaxAmmo];
ArmourDurability = [global.ItemIndex[#ArmourID, ITEMSTATS.BaseDurability], global.ItemIndex[#HelmetID, ITEMSTATS.BaseDurability], global.ItemIndex[# ShieldID, ITEMSTATS.BaseDurability]];		

#region Flashed
FlashedTimer = -1;
FlashedTime = 7 * game_get_speed(gamespeed_fps);
#endregion

rank_boost = get_rank_boost(global.game_struct.Enemy_ep[global.game_struct.Current_game]);
rank_less = get_rank_less(global.game_struct.Enemy_ep[global.game_struct.Current_game]);
cs_spread = 128 * rank_less;
chasing_time = round(5 * game_get_speed(gamespeed_fps) * rank_boost);
chasing_timer = -1;


#region Movement engine
Acceleration = min(.5 * rank_boost, .9);
Friction = .4;
MaxSpeed = min(2 * rank_boost, 4.5);
MoveDirection = RotationAngle;
MoveTime = 0;
XSpeed = 0;
YSpeed = 0;
ReactionTimer = -1;
ReactionTime = clamp(2 * game_get_speed(gamespeed_fps) * rank_less, .25 * game_get_speed(gamespeed_fps), 1 * game_get_speed(gamespeed_fps));
ChasingDistance = min(768 * rank_boost, 1200);
#endregion

#region Legs
FootStepTimer = -1;
FootSteps = 0;
Legs = instance_create_depth(x,y,depth + 2,oObjectLegs);
Legs.Object = id;
Legs.Visible = false;
#endregion


attachments = array_create(2);
for(var i = 0; i < 2; i++){
	attachments[i] = array_create(ATTACHMENTS.total, ITEM.None);
}

Weapon = instance_create_depth(x + WX, y + WY, depth - 1, oWeapon);
Weapon.Visible = false;
Weapon.Owner = id;


#region Flashlight
FlashLightX = x;
FlashLightY = y;
#endregion

#region Hitbox
HeadHB = instance_create_depth(x, y, depth - 1, oHitBox);
HeadHB.image_index = HITBOX.Head;
HeadHB.MainObject = id;
BodyHB = instance_create_depth(x, y, depth - 1, oHitBox);
BodyHB.image_index = HITBOX.BodyNoWeapon;
BodyHB.MainObject = id;
ArmHB = instance_create_depth(x, y, depth - 1, oHitBox);
ArmHB.image_index = HITBOX.ArmNoWeapon;
ArmHB.MainObject = id;
LegHB = instance_create_depth(x, y, depth - 1, oHitBox);
LegHB.image_index = HITBOX.LegProne;
LegHB.MainObject = id;
LegHB.visible = false;
#endregion

