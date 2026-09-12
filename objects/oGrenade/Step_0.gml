/// @description Insert description here
// You can write your code in this editor
if(stuck == false){
	x += lengthdir_x(stats.Speed, stats.Direction);
	y += lengthdir_y(stats.Speed, stats.Direction);
	stats.Speed *= .95 * global.time_step;
	
	if!(place_meeting(x, y, oParentTile) && place_meeting(x, y, oBot)){
		image_angle += stats.Speed*2 * global.time_step;
	}

}

if(stats.Item_id == Item.StickyGrenade){
	if (!stuck) {
		if(instance_exists(oParentTile)){
		    var collision_instance = instance_place(x, y, oParentTile);
		    if (collision_instance != noone) {
		        stuck = true;
		        stuck_to = collision_instance;
		        stuck_offset_x = x - stuck_to.x;
		        stuck_offset_y = y - stuck_to.y;
		    }
		}
		if(instance_exists(oBot)){
		    var collision_instance = instance_place(x, y, oBot);
		    if (collision_instance != noone) {
		        stuck = true;
		        stuck_to = collision_instance;
		        stuck_offset_x = x - stuck_to.x;
		        stuck_offset_y = y - stuck_to.y;
		    }
		}
	} else {
		if(instance_exists(stuck_to)){
			if(stuck_to.object_index = oBot){
				if(stuck_to.Visible == false){
					visible = false;
				}else{
					visible = true;
				}
			}
			x = stuck_to.x + stuck_offset_x;
			y = stuck_to.y + stuck_offset_y;
		}
	}
}

if(stats.Item_id == Item.MolotovGrenade && image_index == 4 && instance_exists(oParticleSystem)){
	var flame_offset = 13 * max(image_xscale, image_yscale);
	var flame_x = x + lengthdir_x(flame_offset, image_angle - 90);
	var flame_y = y - z + lengthdir_y(flame_offset, image_angle - 90);
	part_type_direction(oParticleSystem.flame_particle, image_angle - 120, image_angle - 60, 0, 6);
	part_particles_create(global.ParticleSystem, flame_x, flame_y, oParticleSystem.flame_particle, 1);
	part_type_direction(oParticleSystem.flame_particle, 0, 360, 0, 9);
	part_particles_create(global.ParticleSystem, flame_x, flame_y, oParticleSystem.fire_particle, 1);
}

if(ExplodeTimer > -1){
	ExplodeTimer -= global.time_step;
}

#region Explode
if(stats.Speed < .1 && stats.Speed > .0001){
	if(ExplosionTimer == -1){
		ExplosionTimer = ExplosionTime;
	}
}

if(ExplosionTimer > -1){
	ExplosionTimer -= global.time_step;
}

