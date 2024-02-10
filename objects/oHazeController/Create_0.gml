/// @description Customize here
//Tweak these vars:-------------------------
hazeSpeed = 1; //Speed of the haze animation
hazeSize = 1; //Size of the haze disturbances
hazeWaveLength = 1; //Wavelength of the haze
                    //or, Size of the haze map

viewN = 0; //View number, if using views

//-----------END----------------------------

//vars
cameraUsed = false;
coverScreen = false;
debugMode = false;

//surface
surfW = surface_get_width(application_surface);
show_debug_message("SurfW: " + string(surfW));
surfH = surface_get_height(application_surface);

hazeSurf = surface_create(surfW, surfH);
haze_surf_clear(hazeSurf);

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
