/* Room start - oNetworkManager */
if (is_server) {
	global.sv_cheats = true;
	create_local_player(my_pid);
	send_weather_broadcast();
	free_item_ids = ds_stack_create();
	for (var i = 511; i >= 0; i--) {
		ds_stack_push(free_item_ids, i);
	}
	free_bird_ids = ds_stack_create();
	for (var i = 63; i >= 0; i--) {
		ds_stack_push(free_bird_ids, i);
	}
	free_grenade_ids = ds_stack_create();
	for (var i = 511; i >= 0; i--) {
		ds_stack_push(free_grenade_ids, i);
	}
	free_airplane_ids = ds_stack_create();
	for (var i = 255; i >= 0; i--) {
		ds_stack_push(free_airplane_ids, i);
	}
} else if (is_connected == true) {
	create_local_player(my_pid);
	with (global.local_player) {
		equip_network_propagate();
		weapon_network_propagate();
	}
	with (oItems) { instance_destroy(); } ///Smaz vsechny itemy, resi se pres server
	send_request_init(); // Pozadej server o dulezite veci (itemy, hraci a jejich zbrane, armoury...)
}
