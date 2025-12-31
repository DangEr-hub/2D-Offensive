event_inherited();
setting_tab_width = 512 * global.GUIMultiplier;
setting_tab_height = 512 * global.GUIMultiplier;

//draw_set_valign(1);
draw_set_font(set_font("Menu_small"));
zui_set_size(setting_tab_width, setting_tab_height);

gap = 256 * global.GUIMultiplier;
position_x = 32 + global.GUIMultiplier;
position_y = 64 + global.GUIMultiplier;
toggle_particles_string = "Particles: ";
crosshair_color_string = "Crosshair color (rgb): ";
toggle_bloom_string = "Bloom shader: ";
anti_aliasing_string = "Anti-aliasing: ";
volume_gain_string = "Volume gain: ";
text_height = string_height("a")*2;

window_resolution_callback = function() {
    var resolutions = [
        [480, 270],
        [960, 540],
        [1280, 720],
        [1366, 768],
        [1600, 900],
        [1920, 1080]
    ];

    var index = -1;

    // najdi současné rozlišení
    for (var i = 0; i < array_length(resolutions); i++) {
        if (global.window_width == resolutions[i][0] &&
            global.window_height == resolutions[i][1]) 
        {
            index = i;
            break;
        }
    }

    // další index
    index = (index + 1) mod array_length(resolutions);

	ui_scale_set_window_size(resolutions[index][0], resolutions[index][1]);

    // update caption
    with (window_resolution_button) {
        caption = string(global.window_width) + " x " + string(global.window_height);
    }

    save_game();
};

gui_scale_callback = function() {
    var gui_scales = [1, 1.5, 2];
    var closest_index = 0;
    var smallest_diff = abs(global.GUIMultiplier - gui_scales[0]);
    
    for (var i = 1; i < array_length(gui_scales); i++) {
        var diff = abs(global.GUIMultiplier - gui_scales[i]);
        if (diff < smallest_diff) {
            closest_index = i;
            smallest_diff = diff;
        }
    }
    
    if (closest_index + 1 < array_length(gui_scales)) {
        global.GUIMultiplier = gui_scales[closest_index + 1];
    } else {
        global.GUIMultiplier = gui_scales[0];
    }
    
    with(gui_scale_button){
        caption = string(global.GUIMultiplier);
    }
    reset_gui();
    save_game();
};



toggle_particles_callback = function(){
	with(toggle_particles_button){
		if(global.DrawParticles == false){
			global.DrawParticles = true;
			caption = "On";
		}else{
			global.DrawParticles = false;
			caption = "Off";
		}
	}
	save_game();
};

crosshair_color_text_input_callback = function(InputText){
	set_crosshair_color(InputText);	
	save_game();
};

anti_aliasing_callback = function() {
    var max_anti_aliasing = display_aa;

    function is_AA_supported(maxAA, level) {
        return (maxAA & level) == level;
    }

    switch (global.anti_aliasing) {
        case 0:
            if (is_AA_supported(max_anti_aliasing, 2)) global.anti_aliasing = 2;
            else if (is_AA_supported(max_anti_aliasing, 4)) global.anti_aliasing = 4;
            else if (is_AA_supported(max_anti_aliasing, 8)) global.anti_aliasing = 8;
            else global.anti_aliasing = 0;
            break;
        
        case 2:
            if (is_AA_supported(max_anti_aliasing, 4)) global.anti_aliasing = 4;
            else if (is_AA_supported(max_anti_aliasing, 8)) global.anti_aliasing = 8;
            else global.anti_aliasing = 0;
            break;
        
        case 4:
            if (is_AA_supported(max_anti_aliasing, 8)) global.anti_aliasing = 8;
            else global.anti_aliasing = 0;
            break;
        
        case 8:
            global.anti_aliasing = 0;
            break;
    }
    
    display_reset(global.anti_aliasing, false);

    with (anti_aliasing_button) {
        switch(global.anti_aliasing) {
            case 0: caption_string = "Off"; break;
            case 2: caption_string = "2x"; break;
            case 4: caption_string = "4x"; break;
            case 8: caption_string = "8x"; break;
        }
        caption = caption_string;
    }
	save_game();
};

toggle_bloom_callback = function(){
	with(toggle_bloom_button){
		if(global.BloomShader == false){
			global.BloomShader = true;
			caption = "On";
		}else{
			global.BloomShader = false;
			caption = "Off";
		}
	}
	save_game();
};


with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Settings";
	draggable = 1;
}

with (zui_create(position_x + gap, position_y - text_height/4, objUISlider)) {
	zui_set_anchor(0.5, 0);
	zui_set_width(256);

	minimum = 0;
	maximum = 100;
	value = global.sound_gain;
	type = "Volume";
	
	callback = function(_id, _value){
		audio_master_gain(value/100);
		save_game();
	};
}

draw_set_font(set_font("Console"));
with (zui_create(position_x, position_y, objUILabel)) {
	color = c_white;
	caption = other.volume_gain_string;
}

