stats = {
	"Speed": 0,
	"Shot_x": 0,
	"Shot_y": 0,
	"Damage": 0,
	"Starting_x": x,
	"Starting_y": y,
	"Object": noone,
	"Item_id": 0,
	"Penetration_damage": 0,
	"Object_index": -1,
	"Owner_name": "Noone",
	"Distance": 0,
	"Nearest_enemy": noone,
	"Object_x": 0,
	"Object_y": 0,
	"Owner_id": -1, /// PID hráče
	"Owner_visible": false, ///Visibilita hráče
};
is_remote = false;
is_local = false;
last_bullet_x = x;
last_bullet_y = y;
travelled_distance = 0;
Inaccuracy = 2;
infra_vision_light = undefined;
image_speed = 0;
HitList = ds_list_create();

owner_id = -1;
network_id = -1;

//create_haze_effect(x, y, 2 * game_get_speed(gamespeed_fps), id, "Circle", true, 128);