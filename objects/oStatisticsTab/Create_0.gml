event_inherited();
tab_width = max(768 * global.gui_scale, 896);
tab_height = max(512 * global.gui_scale, 768);

draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);

text_gap = sprite_get_height(spr_Icons) * 1.1 * global.gui_scale;
content_left = zui_get_width() * .16;
column_width = zui_get_width() * .36;
content_title_y = max(75, 64 * global.gui_scale);

xp_string = "Experience: " + string(global.player_stats.Xp) + "/" + string(global.player_stats.Max_xp);
stamina_string = "Stamina: " + string(global.player_stats.Max_stamina);
health_string = "Health: " + string(global.player_stats.Max_health);
level_string = "Level: " + string(global.player_stats.Lvl);
bonus_xp_string = "(+" + string(global.player_stats.Max_xp) + ")";
bonus_health_string = "(+" + string((global.player_stats.Max_health * power(STATS_LVL_UP, ln(global.player_stats.Lvl + 1))) - global.player_stats.Max_health) + ")";
bonus_stamina_string = "(+" + string((global.player_stats.Max_stamina * power(STATS_LVL_UP, ln(global.player_stats.Lvl + 1))) - global.player_stats.Max_stamina) + ")";
level_string_width = string_width(level_string);
health_row_width = string_width(health_string + " " + bonus_health_string);
stamina_row_width = string_width(stamina_string + " " + bonus_stamina_string);
health_graph = noone;
stamina_graph = noone;

health_graph_callback = function(){
	if(instance_exists(oStatisticsTab.stamina_graph)){
		with(oStatisticsTab.stamina_graph){ zui_destroy(); }
	}

	if(!instance_exists(oStatisticsTab.health_graph)){
		oStatisticsTab.health_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);
		with(oStatisticsTab.health_graph){
			zui_set_depth(-1000);
			values_x = [];
			values_y = [];
			line_color = c_lime;
			point_color = c_green;
			x_label_decimals = 0;
			y_label_decimals = 1;
			x_axis_name = "Level";
			y_axis_name = "Health";
			var final_level = max(15, ceil(global.player_stats.Lvl) + 5);
			var projected_health = global.player_stats.Max_health;
			for(var level = global.player_stats.Lvl; level >= 2; level--){
				projected_health /= power(STATS_LVL_UP, ln(level));
			}
			for(var level = 1; level <= final_level; level++){
				if(level >= 2){
					projected_health *= power(STATS_LVL_UP, ln(level));
				}
				array_push(values_x, level);
				array_push(values_y, projected_health);
			}
		}
	}else{
		with(oStatisticsTab.health_graph){ zui_destroy(); }
	}
};

stamina_graph_callback = function(){
	if(instance_exists(oStatisticsTab.health_graph)){
		with(oStatisticsTab.health_graph){ zui_destroy(); }
	}

	if(!instance_exists(oStatisticsTab.stamina_graph)){
		oStatisticsTab.stamina_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);
		with(oStatisticsTab.stamina_graph){
			zui_set_depth(-1000);
			values_x = [];
			values_y = [];
			line_color = c_aqua;
			point_color = c_blue;
			x_label_decimals = 0;
			y_label_decimals = 1;
			x_axis_name = "Level";
			y_axis_name = "Stamina";
			var final_level = max(15, ceil(global.player_stats.Lvl) + 5);
			var projected_stamina = global.player_stats.Max_stamina;
			for(var level = global.player_stats.Lvl; level >= 2; level--){
				projected_stamina /= power(STATS_LVL_UP, ln(level));
			}
			for(var level = 1; level <= final_level; level++){
				if(level >= 2){
					projected_stamina *= power(STATS_LVL_UP, ln(level));
				}
				array_push(values_x, level);
				array_push(values_y, projected_stamina);
			}
		}
	}else{
		with(oStatisticsTab.stamina_graph){ zui_destroy(); }
	}
};

#region Level

var level_x = content_left;
plot_button_width = max(56 * global.gui_scale, 64);
plot_button_height = max(20 * global.gui_scale, 24);
control_gap = max(32 * global.gui_scale, 48);
label_height = font_get_size(draw_get_font());

with(zui_create(level_x, content_title_y, objUILabel)){
	color = MAIN_COLOR;
	caption = other.level_string;
}

