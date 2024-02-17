/// @description Insert description here
// You can write your code in this editor
event_inherited();
randomize();
alarm[1] = audio_sound_length(snd_Explosion) * game_get_speed(gamespeed_fps) * .75;
LightObject = noone;
infra_vision_light = noone;
image_speed = 1;
Angle = 0;
Sprite = choose(spr_Explosion1, spr_Explosion2);
alarm[0] = ceil((sprite_get_number(Sprite) - 2) / image_speed);
ExplosionPower = 1;