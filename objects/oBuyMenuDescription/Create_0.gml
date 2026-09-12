event_inherited();
alpha = global.GUIHUDAlpha * 3;
alarm[0] = 1;
item_variable = Item.None;
menu_width = global.gui_scale <= 1.5 ? 500 : 550;
menu_height = global.gui_scale <= 1.5 ? 300 : 350;
desc_width = menu_width * .95;
coin_size = 32;

draw_set_font(set_font("GUI_small"));
zui_set_size(menu_width, menu_height);
