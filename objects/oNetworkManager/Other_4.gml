/* Room start - oNetworkManager */
if (is_server) {
	global.sv_cheats = true;
    create_local_player(my_pid);
	send_weather_broadcast();
	free_item_ids = ds_stack_create();
	// 0..511
	for (var i = 511; i >= 0; i--) {
		ds_stack_push(free_item_ids, i);
	}
}else if(is_connected == true){
	create_local_player(my_pid);
	with(oItems){instance_destroy();} ///Smaž všechny itemy, řeši se přes server
	send_request_init(); // Požádej server o důležité věci (itemy, hrači a jejich zbraně, armoury...)
}

