/// @description  haze_start(views_used, cover_screen);
/// @function  haze_start
/// @param views_used
/// @param  cover_screen
function haze_start(argument0, argument1) {
	if (instance_exists(obj_hazeC)){
	    show_error("Haze already started", false);
	    return 0;
	}

	instance_create_depth(0, 0, 0, obj_hazeC);
	obj_hazeC.cameraUsed = argument0;
	obj_hazeC.coverScreen = argument1;



}
