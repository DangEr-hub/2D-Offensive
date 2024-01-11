/// @description Insert description here
// You can write your code in this editor
if(distance_to_point(StartingPointX, StartingPointY) > Distance){
	instance_destroy(id);
}

if(instance_exists(oParentTile)){
	if(collision_line(xprevious, yprevious, x, y, oParentTile, true, false)){
		PenetrationDamage ++;
		if(WallHit == false){
			randomize();
			Wall = instance_nearest(x, y, oParentTile);
			WallParticles = min(irandom_range(Damage, Damage*2), 10);
			if(Wall.Type == "Concrete"){
				ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
				ParticleCreate(WallParticles, 0.8, random(360), ParticleTexture, 
				random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, false, false, 0, x, y);
				ParticleCreate(ceil(WallParticles/2), 0.8, random(360), ParticleTexture, 
				random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, true, false, 0, x, y);
			}
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, min(ceil(Damage/5), 10));
			if(audio_is_playing(snd_BulletConcrete)){
				play_sound(x, y, snd_BulletConcrete);
			}
			WallHit = true;
		}
	}else{
		WallHit = false;
	}
}
