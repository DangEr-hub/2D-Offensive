/// @description Insert description here
// You can write your code in this editor
if(global.ItemIndex[# other.stats.Item_id, ItemStat.Type] != "Weapon"){
	exit;
}


var bullet_hit = snd_BulletHit;
var BloodSplashNumber = round(global.ItemIndex[#other.stats.Item_id, ItemStat.Damage] / 5);
var BloodParticleNumber = round(global.ItemIndex[#other.stats.Item_id, ItemStat.Damage] / 2);

if(other.stats.Tracer_image == 2){
	BloodParticleNumber = 1;
}

create_blood(BloodSplashNumber, other.x, other.y, c_red, BloodParticleNumber);
play_sound(other.x, other.y, bullet_hit, other.stats.Object);
