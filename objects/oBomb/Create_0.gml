event_inherited();
timer = BOMB_TIMER;

if (instance_exists(oDraw)) {
	oDraw.bomb_detonation_pending = false;
	oDraw.round_end_timer = -1;
}

stats = {
	"Item_id": Item.Bomb
};

if (!IS_NET || oNetworkManager.is_server) {
	global.bomb_planted = true;
	global.bomb_timer = BOMB_TIMER;
}

stats = {
	Object: noone,
	Object_index: oBomb,
	Owner_name: "Bomb",
	Owner_id: global.bomb_planter_pid,
	Item_id: Item.Bomb
};

image_xscale = .5;
image_yscale = .5;
image_speed = 0;
image_index = 0;

tick_interval = game_get_speed(gamespeed_fps);
tick_timer = tick_interval;
tick_pulse_duration = 8;
tick_pulse_timer = 0;
tick_light = undefined;

if (instance_exists(oLightRenderer)) {
	tick_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
	tick_light.castShadows = false;
	tick_light.blend = c_red;
	tick_light.xscale = 0.5;
	tick_light.yscale = 0.5;
	tick_light.alpha = 0;
}
