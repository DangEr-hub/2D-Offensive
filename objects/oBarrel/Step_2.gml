if(stats.Health_points <= 0){
	ExplosionCreate(
		ceil(stats.Damage/4),
		x,
		y,
		stats.Damage,
		true,
		Object,
		stats.Penetration_power,
		stats.Damage_drop
	);
}

