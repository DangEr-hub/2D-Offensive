//Get app surf size
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);

var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

//Aspect Ratio
var rW = surfW/surfH;

//Set app surf size to GUI layer
surface_resize(application_surface, guiH * rW,
    guiH);

//Update app surf size
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);
    
//Adjust location
//var pos = application_get_position();
//display_set_gui_maximise(1, 1, pos[0], pos[1]);

//Set GUI size to app surf
//display_set_gui_size(surfW, surfH);

if (!surface_exists(hazeSurf)){
    hazeSurf = surface_create(surfW, surfH);
    haze_surf_clear(hazeSurf);
}
else{
    surface_resize(hazeSurf, surfW, surfH);
}


