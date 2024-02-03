/// @description Insert description here
// You can write your code in this editor
var BloodSplashNumber = ceil(global.ItemIndex[#other.Weapon, ItemStat.Damage] / 5);
var BloodParticleNumber = ceil(global.ItemIndex[#other.Weapon, ItemStat.Damage] / 2);

repeat(BloodSplashNumber){
	var BloodSplash = instance_create_layer(other.x, other.y, "ItemsO", oBloodSplash);
	BloodSplash.image_blend = c_red;
}

if(instance_exists(oParticleSystem)){
	part_type_color1(oParticleSystem.BloodParticle, c_red);
	part_particles_create(global.ParticleSystem, other.x, other.y, oParticleSystem.BloodParticle, BloodParticleNumber);
}

play_sound(other.x, other.y, choose(snd_BulletHit1, snd_BulletHit2));	