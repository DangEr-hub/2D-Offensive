/// @description Insert description here
// You can write your code in this editor
application_surface_draw_enable(false);
draw_texture_flush();
var_slot = 0;
item_description = "";
Pick = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyPickUp])) + "]";
UseString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyUse])) + "]";
CycleLeftString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleLeft])) + "] --";
CycleRightString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyCycleRight])) + "] ++";
DropString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyDrop])) + "] + " + "[" + 
string(keycode_to_string(global.KeyBinds[| KeyBind.KeyDropMouse])) + "]";
HUDShift = 16; //Distance from edge of monitor
camera_set_view_size(view_camera[0], global.CameraWidth, global.CameraHeight);

NightVisionSurface = -1;
BlackoutSurface = -1;
zoomSurface = -1;
ZoomValue = 1;

draw_set_font(set_font("Console"));

#region Weapon attachments
show_weapon_attachments = false;
#endregion

#region Bokeh effect
randomize();
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
BlurGrayScaleSurface = -1;
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
PauseMenu = false;
RespawnMenu = false;
BackGround = -1;
#endregion

#region Scope
BlackoutSurface = -1;
SurfaceWidth = display_get_gui_width();
SurfaceHeight = display_get_gui_height();
usize = shader_get_uniform(shd_Blur, "size");
BlurValue = 0;
#endregion

#region Bloom
shader_bloom_lum = shd_BloomTwo;
u_bloom_threshold = shader_get_uniform(shader_bloom_lum, "bloom_threshold");
u_bloom_range = shader_get_uniform(shader_bloom_lum, "bloom_range");
bloom_texture = -1;
Surface1 = -1;
Surface2 = -1;
ViewW = camera_get_view_width(view_camera[0]);
ViewH = camera_get_view_height(view_camera[0]);
ViewX = camera_get_view_x(view_camera[0]);
ViewY = camera_get_view_y(view_camera[0]);
shader_bloom_blend = shd_BloomBlend;
u_bloom_intensity = shader_get_uniform(shader_bloom_blend, "bloom_intensity");
u_bloom_darken = shader_get_uniform(shader_bloom_blend, "bloom_darken");
u_bloom_saturation = shader_get_uniform(shader_bloom_blend, "bloom_saturation");
u_bloom_texture = shader_get_sampler_index(shader_bloom_blend, "bloom_texture");
bloom_threshold = 0.29;//0.35;
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