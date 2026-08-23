event_inherited();
part_pos = [];
hp = 100;
fog_timer = -1;
base_spd = 15;
alarm[0] = round(random_range(game_get_speed(gamespeed_fps) * .5, game_get_speed(gamespeed_fps) * 1.1));
network_id = -1;
network_authority = (!IS_NET || (instance_exists(oNetworkManager) && oNetworkManager.is_server));
network_visual_only = (IS_NET && !network_authority);
network_target_x = x;
network_target_y = y;
network_target_direction = direction;
network_sync_timer = irandom_range(5, 15);
airplane_sound = -1;
if (audio_emitter_exists(Emitter)) {
	var listener_target = get_audio_listener_target();
	var emitter_x = instance_exists(listener_target) ? get_spatial_audio_x(x, listener_target) : x;
	audio_emitter_position(Emitter, emitter_x, y, 0);
	audio_emitter_falloff(Emitter, 200, 3500, 1);
	if (instance_exists(global.local_player)) {
		audio_emitter_gain(Emitter, clamp(global.local_player.muffled_sounds, 0, 1));
		audio_emitter_pitch(Emitter, max(1 / 256, global.local_player.muffled_sounds * global.time_step));
	}
	airplane_sound = audio_play_sound_on(Emitter, snd_Airplane, false, 0);
}

stats = {
	Health_points: hp,
	Max_health_points: hp,
	Damage_health_points: hp,
	Item_id: Item.base_explosion,
	Damage: 0,
	Object_index: -1,
	Owner_name: "Aircraft",
	Owner_id: -1,
	Object: noone,
};
stats.Damage = global.ItemIndex[#stats.Item_id, ItemStat.Damage];












