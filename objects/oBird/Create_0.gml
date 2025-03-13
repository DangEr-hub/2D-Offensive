event_inherited();
state = "Flying";
direction = random(360);
image_angle = direction;
speed = random_range(4, 5);
image_speed = clamp(speed * 0.5, 0.7, 1);
walk_spd = random_range(.5, 1);
move_pos = [x, y];
move_timer = -1;
alarm[0] = random_range(1 * game_get_speed(gamespeed_fps), 2 * game_get_speed(gamespeed_fps));









