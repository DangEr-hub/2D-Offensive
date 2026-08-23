//Get app surf size
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
else if (surface_get_width(hazeSurf) != surfW || surface_get_height(hazeSurf) != surfH){
    surface_resize(hazeSurf, surfW, surfH);
}

if (!surface_exists(hazePointSurf)){
    hazePointSurf = surface_create(surfW, surfH);
    haze_surf_clear(hazePointSurf);
}
else if (surface_get_width(hazePointSurf) != surfW || surface_get_height(hazePointSurf) != surfH){
    surface_resize(hazePointSurf, surfW, surfH);
}
