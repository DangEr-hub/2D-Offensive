if(global.local_player.mortar_coordinates[0] != 0 && global.local_player.mortar_coordinates[1] != 0){
	image_angle = point_direction(x, y, global.local_player.mortar_coordinates[0], global.local_player.mortar_coordinates[1]);
}


if(shoot_timer > -1){
	shoot_timer --;
}

if(shoot_timer == 0 && instance_exists(oMortarMenu)){
	oMortarMenu.launch_button.alpha = 1;	
}