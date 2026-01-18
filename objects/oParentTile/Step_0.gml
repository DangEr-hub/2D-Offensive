		#region Knife hit
		var knife_object = instance_nearest(x, y, oKnife);
		if (instance_exists(knife_object)) {
		    if (instance_exists(knife_object.stats.Object) && knife_object.stats.Object_index == oPlayer) {
		        if (knife_object.stats.Object.knife_attack_timer >= global.ItemIndex[# knife_object.stats.Item_id, ItemStat.ReloadSpeed]) {
		            var hitbox_corners = get_hitbox_corners(knife_object, 25, 50, 20, knife_object.stats.Object.RotationAngle);

		            // Get the min and max x and y coordinates from the hitbox corners to define the bounding box
		            var min_x = min(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
		            var max_x = max(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
		            var min_y = min(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);
		            var max_y = max(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);

		            if (collision_rectangle(min_x, min_y, max_x, max_y, id, true, false)) {
						
						var wall_sound = snd_BulletConcrete;
						var WallParticles = irandom_range(knife_object.stats.Damage, knife_object.stats.Damage*2);
						if(Type == MATERIAL.METAL){
							wall_sound = snd_BulletMetal;
						}else if(Type == MATERIAL.WOOD){
							wall_sound = snd_BulletWood;	
						}else if(Type == MATERIAL.GLASS){
							wall_sound = snd_BulletGlass;	
						}
						if!(audio_is_playing(wall_sound)){
							play_sound(knife_object.x, knife_object.y, wall_sound, knife_object.stats.Object);
						}
						
						#region Particles
						if(instance_exists(oParticleSystem)){
							var spark_number = ceil(knife_object.stats.Damage/5);
							part_particles_create(global.ParticleSystem, knife_object.x, knife_object.y, oParticleSystem.Spark, spark_number);
							var posX = knife_object.x;
							var posY = knife_object.y;
							var partSystem = global.ParticleSystem;
							var partType = oParticleSystem.headshot_particle;

							for (var i = 0; i < spark_number; i++) {
								var randomDirection = random_range(knife_object.stats.Object.RotationAngle - 180 - 90, knife_object.stats.Object.RotationAngle - 180 + 90);
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
							knife_object.x,
							knife_object.y
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
							knife_object.x,
							knife_object.y
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
							knife_object.x,
							knife_object.y
						);
						#endregion
		            }
		        }
		    }
		}
		#endregion