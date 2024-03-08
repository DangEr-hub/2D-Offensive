var view = CAMERA;
var current_view_x = camera_get_view_x(view);
var current_view_y = camera_get_view_y(view);
var view_x = clamp(x, 0, room_width - global.CameraWidth);
var view_y = clamp(y, 0, room_height - global.CameraHeight);

//if(oPlayer.player_can_shoot == true){
	camera_set_view_pos(view, lerp(current_view_x, view_x, .1), lerp(current_view_y, view_y, .1));
//}