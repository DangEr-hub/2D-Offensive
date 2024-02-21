/// @description Insert description here
// You can write your code in this editor
var bullet_hit = choose(snd_BulletHit1, snd_BulletHit2);
var BloodSplashNumber = ceil(global.ItemIndex[#other.stats.Item_id, ItemStat.Damage] / 5);
var BloodParticleNumber = ceil(global.ItemIndex[#other.stats.Item_id, ItemStat.Damage] / 2);

if(other.stats.Tracer_image == 2){
	//BloodSplashNumber = 1;
	BloodParticleNumber = 1;
}

repeat(BloodSplashNumber){
	var BloodSplash = instance_create_layer(other.x, other.y, "ItemsO", oBloodSplash);
	BloodSplash.image_blend = c_red;
}

if(instance_exists(oParticleSystem)){
	part_type_color1(oParticleSystem.BloodParticle, c_red);
	part_particles_create(global.ParticleSystem, other.x, other.y, oParticleSystem.BloodParticle, BloodParticleNumber);
}

if!(audio_is_playing(bullet_hit)){
	play_sound(other.x, other.y, bullet_hit, other.stats.Object);	
}