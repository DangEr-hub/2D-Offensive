// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function smoke_effect_create(Radius, MoveDirection, MoveSpeed, RotateSpeed, Num, Alpha, Fade, Time){
	radius = Radius;//random_range(150, 250);  //size of cloud
	move_dir = MoveDirection;//random(360);  //movement of particles
	move_speed = MoveSpeed;//0.6;  //movement of particles
	rotate_speed = RotateSpeed;//random_range(.1, .5);
	num_cloud_particles = Num;//random_range(3, 11);
	cloud_particles[num_cloud_particles,9] = 0;
	image_alpha = Alpha;//random_range(.25, .5); //cloud alpha
	cloud_fade = Fade;//random_range(.5, 1.5);  //governs how quickly clouds particles fade in and out (should be near 1.0
	alarm[0] = Time;//random_range(3 * room_speed, 5 * room_speed);

	for (var i = 0; i < num_cloud_particles; i++)
	{
	    cloud_particles[i,0] = ((i / num_cloud_particles)*2-1)*radius;  //x position
	    cloud_particles[i,1] = random_range(-radius,radius)*0.8;  //y position
	    cloud_particles[i,2] = move_speed; //speed
	    cloud_particles[i,3] = image_alpha * power(1.0 - abs(cloud_particles[i,0] / radius),cloud_fade);
	    cloud_particles[i,4] = random(360); //image angle
	    cloud_particles[i,5] = random_range(-rotate_speed,rotate_speed); //rotation rate
	    cloud_particles[i,6] = random_range(5,7)*radius/300;
	    cloud_particles[i,7] = cloud_particles[i,6] * choose(-1,1);
	    cloud_particles[i,8] = irandom(4);
	    cloud_particles[i,9] = c_white;
	}
}