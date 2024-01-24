event_inherited();
armour_descriptionwidth = 768 * global.GUIMultiplier;
armour_descriptionheight = 192 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(armour_descriptionwidth, armour_descriptionheight);

offset_position_x = 32;
offset_position_y = 64;
grid_height = ITEM_CELL_HEIGHT * global.GUIMultiplier * 2; 

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = oDraw.item_description;
	draggable = 1;
}


button_width = 128 * global.GUIMultiplier;
button_height = 16 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .5, zui_get_height() - button_height*1.25, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = -1;
}
with(zui_create(offset_position_x, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
	type = "Armour description";
}