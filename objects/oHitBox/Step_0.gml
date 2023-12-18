/// @description Insert description here
// You can write your code in this editor

if(instance_exists(MainObject)){
	x = MainObject.x;
	y = MainObject.y;
	image_angle = MainObject.RotationAngle;
	
	if(MainObject.object_index != oPlayer){
		if(instance_exists(MainObject.ChasingObject)){
			if(MainObject.ChasingObject.object_index != oPlayer){
				if(MainObject.ChasingObject.State == States.Death){
					MainObject.ChasingObject = oPlayer;
				}
			}
		}
	}
}