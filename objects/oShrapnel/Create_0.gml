/// @description Insert description here
// You can write your code in this editor
event_inherited();
LightObject = new BulbLight(oLightRenderer.lighting, sLightTracer, 0, x, y);
LightObject.castShadows = false;
LightObject.blend = MAIN_COLOR;
LightObject.xscale = .5;
LightObject.yscale = .5;
starting_x = x;
starting_y = y;
Id = Item.None;
Object = noone;
DamageDrop = 0;
PenetrationPower = 0;
Damage = 0;
PenetrationDamage = 0;
WallHit = false;
Distance = 0;