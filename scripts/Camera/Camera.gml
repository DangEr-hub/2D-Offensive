function Camera(argument0, argument1, argument2, argument3, argument4) {
	Dist = point_distance(argument0,argument1,argument2,argument3) * argument4;
	Dir = point_direction(argument0,argument1,argument2,argument3);
	x = argument0 + lengthdir_x(Dist,Dir);
	y = argument1 + lengthdir_y(Dist,Dir);



}