xp_bar_size = max(64 * global.gui_scale, 80);
xp_bar_x = level_x + level_string_width + control_gap;
xp_bar_y = content_title_y - (xp_bar_size - label_height) * .5;
with(zui_create(xp_bar_x, xp_bar_y, objUIImage)){
	zui_set_anchor(0, 0);
	zui_set_size(other.xp_bar_size, other.xp_bar_size);
	clickable = false;
	hover = false;
	circular_bar = true;
	bar_value = global.player_stats.Xp;
	bar_max_value = max(1, global.player_stats.Max_xp);
	bar_color = c_olive;
	bar_background_color = make_color_rgb(45, 48, 55);
	bar_radius = other.xp_bar_size * .5 - max(4 * global.gui_scale, 6);
	bar_thickness = max(4 * global.gui_scale, 6);
}

with(zui_create(level_x + string_width(" ") + string_width(xp_string), content_title_y + text_gap * 2, objUILabel)){
	color = c_red;
	caption = other.bonus_xp_string;
}

with(zui_create(level_x, content_title_y + text_gap * 2, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.xp;
	color = c_white;
	caption = other.xp_string;
}

with(zui_create(level_x, content_title_y + text_gap * 3, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.health;
	color = c_white;
	caption = other.health_string;
}

with(zui_create(level_x + string_width(" ") + string_width(health_string), content_title_y + text_gap * 3, objUILabel)){
	color = c_green;
	caption = other.bonus_health_string;
}

health_plot_x = level_x + health_row_width + control_gap;
health_plot_y = content_title_y + text_gap * 3 - (plot_button_height - label_height) * .5;
with(zui_create(health_plot_x, health_plot_y, objUIButton)){
	zui_set_size(other.plot_button_width, other.plot_button_height);
	caption = "Plot";
	callback = oStatisticsTab.health_graph_callback;
}

with(zui_create(level_x, content_title_y + text_gap * 4, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.stamina;
	color = c_white;
	caption = other.stamina_string;
}

with(zui_create(level_x + string_width(" ") + string_width(stamina_string), content_title_y + text_gap * 4, objUILabel)){
	color = c_green;
	caption = other.bonus_stamina_string;
}

stamina_plot_x = level_x + stamina_row_width + control_gap;
stamina_plot_y = content_title_y + text_gap * 4 - (plot_button_height - label_height) * .5;
with(zui_create(stamina_plot_x, stamina_plot_y, objUIButton)){
	zui_set_size(other.plot_button_width, other.plot_button_height);
	caption = "Plot";
	callback = oStatisticsTab.stamina_graph_callback;
}

#endregion

#region Statistics

var statistics_x = content_left + column_width;
with(zui_create(statistics_x, content_title_y, objUILabel)){
	color = MAIN_COLOR;
	caption = "Statistics";
}

with(zui_create(statistics_x, content_title_y + text_gap, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.kills;
	color = c_white;
	caption = "Kills: " + string(global.player_stats.Kills);
}

with(zui_create(statistics_x, content_title_y + text_gap * 2, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.assists;
	color = c_white;
	caption = "Assists: " + string(global.player_stats.Assists);
}

with(zui_create(statistics_x, content_title_y + text_gap * 3, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.deaths;
	color = c_dkgray;
	caption = "Deaths: " + string(global.player_stats.Deaths);
}

kd_ratio_color = c_green;
if(global.player_stats.Get_KD() < 1 && global.player_stats.Get_KD() > 0){
	kd_ratio_color = c_red;
}

with(zui_create(statistics_x, content_title_y + text_gap * 4, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.kd;
	color = other.kd_ratio_color;
	caption = "K/D ratio: " + string(global.player_stats.Get_KD());
}

with(zui_create(statistics_x, content_title_y + text_gap * 5, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.headshot_percentage;
	color = c_white;
	caption = "Headshot percentage: " + string(global.player_stats.Get_headshot_percentage()) + " %";
}

with(zui_create(statistics_x, content_title_y + text_gap * 6, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.accuracy;
	color = c_white;
	caption = "Accuracy: " + string_format(global.player_stats.Get_accuracy(), 0, 1) + "%";
}

with(zui_create(statistics_x, content_title_y + text_gap * 7, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.game;
	color = c_white;
	caption = "Finished games: " + string(global.game_struct.Played_games);
}

with(zui_create(statistics_x, content_title_y + text_gap * 8, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.won_game;
	color = c_white;
	caption = "Won games: " + string(global.game_struct.Won_games);
}

with(zui_create(statistics_x, content_title_y + text_gap * 9, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.lost_game;
	color = c_white;
	caption = "Lost games: " + string(global.game_struct.Lost_games);
}

with(zui_create(statistics_x, content_title_y + text_gap * 10, objUILabel)){
	icon_sprite_index = spr_Icons;
	icon_image_index = ICON.tied_game;
	color = c_white;
	caption = "Tied games: " + string(global.game_struct.Tied_games);
}

#endregion

with(zui_create(0, 0, objUIWindowCaption)){
	caption = "Statistics";
	draggable = 1;
}
