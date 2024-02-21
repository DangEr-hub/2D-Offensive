/// @description Insert description here
stats = {
	"Speed": 0,
	"Shot_x": 0,
	"Shot_y": 0,
	"Damage": 0,
	"Starting_x": 0,
	"Starting_y": 0,
	"Object": 0,
	"Item_id": 0,
	"Penetration_damage": 0,
	"Object_index": 0,
	"Object_name": 0,
	"Distance": 0,
	"Nearest_enemy": noone
};
LightObject = new BulbLight(oLightRenderer.lighting, sLightTracer, 0, x, y); 
LightObject.castShadows = false;
last_bullet_x = x;
last_bullet_y = y;
travelled_distance = 0;
Inaccuracy = 0;
infra_vision_light = undefined;
image_speed = 0;
HitList = ds_list_create();