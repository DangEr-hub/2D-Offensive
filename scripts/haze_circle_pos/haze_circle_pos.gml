/// @description  haze_circle_pos(id, x, y);
/// @function  haze_circle_pos
/// @param id
/// @param  x
/// @param  y
function haze_circle_pos(argument0, argument1, argument2) {
	//Started?
	if (!instance_exists(obj_hazeC)){
	    show_error("Haze not started. Use haze_start()", false);
	    return 0;
	}

	//Change
	var arr = obj_hazeC.hazePoints[| argument0];

	var newArr;
	newArr[0] = argument1;
	newArr[1] = argument2;
	newArr[2] = arr[2];

	obj_hazeC.hazePoints[| argument0] = newArr;



}
