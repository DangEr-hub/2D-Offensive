/// @desc Rotate

if(Object != noone){
	light[| eLight.X] = Object.FlashLightX;
	light[| eLight.Y] = Object.FlashLightY;
	light[| eLight.Direction] = Object.RotationAngle;
}

if(DestroyTimer > -1){
	DestroyTimer --;
}

if(DestroyTimer == 0){
	instance_destroy(self);
}