network_ip = "";
network_name = "";
usrname = "";
passwd = "";
active = true;
fov_size = 512;
active_timer = -1;
alarm_triggered = false;
scan_timer = 0;
max_spawn = 3;
spawn_n = 0;
alarm[0] = 5;

fov = 90;

lx1 = 0;
ly1 = 0;
lx2 = 0;
ly2 = 0;

if(!instance_exists(oCollisionTriangle)){
	collision_triangle_init();
}


cam_light = undefined;
if(instance_exists(oLightRenderer)){
	cam_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
	cam_light.castShadows = false;
	cam_light.xscale = 0.25;
	cam_light.yscale = 0.25;
	cam_light.alpha = 1;
	cam_light.blend = c_red;
}







