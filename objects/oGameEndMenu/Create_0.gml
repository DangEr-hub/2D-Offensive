event_inherited();
draw_set_font(set_font("Menu_small"));
pause_width_tab = 384 * global.GUIMultiplier;
pause_height_tab = max(512 * global.GUIMultiplier, 768);
//pause_width_tab = 768 * global.GUIMultiplier;
//pause_height_tab = 896;

zui_set_size(pause_width_tab, pause_height_tab);

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Game end";
	draggable = 1;
}

title_position_x = zui_get_width() * .5;
title_position_y = zui_get_height() * .2 + 24/global.GUIMultiplier;
gap = 128;

#region Rank callbacks
rank_callbacks = [    
    function(){ ui_show_popup(global.RankIndex[# RankType.Unranked, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.Unranked, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SilverI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverI, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SilverII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SilverIII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverIII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SilverIV, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverIV, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SilverV, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverV, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SilverMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SilverMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.GoldI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldI, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.GoldII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.GoldIII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldIII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.GoldIV, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldIV, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.GoldMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GoldMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.DiamondI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondI, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.DiamondII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.DiamondIII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondIII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.DiamondMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.DiamondMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.AssaultEliteI, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.AssaultEliteI, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.AssaultEliteII, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.AssaultEliteII, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.AssaultMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.AssaultMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.VersatileMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.VersatileMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.SupremeMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.SupremeMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); },
    function(){ ui_show_popup(global.RankIndex[# RankType.GlobalMaster, RankStat.Name], "Min eggy points: " + string(global.RankIndex[# RankType.GlobalMaster, RankStat.Ep]), "OK", -1, 288 * global.GUIMultiplier, 64 * global.GUIMultiplier, -1, -1); }
];

#endregion

#region Callbacks

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	update_tracking_games();
	clear_player_statistics(global.player_rating_struct.Rounds_win + global.player_rating_struct.Rounds_lost);
	save_game();
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit the game?", "Exit", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	update_tracking_games();
	clear_player_statistics(global.player_rating_struct.Rounds_win + global.player_rating_struct.Rounds_lost);
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_main_menu_callback_positive, -1);	
};
#endregion

#region Rank up title
if(global.player_rating_struct.Played_games >= TRACKING_GAMES/2){
	if(get_rank(global.player_rating_struct.Previous_ep) < get_rank(global.player_rating_struct.Ep)){
		rank_string_color = MAIN_COLOR;
		var px = random_range(camera_get_view_x(CAMERA) + camera_get_view_width(CAMERA)/2, camera_get_view_x(CAMERA) + camera_get_view_width(CAMERA)/2);
		var py = zui_get_height() * .2;
		part_type_direction(oParticleSystem.level_up_particle, 180, 360, 0, 30);
		part_type_life(oParticleSystem.level_up_particle, 5 * game_get_speed(gamespeed_fps), 15 * game_get_speed(gamespeed_fps));
		part_type_speed(oParticleSystem.level_up_particle, 1, 2, 0, .5);
		part_particles_create(global.ParticleSystem, px, py, oParticleSystem.level_up_particle, 50);
		part_type_direction(oParticleSystem.level_up_particle, 0, 360, 0, 0);
		part_type_life(oParticleSystem.level_up_particle, oParticleSystem.level_up_life_min, oParticleSystem.level_up_life_max);
		part_type_speed(oParticleSystem.level_up_particle, oParticleSystem.level_up_speed_min, oParticleSystem.level_up_speed_max, 0, 0);
	}
}
#endregion

#region Title
draw_set_font(set_font("Title"));
player_score = string(global.player_rating_struct.Rounds_win);
enemy_score = string(global.player_rating_struct.Rounds_lost);
separator = "/";
score_string_width = string_width(player_score + enemy_score + separator);
player_score_string_width = string_width(player_score);
title_color = MAIN_COLOR;
title_string = "Win";
if(global.player_rating_struct.Rounds_lost > global.player_rating_struct.Rounds_win){
	title_color = c_red;
	title_string = "Loss";	
}else if(global.player_rating_struct.Rounds_lost == global.player_rating_struct.Rounds_win){
	title_color = c_ltgray;
	title_string = "Draw";
}
with (zui_create(title_position_x - string_width(title_string)/2, title_position_y, objUILabel)) {
	font = set_font("Title");
	color = MAIN_COLOR;
	caption = other.title_string;
}

with (zui_create(title_position_x - score_string_width/2, title_position_y + string_height("a"), objUILabel)) {
	font = set_font("Title");
	color = MAIN_COLOR;
	caption = other.player_score;
}
with (zui_create(title_position_x - score_string_width/2 + player_score_string_width, title_position_y + string_height("a"), objUILabel)) {
	font = set_font("Title");
	color = c_dkgray;
	caption = other.separator;
}
with (zui_create(title_position_x - score_string_width/2 + player_score_string_width + string_width(separator), title_position_y + string_height("a"), objUILabel)) {
	font = set_font("Title");
	color = c_dkgray;
	caption = other.enemy_score;
}
draw_set_font(set_font("Menu_small"));
#endregion

#region Current player rank
draw_set_font(set_font("Title"));
prev_rank_y = zui_get_height() * .1 + 24/global.GUIMultiplier;
current_rank_y = zui_get_height() * .35 + 24/global.GUIMultiplier;
text_gap = sprite_get_height(spr_Icons) * global.GUIMultiplier;
rank_previous = get_rank(global.player_rating_struct.Previous_ep);
rank_position = 0;
if(global.player_rating_struct.Played_games >= TRACKING_GAMES/2){
	rank_position = get_rank(global.player_rating_struct.Ep);
}

rank_image_size_width = sprite_get_width(spr_ranks) * global.GUIMultiplier;
rank_image_size_height = sprite_get_height(spr_ranks) * global.GUIMultiplier;
rank_x = zui_get_width() * .5 - (rank_image_size_width + string_width("VS"))/2;

with (zui_create(rank_x, current_rank_y, objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_ranks;
	sprite_image_index = other.rank_position;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
    callback = other.rank_callbacks[other.rank_position];
}

with (zui_create(rank_x, prev_rank_y, objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	tag = "rank";
	sprite = spr_ranks;
	sprite_image_index = other.rank_previous;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
    callback = other.rank_callbacks[other.rank_previous];
}
#endregion

#region VS text
with (zui_create(rank_x + rank_image_size_width, prev_rank_y, objUILabel)) {
	font = set_font("Title");
	color = MAIN_COLOR;
	caption = "VS";
}
#endregion

#region Enemy rank

rank_previous = get_rank(global.player_rating_struct.Enemy_ep[global.player_rating_struct.Current_game]);
rank_position = 0;

if(global.player_rating_struct.Played_games >= TRACKING_GAMES/2){
	if(global.player_rating_struct.Current_game < TRACKING_GAMES/2 - 1){
		rank_position = get_rank(global.player_rating_struct.Enemy_ep[global.player_rating_struct.Current_game + 1]);
	}else{
		rank_position = 0;
	}
}
rank_image_size_width = sprite_get_width(spr_ranks) * global.GUIMultiplier;
rank_image_size_height = sprite_get_height(spr_ranks) * global.GUIMultiplier;

with (zui_create(rank_x + rank_image_size_width + string_width("VS"), prev_rank_y, objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_ranks;
	sprite_image_index = other.rank_previous;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
    callback = other.rank_callbacks[other.rank_previous];
}

with (zui_create(rank_x + rank_image_size_width + string_width("VS"), current_rank_y, objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_ranks;
	sprite_image_index = other.rank_position;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
    callback = other.rank_callbacks[other.rank_position];
}
#endregion

#region Main menu and exit button
offset_y = min(96 * global.GUIMultiplier, 192);
button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .5, zui_get_height() * .8 - offset_y, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Statistics";
	callback = function(){
		with(zui_main()){
			var _black = zui_create(0, 0, objUIBlack, -1000);
			with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oStatistics, -1000)) {
				black = _black;
				alpha = global.GUIHUDAlpha * 2.25; alpha_value = 0;
				window_id = id;
			}
		}
	};
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .8 - offset_y + button_height*1.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Damage table";
	callback = function(){
		with(zui_main()){
			var _black = zui_create(0, 0, objUIBlack, -1000);
			with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oDamageTable, -1000)) {
				black = _black;
				alpha = global.GUIHUDAlpha * 2.25; alpha_value = 0;
				window_id = id;
			}
		}
	};
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .8 - offset_y + button_height*3, objUIButton, -999)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .8 - offset_y + button_height*4.5, objUIButton, -999)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}

#endregion
