#region Bullet wall hit
var wall_collision = process_bullet_collision(starting_x, starting_y, x, y, ShotX, ShotY, oParentTile, false);
if(wall_collision != noone){
	
	randomize();
	
	#region Variables
	var WallParticles = irandom_range(global.ItemIndex[#Weapon, ItemStat.Damage], global.ItemIndex[#Weapon, ItemStat.Damage]*2);
	var wall_sound = snd_BulletConcrete;
	if(wall_collision.instance_id.Type == "Metal"){
		wall_sound = snd_BulletMetal;
	}
	#endregion
	
	if(image_index == 0){
		
		#region Bullet hits wall
		
		if(ds_exists(HitList, ds_type_list)){
			if(ds_list_find_index(HitList, wall_collision.instance_id) == -1){
				
				play_sound(wall_collision.x, wall_collision.y, wall_sound);
				
				#region Barrel
				if(wall_collision.instance_id.object_index == oBarrel){
					var bullet_damage = Damage * power(1 - global.ItemIndex[#Weapon, ItemStat.DamageDrop], point_distance(starting_x, starting_y, wall_collision.instance_id.x, wall_collision.instance_id.y));
					wall_collision.instance_id.Object = Object;
					wall_collision.instance_id.stats.Health_points -= bullet_damage / (PenetrationDamage + 1);
				}
				#endregion
			
				#region Particles
				var ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
				ParticleCreate(
					WallParticles, 
					0.8, 
					random(360), 
					ParticleTexture, 
					random_range(-5, -10), 
					random_range(-90, 90), 
					other.image_angle, 
					1, 
					false, 
					false, 
					0, 
					wall_collision.x,
					wall_collision.y
				);
				ParticleCreate(
					ceil(WallParticles/2), 
					0.8, 
					random(360), 
					ParticleTexture, 
					random_range(-5, -10), 
					random_range(-90, 90), 
					other.image_angle, 
					1, 
					true, 
					false, 
					0, 
					wall_collision.x,
					wall_collision.y
				);
				ParticleCreate(
					global.ItemIndex[#Weapon, ItemStat.Damage]/5, 
					.8, 
					random(360), 
					spr_MovementParticle, 
					global.ItemIndex[#Weapon, ItemStat.Damage]/5, 
					random_range(-90, 90),
					random(360),
					1,
					choose(true, false),
					false,
					0,
					wall_collision.x,
					wall_collision.y
				);
				if(instance_exists(oParticleSystem)){
					part_particles_create(global.ParticleSystem, wall_collision.x, wall_collision.y, oParticleSystem.Spark, ceil(global.ItemIndex[#Weapon, ItemStat.Damage]/5));
				}
				#endregion
			
				ds_list_add(HitList, wall_collision.instance_id);
			
			}
		}
		PenetrationDamage ++;
		#endregion
		
	}else{
		
		#region Rocket hits wall
		var ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
		ParticleCreate(WallParticles, 0.8, random(360), ParticleTexture, 
		random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, false, false, 0, x, y);
		ParticleCreate(ceil(WallParticles/2), 0.8, random(360), ParticleTexture, 
		random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, true, false, 0, x, y);
		ExplosionCreate(30, x, y, global.ItemIndex[#Weapon, ItemStat.Damage], false, Object, global.ItemIndex[#Weapon, ItemStat.PenetrationPower], global.ItemIndex[#Weapon, ItemStat.DamageDrop], Item.None, 128);	
		
		if(instance_exists(oParticleSystem)){
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, ceil(global.ItemIndex[#Weapon, ItemStat.Damage]/5));
		}
		
		if!(audio_is_playing(wall_sound)){play_sound(x, y, wall_sound);}
		
		instance_destroy(self);
		#endregion
		
	}
}
#endregion
/*if(instance_exists(oBarrel)){
	var Barrel = process_bullet_collision(starting_x, starting_y, x, y, ShotX, ShotY, oBarrel, true);
	if(Barrel != noone){
		var wall_sound = snd_BulletConcrete;
		if(Barrel.instance_id.Type == "Metal"){
			wall_sound = snd_BulletMetal;
		}
		play_sound(Barrel.x, Barrel.y, wall_sound);
	if(ds_exists(HitList, ds_type_list)){
			if(ds_list_find_index(HitList, Barrel.instance_id) == -1){
				var bullet_damage = Damage * power(1 - global.ItemIndex[#Weapon, ItemStat.DamageDrop], point_distance(starting_x, starting_y, Barrel.instance_id.x, Barrel.instance_id.y));
				Barrel.instance_id.Object = Object;
				Barrel.instance_id.stats.Health_points -= bullet_damage / (PenetrationDamage + 1);
				ds_list_add(HitList, Barrel.instance_id);
			}
		}
	}
}