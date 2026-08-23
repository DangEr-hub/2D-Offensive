/// @description Insert description here
// You can write your code in this editor
event_inherited();
explosion_timer = audio_sound_length(snd_Explosion) * game_get_speed(gamespeed_fps) * .75;
alarm[1] = explosion_timer;
LightObject = noone;
infra_vision_light = noone;
image_speed = 1;
Angle = 0;
Sprite = spr_Explosion;
alarm[0] = round((sprite_get_number(Sprite) - 2) / image_speed);
ExplosionPower = 1;

create_haze_effect(x, y, 10 * game_get_speed(gamespeed_fps), id, "Circle", true, 256);