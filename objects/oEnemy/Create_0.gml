/// @description Insert description here
// You can write your code in this editor
event_inherited();
randomize();
Visible = false;
Age = irandom_range(15, 70);
Height = random_range(150, 200);
Weight = random_range(70, 170);
MaxHP = ceil(80 + Height/10 + Weight/10 * 1.1*exp(-(power(Age - 40, 2)/2)));
Name = choose("John", "Joe", "Jorge de Guzman", "Lalo salamanca", "Elvis", "Stuart", "Lewis", "Tommy hilfiger", "Hector", "Cortez", "Rico", "Nico", "Leo");
HP = MaxHP;
DamageHP = MaxHP;
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
WeaponNumberMax = 5;
HPTimer = -1;
ChasingObjectSpotted = false;
State = States.Idle;
CanShoot = true;
ShootTimer = -1;
Inaccuracy = 0;
DeathTimer = 5 * room_speed;
depth = ChasingObject.depth + 2;
ReloadTime = 0;
Reloading = false;
SpottedDanger = false;
EquippedGrenade = Item.None;
EquippedGrenadeTimer = -1;
EquippedGrenadeTime = .25 * room_speed;
MaxStamina = ceil(80 * 1.1*exp(-(power(Age - 40, 2)/2)));
Stamina = MaxStamina;
DamageStamina = Stamina;
FacingX = ChasingObject.x;
FacingY = ChasingObject.y;
VisibilityTimer = -1;
VisibilityTime = 2 * room_speed;
InfraVisionIntensity = 2;
infra_vision_light = noone;
EquippedGrenadeID = Item.None;
grenade_angle = random(360);
healing = false;
equip_time = 0;
equip_timer = -1;
healing_time = -1;
health_packs = 3;
EquippedLandMineID = Item.None;
LandMineAngle = random(360);
EquippedLandMineTime = .25 * room_speed;
EquippedLandMineTimer = -1;
LandMines = [3, 3, 3];
AccelX = 0;AccelY = 0;VelocityX = 0;VelocityY = 0;
Grenades = [3, 3, 3, 3]; //HEGrenades, FlashGrenades, SmokeGrenades, MolotovGrenades
GrenadeObject = noone;
sprite_index = choose(spr_EnemyBasic, spr_EnemyBasicTwo, spr_EnemyBasicThree, spr_EnemyBasicFour);
alarm[0] = 5;

#region Flashed
FlashedTimer = -1;
FlashedTime = 7 * room_speed;
#endregion

#region Set armour
ArmourID = choose(Item.KevlarVest, Item.MilitaryVest, Item.SpecOpsVest, Item.None, Item.Spas);
HelmetID = choose(Item.KevlarHelm, Item.MilitaryHelm, Item.SpecOpsHelm, Item.MilitaryNightVision, Item.BasicNightVision, Item.None);
ArmourDurability = [global.ItemIndex[#ArmourID, ItemStat.BaseDurability], global.ItemIndex[#HelmetID, ItemStat.BaseDurability]];
#endregion

#region Ranks
Rank = irandom_range(RankType.SilverI, RankType.SilverMaster);
#endregion

#region Movement engine
Acceleration = min(.59 * global.RankIndex[#Rank, RankStat.BoostModifier], .75);
Friction = .75;
MaxSpeed = min(3.5 * global.RankIndex[#Rank, RankStat.BoostModifier], 5.75);
MoveDirection  = 0;
MoveTime = 0;
XSpeed = 0;
YSpeed = 0;
ReactionTimer = -1;
ReactionTime = clamp(2 * room_speed * global.RankIndex[#Rank, RankStat.LessModifier], .25 * room_speed, 1.25 * room_speed);
ChasingDistance = min(512 * global.RankIndex[#Rank, RankStat.BoostModifier], 1024);

#endregion

#region Legs
FootStepTimer = -1;
FootSteps = 0;
Legs = instance_create_depth(x,y,depth + 1,oObjectLegs);
Legs.Object = id;
#endregion

#region Weapon equip
WeaponID[0] = Item.Spas;//choose(Item.SG550, Item.AKM, Item.SSG08);
WeaponID[1] = choose(Item.DesertEagle, Item.Glock);
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
LegHitBox = instance_create_depth(x, y, depth - 1, oHitBox);
LegHitBox.image_index = HitBox.LegProne;
LegHitBox.MainObject = id;
LegHitBox.visible = false;
#endregion


