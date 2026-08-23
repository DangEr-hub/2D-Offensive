if (IS_NET && !network_authority) {
	exit;
}

var drop_x = x;
var drop_y = y + 100;
var impact_offset = 24;

// The missile impact can be offset by its rotation, so keep the whole impact area off roofs.
if(collision_circle(drop_x, drop_y, impact_offset, oRoof, false, true) != noone){
	alarm[0] = 1;
	exit;
}

var missile = instance_create_layer(drop_x, drop_y, "OtherO", oMissile);
missile.stats = stats;

if (IS_NET && oNetworkManager.is_server) {
	server_process_airplane_bomb_spawn(missile, id);
}










