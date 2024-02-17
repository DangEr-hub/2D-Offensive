event_inherited();
randomize();
Type = "Metal";
Object = noone;
image_index = choose(0, 1);
image_speed = 0;
stats = {
	Penetration_power: .5 * (image_index + 1),
	Damage_drop: .001,
	Health_points: 100 * (image_index + 1),
	Damage: 100 * (image_index + 1)
};