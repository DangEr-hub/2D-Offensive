/// @description Insert description here
// You can write your code in this editor
var grenade_previous_x = x;
var grenade_previous_y = y;
if(stuck == false){
	x += lengthdir_x(stats.Speed, stats.Direction);
	y += lengthdir_y(stats.Speed, stats.Direction);
	stats.Speed *= 1 - (1 - 0.95) * global.time_step;
	
	if!(place_meeting(x, y, oParentTile) && place_meeting(x, y, oBot)){
		image_angle += stats.Speed*2 * global.time_step;
	}

}

if(stats.Item_id == ITEM.StickyGrenade){
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

if(stuck == false){
	var hit_wall = place_meeting(x, y, oParentTile);
	var hit_bot = instance_place(x, y, oBot);
	if(hit_bot == stats.Object){ hit_bot = noone; }
	if(hit_wall || hit_bot != noone){
		var hit_x = place_meeting(x, grenade_previous_y, oParentTile)
			|| (hit_bot != noone && place_meeting(x, grenade_previous_y, hit_bot));
		var hit_y = place_meeting(grenade_previous_x, y, oParentTile)
			|| (hit_bot != noone && place_meeting(grenade_previous_x, y, hit_bot));
		if(!hit_x && !hit_y){ hit_x = true; hit_y = true; }
		if(hit_x){ x = grenade_previous_x; stats.Direction = 180 - stats.Direction; }
		if(hit_y){ y = grenade_previous_y; stats.Direction = -stats.Direction; }
		stats.Speed *= .75;
	}
}

if(stats.Item_id == ITEM.molotov && image_index == 4 && instance_exists(oParticleSystem)){
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
		if(stats.Item_id == ITEM.HEGrenade){
			
			#region Create explosion effect
			explosion_create(
				30, 
				[x, y],
				global.ItemIndex[#stats.Item_id, ITEMSTATS.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
			#endregion
			
		}else if(stats.Item_id == ITEM.flashbang){
			explosion_create(
				5, 
				[x, y],
				global.ItemIndex[#stats.Item_id, ITEMSTATS.Damage], 
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
			with(oBot){
				if(point_distance(other.x, other.y, x, y) < global.FlashBangMaxDistance){
					if(!collision_line(other.x, other.y, x, y, oParentTile, true, false)){
						
						#region Flash enemy
						var angular_diff = abs(point_direction(x, y, other.x, other.y) - RotationAngle);
						if (angular_diff > 180){
							angular_diff = 360 - angular_diff;
						}
						Reloading = false;
						ReloadTime = 0;
						reload_timer = -1;
						Flashed = true;
						trigger_texture_timer = trigger_texture_time;
						FlashedTimer = round(FlashedTime * (1 - (angular_diff / 180)) * (1 - (point_distance(other.x, other.y, x, y) / global.FlashBangMaxDistance)*.1));
						#endregion
						
					}
					
				}
			}
		}else if(stats.Item_id == ITEM.smoke){
				
			#region Create smoke effect
			instance_destroy(id);
			create_fog(x, y, random_range(100, 150), random(360), 0.1, random_range(.1, .5), 
				11, 
				.9, 
				.75, SMOKE_TIME
			);
			#endregion
				
		}else if(stats.Item_id == ITEM.molotov){
			var owner_id = -1;
			if(is_struct(stats) && variable_struct_exists(stats, "Owner_id")){
				owner_id = stats.Owner_id;
			}
			var molotov_impact = create_molotov_impact(
				x,
				y,
				global.ItemIndex[#stats.Item_id, ITEMSTATS.Damage],
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

		}else if(stats.Item_id == ITEM.StickyGrenade){
			
			#region Create explosion effect
			explosion_create(
				30,
				[x, y],
				global.ItemIndex[#stats.Item_id, ITEMSTATS.Damage], 
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
