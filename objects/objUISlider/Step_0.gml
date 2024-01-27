if(alpha_value < 1){
	alpha_value += ALPHA_SPEED;
}

if (pvalue != value) {
	var scroll_value = inverse_lerp(minimum, maximum, value);
	var scroll_x = scroll_value * (__width - 16) + 8;

	handle.__x = scroll_x;
	pvalue = value;
	
	switch(type){
		case "Volume":
			global.sound_gain = value;
		break;
	}
 
	if (is_callable(callback))
		callback(value);
}
