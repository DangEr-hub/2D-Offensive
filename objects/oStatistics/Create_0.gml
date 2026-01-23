event_inherited();
statistics_width_tab = clamp(768 * global.GUIMultiplier, 768, 1080);
statistics_height_tab = max(192 * global.GUIMultiplier, 224);
alpha = 1;
black = -1;

draw_set_font(set_font("GUI_small"));
zui_set_size(statistics_width_tab, statistics_height_tab);

statistics_x = zui_get_width() * .25;
statistics_y = max(zui_get_height() * .2, 64);
button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;

#region Statistics
statistics_number = 3;
text_gap = sprite_get_height(spr_Icons)*1.1 * global.GUIMultiplier;
average_playing_time = average(global.rating_struct.Playing_time_per_round, false);
total_headshots = sum(global.rating_struct.Headshots_per_round);
total_kills = sum(global.rating_struct.Kills_per_round);
with (zui_create(statistics_x, statistics_y, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.kills;
	color = c_white;
	caption = "Kills: " + string(oRatingController.kills);
}

with (zui_create(statistics_x, statistics_y + text_gap, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.headshot_percentage;
	color = c_white;
	caption = "Headshots: " + string(oRatingController.headshots);
}

with (zui_create(statistics_x, statistics_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.time;
	color = c_white;
	caption = "Time alive: " + string(oRatingController.playing_time/game_get_speed(gamespeed_fps)) + " s";
}
with (zui_create(zui_get_width() * .75 - string_width("Total kills: " + string(other.total_kills)), statistics_y, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.kills;
	color = c_white;
	caption = "Total kills: " + string(other.total_kills);
}

with (zui_create(zui_get_width() * .75 - string_width("Total kills: " + string(other.total_kills)), statistics_y + text_gap, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.headshot_percentage;
	color = c_white;
	caption = "Total headshots: " + string(other.total_headshots);
}
with (zui_create(zui_get_width() * .75 - string_width("Total kills: " + string(other.total_kills)), statistics_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.time;
	color = c_white;
	caption = "Average playing time: " + string(other.average_playing_time) + "s";
}
#endregion

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Statistics";
	draggable = 1;
}
with(zui_create(zui_get_width() * .5, statistics_y + statistics_number*sprite_get_height(spr_Icons)*global.GUIMultiplier, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Close";
	callback = function(){
		with(oStatistics.black){
			zui_destroy();
		}
		with(oStatistics){
			zui_destroy();
		}
	}
}
