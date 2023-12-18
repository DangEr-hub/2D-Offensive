/// @description Insert description here
// You can write your code in this editor
if(State == States.Death){
	other.Object.AttackDamage = global.ItemIndex[#other.Weapon, ItemStat.Damage];
	BloodSplashNumber = ceil(other.Object.AttackDamage / 5);
	BloodParticleNumber = ceil(other.Object.AttackDamage / 2);



	repeat(BloodSplashNumber){
		BloodSplash = instance_create_layer(other.x, other.y, "ItemsO", oBloodSplash);
		BloodSplash.image_blend = c_red;
	}
	
	
	
	if(instance_exists(oParticleSystem)){
		part_type_color1(oParticleSystem.BloodParticle, c_red);
		part_particles_create(global.ParticleSystem, other.x, other.y, oParticleSystem.BloodParticle, BloodParticleNumber);
	}
	
	
	
	PlaySound(other.x, other.y, choose(snd_BulletHit1, snd_BulletHit2));	
}