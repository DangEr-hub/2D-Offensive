view_enabled = true;
view_visible[0] = true;
window_set_size(global.window_width, global.window_height);
surface_resize(application_surface, global.CameraWidth*window_scale, global.CameraHeight*window_scale);
camera_set_view_size(CAMERA, global.CameraWidth, global.CameraHeight);