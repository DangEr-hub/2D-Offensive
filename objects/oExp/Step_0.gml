z += zspeed - zgravity;

zspeed *= .75;

if(z <= 0){
	zmaxspeed *= .7;
	zspeed = zmaxspeed;
}

z = clamp(z, 0, 99999);

var scale = 1 + (z/100);

image_xscale = scale;
image_yscale = scale;

if(distance_to_object(oPlayer) <= 96){
	move_towards_point(oPlayer.x, oPlayer.y, 5);
}else{
	move_towards_point(oPlayer.x, oPlayer.y, 0);
	speed = 0;
}
if(place_meeting(x, y, oPlayer)){
	global.player_stats_struct.Xp += value;
	damage_indicator("+" + string_format(value, 0, 1), x, y - z, c_olive, spr_Icons, icons.xp);
	play_sound(x, y, snd_exp_pick_up);
	instance_destroy(self);
}

if(instance_exists(LightObject)){
	LightObject.light[| eLight.X] = x;
	LightObject.light[| eLight.Y] = y - z;
}

if(PushTimer > -1){
    var proposedX = x + ceil(lengthdir_x(PushForce, PushDirection));
    var proposedY = y + ceil(lengthdir_y(PushForce, PushDirection));
    
    if (!place_meeting(proposedX, proposedY, oParentTile)) {
        x = proposedX;
        y = proposedY;
    }
    image_angle += ceil(sign(angle_difference(image_angle, PushDirection)) * PushForce);    

    PushTimer--;
}