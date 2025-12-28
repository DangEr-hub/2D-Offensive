event_inherited();

Type = MATERIAL.GLASS;
image_index = choose(0, 1);
image_speed = 0;

stats = {
	Health_points: image_index == 1 ? 200 : 100
};