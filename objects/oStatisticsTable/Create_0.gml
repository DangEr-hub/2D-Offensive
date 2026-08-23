event_inherited();

alpha = global.GUIHUDAlpha * 1.75;
table_width = clamp(960 * global.GUIMultiplier, 900, 1280);
table_height = clamp(720 * global.GUIMultiplier, 720, 880);
zui_set_size(table_width, table_height);

with(zui_create(0, 0, objUIWindowCaption, depth - 1)){
	caption = "Scoreboard";
	draggable = 0;
}

with(zui_create(32 * global.GUIMultiplier, 48 * global.GUIMultiplier, objUIGrid)){
	zui_set_anchor(0, 0);
	zui_set_size(other.table_width - 64 * global.GUIMultiplier, other.table_height - 72 * global.GUIMultiplier);
	show_stats = true;
	type = "Scoreboard";
	alpha = global.GUIHUDAlpha * 1.75;
}
