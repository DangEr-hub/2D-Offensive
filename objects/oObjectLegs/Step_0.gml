//Faces same angle as player
if(instance_exists(Object)){
	x = Object.x;
	y = Object.y;
	image_angle = variable_instance_exists(Object, "RotationAngle") ? Object.RotationAngle : Object.image_angle;

	var owner_is_dead = variable_instance_exists(Object, "stats")
		&& is_struct(Object.stats)
		&& variable_struct_exists(Object.stats, "Health_points")
		&& Object.stats.Health_points <= 0;
	if(owner_is_dead){
		Visible = false;
		image_speed = 0;
		image_index = first_frame;
		footstep_progress = 0;
		exit;
	}

	//Stops the animation if the player stops moving
	if(image_speed <= 0){
		image_index = first_frame;
		footstep_progress = 0;
	}else{
		var animation_frames = sprite_get_number(spr_ObjectLegs);
		image_index = image_index mod animation_frames;
		var half_animation = animation_frames * .5;
		footstep_progress += abs(image_speed);

		if(footstep_progress >= half_animation){
			footstep_progress -= half_animation;
			var silent_movement = variable_instance_exists(Object, "walking") && Object.walking;
			if(!silent_movement){
				play_sound(x, y, choose(snd_FootStep1, snd_FootStep2), Object);
			}
		}
	}
}
