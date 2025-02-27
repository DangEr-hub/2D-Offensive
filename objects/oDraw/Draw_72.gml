/// @description For haze
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

if (!surface_exists(haze_final_surface)){
    haze_final_surface = surface_create(surfW, surfH);
    haze_surf_clear(haze_final_surface);
}
else{
    surface_resize(haze_final_surface, surfW, surfH);
}

