if (pressed) {
	pressed = 0;

	if (zui_get_hover()) {
		if (is_callable(callback))
			audio_play_sound(snd_Button, 0, false);
			callback(id);
	}
}
