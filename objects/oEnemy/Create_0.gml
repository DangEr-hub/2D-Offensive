/// @description Insert description here
// You can write your code in this editor
event_inherited();
randomize();
check_other_enemies_time = game_get_speed(gamespeed_fps);
alarm[5] = check_other_enemies_time;
hidden = false;
check_smokes_timer = -1;
EquippedLandMine = Item.None;
stats = create_enemy(80, [random_range(150, 200), random_range(70, 170)], irandom_range(15, 70), choose("John", "Joe", "Jorge de Guzman", "Lalo salamanca", "Elvis", "Stuart", "Lewis", "Tommy hilfiger", "Hector", "Cortez", "Rico", "Nico", "Leo"), 80);
WeaponID = [0, 0];
Ammo = [0, 0];
ClipAmmo = [0, 0];
MaxAmmo = [0, 0];
Weapon = noone;
WeaponPositionID = choose(0, 1);
image_speed = 0;
RotationAngle = random(360);
ChasingObject = oPlayer;
Weapon = noone;
WX = 8;
WY = 8;
KickBackAngle = 0;
WeaponDistance = 0;
WeaponNumber = 0;
WeaponNumberMax = 2;
HPTimer = -1;
ChasingObjectSpotted = false;
State = States.Idle;
CanShoot = true;
ShootTimer = -1;
Inaccuracy = 0;
DeathTimer = 5 * game_get_speed(gamespeed_fps);
depth = ChasingObject.depth + 2;
ReloadTime = 0;
Reloading = false;
SpottedDanger = false;
EquippedGrenade = Item.None;
EquippedGrenadeTimer = -1;
EquippedGrenadeTime = .25 * game_get_speed(gamespeed_fps);
FacingX = ChasingObject.x;
FacingY = ChasingObject.y;
VisibilityTimer = -1;
VisibilityTime = 2 * game_get_speed(gamespeed_fps);
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
sprite_index = choose(spr_EnemyBasic, spr_EnemyBasicTwo, spr_EnemyBasicThree, spr_EnemyBasicFour);
alarm[0] = 5;

#region Flashed
FlashedTimer = -1;
FlashedTime = 7 * game_get_speed(gamespeed_fps);
#endregion

#region Set armour
ArmourID = choose(Item.None, Item.KevlarVest, Item.MilitaryVest);
HelmetID = choose(Item.None, Item.KevlarHelm, Item.MilitaryHelm);
ArmourDurability = [global.ItemIndex[#ArmourID, ItemStat.BaseDurability], global.ItemIndex[#HelmetID, ItemStat.BaseDurability]];
#endregion

#region Movement engine
Acceleration = min(.5 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]), .7);
Friction = .75;
MaxSpeed = min(2.5 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]), 5);
MoveDirection  = 0;
MoveTime = 0;
XSpeed = 0;
YSpeed = 0;
ReactionTimer = -1;
ReactionTime = clamp(2 * game_get_speed(gamespeed_fps) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]), .25 * game_get_speed(gamespeed_fps), .75 * game_get_speed(gamespeed_fps));
ChasingDistance = min(768 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]), 1024);
#endregion

#region Legs
FootStepTimer = -1;
FootSteps = 0;
Legs = instance_create_depth(x,y,depth + 1,oObjectLegs);
Legs.Object = id;
#endregion

#region Weapon equip
WeaponID[0] = choose(Item.SG550, Item.AKM, Item.SSG08, Item.Spas, Item.m4a1, Item.awm, Item.galil, Item.m4_carbine, Item.famas);
WeaponID[1] = choose(Item.Glock, Item.DesertEagle, Item.usp, Item.p250);
Ammo[0] = global.ItemIndex[#WeaponID[0], ItemStat.Ammo];
ClipAmmo[0] = global.ItemIndex[#WeaponID[0], ItemStat.ClipAmmo];
MaxAmmo[0] = global.ItemIndex[#WeaponID[0], ItemStat.Ammo];
Ammo[1] = global.ItemIndex[#WeaponID[1], ItemStat.Ammo];
ClipAmmo[1] = global.ItemIndex[#WeaponID[1], ItemStat.ClipAmmo];
MaxAmmo[1] = global.ItemIndex[#WeaponID[1], ItemStat.Ammo];

Weapon = instance_create_depth(x + WX, y + WY, depth - 1, oWeapon);

#endregion

#region Flashlight
FlashLightX = x;
FlashLightY = y;
#endregion

#region Hitbox
HeadHitBox = instance_create_depth(x, y, depth - 1, oHitBox);
HeadHitBox.image_index = HitBox.Head;
HeadHitBox.MainObject = id;
BodyHitBox = instance_create_depth(x, y, depth - 1, oHitBox);
BodyHitBox.image_index = HitBox.BodyWithoutWeapon;
BodyHitBox.MainObject = id;
ArmHitBox = instance_create_depth(x, y, depth - 1, oHitBox);
ArmHitBox.image_index = HitBox.ArmWithoutWeapon;
ArmHitBox.MainObject = id;
//LegHitBox = instance_create_depth(x, y, depth - 1, oHitBox);
//LegHitBox.image_index = HitBox.LegProne;
//LegHitBox.MainObject = id;
//LegHitBox.visible = false;
#endregion


