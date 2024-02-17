/// @description Insert description here
// You can write your code in this editor
event_inherited();
LightObject = new BulbLight(oLightRenderer.lighting, sLightTracer, 0, x, y); 
collision_x = 0;
collision_y = 0;
LightObject.castShadows = false;
Damage = 0;
infra_vision_light = undefined;
image_speed = 0;
HitList = ds_list_create();
ShotX = 0;
ShotY = 0;
starting_x = 0;
starting_y = 0;
WallHit = false;
Object = noone;
Weapon = -1;
PenetrationDamage = 0;
speed = global.BulletSpeed;
NearestEnemy = noone;
