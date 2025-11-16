if(is_local == true){
	var knife_offset_x = 40;
	var knife_offset_y = -5;

	if(knife_attack_timer != -1 || Flashed == true){
		knife_offset_x = 30;
		knife_offset_y = 35;
	}
	
	if(moving_state == states_player.prone_state){
		knife_offset_x = 100;
		knife_offset_y = -3;
		
		if(knife_attack_timer != -1 || Flashed == true){
			knife_offset_x = 100;
			knife_offset_y = 34;
		}
	}
	var knife_x = x + lengthdir_x(knife_offset_x, RotationAngle) - lengthdir_y(knife_offset_y, RotationAngle);
	var knife_y = y + lengthdir_y(knife_offset_x, RotationAngle) + lengthdir_x(knife_offset_y, RotationAngle);

	// Update the knife's position
	Knife.x = knife_x;
	Knife.y = knife_y;
}


