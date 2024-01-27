if(alpha_value < 1){
	alpha_value += ALPHA_SPEED;
}

if (pressed) {
	with (__parent) {
		var percent = inverse_lerp(8 * __sx, (__width - 8) * __sx, global.__zui_mx - __dx + __ax);
		value = clamp(round(minimum + (maximum - minimum) * percent), minimum, maximum);
	}
}
