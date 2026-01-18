event_inherited();

transparent = true;
building_id = -1;
Type = MATERIAL.GLASS;
image_index = choose(0, 1);
image_speed = 0;
alarm[0] = 1;

stats = {
	Health_points: image_index == 1 ? 200 : 100
};