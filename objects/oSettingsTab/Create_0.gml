event_inherited();
ingame_overlay = false;
overlay_black = noone;
setting_tab_width = max(512 * global.gui_scale, 768);
setting_tab_height = max(512 * global.gui_scale, 768);

//draw_set_valign(1);
draw_set_font(set_font("GUI_small"));
zui_set_size(setting_tab_width, setting_tab_height);

gap = 288 * global.gui_scale;
position_x = 32 + global.gui_scale;
position_y = 64 + global.gui_scale;
toggle_particles_string = "Particles: ";
crosshair_color_string = "Crosshair color (rgb): ";
toggle_bloom_string = "Bloom shader: ";
anti_aliasing_string = "Anti-aliasing: ";
volume_gain_string = "Volume gain: ";
saturation_level_string = "Saturation level: ";
text_height = min(string_height("a")*2, 36 * global.gui_scale);

language_callback = function(language_code){
	global.language = language_code;
	language_cz_checkbox.value = language_code == "cz";
	language_en_checkbox.value = language_code == "en";
	save_game();
};

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
    var gui_scales = [1, 2];
    var closest_index = 0;
    var smallest_diff = abs(global.gui_scale - gui_scales[0]);
    
    for (var i = 1; i < array_length(gui_scales); i++) {
        var diff = abs(global.gui_scale - gui_scales[i]);
        if (diff < smallest_diff) {
            closest_index = i;
            smallest_diff = diff;
        }
    }
    
    if (closest_index + 1 < array_length(gui_scales)) {
        global.gui_scale = gui_scales[closest_index + 1];
    } else {
        global.gui_scale = gui_scales[0];
    }
    
    with(gui_scale_button){
        caption = string(global.gui_scale);
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

crosshair_type_callback = function(type_index){
	global.cs_conf.type = type_index;
	for(var checkbox_index = 0; checkbox_index < 4; checkbox_index++){
		crosshair_type_checkboxes[checkbox_index].value = checkbox_index == type_index;
	}
	save_game();
};

crosshair_outline_color_callback = function(input_text){
	set_crosshair_color(input_text, true);
	save_game();
};

crosshair_reset_callback = function(){
	global.cs_conf.width = 15;
	global.cs_conf.height = 2;
	global.cs_conf.alpha = 1;
	global.cs_conf.scale = 1;
	global.cs_conf.outline = true;
	global.cs_conf.outline_w = 1;
	global.cs_conf.outline_color = c_black;
	global.cs_conf.color = c_white;
	global.cs_conf.dynamic = false;
	global.cs_conf.spread = 24;

	var reset_sliders = [
		[spread_slider, 24], [width_slider, 15], [height_slider, 2],
		[outline_width_slider, 1], [alpha_slider, 20], [scale_slider, 4]
	];
	for(var slider_index = 0; slider_index < array_length(reset_sliders); slider_index++){
		var slider = reset_sliders[slider_index][0];
		var slider_value = reset_sliders[slider_index][1];
		slider.value = slider_value;
		slider.pvalue = slider_value;
		slider.handle.__x = inverse_lerp(slider.minimum, slider.maximum, slider_value) * (slider.__width - 16) + 8;
	}
	spread_slider_label.caption = "Spread: 24";
	width_slider_label.caption = "Width: 15";
	height_slider_label.caption = "Height: 2";
	outline_width_slider_label.caption = "Outline W: 1";
	alpha_slider_label.caption = "Alpha: 1";
	scale_slider_label.caption = "Scale: 1";
	outline_checkbox.value = true;
	dynamic_crosshair_checkbox.value = false;
	crosshair_color_input.init_text = "255255255";
	crosshair_color_input.chars = ["2", "5", "5", "2", "5", "5", "2", "5", "5"];
	crosshair_color_input.text = crosshair_color_input.init_text;
	crosshair_color_input.active = false;
	outline_color_input.init_text = "000000000";
	outline_color_input.chars = ["0", "0", "0", "0", "0", "0", "0", "0", "0"];
	outline_color_input.text = outline_color_input.init_text;
	outline_color_input.active = false;
	save_game();
};

saturation_level_text_input_callback = function(InputText){
	var saturation_text = string_replace_all(string_trim(InputText), ",", ".");
	var valid_number = string_length(saturation_text) > 0;
	var decimal_points = 0;
	var digits = 0;

	for(var i = 1; i <= string_length(saturation_text); i++){
		var character = string_char_at(saturation_text, i);
		if(character == "."){
			decimal_points++;
		}else if(string_pos(character, "0123456789") == 0){
			valid_number = false;
			break;
		}else{
			digits++;
		}
	}

	if(valid_number && digits > 0 && decimal_points <= 1){
		global.saturation_level = clamp(real(saturation_text), 0, 2);
		save_game();
	}
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
		if(global.bloom_shader == false){
			global.bloom_shader = true;
			caption = "On";
		}else{
			global.bloom_shader = false;
			caption = "Off";
		}
	}
	save_game();
};


