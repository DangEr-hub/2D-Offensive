/// @description Create objects
if(is_local == true){
	if (!instance_exists(oEconomics)) {
		instance_create_layer(x, y, "OtherO", oEconomics);
	}

	if(global.DrawParticles == true){
		instance_create_layer(x, y, "ItemsO", oParticleSurface);
		instance_create_layer(x, y, "OtherO", oParticleSystem);
	}
	instance_create_layer(x, y, "OtherO", oDraw);
	instance_create_layer(x, y, "OtherO", oConsole);
	instance_create_layer(x, y, "OtherO", oCrosshair);
	Knife = instance_create_depth(x + 40, y - 5, depth - 1, oKnife);
	Knife.stats.Object = id;
	Knife.stats.Object_index = object_index; 
}










