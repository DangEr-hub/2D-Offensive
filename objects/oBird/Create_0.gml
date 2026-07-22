/* oBird create event */
event_inherited();
state = 1;
is_local = true;
direction = random(360);
image_angle = direction;
base_spd_fly = random_range(3, 5);
base_spd_walk = 0.75;
speed = base_spd_fly;
base_is_fly = 0.75;
base_is_walk = 0.4;
image_speed = base_is_fly;
walk_spd = base_spd_walk;
move_pos = [x, y];
move_timer = -1;
network_id = -1;
alarm[0] = random_range(1 * game_get_speed(gamespeed_fps), 2 * game_get_speed(gamespeed_fps));









