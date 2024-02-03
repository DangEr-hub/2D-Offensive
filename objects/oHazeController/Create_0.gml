/// @description Customize here
//Tweak these vars:-------------------------
hazeSpeed = 1; //Speed of the haze animation
hazeSize = 1; //Size of the haze disturbances
hazeWaveLength = 1; //Wavelength of the haze
                    //or, Size of the haze map

viewN = 0; //View number, if using views

//-----------END----------------------------

//vars
cameraUsed = true;
coverScreen = false;
debugMode = false;

//surf
/*if (cameraUsed){
    surfW = view_wview[viewN];
    surfH = view_hview[viewN];
}
else{
    surfW = room_width;
    surfH = room_height;
}*/

//surface
surfW = surface_get_width(application_surface);
surfH = surface_get_height(application_surface);

hazeSurf = surface_create(surfW, surfH);
haze_surf_clear(hazeSurf);

var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

//Aspect Ratio
var rW = surfW/surfH;

//Set app surf size to GUI layer
surface_resize(application_surface, guiH * rW,
    guiH);

//points
hazePoints = ds_list_create();
//0 - X
//1 - Y
//2 - Radius
hazeAreas = ds_list_create();
//0 - X
//1 - Y
//2 - W
//3 - H

//shader
uniTime = shader_get_uniform(sh_haze, "Time");
uniSamp = shader_get_sampler_index(sh_haze, "Noise");
uniSampSize = shader_get_sampler_index(sh_haze, "NoiseSize");

uniSpeed = shader_get_uniform(sh_haze, "Speed");
uniSize = shader_get_uniform(sh_haze, "Size");
uniFreq = shader_get_uniform(sh_haze, "Freq");


/* */
/*  */
