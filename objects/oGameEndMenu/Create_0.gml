event_inherited();
pause_width_tab = 768 * global.GUIMultiplier;
pause_height_tab = max(512 * global.GUIMultiplier, 768);

zui_set_size(pause_width_tab, pause_height_tab);

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Game end";
	draggable = 1;
}

title_position_x = zui_get_width() * .5;
title_position_y = zui_get_height() * .1 + 24/global.GUIMultiplier;
base_position_y = zui_get_height() * .2 + 24/global.GUIMultiplier;
gap = 128;

#region Rank callbacks
rank_callbacks = [    
	function(){
        ui_show_popup(global.RankIndex[# RankType.Unranked, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.Unranked, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.Unranked, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverIII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverIII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverIII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverIV, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverIV, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverIV, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverV, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverV, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverV, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldIII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldIII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldIII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldIV, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldIV, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldIV, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondIII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondIII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondIII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.AssaultEliteI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.AssaultEliteI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.AssaultEliteI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.AssaultEliteII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.AssaultEliteII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.AssaultEliteII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.AssaultMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.AssaultMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.AssaultMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.VersatileMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.VersatileMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.VersatileMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SupremeMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SupremeMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SupremeMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GlobalMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GlobalMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GlobalMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
];
#endregion

#region Callbacks

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	clear_player_statistics(global.player_elo_struct.Rounds_win + global.player_elo_struct.Rounds_lost);
	save_game();
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit game?", "Exit", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	clear_player_statistics(global.player_elo_struct.Rounds_win + global.player_elo_struct.Rounds_lost);
	save_game();
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_main_menu_callback_positive, -1);	
};
#endregion

#region Title
draw_set_font(set_font("Title"));
title_string = "Win";
if(global.player_elo_struct.Rounds_lost > global.player_elo_struct.Rounds_win){
	title_string = "Loss";	
}else if(global.player_elo_struct.Rounds_lost == global.player_elo_struct.Rounds_win){
	title_string = "Draw";
}
with (zui_create(title_position_x - string_width(title_string)/2, title_position_y, objUILabel)) {
	font = set_font("Title");
	color = global.GoldColor;
	caption = other.title_string;
}
draw_set_font(set_font("Menu_small"));
#endregion

#region Current player rank
text_gap = sprite_get_height(spr_Icons) * global.GUIMultiplier;
rank_position = 0;
if(global.player_elo_struct.Played_games >= TRACKING_GAMES/2){
	rank_position = get_rank();
}

rank_image_size_width = sprite_get_width(spr_ranks) * global.GUIMultiplier;
rank_image_size_height = sprite_get_height(spr_ranks) * global.GUIMultiplier;
current_rank_x = zui_get_width() * .5;

with (zui_create(current_rank_x - rank_image_size_width/2, base_position_y, objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_ranks;
	sprite_image_index = other.rank_position;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
    callback = other.rank_callbacks[other.rank_position];
}

with (zui_create(current_rank_x - string_width("VS")/2, base_position_y + rank_image_size_height*1.5, objUILabel)) {
	font = set_font("Console");
	color = global.GoldColor;
	caption = "VS";
}

rank_position = get_rank(oEnemy);
rank_image_size_width = sprite_get_width(spr_ranks) * global.GUIMultiplier;
rank_image_size_height = sprite_get_height(spr_ranks) * global.GUIMultiplier;
current_rank_x = zui_get_width() * .5;

with (zui_create(current_rank_x - rank_image_size_width/2, base_position_y + rank_image_size_height*1.5 + string_height("a"), objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_ranks;
	sprite_image_index = other.rank_position;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
    callback = other.rank_callbacks[other.rank_position];
}
#endregion

#region Statistics
average_playing_time = average(global.player_elo_struct.Playing_time_per_round);
total_headshots = sum(global.player_elo_struct.Headshots_per_round);
total_kills = sum(global.player_elo_struct.Kills_per_round);
offset_y = 96;
statistics_x = zui_get_width() * .25;
statistics_y = base_position_y + rank_image_size_height*1.5 + string_height("a") + offset_y;
with (zui_create(statistics_x, statistics_y, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.kills;
	color = c_white;
	caption = "Kills: " + string(oEggyEloRatingSystem.kills);
}

with (zui_create(statistics_x, statistics_y + text_gap, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.headshot_percentage;
	color = c_white;
	caption = "Headshots: " + string(oEggyEloRatingSystem.headshots);
}

with (zui_create(statistics_x, statistics_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.time;
	color = c_white;
	caption = "Time alive: " + string(oEggyEloRatingSystem.playing_time/game_get_speed(gamespeed_fps)) + " s";
}
with (zui_create(statistics_x + gap*2, statistics_y, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.kills;
	color = c_white;
	caption = "Total kills: " + string(other.total_kills);
}

with (zui_create(statistics_x + gap*2, statistics_y + text_gap, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.headshot_percentage;
	color = c_white;
	caption = "Total headshots: " + string(other.total_headshots);
}
with (zui_create(statistics_x + gap*2, statistics_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.time;
	color = c_white;
	caption = "Average playing time: " + string(other.average_playing_time) + "s";
}
#endregion

#region Main menu and exit button
offset_y = 64;
button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;

with(zui_create(zui_get_width() * .5, zui_get_height() * .8 - offset_y + button_height*1.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .8 - offset_y + button_height*3, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}
#endregion
