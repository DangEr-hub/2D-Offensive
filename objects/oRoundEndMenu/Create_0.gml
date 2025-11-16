event_inherited();
draw_set_font(set_font("Menu_small"));
round_end_width_tab = 512 * global.GUIMultiplier;
round_end_height_tab = max(512 * global.GUIMultiplier, 704);

zui_set_size(round_end_width_tab, round_end_height_tab);

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Round end";
	draggable = 1;
}

title_color = MAIN_COLOR;
title_string = "Round won";
title_position_x = zui_get_width() * .5;
title_position_y = zui_get_height() * .1 + 24/global.GUIMultiplier;
base_position_y = zui_get_height() * .2 + 24/global.GUIMultiplier;
gap = 128;

if(oRatingController.player_win == false){
	title_color = c_red;
	title_string = "Round lost";	
}

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

popup_continue_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	room_restart();	
};

continue_callback = function(){
	ui_show_popup("Continue to the next round?", "Continue", "Yes", "No", 288 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_continue_callback_positive, -1);		
};

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit the game?", "Exit", "Yes", "No", 288 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	save_game();
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 288 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_main_menu_callback_positive, -1);	
};
#endregion

draw_set_font(set_font("Title"));
with (zui_create(title_position_x - string_width(other.title_string)/2, title_position_y, objUILabel)) {
	font = set_font("Title");
	color = other.title_color;
	caption = other.title_string;
}
draw_set_font(set_font("Menu_small"));

#region Current player rank
text_gap = sprite_get_height(spr_Icons) * global.GUIMultiplier;
rank_position = 0;
if(global.rating_struct.Played_games >= TRACKING_PERIOD/2){
	rank_position = get_rank(global.rating_struct.Player_ep);
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
	color = MAIN_COLOR;
	caption = "VS";
}

rank_position = get_rank(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
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

#region Buttons
offset_y = clamp(128 * global.GUIMultiplier, 144, 224);
button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .5, zui_get_height() * .7 - offset_y, objUIButton)){
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

with(zui_create(zui_get_width() * .5, zui_get_height() * .7 - offset_y + button_height*1.5, objUIButton)){
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

with(zui_create(zui_get_width() * .5, zui_get_height() * .7 - offset_y + button_height*3, objUIButton, -999)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Continue";
	callback = other.continue_callback;
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .7 - offset_y + button_height*4.5, objUIButton, -999)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .7 - offset_y + button_height*6, objUIButton, -999)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}
#endregion
