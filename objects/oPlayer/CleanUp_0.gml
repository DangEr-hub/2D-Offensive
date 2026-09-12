/// @description Clean up
event_inherited();

if (is_local && dilatation_timer > -1) {
	global.time_step = 1;
}

if(is_local && instance_exists(oTerminal)){
	with(oTerminal) zui_destroy();
}

var owned_instances = [Weapon, Shield, Legs, HeadHB, BodyHB, ArmHB, LegHB];
for (var owned_index = 0; owned_index < array_length(owned_instances); owned_index++) {
	var owned_instance = owned_instances[owned_index];
	if (instance_exists(owned_instance)) {
		instance_destroy(owned_instance);
	}
}

ds_list_destroy(bot_select_list);

