//NOTE:  Cloud can be set in motion at direction and speed totally independent of particle motion.
randomize();
cloud_fade = 0;
rotate_speed = 0;
move_dir = 0;
moving = false;
moving_x = 0;
moving_y = 0;
smoke_effect_create(
	random_range(100, 150),
	random(360),
	0.1,
	random_range(.1, .5),
	11,
	.9,
	.75,
	5 * game_get_speed(gamespeed_fps)
);