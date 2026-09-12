/// @description Insert description here
// You can write your code in this editor
Visible = true;
stuck_offset_x = 0;
stuck_offset_y = 0;
stuck_to = noone;
stuck = false;
ExplodeTimer = 1 * game_get_speed(gamespeed_fps);
image_speed = 0;
z = 0;
zgravity = 4;
zmaxspeed = 20;
zspeed = zmaxspeed;
ExplosionTimer = -1;
ExplosionTime = 1 * game_get_speed(gamespeed_fps);

network_id = -1;
network_owner_pid = 255;
network_authority = true;
network_visual_only = false;
grenade_explosion_broadcasted = false;
network_id_reserved_for_impact = false;
