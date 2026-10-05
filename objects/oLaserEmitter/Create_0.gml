/// @description Insert description here
// You can write your code in this editor
event_inherited();
len = 1024;
l_x = x;
l_y = y;
active = true;
alarm_triggered = false;
network_ip = "";
network_name = "";
usrname = "";
passwd = "";
laser_time = round(random_range(0.25, 2) * game_get_speed(gamespeed_fps));
alarm[0] = 1;
laser_timer = round(laser_time);
emitting_timer = -1;
l_spd = random_range(7, 9);
emitting_time = round(len/l_spd);
laser_sync_timer = 0;
laser_last_active = active;
laser_last_sync_sequence = -1;
l_points = [];
l_stops = [];
l_n = 0;
laser_hit = noone;
l_dist = 1;
lx1 = 0;
ly1 = 0;
lx2 = 0;
ly2 = 0;
image_speed = 0;

image_index = irandom(2);


var item_id = ITEM.None;
switch(image_index){
	case 0:
		damage_interval = 0.75 * game_get_speed(gamespeed_fps);
		item_id = ITEM.red_laser;
	break;
	
	case 1:
		damage_interval = 0.55 * game_get_speed(gamespeed_fps);
		item_id = ITEM.yellow_laser;
	break;
	
	case 2:
		damage_interval = 2 * game_get_speed(gamespeed_fps);
		item_id = ITEM.blue_laser;
	break;
}


damage_age = 0;
damage_hits = ds_map_create();
stats = {
	Damage: global.ItemIndex[# item_id, ITEMSTATS.Damage],
	Starting_x: x,
	Starting_y: y,
	Object: noone,
	Item_id: item_id,
	Penetration_damage: 0,
	Tracer_image: 4,
	Object_index: -1,
	Owner_name: global.ItemIndex[# item_id, ITEMSTATS.Name],
	Owner_id: -1
};

col = global.ItemIndex[# item_id, ITEMSTATS.ItemColor];

if(!instance_exists(oCollisionTriangle)) collision_triangle_init();

cam_light = undefined;
if(instance_exists(oLightRenderer)){
	cam_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
	cam_light.castShadows = false;
	cam_light.xscale = 0.25;
	cam_light.yscale = 0.25;
	cam_light.alpha = 1;
	cam_light.blend = c_red;
}













