application_surface_draw_enable(false);
draw_texture_flush();
saturation_level = 0;
KilledByWeapon = "Nothing";
KilledByName = "No one";
var_slot = 0;
item_description = "";
Pick = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyPickUp])) + "]";
DropString = "[" + string(keycode_to_string(global.KeyBinds[| KeyBind.KeyDrop])) + "] + " + "[" + 
string(keycode_to_string(global.KeyBinds[| KeyBind.KeyPickUp])) + "]";
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

#region Bloom
shader_bloom_lum = shd_BloomTwo;
u_bloom_threshold = shader_get_uniform(shader_bloom_lum, "bloom_threshold");
u_bloom_range = shader_get_uniform(shader_bloom_lum, "bloom_range");
bloom_texture = -1;
Surface1 = -1;
Surface2 = -1;
ViewW = camera_get_view_width(CAMERA);
ViewH = camera_get_view_height(CAMERA);
ViewX = camera_get_view_x(CAMERA);
ViewY = camera_get_view_y(CAMERA);
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