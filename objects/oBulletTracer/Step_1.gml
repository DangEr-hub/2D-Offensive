var wall_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, oParentTile, false);

if(wall_collision == noone && instance_exists(stats.Object)){
	if(collision_line(stats.Object_x, stats.Object_y, stats.Shot_x, stats.Shot_y, oParentTile, true, false) && stats.Item_id != Item.basic_machine_gun){
		stats.Penetration_damage += .5 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
	}
}

if(wall_collision != noone){
	
	randomize();
	
	#region Variables
	var wall_sound = snd_BulletConcrete;
	var WallParticles = irandom_range(global.ItemIndex[#stats.Item_id, ItemStat.Damage], global.ItemIndex[#stats.Item_id, ItemStat.Damage]*2);
	if(image_index == 2){
		WallParticles = 1;	
	}
	if(wall_collision.instance_id.Type == "Metal"){
		wall_sound = snd_BulletMetal;
	}
	#endregion
	
	if(image_index == 0 || image_index == 2){
		
		#region Bullet and shrapnel hits wall
		
		if(ds_exists(HitList, ds_type_list)){
			if(ds_list_find_index(HitList, wall_collision.instance_id) == -1){
				
				if!(audio_is_playing(wall_sound)){
					play_sound(wall_collision.x, wall_collision.y, wall_sound, stats.Object);
				}
				
				#region Barrel
				if(wall_collision.instance_id.object_index == oBarrel){
					var bullet_damage = stats.Damage * power(1 - global.ItemIndex[#stats.Item_id, ItemStat.DamageDrop], point_distance(stats.Starting_x, stats.Starting_y, wall_collision.instance_id.x, wall_collision.instance_id.y));
					wall_collision.instance_id.stats.Object_name = stats.Object_name;
					wall_collision.instance_id.stats.Object_index = stats.Object_index;
					wall_collision.instance_id.stats.Object = stats.Object;
					wall_collision.instance_id.stats.Health_points -= bullet_damage / (stats.Penetration_damage + 1);
				}
				#endregion
				
				#region Barrel
				if(wall_collision.instance_id.object_index == oGlass){
					var bullet_damage = stats.Damage * power(1 - global.ItemIndex[#stats.Item_id, ItemStat.DamageDrop], point_distance(stats.Starting_x, stats.Starting_y, wall_collision.instance_id.x, wall_collision.instance_id.y));
					wall_collision.instance_id.stats.Health_points -= bullet_damage / (stats.Penetration_damage + 1);
				}
				#endregion
			
				#region Particles
				if(instance_exists(oParticleSystem)){
					var spark_number = ceil(global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5);
					if(image_index == 2){
						spark_number = 1;	
					}
					part_particles_create(global.ParticleSystem, wall_collision.x, wall_collision.y, oParticleSystem.Spark, spark_number);
					var posX = x;
					var posY = y;
					var partSystem = global.ParticleSystem;
					var partType = oParticleSystem.headshot_particle;

					for (var i = 0; i < spark_number; i++) {
					    var randomDirection = random_range(direction - 180 - 90, direction - 180 + 90);
						part_type_color1(partType, c_gray);
					    part_type_direction(partType, randomDirection, randomDirection, 0, 0);
					    part_type_orientation(partType, randomDirection, randomDirection, 0, 0, false);
					    part_particles_create(partSystem, posX, posY, partType, 1);
						part_type_color1(partType, c_white);
					}
				}
				var ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
				particle_create(
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
				particle_create(
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
				particle_create(
					WallParticles, 
					.8, 
					random(360), 
					spr_MovementParticle, 
					WallParticles, 
					random_range(-90, 90),
					random(360),
					1,
					choose(true, false),
					false,
					0,
					wall_collision.x,
					wall_collision.y
				);
				#endregion
			
				ds_list_add(HitList, wall_collision.instance_id);
			
			}
		}
		stats.Penetration_damage += .5 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
		#endregion
		
	}else if(image_index == 1){
		
		#region Rocket hits wall
		var ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
		particle_create(WallParticles, 0.8, random(360), ParticleTexture, 
		random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, false, false, 0, x, y);
		particle_create(ceil(WallParticles/2), 0.8, random(360), ParticleTexture, 
		random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, true, false, 0, x, y);
		explosion_create(
			10, 
			x, 
			y, 
			global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
			false, 
			stats.Object, 
			stats.Item_id,
			2,
			128
		);	
		
		if(instance_exists(oParticleSystem)){
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, ceil(global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5));
		}
		
		if!(audio_is_playing(wall_sound)){play_sound(x, y, wall_sound, stats.Object);}
		
		instance_destroy(self);
		#endregion
		
	}
}