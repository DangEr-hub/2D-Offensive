/// @description  haze_rect_add(x, y, w, h);
/// @function  haze_rect_add
/// @param x
/// @param  y
/// @param  w
/// @param  h
function haze_rect_add(argument0, argument1, argument2, argument3) {
	//Started?
	if (!instance_exists(obj_hazeC)){
	    show_error("Haze not started. Use haze_start()", false);
	    return 0;
	}

	//ID
	var pID = ds_list_size(obj_hazeC.hazeAreas);

	//Add array
	var arr;
	arr[0] = argument0;
	arr[1] = argument1;
	arr[2] = argument2;
	arr[3] = argument3;

	ds_list_add(obj_hazeC.hazeAreas, arr);

	return pID;



}
