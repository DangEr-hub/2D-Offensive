/// @description Insert description here
// You can write your code in this editor
event_inherited();
randomize();
LightObject = noone;
infra_vision_light = noone;
image_speed = .75;
Angle = 0;
Sprite = choose(spr_Explosion1, spr_Explosion2);
alarm[0] = ceil((sprite_get_number(Sprite) - 2) / image_speed);
ExplosionPower = 1;