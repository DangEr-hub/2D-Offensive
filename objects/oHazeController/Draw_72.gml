//Get app surf size
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);
var guiW = display_get_gui_width();
var guiH = display_get_gui_height();
var rW = surfW/surfH;
surface_resize(application_surface, guiH * rW,
    guiH);

//Update app surf size
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);

if (!surface_exists(hazeSurf)){
    hazeSurf = surface_create(surfW, surfH);
    haze_surf_clear(hazeSurf);
}
else{
    surface_resize(hazeSurf, surfW, surfH);
}


