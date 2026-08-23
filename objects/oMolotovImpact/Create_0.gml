event_inherited();
sprite_index = spr_MolotovImpact;
mask_index = spr_MolotovImpact;
image_speed = 0;
image_index = 0;
image_blend = c_orange;
image_alpha = .22;

start_radius = 16;
max_radius = 256;
current_radius = start_radius;
spread_time = 1.25 * game_get_speed(gamespeed_fps);
life_time = 7 * game_get_speed(gamespeed_fps);
fade_time = 1.5 * game_get_speed(gamespeed_fps);
age = 0;

molotov_shape_points = 18;
molotov_shape_angle = array_create(molotov_shape_points, 0);
molotov_shape_distance = array_create(molotov_shape_points, 0);
molotov_shape_scale = array_create(molotov_shape_points, 1);
molotov_shape_yscale = array_create(molotov_shape_points, 1);
molotov_shape_alpha = array_create(molotov_shape_points, 1);

for(var i = 0; i < molotov_shape_points; i++){
	molotov_shape_angle[i] = i * (360 / molotov_shape_points) + random_range(-18, 18);
	molotov_shape_distance[i] = random_range(.22, .58);
	molotov_shape_scale[i] = random_range(.34, .72);
	molotov_shape_yscale[i] = random_range(.88, 1.08);
	molotov_shape_alpha[i] = random_range(.45, .9);
}

damage_interval = .55 * game_get_speed(gamespeed_fps);
damage_hits = ds_map_create();
can_damage = true;

molotov_particle_emitter = -1;
molotov_particle_emitter_created = false;
if(instance_exists(oParticleSystem)){
	molotov_particle_emitter = part_emitter_create(global.ParticleSystem);
	molotov_particle_emitter_created = true;
}

LightObject = noone;
if(instance_exists(oLightRenderer)){
	LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
	LightObject.castShadows = false;
	LightObject.blend = c_orange;
	LightObject.xscale = 1;
	LightObject.yscale = 1;
}

stats = {
	Damage: global.ItemIndex[# Item.MolotovGrenade, ItemStat.Damage],
	Starting_x: x,
	Starting_y: y,
	Object: noone,
	Item_id: Item.MolotovGrenade,
	Penetration_damage: 0,
	Tracer_image: 4,
	Object_index: -1,
	Owner_name: "Noone",
	Owner_id: -1
};

create_haze_effect(x, y, life_time + fade_time, id, "Circle", true, max_radius * 2, max_radius * 2);

play_sound(x, y, snd_Explosion, id, 100, 1500, .45);
