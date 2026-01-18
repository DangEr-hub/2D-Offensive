/* Create event */
event_inherited();
predictive_side = choose(-1, 1);
shoot_accumulator = 0;
chasing_available = false;
trigger_texture_timer = 1;
trigger_texture_time = 1 * game_get_speed(gamespeed_fps);
check_danger_timer = -1;
check_danger_time = .25 * game_get_speed(gamespeed_fps);
target_x = x;
target_y = y;
has_suppressor = false;
refresh_target_timer = 5 * game_get_speed(gamespeed_fps);
alarm[1] = 1;
team = TEAM.TERRORIST;//percent_chance(25) ? TEAM.POLICE : TEAM.TERRORIST;
NearestDangerObject = noone;
AmmoNeeded = 0;
check_other_enemies_time = game_get_speed(gamespeed_fps);
alarm[5] = check_other_enemies_time;
hidden = false;
check_smokes_timer = -1;
EquippedLandMine = Item.None;
stats = {};
NearestDangerX = -1;
NearestDangerY = -1;
stats = create_enemy(80, [random_range(150, 200), random_range(70, 170)], irandom_range(15, 70), choose("John", "Joe", "Jorge de Guzman", "Lalo salamanca", "Elvis", "Stuart", "Lewis", "Tommy hilfiger", "Hector", "Cortez", "Rico", "Nico", "Leo"), 80);
stats.Max_health_points = stats.Health_points;
stats.Max_stamina_points = stats.Stamina_points;
WeaponID = [0, 0];
WeaponDistance = 0;
RotationAngle = 0;
Ammo = [0, 0];
ClipAmmo = [0, 0];
MaxAmmo = [0, 0];
Weapon = noone;
WeaponPositionID = choose(0, 1);
image_speed = 0;
RotationAngle = random(360);
WX = 8;
WY = 8;
KickBackAngle = 0;
WeaponNumber = 0;
WeaponNumberMax = 2;
HPTimer = -1;
ChasingObjectSpotted = false;
State = STATES.Idle;
CanShoot = true;
ShootTimer = -1;
Inaccuracy = 0;
DeathTimer = 5 * game_get_speed(gamespeed_fps);
ReloadTime = 0;
Reloading = false;
SpottedDanger = false;
EquippedGrenade = Item.None;
EquippedGrenadeTimer = -1;
EquippedGrenadeTime = .25 * game_get_speed(gamespeed_fps);
FacingX = 0;
FacingY = 0;
EquippedGrenadeID = Item.None;
xp_value = 1;
grenade_angle = random(360);
enemy_aimpunch_direction = 0;
enemy_aimpunch = 0;
healing = false;
equip_time = 0;
equip_timer = -1;
healing_time = -1;
health_packs = 3;
EquippedLandMineID = Item.None;
LandMineAngle = random(360);
EquippedLandMineTime = .25 * game_get_speed(gamespeed_fps);
EquippedLandMineTimer = -1;
LandMines = [3, 3, 3];
AccelX = 0;AccelY = 0;VelocityX = 0;VelocityY = 0;
Grenades = [3, 3, 3, 3]; //HEGrenades, FlashGrenades, SmokeGrenades, MolotovGrenades
GrenadeObject = noone;
check_chasing_timer = 1 * game_get_speed(gamespeed_fps);
alarm[6] = 1;
sprite_index = team == TEAM.TERRORIST ? choose(spr_TerroristBot, spr_TerroristBot3, spr_TerroristBot2) : choose(spr_PoliceBot, spr_PoliceBot2);
alarm[0] = 5;

#region Flashed
FlashedTimer = -1;
FlashedTime = 7 * game_get_speed(gamespeed_fps);
#endregion

rank_boost = get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
rank_less = get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
chasing_timer = ceil(5 * game_get_speed(gamespeed_fps) * rank_boost);

#region Set armour
ArmourID = choose(Item.None, Item.KevlarVest, Item.MilitaryVest);
HelmetID = choose(Item.None, Item.KevlarHelm, Item.MilitaryHelm);
ArmourDurability = [global.ItemIndex[#ArmourID, ItemStat.BaseDurability], global.ItemIndex[#HelmetID, ItemStat.BaseDurability]];
#endregion

#region Movement engine
Acceleration = min(.55 * rank_boost, .9);
Friction = .75;
MaxSpeed = min(2.5 * rank_boost, 5);
MoveDirection  = 0;
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


#region Weapon equip
WeaponID[0] = choose(Item.SG550, Item.AKM, Item.SSG08, Item.Spas, Item.m4a1, Item.awm, Item.galil, Item.MK18, Item.famas);
WeaponID[1] = choose(Item.Glock, Item.DesertEagle, Item.usp, Item.p250, Item.tec9);
Ammo[0] = global.ItemIndex[#WeaponID[0], ItemStat.MaxAmmo];
ClipAmmo[0] = global.ItemIndex[#WeaponID[0], ItemStat.ClipAmmo];
MaxAmmo[0] = global.ItemIndex[#WeaponID[0], ItemStat.MaxAmmo];
Ammo[1] = global.ItemIndex[#WeaponID[1], ItemStat.MaxAmmo];
ClipAmmo[1] = global.ItemIndex[#WeaponID[1], ItemStat.ClipAmmo];
MaxAmmo[1] = global.ItemIndex[#WeaponID[1], ItemStat.MaxAmmo];

attachments = array_create(2);
for(var i = 0; i < 2; i++){
	attachments[i] = array_create(4, Item.None);
}

#region Attachments
if(percent_chance(10 * rank_boost)){
	weapon_attachment_equip(Item.advanced_suppressor, ATTACHMENTS.slot_suppressor, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var item = choose(Item.adaptive_chambering, Item.range_finder);
	weapon_attachment_equip(item, ATTACHMENTS.slot_barrel, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var item = choose(Item.vertical_grip, Item.horizontal_grip);
	weapon_attachment_equip(item, ATTACHMENTS.slot_grip, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var item = choose(Item.red_dot_scope, Item.two_scope);
	weapon_attachment_equip(item, ATTACHMENTS.slot_scope, id, 0);
}

#endregion

Weapon = instance_create_depth(x + WX, y + WY, depth - 1, oWeapon);
Weapon.Visible = false;

#endregion

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
LegHB = noone;
#endregion


