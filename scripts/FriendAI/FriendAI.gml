function MoveToPoint(PointX, PointY, Accel){
	var margin = 32;
	var distance = point_distance(x, y, PointX, PointY);
	MoveTime = distance/MaxSpeed;
	if(distance > margin){
		MoveDirection = point_direction(x, y, PointX, PointY);
		alarm[0] = MoveTime * random(1);
		XSpeed += lengthdir_x(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
		YSpeed += lengthdir_y(Accel, MoveDirection) * (game_get_speed(gamespeed_fps)/60);
	}else{
		set_state(States.NoMove);
	}
}

function StopMove(){
	MoveTime = 0;
	MoveDirection = 0;
	XSpeed = 0;
	YSpeed = 0;
}