event_inherited();
setting_tab_width = 512 * global.GUIMultiplier;
setting_tab_height = 512 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(setting_tab_width, setting_tab_height);

volume_gain_string = "Volume gain";

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Settings";
	draggable = 1;
}

with (zui_create(zui_get_width() * 0.5 + string_width(volume_gain_string)*1.1, zui_get_height() * .8, objUISlider)) {
	zui_set_anchor(0.5, 0);
	zui_set_width(256);

	minimum = 0;
	maximum = 100;
	value = global.sound_gain;
	type = "Volume";
	
	callback = function(_id, _value){
		audio_master_gain(value/100);
	};
}

draw_set_font(set_font("Console"));
with (zui_create(zui_get_width() * 0.5, zui_get_height() * .8, objUILabel)) {
	color = c_white;
	caption = volume_gain_string;
}
