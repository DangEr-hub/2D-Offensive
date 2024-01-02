/// @description Insert description here
// You can write your code in this editor
InSmoke = false;
AimPunchTimer = -1;
AimPunchTime = .25 * game_get_speed(gamespeed_fps);
AimPunchMultiplier = 1;
ArmourDurability = [0, 0];
alarm[1] = 1;
StaminaTimer= -1;
KilledBy = noone;
Emitter = -1; 
KickBackAngle = 0;
Flashed = false;
HitMap = ds_map_create();