with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Settings";
	draggable = 1;
}

with (zui_create(position_x + gap, round(position_y - text_height/4), objUISlider)) {
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
	zui_set_width(64 * global.gui_scale);
	zui_set_height(16 * global.gui_scale);
	
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
	zui_set_width(64 * global.gui_scale);
	zui_set_height(16 * global.gui_scale);
	
	caption = "On";
	if(global.bloom_shader == false){
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

toggle_particles_button = zui_create(position_x + gap, round(position_y - text_height/4 + text_height*3), objUIButton);
with(toggle_particles_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(64 * global.gui_scale);
	zui_set_height(16 * global.gui_scale);
	
	caption = "On";
	if(global.DrawParticles == false){
		caption = "Off";
	}
	callback = other.toggle_particles_callback;
}
#endregion

checkbox_size = 16 * global.gui_scale;

#region Fullscreen
fullscreen_string = "Toggle fullscreen: ";
with(zui_create(position_x, position_y + text_height*4, objUILabel)){
	color = c_white;
	caption = other.fullscreen_string;
}

with(zui_create(position_x + gap, position_y + text_height*4 - checkbox_size/2, objUICheckbox)){
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
with(zui_create(position_x, position_y + text_height*5, objUILabel)){
	color = c_white;
	caption = other.player_name_string;
}

with(zui_create(position_x + gap*.75, position_y + text_height*5 - text_height/3, objUITextInput)){
	zui_set_anchor(0, 0);
	init_text = global.player_stats.Name;
	max_string_length = 16;
	callback = function(InputText){
		global.player_stats.Name = InputText;
	};
}
#endregion

#region Window size
with(zui_create(position_x, position_y + text_height*6, objUILabel)){
	color = c_white;
	caption = "Window size: ";
}

window_resolution_button = zui_create(position_x + gap, position_y + text_height*5.5, objUIButton);

with (window_resolution_button) {
    zui_set_anchor(0.5, 0);
    zui_set_width(96 * global.gui_scale);
    zui_set_height(24 * global.gui_scale);

    caption = string(global.window_width) + " x " + string(global.window_height);
    callback = other.window_resolution_callback;
}


#endregion

#region GUI scale
with(zui_create(position_x, position_y + text_height*7, objUILabel)){
	color = c_white;
	caption = "GUI scale: ";
}

gui_scale_button = zui_create(position_x + gap, round(position_y - text_height/4 + text_height*7), objUIButton);
with(gui_scale_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(64 * global.gui_scale);
	zui_set_height(16 * global.gui_scale);
	
	caption = global.gui_scale;
	callback = other.gui_scale_callback;
}
#endregion

#region Saturation level
with(zui_create(position_x, position_y + text_height*8, objUILabel)){
	color = c_white;
	caption = other.saturation_level_string;
}

with(zui_create(position_x + gap*.75, position_y + text_height*8 - text_height/3, objUITextInput)){
	zui_set_anchor(0, 0);
	init_text = string(global.saturation_level);
	max_string_length = 4;
	callback = other.saturation_level_text_input_callback;
}
#endregion

#region Language
with(zui_create(position_x, position_y + text_height*9, objUILabel)){
	color = c_white;
	caption = "Language: ";
}

language_cz_checkbox = zui_create(position_x + gap, position_y + text_height*9 - checkbox_size/2, objUICheckbox);
with(language_cz_checkbox){
	zui_set_anchor(0, 0);
	zui_set_size(other.checkbox_size, other.checkbox_size);
	value = global.language == "cz";
	callback = function(){ oSettingsTab.language_callback("cz"); };
}

with(zui_create(position_x + gap + checkbox_size + 12 * global.gui_scale, position_y + text_height*9, objUILabel)){
	color = c_white;
	caption = "CZ";
}

language_en_checkbox = zui_create(position_x + gap + 100 * global.gui_scale, position_y + text_height*9 - checkbox_size/2, objUICheckbox);
with(language_en_checkbox){
	zui_set_anchor(0, 0);
	zui_set_size(other.checkbox_size, other.checkbox_size);
	value = global.language == "en";
	callback = function(){ oSettingsTab.language_callback("en"); };
}

with(zui_create(position_x + gap + 100 * global.gui_scale + checkbox_size + 12 * global.gui_scale, position_y + text_height*9, objUILabel)){
	color = c_white;
	caption = "EN";
}
#endregion

#region Crosshair type
crosshair_type_names = ["Classic", "Circ.", "Rect.", "Dot"];
crosshair_type_checkboxes = array_create(4);
var type_start_x = position_x + 170 * global.gui_scale;
var type_spacing = (setting_tab_width - type_start_x - 24 * global.gui_scale) / 4;
with(zui_create(position_x, position_y + text_height*10, objUILabel)){
	color = c_white;
	caption = "Crosshair type: ";
}
for(var type_index = 0; type_index < 4; type_index++){
	var type_x = type_start_x + type_index * type_spacing;
	crosshair_type_checkboxes[type_index] = zui_create(type_x, position_y + text_height*10 - checkbox_size/2, objUICheckbox);
	with(crosshair_type_checkboxes[type_index]){
		zui_set_anchor(0, 0);
		zui_set_size(other.checkbox_size, other.checkbox_size);
		crosshair_type_value = type_index;
		value = global.cs_conf.type == crosshair_type_value;
		callback = function(){ oSettingsTab.crosshair_type_callback(crosshair_type_value); };
	}
	with(zui_create(type_x + checkbox_size + 4 * global.gui_scale, position_y + text_height*10, objUILabel)){
		color = c_white;
		caption = other.crosshair_type_names[type_index];
	}
}
#endregion

#region Dynamic crosshair
dynamic_crosshair_checkbox = zui_create(position_x + gap, position_y + text_height*11 - checkbox_size/2, objUICheckbox);
with(zui_create(position_x, position_y + text_height*11, objUILabel)){
	color = c_white;
	caption = "Dynamic crosshair: ";
}
with(dynamic_crosshair_checkbox){
	zui_set_anchor(0, 0);
	zui_set_size(other.checkbox_size, other.checkbox_size);
	value = global.cs_conf.dynamic;
	callback = function(){
		value = !value;
		global.cs_conf.dynamic = value;
		save_game();
	};
}
#endregion

#region Crosshair color
with(zui_create(position_x, position_y + text_height*12, objUILabel)){
	color = c_white;
	caption = other.crosshair_color_string;
}
crosshair_color_input = zui_create(position_x + gap*.75, position_y + text_height*12 - text_height/3, objUITextInput);
with(crosshair_color_input){
	zui_set_anchor(0, 0);
	var r = (global.cs_conf.color >> 16) & 0xFF;
	var g = (global.cs_conf.color >> 8) & 0xFF;
	var b = global.cs_conf.color & 0xFF;
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

#region Crosshair spread
spread_slider_label = zui_create(position_x, position_y + text_height*13, objUILabel);
with(spread_slider_label){
	color = c_white;
	caption = "Spread: " + string(global.cs_conf.spread);
}
spread_slider = zui_create(position_x + gap, position_y + text_height*13 - text_height/4, objUISlider);
with(spread_slider){
	zui_set_anchor(0.5, 0);
	zui_set_width(256);
	minimum = 2;
	maximum = 100;
	value = global.cs_conf.spread;
	callback = function(slider_value){
		global.cs_conf.spread = slider_value;
		oSettingsTab.spread_slider_label.caption = "Spread: " + string(slider_value);
		save_game();
	};
}
#endregion

#region Crosshair width and height
width_slider_label = zui_create(position_x, position_y + text_height*14, objUILabel);
with(width_slider_label){
	color = c_white;
	caption = "Width: " + string(global.cs_conf.width);
}
width_slider = zui_create(position_x + 155 * global.gui_scale, position_y + text_height*14 - text_height/4, objUISlider);
with(width_slider){
	zui_set_anchor(0, 0);
	zui_set_width(80 * global.gui_scale);
	minimum = 2;
	maximum = 48;
	value = clamp(round(global.cs_conf.width), minimum, maximum);
	callback = function(slider_value){
		global.cs_conf.width = slider_value;
		oSettingsTab.width_slider_label.caption = "Width: " + string(slider_value);
		save_game();
	};
}
height_slider_label = zui_create(position_x + 310 * global.gui_scale, position_y + text_height*14, objUILabel);
with(height_slider_label){
	color = c_white;
	caption = "Height: " + string(global.cs_conf.height);
}
height_slider = zui_create(position_x + 405 * global.gui_scale, position_y + text_height*14 - text_height/4, objUISlider);
with(height_slider){
	zui_set_anchor(0, 0);
	zui_set_width(80 * global.gui_scale);
	minimum = 2;
	maximum = 48;
	value = clamp(round(global.cs_conf.height), minimum, maximum);
	callback = function(slider_value){
		global.cs_conf.height = slider_value;
		oSettingsTab.height_slider_label.caption = "Height: " + string(slider_value);
		save_game();
	};
}
#endregion

#region Crosshair outline
with(zui_create(position_x, position_y + text_height*15, objUILabel)){
	color = c_white;
	caption = "Outline: ";
}
outline_checkbox = zui_create(position_x + 155 * global.gui_scale, position_y + text_height*15 - checkbox_size/2, objUICheckbox);
with(outline_checkbox){
	zui_set_anchor(0, 0);
	zui_set_size(other.checkbox_size, other.checkbox_size);
	value = global.cs_conf.outline;
	callback = function(){
		value = !value;
		global.cs_conf.outline = value;
		save_game();
	};
}
outline_width_slider_label = zui_create(position_x + 310 * global.gui_scale, position_y + text_height*15, objUILabel);
with(outline_width_slider_label){
	color = c_white;
	caption = "Outline W: " + string(global.cs_conf.outline_w);
}
outline_width_slider = zui_create(position_x + 405 * global.gui_scale, position_y + text_height*15 - text_height/4, objUISlider);
with(outline_width_slider){
	zui_set_anchor(0, 0);
	zui_set_width(80 * global.gui_scale);
	minimum = 1;
	maximum = 8;
	value = clamp(round(global.cs_conf.outline_w), minimum, maximum);
	callback = function(slider_value){
		global.cs_conf.outline_w = slider_value;
		oSettingsTab.outline_width_slider_label.caption = "Outline W: " + string(slider_value);
		save_game();
	};
}
#endregion

#region Crosshair outline color
with(zui_create(position_x, position_y + text_height*16, objUILabel)){
	color = c_white;
	caption = "Outline color (rgb): ";
}
outline_color_input = zui_create(position_x + gap*.75, position_y + text_height*16 - text_height/3, objUITextInput);
with(outline_color_input){
	zui_set_anchor(0, 0);
	var red_value = (global.cs_conf.outline_color >> 16) & 0xFF;
	var green_value = (global.cs_conf.outline_color >> 8) & 0xFF;
	var blue_value = global.cs_conf.outline_color & 0xFF;
	init_text = string_repeat("0", 3 - string_length(string(red_value))) + string(red_value)
		+ string_repeat("0", 3 - string_length(string(green_value))) + string(green_value)
		+ string_repeat("0", 3 - string_length(string(blue_value))) + string(blue_value);
	max_string_length = 9;
	callback = other.crosshair_outline_color_callback;
}
#endregion

#region Crosshair alpha and scale
alpha_slider_label = zui_create(position_x, position_y + text_height*17, objUILabel);
with(alpha_slider_label){
	color = c_white;
	caption = "Alpha: " + string(global.cs_conf.alpha);
}
alpha_slider = zui_create(position_x + 155 * global.gui_scale, position_y + text_height*17 - text_height/4, objUISlider);
with(alpha_slider){
	zui_set_anchor(0, 0);
	zui_set_width(80 * global.gui_scale);
	minimum = 0;
	maximum = 20;
	value = clamp(round(global.cs_conf.alpha * 20), minimum, maximum);
	callback = function(slider_value){
		global.cs_conf.alpha = slider_value / 20;
		oSettingsTab.alpha_slider_label.caption = "Alpha: " + string(global.cs_conf.alpha);
		save_game();
	};
}
scale_slider_label = zui_create(position_x + 310 * global.gui_scale, position_y + text_height*17, objUILabel);
with(scale_slider_label){
	color = c_white;
	caption = "Scale: " + string(global.cs_conf.scale);
}
scale_slider = zui_create(position_x + 405 * global.gui_scale, position_y + text_height*17 - text_height/4, objUISlider);
with(scale_slider){
	zui_set_anchor(0, 0);
	zui_set_width(80 * global.gui_scale);
	minimum = 1;
	maximum = 20;
	value = clamp(round(global.cs_conf.scale * 4), minimum, maximum);
	callback = function(slider_value){
		global.cs_conf.scale = slider_value / 4;
		oSettingsTab.scale_slider_label.caption = "Scale: " + string(global.cs_conf.scale);
		save_game();
	};
}
#endregion

#region Reset crosshair
with(zui_create(position_x, position_y + text_height*18, objUILabel)){
	color = c_white;
	caption = "Reset crosshair: ";
}
with(zui_create(position_x + gap, position_y + text_height*18 - text_height/4, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(96 * global.gui_scale);
	zui_set_height(16 * global.gui_scale);
	caption = "Reset";
	callback = other.crosshair_reset_callback;
}
#endregion