#region Anti-aliasing
with(zui_create(position_x, position_y + text_height, objUILabel)){
	color = c_white;
	caption = other.anti_aliasing_string;
}

anti_aliasing_button = zui_create(position_x + gap, position_y + text_height/2, objUIButton);
with(anti_aliasing_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(64 * global.GUIMultiplier);
	zui_set_height(16 * global.GUIMultiplier);
	
    switch(global.anti_aliasing) {
        case 0: caption = "Off"; break;
        case 2: caption = "2x"; break;
        case 4: caption = "4x"; break;
        case 8: caption = "8x"; break;
    }
	callback = other.anti_aliasing_callback;
}
#endregion

#region Toggle bloom shader
with(zui_create(position_x, position_y + text_height*2, objUILabel)){
	color = c_white;
	caption = other.toggle_bloom_string;
}

toggle_bloom_button = zui_create(position_x + gap, position_y + text_height/2 + text_height, objUIButton);
with(toggle_bloom_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(64 * global.GUIMultiplier);
	zui_set_height(16 * global.GUIMultiplier);
	
	caption = "On";
	if(global.BloomShader == false){
		caption = "Off";
	}
	callback = other.toggle_bloom_callback;
}
#endregion

#region Draw particles
with(zui_create(position_x, position_y + text_height*3, objUILabel)){
	color = c_white;
	caption = other.toggle_particles_string;
}

toggle_particles_button = zui_create(position_x + gap, position_y - text_height/4 + text_height*3, objUIButton);
with(toggle_particles_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(64 * global.GUIMultiplier);
	zui_set_height(16 * global.GUIMultiplier);
	
	caption = "On";
	if(global.DrawParticles == false){
		caption = "Off";
	}
	callback = other.toggle_particles_callback;
}
#endregion

#region Crosshair color
with(zui_create(position_x, position_y + text_height*4, objUILabel)){
	color = c_white;
	caption = other.crosshair_color_string;
}

with(zui_create(position_x + gap*.75, position_y + text_height*4 - text_height/3, objUITextInput)){
	zui_set_anchor(0, 0);
	var r = (global.crosshair_color >> 16) & 0xFF;
	var g = (global.crosshair_color >> 8) & 0xFF;
	var b = global.crosshair_color & 0xFF;
	var r_str = string(r);
	var g_str = string(g);
	var b_str = string(b);
	r_str = string_repeat("0", 3 - string_length(r_str)) + r_str;
	g_str = string_repeat("0", 3 - string_length(g_str)) + g_str;
	b_str = string_repeat("0", 3 - string_length(b_str)) + b_str;

	init_text = r_str + g_str + b_str;
	max_string_length = string_length("255255255");
	callback = other.crosshair_color_text_input_callback;
}
#endregion

#region Fullscreen
checkbox_size = 16 * global.GUIMultiplier;
fullscreen_string = "Toggle fullscreen: ";
with(zui_create(position_x, position_y + text_height*5, objUILabel)){
	color = c_white;
	caption = other.fullscreen_string;
}

with(zui_create(position_x + gap, position_y + text_height*5 - checkbox_size/2, objUICheckbox)){
	zui_set_anchor(0, 0);
	zui_set_size(other.checkbox_size, other.checkbox_size);
	value = window_get_fullscreen();
	callback = function(){
		value = !value;
		window_set_fullscreen(value);
	};
}
#endregion

#region Player name
player_name_string = "Player’s name: ";
with(zui_create(position_x, position_y + text_height*6, objUILabel)){
	color = c_white;
	caption = other.player_name_string;
}

with(zui_create(position_x + gap*.75, position_y + text_height*6 - text_height/3, objUITextInput)){
	zui_set_anchor(0, 0);
	init_text = global.player_stats_struct.Name;
	max_string_length = 16;
	callback = function(InputText){
		global.player_stats_struct.Name = InputText;
	};
}
#endregion

#region Window size
with(zui_create(position_x, position_y + text_height*7, objUILabel)){
	color = c_white;
	caption = "Window size: ";
}

window_resolution_button = zui_create(position_x + gap, position_y + text_height * 6.5, objUIButton);

with (window_resolution_button) {
    zui_set_anchor(0.5, 0);
    zui_set_width(96 * global.GUIMultiplier);
    zui_set_height(24 * global.GUIMultiplier);

    caption = string(global.window_width) + " x " + string(global.window_height);
    callback = other.window_resolution_callback;
}


#endregion

#region GUI scale
with(zui_create(position_x, position_y + text_height*8, objUILabel)){
	color = c_white;
	caption = "GUI scale: ";
}

gui_scale_button = zui_create(position_x + gap, position_y - text_height/4 + text_height*8, objUIButton);
with(gui_scale_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(64 * global.GUIMultiplier);
	zui_set_height(16 * global.GUIMultiplier);
	
	caption = global.GUIMultiplier;
	callback = other.gui_scale_callback;
}
#endregion











