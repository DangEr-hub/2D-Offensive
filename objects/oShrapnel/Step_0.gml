/// @description Insert description here
// You can write your code in this editor
LightObject.x = x;
LightObject.y = y;
LightObject.angle = image_angle;

if(distance_to_point(starting_x, starting_y) > Distance){
	instance_destroy(id);
}

#region Wall collision
var end_x = starting_x + (Distance * dcos(direction));
var end_y = starting_y + (Distance * dsin(direction));
var wall_collision = collision_line(starting_x, starting_y, end_x, end_y, oParentTile, true, false);
if (wall_collision != noone) {
	randomize();
	var Wall = instance_nearest(x, y, oParentTile);
	var WallParticles = min(irandom_range(Damage, Damage*2), 10);
	var wall_sound = snd_BulletConcrete;
	
	if(instance_exists(Wall)){
		if(Wall.Type == "Metal"){
			wall_sound = snd_BulletMetal;
		}
	}
	PenetrationDamage ++;
	if(WallHit == false){
		if!(audio_is_playing(wall_sound)){play_sound(x, y, wall_sound);}
		var ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
		ParticleCreate(WallParticles, 0.8, random(360), ParticleTexture, 
		random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, false, false, 0, x, y);
		ParticleCreate(ceil(WallParticles/2), 0.8, random(360), ParticleTexture, 
		random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, true, false, 0, x, y);
		if(instance_exists(oParticleSystem)){
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, min(ceil(Damage/5), 10));
		}
		WallHit = true;
	}		
}else{
	WallHit = false;
}
#endregion
