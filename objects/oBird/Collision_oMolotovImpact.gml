var damage = other.stats.Damage;

if(!IS_NET){
	var BloodSplashNumber = round(damage / 5);
	var BloodParticleNumber = round(damage / 2);

	create_blood(BloodSplashNumber, other.x, other.y, c_red, BloodParticleNumber);
}

if (IS_NET) {
    if (oNetworkManager.is_server) {
        server_process_bird_death(id, damage);
        exit;
    } else if (network_id >= 0) {
        send_bird_death_request(network_id, damage);
    }
}else{
	play_sound(x, y, snd_BirdDeath);
	instance_destroy(id);
}




