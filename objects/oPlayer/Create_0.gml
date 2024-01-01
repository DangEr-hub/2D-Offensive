event_inherited();
RotationAngle = 0;
AccelX = 0;
AccelY = 0;
VelocityX = 0;
VelocityY = 0;
game_set_speed(60, gamespeed_fps);
shooting = false;
ItemUsePosition = 0;
PickUpDistance = 16;
WeaponNumber = 0;
WeaponNumberMax = 2;
CanShoot = true;
ShootTimer = -1;
WeaponID = 0;
WeaponDistance = 0;
Weapon = noone;
MuzzleFlashLight = noone;
XSpeed = 0;
YSpeed = 0;
ScopeIn = false;
ScopeInaccuracyTimer = -1;
EquippedGrenadeTimer = -1;
EquippedGrenadeTime = game_get_speed(gamespeed_fps) * .25;
BloodTimer = -1;
EquipmentAlpha = 0;
ReloadTimer = -1;
FlashedAlpha = 0;
FlashedBackGround = -1;
ToggleNightVision = false;
BaseHealingPower = ceil(global.MaxHP/50);
HealingTime = -1;
HealingItemId = Item.None;
Healing = false;
ToggleInfraVision = false;
infra_vision_light = noone;
AimPunchDir = 0;
KickBack = 0;
KickBackAngle = 0;
KickBackStabilizationSpeed = 1;
kick_back_timer = -1;
KickBackTime = round(.08 * game_get_speed(gamespeed_fps));
Range = 0;
Reloading = false;
ReloadTime = 0;
image_speed = 0;
moving_timer = -1;
moving_state = player_states.none_state;
equip_time = 0;
equip_timer = -1;
player_has_scope = -1;
player_can_shoot = true;
near_explosion = false;
shooting_reset_timer = -1;
weapon_shooting_mode = 0;
grenade_angle = random(360);
triangle_point_distance = 1024;
Name = "DangEr";
WX = 8;
WY = 8;

global.Hostage = false;
global.Weight = 0;

#region Burstfire
burst_fire = false;
burst_shots_fired = 0;
burst_shot_limit = 3;
burst_fire_timer = 0; 
#endregion

#region Statistics
HealingTimer = game_get_speed(gamespeed_fps);
HPHealingTimer = -1;
HP = global.MaxHP;
DamageHP = HP;
HPTimer = -1;
StaminaHealingTimer = -1;
Stamina = global.MaxStamina;
DamageStamina = Stamina;
#endregion

#region Crosshair vars
CrosshairShake = 0;
crosshair_position = [mouse_x, mouse_y];
#endregion

#region Create objects
instance_create_layer(x, y, "OtherO", oDraw);
instance_create_layer(x, y, "OtherO", oConsole);
instance_create_layer(x, y, "OtherO", oCamera);
instance_create_layer(x, y, "OtherO", oCrosshair);
instance_create_layer(x, y, "ItemsO", oParticleSurface);
instance_create_layer(x, y, "OtherO", oParticleSystem);
Weapon = instance_create_depth(x + WX, y + WY, depth - 1, oWeapon);
#endregion

#region Camera
ViewAngle = 0;
ViewShake = false; 
ViewShakeTimer = -1;
ViewShakeValuePower = 0;
#endregion

#region Movement vars
MoveSpeed = 700;
SpeedMul = 1;
Moving = false;
RelativeSpeedValue = MoveSpeed * 0.1;
RelativeSpeedX = 0;
RelativeSpeedY = 0;
MovingStabilizationTime = .05 * game_get_speed(gamespeed_fps);
MovingStabilizationTimer = -1;

#endregion

#region Legs
FootStepTimer = -1;
FootSteps = 0;
Legs = instance_create_depth(x,y,depth + 1,oObjectLegs);
Legs.Object = id;
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
#endregion
