/// @description Create objects
if(is_local == true){
	if(global.DrawParticles == true){
		instance_create_layer(x, y, "ItemsO", oParticleSurface);
		instance_create_layer(x, y, "OtherO", oParticleSystem);
	}
	if(global.ranked_game == true){
		instance_create_layer(x, y, "OtherO", oEggyEloRatingSystem);
	}
	instance_create_layer(x, y, "OtherO", oDraw);
	instance_create_layer(x, y, "OtherO", oConsole);
	instance_create_layer(x, y, "OtherO", oCrosshair);
	Weapon = instance_create_depth(x + WX, y + WY, depth - 1, oWeapon);
	Knife = instance_create_depth(x + 40, y - 5, depth - 1, oKnife);
	Knife.stats.Object = id;
	Knife.stats.Object_index = object_index; 
}










