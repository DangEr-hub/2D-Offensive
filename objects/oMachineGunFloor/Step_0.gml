if(is_struct(stats) && variable_struct_exists(stats, "Object")){
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
}



