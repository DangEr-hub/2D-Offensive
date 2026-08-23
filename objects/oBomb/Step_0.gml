tick_timer--;

if (tick_timer <= 0) {
	tick_timer = tick_interval;
	tick_pulse_timer = tick_pulse_duration;
	play_sound(x, y, snd_Beep);
}

if (tick_pulse_timer > 0) {
	image_index = 1;
	tick_pulse_timer--;
} else {
	image_index = 0;
}

if (tick_light != undefined) {
	tick_light.x = x;
	tick_light.y = y;
	tick_light.alpha = image_index == 1;
}
