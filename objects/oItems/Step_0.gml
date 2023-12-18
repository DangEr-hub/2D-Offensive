z += zspeed - zgravity;

zspeed *= .75;

if(z <= 0){
	zmaxspeed *= .7;
	zspeed = zmaxspeed;
}

z = clamp(z, 0, 99999);

scale = 1 + (z/100);

image_xscale = scale;
image_yscale = scale;

if(instance_exists(LightObject)){
	LightObject.light[| eLight.X] = x;
	LightObject.light[| eLight.Y] = y - z;
}

if(PushTimer > -1){
    // Calculate proposed new positions
    var proposedX = x + ceil(lengthdir_x(PushForce, PushDirection));
    var proposedY = y + ceil(lengthdir_y(PushForce, PushDirection));
    
    // Check for collisions at the proposed positions
    if (!place_meeting(proposedX, proposedY, oParentTile)) {
        x = proposedX;
        y = proposedY;
    }
    image_angle += ceil(sign(angle_difference(image_angle, PushDirection)) * PushForce);    

    PushTimer--;
}

/*part_type_colour1(obj_ParticleSystem.Coin, c_white);
part_particles_create(global.ParticleSystem, x, y - z, obj_ParticleSystem.Coin, 1);
part_type_colour1(obj_ParticleSystem.Coin, c_yellow);*/