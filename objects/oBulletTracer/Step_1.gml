/* Begin Step oBulletTracer */
xx = stats.Starting_x; 
yy = stats.Starting_y; 
if(impact_ex != -1 && impact_ey != -1){ xx = impact_ex; yy = impact_ey; } 


var wall_collision = process_bullet_collision(xx, yy, x, y, stats.Shot_x, stats.Shot_y, oParentTile, false);

// Pokud je zeď příliš tenká, je potřeba to řešit přes pozici a ne přes kolizi
if(wall_collision == noone && instance_exists(stats.Object)){
	if(collision_line(stats.Object_x, stats.Object_y, stats.Shot_x, stats.Shot_y, oParentTile, true, false) && stats.Item_id != Item.basic_machine_gun){
		stats.Penetration_damage += PENETRATION_VALUE / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
	}
}

var bullet_damage = 0;
if(wall_collision != noone){
	bullet_damage = stats.Damage * power(1 - global.ItemIndex[#stats.Item_id, ItemStat.DamageDrop], point_distance(stats.Starting_x, stats.Starting_y, wall_collision.inst_id.x, wall_collision.inst_id.y));
	if(impact_flag == true){
		stats.Penetration_damage += PENETRATION_VALUE / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
	}
	
		
	if(ds_exists(HitList, ds_type_list) && ds_list_find_index(HitList, wall_collision.inst_id) == -1){
		impact_sx = wall_collision.xx + lengthdir_x(10, image_angle);
		impact_sy = wall_collision.yy + lengthdir_y(10, image_angle);
		impact_flag = true;
		impact_wall = wall_collision.inst_id;
		
		#region Variables
		var wall_sound = snd_BulletConcrete;
		var WallParticles = irandom_range(global.ItemIndex[#stats.Item_id, ItemStat.Damage], global.ItemIndex[#stats.Item_id, ItemStat.Damage]*2);
		if(image_index == 2){
			WallParticles = 1;	
		}
		if(wall_collision.inst_id.Type == MATERIAL.METAL){
			wall_sound = snd_BulletMetal;
		}else if(wall_collision.inst_id.Type == MATERIAL.WOOD){
			wall_sound = snd_BulletWood;	
		}else if(wall_collision.inst_id.Type == MATERIAL.GLASS){
			wall_sound = snd_BulletGlass;	
		}
		#endregion
	
		if(image_index == 0 || image_index == 2){
		
			#region Bullet and shrapnel hits wall
		
				
			if!(audio_is_playing(wall_sound)){
				play_sound(wall_collision.xx, wall_collision.yy, wall_sound, stats.Object);
			}
				
			#region Barrel
			if(wall_collision.inst_id.object_index == oBarrel){
				wall_collision.inst_id.stats.Owner_name = stats.Owner_name;
				wall_collision.inst_id.stats.Object_index = stats.Object_index;
				wall_collision.inst_id.stats.Object = stats.Object;
				wall_collision.inst_id.stats.Health_points -= bullet_damage / (stats.Penetration_damage + 1);
			}
			#endregion
				
			#region Barrel
			if(wall_collision.inst_id.object_index == oGlass){
				wall_collision.inst_id.stats.Health_points -= bullet_damage / (stats.Penetration_damage + 1);
			}
			#endregion
			
			#region Particles
			if(instance_exists(oParticleSystem)){
				var spark_number = ceil(global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5);
				if(image_index == 2){
					spark_number = 1;	
				}
				part_particles_create(global.ParticleSystem, wall_collision.xx, wall_collision.yy, oParticleSystem.Spark, spark_number);
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
				wall_collision.xx,
				wall_collision.yy
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
				wall_collision.xx,
				wall_collision.yy
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
				wall_collision.xx,
				wall_collision.yy
			);
			#endregion
			
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
		ds_list_add(HitList, wall_collision.inst_id);
	}
}

if(instance_exists(impact_wall) && !place_meeting(x, y, impact_wall)){
    if(impact_flag == true){
		
        impact_ex = x + lengthdir_x(20, image_angle);
        impact_ey = y + lengthdir_y(20, image_angle);
        impact_flag = false;

        var base_col = c_black;
        var width = 2;
        var num_s = 5;
        var jitter = 2;

        switch(impact_wall.Type){
            case MATERIAL.WOOD:
                width = random_range(2, 4);
                num_s = 25;
                jitter = 10 * (1 + bullet_damage/25);
            break;

            case MATERIAL.METAL:
                width = random_range(1, 2);
                num_s = 10;
                jitter = 1 * (1 + bullet_damage/25);
            break;
			
            case MATERIAL.GLASS:
                width = random_range(1, 3);
                num_s = 30;
                jitter = 2;
                break;


            case MATERIAL.CONCRETE:
            default:
                width = random_range(1, 3);
                num_s = 20;
                jitter = 3 * (1 + bullet_damage/25);
            break;
        }
		
		var impact_col = c_white;
		if(impact_wall.sprite_index == spr_TileCollision){
			var clr = tilemap_get_pixel(
			    layer_tilemap_get_id(layer_get_id("WallTiles")),
			    global.MapProperties[# global.MapID, MapProperty.Tile],
			    32,
			    32,
			    impact_wall.x,
			    impact_wall.y
			);
			impact_col = make_color_rgb(clr[0], clr[1], clr[2]);
		}else{
			var arr = sprite_getpixel(impact_wall.sprite_index, impact_wall.image_index, sprite_width/2, sprite_height/2);
			impact_col = make_color_rgb(arr[0], arr[1], arr[2]);
		}


        // ===== GENEROVÁNÍ OFFSETŮ PRO SEGMENTY =====
		width *= min((1 + bullet_damage/100), 1.5);
        var offsets = array_create(num_s + 1);

        offsets[0] = 0;
        offsets[num_s] = 0;

        for(var s = 1; s < num_s; s++){
            offsets[s] = random_range(-jitter, jitter);
        }

        // ===== ULOŽENÍ IMPACT LINE =====
		if(ds_list_size(impact_wall.impact_lines) < 8){
	        ds_list_add(
	            impact_wall.impact_lines,
	            [
	                impact_sx,
	                impact_sy,
	                impact_ex,
	                impact_ey,
	                global.clear_particles_timer * (1 + bullet_damage/50),
	                impact_col,
	                width,
	                offsets
	            ]
	        );
		}
    }
}
