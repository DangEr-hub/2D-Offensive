//Faces same angle as player
if(instance_exists(Object)){
	var movement_amount = min(point_distance(x, y, Object.x, Object.y), 8);
	x = Object.x;
	y = Object.y;
	image_angle = variable_instance_exists(Object, "RotationAngle") ? Object.RotationAngle : Object.image_angle;

	image_blend = c_white;
	if(Object.in_water_timer >= game_get_speed(gamespeed_fps) * .9){
			image_alpha = lerp(image_alpha, 0.75, 0.05);
			image_blend = c_aqua;
	}else{
		image_alpha = Object.image_alpha;
	}

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

	var silent_movement = variable_instance_exists(Object, "walking") && Object.walking;
	var making_steps = image_speed > 0 && movement_amount > 0.001 && !silent_movement;
	if(making_steps){
		var step_interval = Object.object_index == oBot ? 10 : 5;
		if(Object.FootStepTimer < 0){
			Object.FootStepTimer = step_interval;
		}else{
			Object.FootStepTimer -= global.time_step;
		}

		var step_due = Object.FootStepTimer <= 0;
		if(step_due){
			Object.FootStepTimer = step_interval;
			Object.FootSteps++;
		}
		if(Object.Visible && Object.in_water_timer <= game_get_speed(gamespeed_fps) * .9){
			if(Object.object_index != oBot || step_due){
				particle_create(round(movement_amount * random(2)), .8, random(360), spr_MovementParticle, random_range(-movement_amount, movement_amount), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
			}
			if(step_due){
				particle_create(1, 0, image_angle, spr_FootSteps, 0, 0, image_angle, 0, false, false, Object.FootSteps mod 2, x, y, .5, 1.5 * game_get_speed(gamespeed_fps));
			}
		}
	}else{
		Object.FootStepTimer = -1;
		Object.FootSteps = 0;
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

		if(footstep_progress >= half_animation*.5){
			footstep_progress -= half_animation;
			var footsteps = choose(snd_FootStep1, snd_FootStep2);
			if(Object.in_water_timer >= game_get_speed(gamespeed_fps) * .9){
				footsteps = choose(snd_WaterStep1, snd_WaterStep2);
			}
			if(!silent_movement){
				play_sound(x, y, footsteps, Object);
			}
		}
	}
}
