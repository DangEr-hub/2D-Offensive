if(stats.Health_points <= 0){
	occluder.Destroy();
	ExplosionCreate(
		30,
		x,
		y,
		stats.Damage,
		true,
		stats.Object,
		stats.Item_id,
	);
}

