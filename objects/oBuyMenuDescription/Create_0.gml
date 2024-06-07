event_inherited();
alpha = global.GUIHUDAlpha * 3;
alarm[0] = 1;
item_variable = Item.None;
menu_width = max(192 * global.GUIMultiplier, 320);
menu_height = max(384 * global.GUIMultiplier, 512);

draw_set_font(set_font("Menu_small"));
zui_set_size(menu_width, menu_height);
