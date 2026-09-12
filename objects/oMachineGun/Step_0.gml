if (IS_NET && operator_pid >= 0 && !instance_exists(stats.Object)) {
	var network_operator = find_instance_by_network_id(oPlayer, operator_pid);
	if (instance_exists(network_operator)) {
		stats.Object = network_operator;
		if (network_operator.is_local) {
			mount_local_player_to_machine_gun(network_operator, id);
		} else {
			var mount_pos = local_to_world(0, 96, image_angle, id);
			network_operator.x = mount_pos[0];
			network_operator.y = mount_pos[1];
			network_operator.target_x = mount_pos[0];
			network_operator.target_y = mount_pos[1];
			network_operator.moving_state = STATES_PLAYER.machine_gun_state;
			network_operator.network_moving_state = STATES_PLAYER.machine_gun_state;
			network_operator.network_weapon_id = Item.basic_machine_gun;
			network_operator.network_scope = stats.Slot_scope;
			network_operator.network_barrel = stats.Slot_barrel;
			network_operator.network_grip = stats.Slot_grip;
			network_operator.network_suppressor = stats.Slot_suppressor;
		}
	}
}

var operator_active = instance_exists(stats.Object);
if(operator_active && variable_instance_exists(stats.Object, "stats")){
	operator_active = stats.Object.stats.Health_points > 0;
}
if(operator_active && stats.Object.object_index == oPlayer){
	operator_active = stats.Object.moving_state == STATES_PLAYER.machine_gun_state;
}else if(operator_active && stats.Object.object_index == oBot){
	operator_active = stats.Object.State == STATES.MACHINE_GUN;
}

if(operator_active){
	image_angle = stats.Object.RotationAngle;
}else{
	stats.Object = noone;
}
