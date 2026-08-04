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
audio_play_sound(snd_Airplane, 0, false);

stats = {
	Health_points: hp,
	Max_health_points: hp,
	Damage_health_points: hp,
	Item_id: Item.base_explosion,
	Damage: 0,
	Object_index: -1,
	Owner_name: "",
	Object: noone,
};
stats.Damage = global.ItemIndex[#stats.Item_id, ItemStat.Damage];












