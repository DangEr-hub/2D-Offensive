/* oItems step event */
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

if(LightObject != undefined){
	var camera = CAM;
	LightObject.visible = true;
	if!(LightObject.__IsOnScreen(camera_get_view_x(camera), camera_get_view_y(camera), camera_get_view_x(camera) + camera_get_view_width(camera), camera_get_view_y(camera) + camera_get_view_height(camera))){
		LightObject.visible = false;
	}
	LightObject.x = x;
	LightObject.y = y - z;
}

if(!IS_NET || oNetworkManager.is_server){

	if(PushTimer > -1){
	    var proposedX = x + round(lengthdir_x(PushForce, PushDirection));
	    var proposedY = y + round(lengthdir_y(PushForce, PushDirection));
    
	    if (!place_meeting(proposedX, proposedY, oParentTile)) {
	        x = proposedX;
	        y = proposedY;
	    }
	    image_angle += round(sign(angle_difference(image_angle, PushDirection)) * PushForce);    

	    PushTimer--;
	}
}

if (IS_NET && !oNetworkManager.is_server) {
   x = lerp(x, target_x, INTERPOLATION_SPD);
   y = lerp(y, target_y, INTERPOLATION_SPD);
}

#region push items
var inst = instance_place(x, y, oItems);

if(inst != noone){
	var dir = random(360);
    if(point_distance(x, y, inst.x, inst.y) > 4){
        dir = point_direction(inst.x, inst.y, x, y);
    }
    // Jemné postrčení
    AccelX += lengthdir_x(0.1, dir);
    AccelY += lengthdir_y(0.1, dir);
}
// Aplikace fyziky
VelocityX += AccelX;
VelocityY += AccelY;

// Kontrola kolizí se stěnami
var FutureX = x + VelocityX;
var FutureY = y + VelocityY;

if(place_meeting(FutureX, y, oParentTile)){
    VelocityX = -VelocityX * 0.5;
}

if(place_meeting(x, FutureY, oParentTile)){
    VelocityY = -VelocityY * 0.5;
}

x += VelocityX;
y += VelocityY;

// Tření a reset akcelerace
VelocityX *= 0.8;
VelocityY *= 0.8;
AccelX = 0;
AccelY = 0;
#endregion