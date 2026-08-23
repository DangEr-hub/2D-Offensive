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
network_id = -1;
network_authority = (!IS_NET || (instance_exists(oNetworkManager) && oNetworkManager.is_server));
network_visual_only = (IS_NET && !network_authority);
bomb_explosion_broadcasted = false;
missile_sound = -1;
if (audio_emitter_exists(Emitter)) {
	var listener_target = get_audio_listener_target();
	var emitter_x = instance_exists(listener_target) ? get_spatial_audio_x(x, listener_target) : x;
	audio_emitter_position(Emitter, emitter_x, y - z, 0);
	audio_emitter_falloff(Emitter, 100, 2500, 1.5);
	if (instance_exists(global.local_player)) {
		audio_emitter_gain(Emitter, clamp(global.local_player.muffled_sounds, 0, 1));
		audio_emitter_pitch(Emitter, max(1 / 256, global.local_player.muffled_sounds * global.time_step));
	}
	missile_sound = audio_play_sound_on(Emitter, snd_FallingBomb, false, 0);
}
depth = -1100;


stats = {
	Item_id: Item.base_explosion,
	Damage: global.ItemIndex[#Item.base_explosion, ItemStat.Damage],
	Object_index: -1,
	Owner_name: "Aircraft",
	Owner_id: -1,
	Object: noone,
};
