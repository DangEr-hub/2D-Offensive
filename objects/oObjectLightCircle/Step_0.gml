/// @desc Follow object
if(instance_exists(Object)){
	light[| eLight.X] = Object.x;
	light[| eLight.Y] = Object.y;
	light[| eLight.Flags] |= eLightFlags.Dirty; // rebuild static shadow casters
	light[| eLight.Range] = sqrt(power(Object.sprite_width, 2) + power(Object.sprite_height, 2));
}