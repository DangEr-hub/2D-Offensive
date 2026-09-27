usrname = oDraw.network_usernames[irandom(array_length(oDraw.network_usernames) - 1)];
passwd = oDraw.network_passwords[irandom(array_length(oDraw.network_passwords) - 1)];
oDraw.register_network_device(id, "c");

lx1 = x + lengthdir_x(fov_size, image_angle - fov/2);
ly1 = y + lengthdir_y(fov_size, image_angle - fov/2);
lx2 = x + lengthdir_x(fov_size, image_angle + fov/2);
ly2 = y + lengthdir_y(fov_size, image_angle + fov/2);













