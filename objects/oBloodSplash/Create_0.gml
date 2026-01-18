/* Create */
movDir = random(360);
movSpd = random_range(7, 21);
fric = random_range(movSpd / 10, movSpd / 5);
image_xscale = random_range(.75, 2);
image_yscale = image_xscale;
image_angle = random(360);
sizeChange = random_range(image_xscale / 5, image_xscale / 2);
is_gui = false;
gui_x = 0;
gui_y = 0;
alphaChange = 0;
alarm[0] = game_get_speed(gamespeed_fps);//pojistka pro zničení

