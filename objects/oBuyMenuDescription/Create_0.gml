event_inherited();
alpha = global.GUIHUDAlpha * 3;
alarm[0] = 1;
item_variable = Item.None;
menu_width = 192 * global.GUIMultiplier;
menu_height = 384 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(menu_width, menu_height);
