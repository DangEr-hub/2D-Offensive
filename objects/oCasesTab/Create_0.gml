event_inherited();
tab_width = 720 * global.GUIMultiplier;
tab_height = 405 * global.GUIMultiplier;

draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);


with (zui_create(zui_get_width() * .85, 64, objUILottery)) {
	zui_set_anchor(0, 0);
}

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Weapon cases";
	draggable = 1;
}