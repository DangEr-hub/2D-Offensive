if(moving == true){
	x += moving_x;
	y += moving_y;
}
for (var i = 0; i < num_cloud_particles; i++)
{
    cloud_particles[i,0] += cloud_particles[i,2]; //move
    cloud_particles[i,4] += cloud_particles[i,5];  //rotate
    cloud_particles[i,3] = image_alpha * power(1.0 - abs(cloud_particles[i,0] / radius),cloud_fade);  //calculate alpha
    //reposition
    if (cloud_particles[i,0] > radius)
    {
        cloud_particles[i,0] = -radius;
        cloud_particles[i,1] = random_range(-radius,radius)*0.8;
        cloud_particles[i,5] = random_range(-rotate_speed,rotate_speed);
        cloud_particles[i,6] = random_range(3.5,5)*radius/300;
        cloud_particles[i,7] = cloud_particles[i,6] * choose(-1,1);
        cloud_particles[i,8] = irandom(4);
        cloud_particles[i,9] = c_white;
    }
}

/*
if(distance_to_object(oPlayer) <= radius){
	if(alarm[0] > 1){
		if(oPlayer.hidden == false){
			oPlayer.hidden = true;	
		}
	}else{
		if(oPlayer.hidden == true){
			oPlayer.hidden = false;
		}
	}
}else{
	if(oPlayer.hidden == true){
		oPlayer.hidden = false;	
	}
}

