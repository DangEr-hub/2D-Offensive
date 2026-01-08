/// @description Insert description here
// You can write your code in this editor
event_inherited();
Visible = true;
ExplodeTimer = 1 * game_get_speed(gamespeed_fps);
image_speed = 0;
z = 100;
zspeed = 0;
zgravity = 10;
zmaxspeed = 20;
z_bouncing = false;
ExplosionTimer = -1;
ExplosionTime = 1 * game_get_speed(gamespeed_fps);
image_angle = random_range(-45, 45);
particle_timer = -1;
z_approach = 0.0175;
play_sound(x, y, snd_FallingBomb);
depth = -1100;


stats = {
	Item_id: Item.base_explosion,
	Damage: global.ItemIndex[#Item.base_explosion, ItemStat.Damage],
	Object_index: -1,
	Owner_name: "Aircraft",
	Object: noone,
};
