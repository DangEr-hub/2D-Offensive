view_enabled = true;
view_visible[0] = true;

/*
var window_h_before = window_get_height();
var display_h_before = display_get_height();
var extra_h = display_h_before - window_h_before; // Výška titulku a okrajů

// Nastavit velikost okna tak, aby vnitřní část byla přesně 1080p
window_set_size(global.window_width, global.window_height + extra_h);
window_set_rectangle(0, extra_h, global.window_width, global.window_height + extra_h);
surface_resize(application_surface, global.CameraWidth*window_scale, global.CameraHeight*window_scale + extra_h);
display_set_gui_size(global.window_width, global.window_height + extra_h);
camera_set_view_size(CAMERA, global.CameraWidth, global.CameraHeight);

