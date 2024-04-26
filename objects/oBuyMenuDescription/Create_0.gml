event_inherited();
Object = noone;
menu_width = 128 * global.GUIMultiplier;
menu_height = 128 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(menu_width, menu_height);


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Item description";
	draggable = 1;
}
