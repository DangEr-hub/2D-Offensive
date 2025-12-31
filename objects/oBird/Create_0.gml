/* oBird create event */
event_inherited();
state = 1;
is_local = true;
direction = random(360);
image_angle = direction;
speed = random_range(3, 5);
image_speed = 0.75;
walk_spd = .75;
move_pos = [x, y];
move_timer = -1;
network_id = -1;
alarm[0] = random_range(1 * game_get_speed(gamespeed_fps), 2 * game_get_speed(gamespeed_fps));









