/// @description  haze_circle_radius(id, radius);
/// @function  haze_circle_radius
/// @param id
/// @param  radius
function haze_circle_radius(argument0, argument1) {
	//Started?
	if (!instance_exists(oHazeController)){
	    show_error("Haze not started. Use haze_start()", false);
	    return 0;
	}

	//Change
	var arr = oHazeController.hazePoints[| argument0];

	var newArr;
	newArr[0] = arr[0];
	newArr[1] = arr[1];
	newArr[2] = argument1;

	oHazeController.hazePoints[| argument0] = newArr;



}
