event_inherited();
tab_width = 768 * global.GUIMultiplier;
tab_height = 512 * global.GUIMultiplier;



draw_set_font(set_font("Menu_small"));
zui_set_size(tab_width, tab_height);

rank_position = 0;
if(global.player_elo_struct.Played_games >= TRACKING_GAMES/2){
	rank_position = get_rank(global.player_elo_struct.Elo);
}

text_gap = sprite_get_height(spr_Icons) * global.GUIMultiplier;
label_gap = 256 * global.GUIMultiplier;
rank_image_position_x = 96;
rank_image_position_y = 96;
rank_image_size_width = sprite_get_width(spr_ranks)/2 * global.GUIMultiplier;
rank_image_size_height = sprite_get_height(spr_ranks)/2 * global.GUIMultiplier;
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

#region Statistics
with (zui_create(rank_title_x + label_gap*2, rank_title_y, objUILabel)) {
	color = MAIN_COLOR;
	caption = "Statistics";
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.kills;
	color = c_white;
	caption = "Kills: " + string(global.player_stats_struct.Kills);
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.deaths;
	color = c_dkgray;
	caption = "Deaths: " + string(global.player_stats_struct.Deaths);
}

kd_ratio_color = c_green;
if(global.player_stats_struct.Get_KD() < 1 && global.player_stats_struct.Get_KD() > 0){
	kd_ratio_color = c_red;
}
with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*3, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.kd;
	color = other.kd_ratio_color;
	caption = "K/D ratio: " + string(global.player_stats_struct.Get_KD());
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*4, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.headshot_percentage;
	color = c_white;
	caption = "Headshot percentage: " + string(global.player_stats_struct.Get_headshot_percentage()) + "%";
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*5, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.accuracy;
	color = c_white;
	caption = "Accuracy: " + string(global.player_stats_struct.Get_accuracy()) + "%";
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*6, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.game;
	color = c_white;
	caption = "Finished games: " + string(global.player_elo_struct.Played_games);
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*7, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.tracking;
	color = c_white;
	caption = "Past period: " + string(TRACKING_GAMES/2) + " games";
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*8, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.tracking;
	color = c_white;
	caption = "Predictive period: " + string(TRACKING_GAMES/2) + " games";
}

with (zui_create(rank_title_x + label_gap*2, rank_title_y + text_gap*9, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.tracking;
	color = c_white;
	caption = "Predictive period percentage: " + string(global.player_elo_struct.Tracking_game/(TRACKING_GAMES/2)*100) + "%";
}

#endregion

#region Level
with (zui_create(rank_title_x + label_gap, rank_title_y, objUILabel)) {
	color = MAIN_COLOR;
	caption = "Level: " + string(global.player_stats_struct.Lvl);
}

with (zui_create(rank_image_position_x + label_gap - sprite_get_width(spr_HealthBar)/4 * global.GUIMultiplier, rank_title_y + text_gap, objUIImage)) {
	zui_set_anchor(0, 0);
	sprite_image_index = 8;
	healthbar = true;
}

with (zui_create(rank_title_x + label_gap + string_width(xp_string), rank_title_y + text_gap*2, objUILabel)) {
	var bonus_xp = (global.player_stats_struct.Max_xp * 2) - global.player_stats_struct.Max_xp;
	color = c_red;
	caption = "(+" + string(bonus_xp) + ")";
}

with (zui_create(rank_title_x + label_gap, rank_title_y + text_gap*2, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.xp;
	color = c_white;
	caption = other.xp_string;
}

with (zui_create(rank_title_x + label_gap, rank_title_y + text_gap*3, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.health;
	color = c_white;
	caption = other.health_string;
}

with (zui_create(rank_title_x + label_gap + string_width(health_string), rank_title_y + text_gap*3, objUILabel)) {
	var bonus_health = (global.player_stats_struct.Max_health * power(1.25, ln(global.player_stats_struct.Lvl + 1))) - global.player_stats_struct.Max_health;
	color = c_green;
	caption = "(+" + string(bonus_health) + ")";
}

with (zui_create(rank_title_x + label_gap, rank_title_y + text_gap*4, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.stamina;
	color = c_white;
	caption = other.stamina_string;
}

with (zui_create(rank_title_x + label_gap + string_width(stamina_string), rank_title_y + text_gap*4, objUILabel)) {
	var bonus_stamina = (global.player_stats_struct.Max_stamina * power(1.25, ln(global.player_stats_struct.Lvl + 1))) - global.player_stats_struct.Max_stamina;
	color = c_green;
	caption = "(+" + string(bonus_stamina) + ")";
}

with (zui_create(rank_title_x + label_gap, rank_title_y + text_gap*5, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.armour;
	color = c_white;
	caption = other.armour_string;
}

with (zui_create(rank_title_x + label_gap + string_width(armour_string), rank_title_y + text_gap*5, objUILabel)) {
	var bonus_armour = .01;
	color = c_green;
	caption = "(+" + string(bonus_armour*100) + "%)";
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