if(is_gui){
	var gui_scale = global.GuiW / oDraw.ViewW;
	gui_x += lengthdir_x(movSpd * gui_scale, movDir);
	gui_y += lengthdir_y(movSpd * gui_scale, movDir);
}else{
	x += lengthdir_x(movSpd, movDir);
	y += lengthdir_y(movSpd, movDir);
}