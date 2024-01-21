display_set_gui_size(1920, 1080);
with (objZUIMain) {
	if (id != other.id) {
		show_error("Do not create ZUIMain twice", true);

		exit;
	}
}
zui_set_size(display_get_gui_width(), display_get_gui_height());
zui_set_anchor(0, 0);

Alpha = 0;
global.__zui_mx = 0;
global.__zui_my = 0;
