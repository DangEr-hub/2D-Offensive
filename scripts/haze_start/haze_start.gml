/// @description  haze_start(views_used, cover_screen);
/// @function  haze_start
/// @param views_used
/// @param  cover_screen
function haze_start(argument0, argument1) {
	if (instance_exists(oHazeController)){
	    show_error("Haze already started", false);
	    return 0;
	}

	instance_create_depth(0, 0, 0, oHazeController);
	oHazeController.cameraUsed = argument0;
	oHazeController.coverScreen = argument1;



}
