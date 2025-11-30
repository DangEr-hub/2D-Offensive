var damage = other.stats.Damage * power(1 - global.ItemIndex[#other.stats.Item_id, ItemStat.DamageDrop], point_distance(x, y, other.stats.Starting_x, other.stats.Starting_y));
var BloodSplashNumber = ceil(damage / 5);
var BloodParticleNumber = ceil(damage / 2);

repeat(BloodSplashNumber){
	var BloodSplash = instance_create_layer(other.x, other.y, "ItemsO", oBloodSplash);
	BloodSplash.image_blend = c_red;
}
if(instance_exists(oParticleSystem)){
	part_type_color1(oParticleSystem.BloodParticle, c_red);
	part_particles_create(global.ParticleSystem, other.x, other.y, oParticleSystem.BloodParticle, BloodParticleNumber);
}

play_sound(other.x, other.y, snd_BirdDeath, global.local_player);
instance_destroy(id);




