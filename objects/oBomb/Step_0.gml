if (VisibilityTimer > 0) {
	VisibilityTimer--;
} else {
	Visible = false;
}

if (check_vis_timer > 0) {
	check_vis_timer--;
} else if (instance_exists(global.local_player)) {
	check_vis_timer = check_vis_time;
	var observer = global.local_player;
	var in_fov = point_in_triangle(bbox_left, bbox_top, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy)
		|| point_in_triangle(bbox_right, bbox_top, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy)
		|| point_in_triangle(bbox_left, bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy)
		|| point_in_triangle(bbox_right, bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy);

	if (in_fov
	&& collision_line(x, y, observer.x, observer.y, oParentTile, true, false) == noone
	&& collision_line(x, y, observer.x, observer.y, oSmokeTile, true, false) == noone) {
		Visible = true;
		VisibilityTimer = VisibilityTime;
	}
}

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
	tick_light.alpha = image_index == 1 && Visible;
}
