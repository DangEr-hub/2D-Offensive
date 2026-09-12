var MaxDistanceToTarget = 256;
var PointDistance = point_distance(stats.Shot_x, stats.Shot_y, stats.Starting_x, stats.Starting_y);
LightObject.x = x;
LightObject.y = y;
LightObject.angle = image_angle;



#region Infra vision
if(global.local_player.ToggleInfraVision == true || global.local_player.ToggleNightVision == true){
	if(infra_vision_light == undefined){
		infra_vision_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
		if(global.local_player.ToggleNightVision == true){
			infra_vision_light.blend = c_green;
		}else{
			infra_vision_light.blend = c_red;	
		}
	}
}else{
	if(infra_vision_light != undefined){
		infra_vision_light.Destroy();
		infra_vision_light = undefined;
	}
}
#endregion

if(is_local){

	#region Bullet enemy penetration
	var Enemy = instance_nearest(x, y, oParentLivingObject);

	if (Enemy != noone && Enemy.object_index == oPlayer && Enemy.is_local){
		Enemy = noone;
	}

    
	if (instance_exists(Enemy)) {
		if (instance_exists(Enemy.HeadHB) && instance_exists(Enemy.BodyHB) && instance_exists(Enemy.ArmHB)) {
			var head_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.HeadHB, false);
			var body_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.BodyHB, false);
			var arm_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.ArmHB, false);
			var leg_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.LegHB, false);
		    if (head_collision != noone) {
				if(ds_list_find_index(HitList, Enemy.HeadHB.MainObject) == -1){
		            if (ds_list_size(HitList) != 0) {
		                stats.Penetration_damage += .5 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
		            }
		            ds_list_add(HitList, Enemy.HeadHB.MainObject);
		        }
			}
		    if (body_collision != noone) {
				if(ds_list_find_index(HitList, Enemy.BodyHB.MainObject) == -1){
		            if (ds_list_size(HitList) != 0) {
		                stats.Penetration_damage += .5 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
		            }
		            ds_list_add(HitList, Enemy.BodyHB.MainObject);
		        }
			}
		    if (arm_collision != noone) {
				if(ds_list_find_index(HitList, Enemy.ArmHB.MainObject) == -1){
		            if (ds_list_size(HitList) != 0) {
		                stats.Penetration_damage += .5 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
		            }
		            ds_list_add(HitList, Enemy.ArmHB.MainObject);
		        }
		    }
		    if (leg_collision != noone) {
				if(ds_list_find_index(HitList, Enemy.LegHB.MainObject) == -1){
		            if (ds_list_size(HitList) != 0) {
		                stats.Penetration_damage += .5 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
		            }
		            ds_list_add(HitList, Enemy.LegHB.MainObject);
		        }
		    }
		}
	}
	#endregion

	#region Homing anti-tank missile bullet tracer
	if(image_index == 1){
		var RandomX = 0;
		var RandomY = 0;
		var NearestTargetX = stats.Shot_x;
		var NearestTargetY = stats.Shot_y;
		var MotorAngle = direction - 180;
		if(instance_exists(oParticleSystem)){
			part_type_orientation(oParticleSystem.flame_particle, MotorAngle, MotorAngle, 0, 0, 0);
			part_type_direction(oParticleSystem.flame_particle,MotorAngle,MotorAngle,0,0);
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.flame_particle, 50);
		}
		if(PointDistance <= global.ItemIndex[#stats.Item_id, ItemStat.Range]){
			if(instance_exists(stats.Nearest_enemy) && stats.Nearest_enemy != noone){
			NearestTargetX = stats.Shot_x;
			NearestTargetY = stats.Shot_y;
				if(distance_to_object(stats.Nearest_enemy) <= MaxDistanceToTarget && stats.Nearest_enemy.Visible == true){
					NearestTargetX = stats.Nearest_enemy.x;
					NearestTargetY = stats.Nearest_enemy.y;
				}
			}
		}else{
			RandomX = random_range(
				stats.Shot_x - inaccuracy_formula(stats.Item_id, stats.Object), 
				stats.Shot_x + inaccuracy_formula(stats.Item_id, stats.Object)
			);
			
			RandomY = random_range(
				stats.Shot_y - inaccuracy_formula(stats.Item_id, stats.Object), 
				stats.Shot_y + inaccuracy_formula(stats.Item_id, stats.Object)
			);
			NearestTargetX = stats.Starting_x +
			lengthdir_x(global.ItemIndex[#stats.Item_id, ItemStat.Range], point_direction(stats.Starting_x, stats.Starting_y, RandomX, RandomY));
			NearestTargetY = stats.Starting_y + 
			lengthdir_y(global.ItemIndex[#stats.Item_id, ItemStat.Range], point_direction(stats.Starting_x, stats.Starting_y, RandomX, RandomY));
		}
		var Angle = point_direction(stats.Starting_x, stats.Starting_y, NearestTargetX, NearestTargetY);
		direction += get_angle(Angle, 16);
			
		if(position_meeting(NearestTargetX, NearestTargetY, self) || distance_to_point(NearestTargetX, NearestTargetY) <= 64){	
			explosion_create(
				20, 
				[NearestTargetX, NearestTargetY],
				global.ItemIndex[# stats.Item_id, ItemStat.Damage] * global.ItemIndex[# other.stats.Item_id, ItemStat.damage_drop](PointDistance), 
				false, 
				stats.Object, 
				stats.Item_id,
				2,
				128
			);	
			instance_destroy(id);
		}
	}
	#endregion

	#region Shrapnel bullet tracer
	if(image_index == 2){
		if(point_distance(stats.Starting_x, stats.Starting_y, x, y) > stats.Distance){
			instance_destroy(id);
		}

		var bullet_distance = 50;
		var total_distance = point_distance(stats.Starting_x, stats.Starting_y, x, y);
		var expected_bullets = floor(total_distance / bullet_distance);
		var created_bullets = floor(point_distance(stats.Starting_x, stats.Starting_y, last_bullet_x, last_bullet_y) / bullet_distance);

		// Create bullets for any missed positions since the last created bullet
		while (created_bullets < expected_bullets) {
		    // Calculate the placement for the next bullet
		    var angle = point_direction(stats.Starting_x, stats.Starting_y, x, y);
		    var next_bullet_distance = (created_bullets + 1) * bullet_distance;
		    var bullet_x = lengthdir_x(next_bullet_distance, angle) + stats.Starting_x;
		    var bullet_y = lengthdir_y(next_bullet_distance, angle) + stats.Starting_y;

			var b = create_bullet(
				bullet_x,
				bullet_y,
				stats.Damage,
				stats.Starting_x,
				stats.Starting_y,
				stats.Object,
				stats.Item_id,
				stats.Penetration_damage,
				image_index,
				stats.Object_index,
				stats.Owner_name,
				direction,
				stats.Owner_id,
				bullet_network_id
			);
			b.hideable_col = hideable_col;
			b.shooter_prone = shooter_prone;

		    // Update tracking for the last bullet created
		    last_bullet_x = bullet_x;
		    last_bullet_y = bullet_y;
		    created_bullets++;
		}
	}
	#endregion

}

#region Normal bullet tracer
if(image_index == 0){
	if(distance_to_point(stats.Starting_x, stats.Starting_y) >= PointDistance){
		var bullet = create_bullet(
			stats.Shot_x,
			stats.Shot_y,
			stats.Damage,
			stats.Starting_x,
			stats.Starting_y,
			stats.Object,
			stats.Item_id,
			stats.Penetration_damage,
			image_index,
			stats.Object_index,
			stats.Owner_name,
			direction,
			stats.Owner_id,
			bullet_network_id
		);
		bullet.is_remote = is_remote;
		bullet.hideable_col = hideable_col;
		bullet.shooter_prone = shooter_prone;
		instance_destroy(id);
	}
}
#endregion
