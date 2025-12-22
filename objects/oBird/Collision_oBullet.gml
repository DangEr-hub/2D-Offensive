var damage = other.stats.Damage * power(1 - global.ItemIndex[#other.stats.Item_id, ItemStat.DamageDrop], point_distance(x, y, other.stats.Starting_x, other.stats.Starting_y));

if(!IS_NET){
	var BloodSplashNumber = ceil(damage / 5);
	var BloodParticleNumber = ceil(damage / 2);

	repeat(BloodSplashNumber){
		var BloodSplash = instance_create_layer(x, y, "ItemsO", oBloodSplash);
		BloodSplash.image_blend = c_red;
	}
	if(instance_exists(oParticleSystem)){
		part_type_color1(oParticleSystem.BloodParticle, c_red);
		part_particles_create(global.ParticleSystem, x, y, oParticleSystem.BloodParticle, BloodParticleNumber);
	}
}

if (IS_NET) {
    if (oNetworkManager.is_server) {
        server_process_bird_death(id, damage);
        exit;
    } else if (network_id >= 0) {
        send_bird_death_request(network_id, damage);
    }
}else{
	play_sound(x, y, snd_BirdDeath, global.local_player);
	instance_destroy(id);
}




