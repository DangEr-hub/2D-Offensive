/// @description For haze
//Get app surf size
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);

// Keep the game and post-processing surfaces at one stable render size.
var target_surf_w = global.GuiW;
var target_surf_h = global.GuiH;

if (surface_get_width(application_surface) != target_surf_w || surface_get_height(application_surface) != target_surf_h) {
    surface_resize(application_surface, target_surf_w, target_surf_h);
}

//Update app surf size
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);

if (!surface_exists(haze_final_surface)){
    haze_final_surface = surface_create(surfW, surfH);
    haze_surf_clear(haze_final_surface);
}
else if (surface_get_width(haze_final_surface) != surfW || surface_get_height(haze_final_surface) != surfH){
    surface_resize(haze_final_surface, surfW, surfH);
}

