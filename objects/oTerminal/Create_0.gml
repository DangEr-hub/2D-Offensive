event_inherited();

terminal_padding = 32 * global.gui_scale;
terminal_width = min(global.GuiW - terminal_padding * 2, global.ConsoleWidth * global.gui_scale + terminal_padding * 2);
terminal_height = min(global.GuiH - terminal_padding * 2, global.ConsoleHeight * global.gui_scale + 128);
zui_set_size(terminal_width, terminal_height);

with(zui_create(0, 0, objUIWindowCaption, depth - 1)){
	caption = "Terminal";
	draggable = 1;
}
