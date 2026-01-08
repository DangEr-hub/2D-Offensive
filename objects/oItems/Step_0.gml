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
	    var proposedX = x + ceil(lengthdir_x(PushForce, PushDirection));
	    var proposedY = y + ceil(lengthdir_y(PushForce, PushDirection));
    
	    if (!place_meeting(proposedX, proposedY, oParentTile)) {
	        x = proposedX;
	        y = proposedY;
	    }
	    image_angle += ceil(sign(angle_difference(image_angle, PushDirection)) * PushForce);    

	    PushTimer--;
	}
}

if (IS_NET && !oNetworkManager.is_server) {
   x = lerp(x, target_x, INTERPOLATION_SPD);
   y = lerp(y, target_y, INTERPOLATION_SPD);
}