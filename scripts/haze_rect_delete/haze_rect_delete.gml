/// @function haze_rect_delete()
/// @arg id
function haze_rect_delete() {

	//Args
	var _id = argument[0];

	//Function
	var arr = obj_hazeC.hazeAreas[|_id];

	arr[@ 0] = -1000;
	arr[@ 1] = -1000;
	arr[@ 2] = 1;
	arr[@ 3] = 1;


}
