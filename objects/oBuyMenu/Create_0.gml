event_inherited();
buy_menu_width = clamp(1182 * global.GUIMultiplier, round(global.GuiW * .825), round(global.GuiW * .975));
buy_menu_height = clamp(798 * global.GUIMultiplier, round(global.GuiH * .825), round(global.GuiH * .975));

draw_set_font(set_font("GUI_small"));
zui_set_size(buy_menu_width, buy_menu_height);

buy_time_cap = zui_create(0, 0, objUIWindowCaption, depth - 1);
with (buy_time_cap) {
	caption = "Buy time remaining: " + string(oDraw.buy_time);
	draggable = 1;
}

function create_buy_item(_x, _y, _item, _clickable){
    with(zui_create(_x, _y, objUIButton)){
        zui_set_size(other.button_width, other.button_height);
        zui_set_anchor(0.5, 0);
        caption_color = MAIN_COLOR;
        caption_offset_y = -other.button_height/4 - 4;
        caption = string(global.ItemIndex[#_item, ItemStat.Name]);
    }

    with(zui_create(_x, _y, objUIImage)){
        zui_set_size(other.button_width, other.button_height);
        zui_set_anchor(0.5, 0);
        item_variable = _item;
        buy_menu = true;
        clickable = _clickable;
        sprite = spr_Items;
        sprite_image_index = _item;
        sprite_width_size = other.button_width;
        sprite_height_size = other.button_height;
        callback = function(){
            buy_item(item_variable);
        };
    }

    if(global.ItemIndex[#_item, ItemStat.is_locked]){
        with(zui_create(_x, _y + oBuyMenu.button_height/2, objUIImage)){
            zui_set_size(45 * global.GUIMultiplier, 45 * global.GUIMultiplier);
            zui_set_depth(-1000);
            sprite = spr_Lock;
            clickable = false;
            alpha = .9;
			sprite_width_size = 45 * global.GUIMultiplier;
			sprite_height_size = 45 * global.GUIMultiplier;
        }
		with(zui_create(_x, _y + oBuyMenu.button_height/2, objUIImage)){
			zui_set_size(other.button_width, other.button_height);
			zui_set_depth(-1000);
			sprite = spr_lockbg;
			clickable = false;
			sprite_image_index = 0;
			sprite_width_size = other.button_width;
			sprite_height_size = other.button_height;
		}
    }
}

button_width = min(144 * global.GUIMultiplier, 192);
button_height = min(64 * global.GUIMultiplier, 96);
buy_items = [
    [Item.AKM, Item.m4a1, Item.SG550, Item.galil, Item.MK18, Item.famas, Item.None],
    [Item.MAC11, Item.MP9, Item.MP7, Item.None, Item.None, Item.None, Item.None],
	[Item.SSG08, Item.awm, Item.Dragunov, Item.None, Item.None, Item.None, Item.None],
    [Item.Glock, Item.usp, Item.DesertEagle, Item.p250, Item.tec9, Item.CZ75, Item.None],
    [Item.Javelin, Item.Spas, Item.None, Item.None, Item.None, Item.None, Item.None],
    [Item.HEGrenade, Item.SmokeGrenade, Item.StickyGrenade, Item.FlashBangGrenade, Item.HealingKit, Item.None, Item.None],
    [Item.KevlarHelm, Item.KevlarVest, Item.MilitaryHelm, Item.MilitaryVest, Item.SpecOpsHelm, Item.SpecOpsVest, Item.None],
	[Item.kevlar_shield, Item.military_shield, Item.spec_ops_shield, Item.None, Item.None, Item.None, Item.None]
];

var start_x = zui_get_width() * .055;
var start_y = zui_get_height() * .05;
var col_spacing = button_width * 1.05;
var row_spacing = button_height * 1.05;

var cols = array_length(buy_items);
var rows = array_length(buy_items[0]);

for(var xx = 0; xx < cols; xx++){
    for(var yy = 0; yy < rows; yy++){
        var item = buy_items[xx][yy];
        if(item != Item.None){
            create_buy_item(
                start_x + xx * col_spacing,
                start_y + yy * row_spacing,
                item,
                true
            );
        }
    }
}