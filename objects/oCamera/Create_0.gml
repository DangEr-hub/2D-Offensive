global.CameraWidth = 1920/2;
global.CameraHeight = 1080/2;
window_scale = 2;
alarm[0] = 1;
Object = oPlayer;
Speed = .5;
view_enable = true;

window_set_size(global.CameraWidth*window_scale, global.CameraHeight*window_scale);
surface_resize(application_surface, global.CameraWidth*window_scale, global.CameraHeight*window_scale);
camera_set_view_size(view_camera[0], global.CameraWidth, global.CameraHeight);


