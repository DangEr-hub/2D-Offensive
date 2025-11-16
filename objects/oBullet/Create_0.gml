/// @description Insert description here
// You can write your code in this editor
LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
LightObject.castShadows = false;
LightObject.blend = MAIN_COLOR;
LightObject.xscale = .5;
LightObject.yscale = .5;
mask_index = spr_Bullet;
image_angle = random(360);
alarm[0] = 1;

stats = {
    "Damage": 0,
    "Starting_x": 0,
    "Starting_y": 0,
    "Object": -1,
    "Item_id": Item.None,
    "Penetration_damage": 0,
    "Tracer_image": 0,
    "Object_index": -1,
    "Owner_name": "Noone",
    "Owner_id": -1
};
