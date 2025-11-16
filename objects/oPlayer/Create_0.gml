//haze_start(true, false);
event_inherited();
window_resize();
alarm[0] = 1;
Weapon = -1;
Knife = -1;
in_water_timer = -1;
flashed_muffled_sounds = 1; ///Pro efekt muffled soundu u flashbangu
rotation_direction = 1; ///Pro view bobbing
rotation_angle = 0; ///Pro view bobbing
rotation_target = 0; ///Pro view bobbing
knife_attack_timer = -1;
item_equip_timer = -1;
item_equip_time = 10; //Offset kvůli tomu, aby hráč nevystřelil při použití itemu
mortar_coordinates = [x, y];
ViewShakeMagnitude = 0;
stamina_inaccuracy = 1;
MoveDirection = 0;
ax = 0;
ay = 0;
bx = 0;
by = 0;
cx = 0;
cy = 0;
Visible = true;
AccelX = 0;
AccelY = 0;
VelocityX = 0;
VelocityY = 0;
game_set_speed(60, gamespeed_fps);
shooting = false;
item_use_position = 0;
PickUpDistance = 16;
WeaponNumber = 0;
WeaponNumberMax = 2;
CanShoot = true;
ShootTimer = -1;
WeaponID = OtherSlot.Primary;
Weapon = noone;
XSpeed = 0;
YSpeed = 0;
ScopeIn = false;
ScopeInaccuracyTimer = -1;
EquippedGrenadeTimer = -1;
EquippedGrenadeTime = game_get_speed(gamespeed_fps) * .25;
ReloadTimer = -1;
FlashedAlpha = 0;
FlashedBackGround = -1;
ToggleNightVision = false;
BaseHealingPower = ceil(global.player_stats_struct.Max_health/50);
HealingTime = -1;
HealingItemId = Item.None;
Healing = false;
ToggleInfraVision = false;
AimPunchDir = 0;
KickBack = 0;
KickBackAngle = 0;
kick_back_timer = -1;
KickBackTime = round(.08 * game_get_speed(gamespeed_fps));
Range = 0;
Reloading = false;
ReloadTime = 0;
image_speed = 0;
moving_timer = -1;
moving_state = states_player.none_state;
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
stats = create_player(global.player_stats_struct.Max_health, global.player_stats_struct.Max_stamina, global.player_stats_struct.Name);

global.Hostage = false;

#region Burstfire
burst_fire = false;
burst_shots_fired = 0;
burst_shot_limit = 3;
burst_fire_timer = 0; 
#endregion

#region Statistics
HealingTimer = game_get_speed(gamespeed_fps);
HPHealingTimer = -1;
HPTimer = -1;
StaminaHealingTimer = -1;
#endregion

#region Crosshair vars
CrosshairShake = 0;
crosshair_position = [mouse_x, mouse_y];
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
RelativeSpeedValue = MoveSpeed * 0.1;
RelativeSpeedX = 0;
RelativeSpeedY = 0;
MovingStabilizationTime = ceil(.025 * game_get_speed(gamespeed_fps));
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

#region Networking
/// Player Object - Create Event (Network additions)

// Network properties
network_id = -1;
is_local = false;//false;
is_remote = false;
// Interpolation for remote players
target_x = x;
target_y = y;
target_direction = 0;
interpolation_speed = 0.3;

// Network state
network_bit_state = 0;
network_armour_id = Item.None;
network_helmet_id = Item.None;
network_armour_dur = 0;
network_helmet_dur = 0;

#endregion
