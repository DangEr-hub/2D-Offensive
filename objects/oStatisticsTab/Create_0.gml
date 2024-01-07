tab_width = 720 * global.GUIMultiplier;
tab_height = 425 * global.GUIMultiplier;



draw_set_font(set_font("Menu_small"));
zui_set_size(tab_width, tab_height);

rank_image_position_x = 32;
rank_image_position_y = 64;
rank_image_size_width = sprite_get_width(spr_ranks)/2 * global.GUIMultiplier;
rank_image_size_height = sprite_get_height(spr_ranks)/2 * global.GUIMultiplier;
rank_image_gap = rank_image_size_height * 1.1;
rank_callbacks = [];

#region Rank callbacks
rank_callbacks = [
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverI, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SilverI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SilverII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverIII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SilverIII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverIII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverIV, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SilverIV, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverIV, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverV, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SilverV, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverV, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SilverMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SilverMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SilverMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldI, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.GoldI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.GoldII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldIII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.GoldIII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldIII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldIV, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.GoldIV, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldIV, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GoldMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.GoldMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GoldMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondI, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.DiamondI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.DiamondII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondIII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.DiamondIII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondIII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.DiamondMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.DiamondMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.DiamondMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.AssaultEliteI, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.AssaultEliteI, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.AssaultEliteI, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.AssaultEliteII, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.AssaultEliteII, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.AssaultEliteII, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.AssaultMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.AssaultMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.AssaultMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.VersatileMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.VersatileMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.VersatileMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.ExperiencedVersatileMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.SupremeMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.SupremeMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.SupremeMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
    },
    function(){
        ui_show_popup(global.RankIndex[# RankType.GlobalMaster, RankStat.Name], "Min elo: " + string(global.RankIndex[# RankType.GlobalMaster, RankStat.Elo]), "OK", -1, max(string_width(global.RankIndex[# RankType.GlobalMaster, RankStat.Name]) * 2, 128 * global.GUIMultiplier), 64 * global.GUIMultiplier, -1, -1);
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

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Statistics";
	draggable = 1;
}