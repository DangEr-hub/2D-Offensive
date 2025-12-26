//Faces same angle as player
if(instance_exists(Object)){
	x = Object.x;
	y = Object.y;
	image_angle = Object.RotationAngle;

	//Stops the animation if the player stops moving
	if (image_speed = 0)
	{
	image_index = 6;	
	}

	//Plays footstep sound when the foot hits the ground during the animation
	if(Object != noone){
		if (image_index = 10){
			play_sound(x, y, choose(snd_FootStep1, snd_FootStep2, snd_FootStep3), Object);
		}

		if (image_index = 19){
			play_sound(x, y, choose(snd_FootStep1, snd_FootStep2, snd_FootStep3), Object);
		}
	}
}