if(ExplosionTimer <= -1 || ExplodeTimer <= -1){
	if(stats.Speed < .1){
		if(network_visual_only){
			exit;
		}
		if(IS_NET && network_authority){
			server_grenade_explosion_broadcast(id);
		}
		if(stats.Item_id == Item.HEGrenade){
			
			#region Create explosion effect
			explosion_create(
				30, 
				[x, y],
				global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
			#endregion
			
		}else if(stats.Item_id == Item.FlashBangGrenade){
			explosion_create(
				5, 
				[x, y],
				global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
			if!(collision_line(x, y, global.local_player.x, global.local_player.y, oParentTile, true, false)){
				if (point_distance(x, y, global.local_player.x, global.local_player.y) < global.FlashBangMaxDistance) {
					
					#region Flash player
					if(global.GodMode == false){
						var angular_diff = abs(point_direction(global.local_player.x, global.local_player.y, x, y) - global.local_player.RotationAngle);
						if (angular_diff > 180){
							angular_diff = 360 - angular_diff;
						}
						global.local_player.FlashedBackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
						global.local_player.Flashed = true;
						global.local_player.Reloading = false;
						global.local_player.knife_attack_timer = -1;
						global.local_player.ReloadTimer = -1;
						global.local_player.FlashedAlpha = (1 - (angular_diff / 180)) * (1 - (point_distance(x, y, global.local_player.x, global.local_player.y) / global.FlashBangMaxDistance)*.1);
						global.local_player.FlashedAlpha = clamp(global.local_player.FlashedAlpha, 0, 1);
					}
					#endregion					
				}
			}
			if(instance_exists(oBot)){
				if!(collision_line(x, y, oBot.x, oBot.y, oParentTile, true, false)){
					if (point_distance(x, y, oBot.x, oBot.y) < global.FlashBangMaxDistance) {
						
						#region Flash enemy
						var angular_diff = abs(point_direction(oBot.x, oBot.y, x, y) - oBot.RotationAngle);
						if (angular_diff > 180){
							angular_diff = 360 - angular_diff;
						}
						oBot.Reloading = false;
						oBot.ReloadTime = 0;
						oBot.reload_timer = -1;
						oBot.Flashed = true;
						oBot.trigger_texture_timer = oBot.trigger_texture_time;
						oBot.FlashedTimer = round(oBot.FlashedTime * (1 - (angular_diff / 180)) * (1 - (point_distance(x, y, oBot.x, oBot.y) / global.FlashBangMaxDistance)*.1));
						#endregion
						
					}
					
				}
			}
		}else if(stats.Item_id == Item.SmokeGrenade){
				
			#region Create smoke effect
			instance_destroy(id);
			create_fog(x, y, random_range(100, 150), random(360), 0.1, random_range(.1, .5), 
				11, 
				.9, 
				.75, SMOKE_TIME
			);
			#endregion
				
		}else if(stats.Item_id == Item.MolotovGrenade){
			var owner_id = -1;
			if(is_struct(stats) && variable_struct_exists(stats, "Owner_id")){
				owner_id = stats.Owner_id;
			}
			var molotov_impact = create_molotov_impact(
				x,
				y,
				global.ItemIndex[#stats.Item_id, ItemStat.Damage],
				stats.Object,
				stats.Item_id,
				stats.Owner_name,
				owner_id,
				true,
				network_id
			);
			if(IS_NET && network_authority && instance_exists(molotov_impact)){
				network_id_reserved_for_impact = true;
			}
			instance_destroy(id);

		}else if(stats.Item_id == Item.StickyGrenade){
			
			#region Create explosion effect
			explosion_create(
				30,
				[x, y],
				global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
			#endregion
		}
	}
}
	


#endregion

#region Bounce
z += zspeed - zgravity;

zspeed *= .75;

if(z <= 0){
	zmaxspeed *= .7;
	zspeed = zmaxspeed;
}

z = clamp(z, 0, 99999);


var scale = 1 + (z/100);

image_xscale = scale;
image_yscale = scale;
#endregion

if(stuck == false){
	
	#region Collision with wall
	if (place_meeting(x, y, oParentTile)) {
		// Reflect off wall
		stats.Speed *= .75;
		stats.Direction = -stats.Direction * random_range(.9, 1);
		x -= lengthdir_x(stats.Speed, stats.Direction);  // Move out of collision
	}

	if (place_meeting(x, y, oParentTile)) {
		stats.Speed *= .75;
		stats.Direction = (180 - stats.Direction) * random_range(.9, 1);
		y -= lengthdir_y(stats.Speed, stats.Direction);  // Move out of collision
	}
	#endregion

	#region Collision with enemy

	x += lengthdir_x(stats.Speed, stats.Direction);
	if (place_meeting(x, y, oBot)) {
		var EnemyNearest = instance_nearest(x, y, oBot);
		if (place_meeting(x, y, EnemyNearest) && stats.Object != EnemyNearest) {
			stats.Speed *= .75;
		    stats.Direction = -stats.Direction * random_range(.75, 1);
		    x -= lengthdir_x(stats.Speed, stats.Direction);  // Move out of collision
		}
	}

	y += lengthdir_y(stats.Speed, stats.Direction);
	if(instance_exists(oBot)){
		var EnemyNearest = instance_nearest(x, y, oBot);
		if (place_meeting(x, y, EnemyNearest) && stats.Object != EnemyNearest) {
			stats.Speed *= .75;
		    stats.Direction = (180 - stats.Direction) * random_range(.75, 1);
		    y -= lengthdir_y(stats.Speed, stats.Direction);  // Move out of collision
		}
	}

	#endregion

}


