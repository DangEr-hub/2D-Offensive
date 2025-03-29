event_inherited();
tab_width = max(768 * global.GUIMultiplier, 896);
tab_height = max(512 * global.GUIMultiplier, 768);



draw_set_font(set_font("Menu_small"));
zui_set_size(tab_width, tab_height);

rank_position = 0;
if(global.player_rating_struct.Played_games >= TRACKING_GAMES/2){
	rank_position = get_rank(global.player_rating_struct.Ep);
}

text_gap = sprite_get_height(spr_Icons)*1.1 * global.GUIMultiplier;
label_gap = 256 * global.GUIMultiplier;
rank_image_position_x = zui_get_width() * .075;
rank_image_position_y = 96;
rank_image_size_width = max(sprite_get_width(spr_ranks)/2 * global.GUIMultiplier, sprite_get_width(spr_ranks)/2 * 1.5);
rank_image_size_height = max(sprite_get_height(spr_ranks)/2 * global.GUIMultiplier, sprite_get_height(spr_ranks)/2 * 1.5);
rank_image_gap = rank_image_size_height * 1.1;
rank_callbacks = [];
rank_title_x = rank_image_position_x - rank_image_size_width/2;
rank_title_y = rank_image_position_y - rank_image_gap;
armour_string = "Armour: " + string(global.player_stats_struct.Armour*100) + "%";
xp_string = "Experience: " + string(global.player_stats_struct.Xp) + "/" + string(global.player_stats_struct.Max_xp);
stamina_string = "Stamina: " + string(global.player_stats_struct.Max_stamina);
health_string = "Health: " + string(global.player_stats_struct.Max_health);

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

for(i = 0; i < RankType.Total; i++) {
    with (zui_create(rank_image_position_x, rank_image_position_y + i*rank_image_gap, objUIImage)) {
		zui_set_anchor(0, 0);
		zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
		sprite = spr_ranks;
		sprite_image_index = other.i;
		sprite_width_size = other.rank_image_size_width;
		sprite_height_size = other.rank_image_size_height;
        callback = other.rank_callbacks[other.i];
    }
}

with (zui_create(rank_image_position_x, rank_image_position_y + rank_position*rank_image_gap, objUIImage)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_current_rank;
	sprite_image_index = 0;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
	callback = other.rank_callbacks[other.rank_position];
}

#region Level
var level_x = zui_get_width() * .35;
with (zui_create(level_x, rank_title_y, objUILabel)) {
	color = MAIN_COLOR;
	caption = "Level: " + string(global.player_stats_struct.Lvl);
}

with (zui_create(rank_image_position_x + label_gap - sprite_get_width(spr_HealthBar)/4 * global.GUIMultiplier, rank_title_y + text_gap, objUIImage)) {
	zui_set_anchor(0, 0);
	sprite_image_index = 8;
	healthbar = true;
}

with (zui_create(level_x + string_width(" ") + string_width(xp_string), rank_title_y + text_gap*2, objUILabel)) {
	var bonus_xp = (global.player_stats_struct.Max_xp * 2) - global.player_stats_struct.Max_xp;
	color = c_red;
	caption = "(+" + string(bonus_xp) + ")";
}

with (zui_create(level_x, rank_title_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.xp;
	color = c_white;
	caption = other.xp_string;
}

with (zui_create(level_x, rank_title_y + text_gap*3, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.health;
	color = c_white;
	caption = other.health_string;
}

with (zui_create(level_x + string_width(" ") + string_width(health_string), rank_title_y + text_gap*3, objUILabel)) {
	var bonus_health = (global.player_stats_struct.Max_health * power(STATS_LVL_UP, ln(global.player_stats_struct.Lvl + 1))) - global.player_stats_struct.Max_health;
	color = c_green;
	caption = "(+" + string(bonus_health) + ")";
}

with (zui_create(level_x, rank_title_y + text_gap*4, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.stamina;
	color = c_white;
	caption = other.stamina_string;
}

with (zui_create(level_x + string_width(" ") + string_width(stamina_string), rank_title_y + text_gap*4, objUILabel)) {
	var bonus_stamina = (global.player_stats_struct.Max_stamina * power(STATS_LVL_UP, ln(global.player_stats_struct.Lvl + 1))) - global.player_stats_struct.Max_stamina;
	color = c_green;
	caption = "(+" + string(bonus_stamina) + ")";
}

with (zui_create(level_x, rank_title_y + text_gap*5, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.armour;
	color = c_white;
	caption = other.armour_string;
}

with (zui_create(level_x + string_width(" ") + string_width(armour_string), rank_title_y + text_gap*5, objUILabel)) {
	var bonus_armour = ARMOUR_LVL_UP;
	color = c_green;
	caption = "(+" + string(bonus_armour*100) + " %)";
}
#endregion

#region Statistics
var statistics_x = zui_get_width() * .65;
with (zui_create(statistics_x, rank_title_y, objUILabel)) {
	color = MAIN_COLOR;
	caption = "Statistics";
}

with (zui_create(statistics_x, rank_title_y + text_gap, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.kills;
	color = c_white;
	caption = "Kills: " + string(global.player_stats_struct.Kills);
}

with (zui_create(statistics_x, rank_title_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.deaths;
	color = c_dkgray;
	caption = "Deaths: " + string(global.player_stats_struct.Deaths);
}

kd_ratio_color = c_green;
if(global.player_stats_struct.Get_KD() < 1 && global.player_stats_struct.Get_KD() > 0){
	kd_ratio_color = c_red;
}
with (zui_create(statistics_x, rank_title_y + text_gap*3, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.kd;
	color = other.kd_ratio_color;
	caption = "K/D ratio: " + string(global.player_stats_struct.Get_KD());
}

with (zui_create(statistics_x, rank_title_y + text_gap*4, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.headshot_percentage;
	color = c_white;
	caption = "Headshot percentage: " + string(global.player_stats_struct.Get_headshot_percentage()) + "%";
}

with (zui_create(statistics_x, rank_title_y + text_gap*5, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.accuracy;
	color = c_white;
	caption = "Accuracy: " + string(global.player_stats_struct.Get_accuracy()) + "%";
}

with (zui_create(statistics_x, rank_title_y + text_gap*6, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.game;
	color = c_white;
	caption = "Finished games: " + string(global.player_rating_struct.Played_games);
}

with (zui_create(statistics_x, rank_title_y + text_gap*7, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.won_game;
	color = c_white;
	caption = "Won games: " + string(global.player_rating_struct.Won_games);
}

with (zui_create(statistics_x, rank_title_y + text_gap*8, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.lost_game;
	color = c_white;
	caption = "Lost games: " + string(global.player_rating_struct.Lost_games);
}

with (zui_create(statistics_x, rank_title_y + text_gap*9, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.tied_game;
	color = c_white;
	caption = "Tied games: " + string(global.player_rating_struct.Tied_games);
}

#endregion


with (zui_create(rank_title_x, rank_title_y, objUILabel)) {
	color = MAIN_COLOR;
	caption = "Rank: " + string(global.RankIndex[#other.rank_position, RankStat.Name]);
}

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Statistics";
	draggable = 1;
}