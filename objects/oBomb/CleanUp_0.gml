event_inherited();
if (tick_light != undefined) {
	tick_light.Destroy();
	tick_light = undefined;
}

if (!IS_NET || oNetworkManager.is_server) {
	global.bomb_planted = false;
	global.bomb_timer = 0;
	global.bomb_planter_pid = -1;
}
