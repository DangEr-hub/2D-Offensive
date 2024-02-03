/// @description Insert description here
// You can write your code in this editor
LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
LightObject.blend = global.GoldColor;
LightObject.xscale = .5;
LightObject.yscale = .5;
Damage = 0;
Tracer = noone;
Object = noone;
mask_index = spr_Bullet;
Weapon = -1;
image_angle = random(360);
PenetrationDamage = 0;
StartingX = 0;
StartingY = 0;
alarm[0] = 1;