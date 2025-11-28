/* Room start - oNetworkManager */
if (IS_SERVER) {
	global.sv_cheats = true;
    create_local_player(my_pid);
	send_weather_broadcast();
}else if(is_connected == true){
	create_local_player(my_pid);
	with(oItems){instance_destroy();} ///Smaž všechny itemy, řeši se přes server
	send_request_init(); // Požádej server o důležité věci (itemy, hrači a jejich zbraně, armoury...)
}