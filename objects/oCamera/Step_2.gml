var view_x = clamp(x, 0, room_width - global.CameraWidth);
var view_y = clamp(y, 0, room_height - global.CameraHeight);
var view = view_camera[0];

camera_set_view_pos(view, x, y);