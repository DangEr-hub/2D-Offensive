application_surface_draw_enable(false);
draw_texture_flush();
aberration_level = 0;
saturation_level = 0;
bird_snd_timer = irandom_range(game_get_speed(gamespeed_fps)*2, game_get_speed(gamespeed_fps) * 7);
KilledByWeapon = "Nothing";
KilledByName = "No one";
var_slot = 0;
item_description = "";
Pick = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyPickUp])) + "]";
HUDShift = 16;

NightVisionSurface = -1;
BlackoutSurface = -1;
zoomSurface = -1;
ZoomValue = 1;

draw_set_font(set_font("Console"));

#region Weapon attachments
show_weapon_attachments = false;
#endregion

#region Bokeh effect

numParticles = 50; 
for (var i = 0; i < numParticles; i++) {
    bokehProperties[i, 0] = random(global.GuiW);
    bokehProperties[i, 1] = random(global.GuiH);
    bokehProperties[i, 2] = random_range(0.5, 2);
    bokehProperties[i, 3] = random_range(0.05, 0.1);
}
#endregion

#region Item description
DrawInfo = false;
#endregion

#region Aimpunch
GrayScaleSurface = -1;
BlurSurface = -1;
#endregion

#region Hotbar
HotBarItems = 3;
BlendColor = shader_get_uniform(shd_LightGray, "blendColor");
#endregion

#region Respawn and pause menu
KilledBy = noone;
#endregion

#region GUI menu
GameEndMenu = false;
PauseMenu = false;
RespawnMenu = false;
BackGround = -1;
#endregion

#region Scope
BlackoutSurface = -1;
SurfaceWidth = display_get_gui_width();
SurfaceHeight = display_get_gui_height();
usize = shader_get_uniform(shd_Blur1Pass, "size");
BlurValue = 0;
#endregion

// hlavní postprocessing surface
post_surface = -1;

// Nightvision
nightvision_surface = -1;

#region Haze
/// @description Customize here
//Tweak these vars:-------------------------
hazeSpeed = 0.5; //Speed of the haze animation
hazeSize = 0.75; //Size of the haze disturbances
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
surfH = surface_get_height(application_surface);

haze_point_surface = -1;

haze_final_surface = surface_create(surfW, surfH);
haze_surf_clear(haze_final_surface);

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

#endregion

#region Bloom
shader_bloom_lum = shd_BloomTwo;
u_bloom_threshold = shader_get_uniform(shader_bloom_lum, "bloom_threshold");
u_bloom_range = shader_get_uniform(shader_bloom_lum, "bloom_range");
bloom_surface1 = -1;
bloom_surface2 = -1;
final_surface = -1;
ViewW = camera_get_view_width(CAM);
ViewH = camera_get_view_height(CAM);
ViewX = camera_get_view_x(CAM);
ViewY = camera_get_view_y(CAM);
shader_bloom_blend = shd_BloomBlend;
u_bloom_intensity = shader_get_uniform(shader_bloom_blend, "bloom_intensity");
u_bloom_darken = shader_get_uniform(shader_bloom_blend, "bloom_darken");
u_bloom_saturation = shader_get_uniform(shader_bloom_blend, "bloom_saturation");
u_bloom_texture = shader_get_sampler_index(shader_bloom_blend, "bloom_texture");
bloom_threshold = 0.29;
bloom_intensity = .05;
bloom_saturation = 5;
shader_blur = shd_BlurLerp;
u_blur_steps = shader_get_uniform(shader_blur, "blur_steps");
u_sigma = shader_get_uniform(shader_blur, "sigma");
u_blur_vector = shader_get_uniform(shader_blur, "blur_vector");
u_texel_size = shader_get_uniform(shader_blur, "texel_size");
bloom_darken = 0.5;
blur_steps = 10;
sigma = .1;
bloom_range = .75;
texel_w = 1/display_get_width();
texel_h = 1/display_get_height();
#endregion

ItemY = global.GuiH - 256;