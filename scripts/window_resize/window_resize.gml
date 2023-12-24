// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function window_resize(){
// Assuming this code runs in a Window Resize event
var new_width = window_get_width();
var new_height = window_get_height();

// Desired aspect ratio (e.g., the original 1920x1080)
var target_aspect = 1920 / 1080;

// Calculate the actual aspect ratio of the new window
var actual_aspect = new_width / new_height;

var cam_width, cam_height;
if (actual_aspect >= target_aspect) {
    // Window is wider than the target aspect ratio
    cam_width = new_height * target_aspect;
    cam_height = new_height;
} else {
    // Window is taller than the target aspect ratio
    cam_width = new_width;
    cam_height = new_width / target_aspect;
}

// Calculate the position to center the camera view
var cam_x = (new_width - cam_width) / 2;
var cam_y = (new_height - cam_height) / 2;// Retrieve the camera from the view
var cam = view_camera[0];

// Set the camera view size
camera_set_view_size(cam, cam_width, cam_height);

// Set the camera view position (if you want to center it)
camera_set_view_pos(cam, cam_x, cam_y);
}