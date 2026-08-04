if (IS_NET && !network_authority) {
	exit;
}

var missile = instance_create_layer(x, y + 100, "OtherO", oMissile);
missile.stats = stats;

if (IS_NET && oNetworkManager.is_server) {
	server_process_airplane_bomb_spawn(missile, id);
}










