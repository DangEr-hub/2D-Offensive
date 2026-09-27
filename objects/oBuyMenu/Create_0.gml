event_inherited();
buy_menu_width = clamp(1182 * global.gui_scale, round(global.GuiW * .825), round(global.GuiW * .975));
buy_menu_height = clamp(798 * global.gui_scale, round(global.GuiH * .825), round(global.GuiH * .975));

draw_set_font(set_font("GUI_small"));
zui_set_size(buy_menu_width, buy_menu_height);

buy_time_cap = zui_create(0, 0, objUIWindowCaption, depth - 1);
with (buy_time_cap) {
	caption = tr("Buy_time_remaining") + " " + string(oDraw.buy_time);
	draggable = 1;
}

function create_buy_item(_x, _y, _item, _clickable){
	var item_offset_y = 0;
	switch(_item){
		case ITEM.HEGrenade:
		case ITEM.SmokeGrenade:
		case ITEM.StickyGrenade:
		case ITEM.FlashBangGrenade:
		case ITEM.HELandMine:
		case ITEM.LELandMine:
		case ITEM.CELandMine:
		case ITEM.NightVision:
		case ITEM.KevlarHelm:
		case ITEM.KevlarVest:
		case ITEM.MilitaryHelm:
		case ITEM.MilitaryVest:
		case ITEM.kevlar_shield:
		case ITEM.military_shield:
		case ITEM.spec_ops_shield:
		case ITEM.HealingKit:
			item_offset_y = oBuyMenu.button_height * .12;
		break;

		case ITEM.SpecOpsHelm:
		case ITEM.SpecOpsVest:
			item_offset_y = oBuyMenu.button_height * .18;
		break;
	}

    with(zui_create(_x, _y, objUIButton)){
        zui_set_size(other.button_width, other.button_height);
        zui_set_anchor(0.5, 0);
        caption_color = MAIN_COLOR;
        caption_offset_y = -other.button_height/4 - 4;
        caption = tr_name(_item);
    }

    with(zui_create(_x, _y + item_offset_y, objUIImage)){
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

    if(global.ItemIndex[#_item, ITEMSTATS.is_locked]){
        with(zui_create(_x, _y + oBuyMenu.button_height/2, objUIImage)){
            zui_set_size(45 * global.gui_scale, 45 * global.gui_scale);
            zui_set_depth(-1000);
            sprite = spr_Lock;
            clickable = false;
            alpha = .9;
			sprite_width_size = 45 * global.gui_scale;
			sprite_height_size = 45 * global.gui_scale;
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

button_width = min(144 * global.gui_scale, 192);
button_height = min(64 * global.gui_scale, 96);
buy_items = [
    [ITEM.AKM, ITEM.m4a1, ITEM.SG550, ITEM.galil, ITEM.MK18, ITEM.famas, ITEM.Scar, ITEM.g36c],
    [ITEM.MAC11, ITEM.MP9, ITEM.MP7, ITEM.P90, ITEM.None, ITEM.None, ITEM.None],
	[ITEM.SSG08, ITEM.awm, ITEM.Dragunov, ITEM.m200, ITEM.None, ITEM.None, ITEM.None],
    [ITEM.Glock, ITEM.usp, ITEM.DesertEagle, ITEM.p250, ITEM.tec9, ITEM.CZ75, ITEM.None],
    [ITEM.Javelin, ITEM.Spas, ITEM.None, ITEM.None, ITEM.None, ITEM.None, ITEM.None],
    [ITEM.HEGrenade, ITEM.SmokeGrenade, ITEM.StickyGrenade, ITEM.FlashBangGrenade, ITEM.HELandMine, ITEM.LELandMine, ITEM.CELandMine, ITEM.NightVision],
    [ITEM.KevlarHelm, ITEM.KevlarVest, ITEM.MilitaryHelm, ITEM.MilitaryVest, ITEM.SpecOpsHelm, ITEM.SpecOpsVest, ITEM.None],
	[ITEM.kevlar_shield, ITEM.military_shield, ITEM.spec_ops_shield, ITEM.HealingKit, ITEM.Bomb, ITEM.None, ITEM.None]
];

var start_x = zui_get_width() * .055;
var start_y = zui_get_height() * .05;
var col_spacing = button_width * 1.05;
var row_spacing = button_height * 1.05;

var cols = array_length(buy_items);

for(var xx = 0; xx < cols; xx++){
    var max_rows = xx < 6 ? 9 : 6;
    var rows = min(array_length(buy_items[xx]), max_rows);

    for(var yy = 0; yy < rows; yy++){
        var item = buy_items[xx][yy];
        if(item != ITEM.None){
            create_buy_item(
                start_x + xx * col_spacing,
				start_y + yy * row_spacing,
				item,
				true
			);
        }
    }
}
