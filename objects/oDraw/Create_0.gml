application_surface_draw_enable(false);
draw_texture_flush();
decor_n = irandom_range(50, 100);
decor_spawned = false;
aberration_level = 0;
saturation_level = 0;
bird_snd_timer = irandom_range(game_get_speed(gamespeed_fps)*2, game_get_speed(gamespeed_fps) * 7);
river_emitter = audio_emitter_create();
river_sound = -1;
if (audio_emitter_exists(river_emitter)) {
	audio_emitter_falloff(river_emitter, 64, 512, 1);
}
KilledByWeapon = "Nothing";
KilledByName = "No one";
var_slot = 0;
item_description = "";
Pick = "[" + string(keycode_to_string(global.KeyBinds[| KEY.PickUp])) + "]";
HUDShift = 16;
buy_time = 0;
buy_period_message_timer = 0;
round_end_timer = -1;
bomb_detonation_pending = false;
alarm[1] = audio_sound_length(snd_Wind);

network_pools = [
	"10.0.0",
	"10.10.0",
	"10.20.4",
	"10.42.0",
	"172.16.0",
	"172.20.0",
	"172.31.0",
	"192.168.0",
	"192.168.1",
	"192.168.10"
];
network_prefix = network_pools[irandom(array_length(network_pools) - 1)];
network_gateway = network_prefix + ".1";

network_usernames = [
	"admin", "operator", "root", "sysadmin", "service",
	"joe", "bob", "daniel", "alex", "sam",
	"guest", "support", "security", "control", "manager"
];
network_passwords = [
	"admin", "1975", "1111", "123456", "password",
	"qwerty", "letmein", "welcome", "access", "control",
	"service", "security", "operator", "system", "network"
];
network_username = network_usernames[irandom(array_length(network_usernames) - 1)];
network_password = network_passwords[irandom(array_length(network_passwords) - 1)];

network_next_host = 2;
network_camera_number = 1;
network_door_number = 1;
network_laser_number = 1;
network_terminal_number = 1;
network_terminal_ip = "";
network_terminal_name = "";
network_devices_initialized = false;

register_network_device = function(device, device_prefix){
	if(!instance_exists(device)) return;
	if(variable_instance_exists(device, "network_ip") && device.network_ip != "") return;
	if(device_prefix == "t" && network_terminal_ip != ""){
		device.network_ip = network_terminal_ip;
		device.network_name = network_terminal_name;
		device.network_online = true;
		device.network_world_x = device.x;
		device.network_world_y = device.y;
		return;
	}

	device.network_ip = network_prefix + "." + string(network_next_host);
	device.network_online = true;
	network_next_host++;

	switch(device_prefix){
		case "c":
			device.network_name = "c" + string(network_camera_number);
			network_camera_number++;
		break;

		case "d":
			device.network_name = "d" + string(network_door_number);
			network_door_number++;
		break;

		case "l":
			device.network_name = "l" + string(network_laser_number);
			network_laser_number++;
		break;

		case "t":
			device.network_name = "t" + string(network_terminal_number);
			network_terminal_ip = device.network_ip;
			network_terminal_name = device.network_name;
			network_terminal_number++;
		break;
	}

	device.network_world_x = device.x;
	device.network_world_y = device.y;
};

NightVisionSurface = -1;
BlackoutSurface = -1;
zoomSurface = -1;
ZoomValue = 1;

wind = {
	time_modifier: random_range(150.0, 250.0),
	amplitude: random_range(0.5, 1.5),
	strength: random_range(1.5, 2.5)
};

if(global.ranked_game == true){
	buy_time = BUY_TIME;	
}

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
rain_flares = [];
rain_timer = -1;
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
spectating = false;
spectate_target = noone;
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
haze_source_surface = -1;

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
u_bloom_texel_size = shader_get_uniform(shader_bloom_blend, "bloom_texel_size");
u_bloom_neighbor_strength = shader_get_uniform(shader_bloom_blend, "bloom_neighbor_strength");
u_bloom_neighbor_radius = shader_get_uniform(shader_bloom_blend, "bloom_neighbor_radius");
u_bloom_blend_threshold = shader_get_uniform(shader_bloom_blend, "bloom_threshold");
u_bloom_blend_range = shader_get_uniform(shader_bloom_blend, "bloom_range");
bloom_threshold = 0.35;
bloom_intensity = .1;
bloom_saturation = 5;
bloom_neighbor_strength = 1; // přímý efekt okolních světlých pixelů (0 = vypnuto)
bloom_neighbor_radius = 4; // vzdálenost okolních vzorků v pixelech
shader_blur = shd_BlurLerp;
u_blur_steps = shader_get_uniform(shader_blur, "blur_steps");
u_sigma = shader_get_uniform(shader_blur, "sigma");
u_blur_vector = shader_get_uniform(shader_blur, "blur_vector");
u_texel_size = shader_get_uniform(shader_blur, "texel_size");
bloom_darken = 1;
blur_steps = 16;
sigma = .5;
bloom_range = .55;
#endregion

ItemY = global.GuiH - 256;
