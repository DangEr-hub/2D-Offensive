var MaxDistanceToTarget = 256;
var PointDistance = point_distance(stats.Shot_x, stats.Shot_y, stats.Starting_x, stats.Starting_y);
LightObject.x = x;
LightObject.y = y;
LightObject.angle = image_angle;

#region Infra vision
if(oPlayer.ToggleInfraVision == true || oPlayer.ToggleNightVision == true){
	if(infra_vision_light == undefined){
		infra_vision_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
		if(oPlayer.ToggleNightVision == true){
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

#region Bullet enemy penetration
if (instance_exists(oEnemy)) {
	var Enemy = instance_nearest(x, y, oEnemy);
    
	if (instance_exists(Enemy)) {
	    if (instance_exists(Enemy.HeadHitBox) && instance_exists(Enemy.BodyHitBox) && instance_exists(Enemy.ArmHitBox)) {
			var head_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.HeadHitBox, false);
			var body_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.BodyHitBox, false);
			var arm_collision = process_bullet_collision(stats.Starting_x, stats.Starting_y, x, y, stats.Shot_x, stats.Shot_y, Enemy.ArmHitBox, false);
	        if (head_collision != noone) {
				if(ds_list_find_index(HitList, head_collision.instance_id.MainObject) == -1){
	                if (ds_list_size(HitList) != 0) {
	                    stats.Penetration_damage += 0.1 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
	                }
	                ds_list_add(HitList, head_collision.instance_id.MainObject);
	            }
			}
	        if (body_collision != noone) {
				if(ds_list_find_index(HitList, body_collision.instance_id.MainObject) == -1){
	                if (ds_list_size(HitList) != 0) {
	                    stats.Penetration_damage += 0.1 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
	                }
	                ds_list_add(HitList, body_collision.instance_id.MainObject);
	            }
			}
	        if (arm_collision != noone) {
				if(ds_list_find_index(HitList, arm_collision.instance_id.MainObject) == -1){
	                if (ds_list_size(HitList) != 0) {
	                    stats.Penetration_damage += 0.1 / global.ItemIndex[#stats.Item_id, ItemStat.PenetrationPower];
	                }
	                ds_list_add(HitList, arm_collision.instance_id.MainObject);
	            }
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
		part_type_orientation(oParticleSystem.FlameParticle, MotorAngle, MotorAngle, 0, 0, 0);
		part_type_direction(oParticleSystem.FlameParticle,MotorAngle,MotorAngle,0,0);
		part_particles_create(global.ParticleSystem, x, y, oParticleSystem.FlameParticle, 50);
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
			stats.Shot_x - global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object), 
			stats.Shot_x + global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object)
		);
			
		RandomY = random_range(
			stats.Shot_y - global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object), 
			stats.Shot_y + global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object)
		);
		NearestTargetX = stats.Starting_x +
		lengthdir_x(global.ItemIndex[#stats.Item_id, ItemStat.Range], point_direction(stats.Starting_x, stats.Starting_y, RandomX, RandomY));
		NearestTargetY = stats.Starting_y + 
		lengthdir_y(global.ItemIndex[#stats.Item_id, ItemStat.Range], point_direction(stats.Starting_x, stats.Starting_y, RandomX, RandomY));
	}
	var Angle = point_direction(stats.Starting_x, stats.Starting_y, NearestTargetX, NearestTargetY);
	direction += get_angle(Angle, 16);
			
	if(position_meeting(NearestTargetX, NearestTargetY, self) || distance_to_point(NearestTargetX, NearestTargetY) <= 64){	
		ExplosionCreate(
			30, 
			NearestTargetX, 
			NearestTargetY, 
			global.ItemIndex[#stats.Item_id, ItemStat.Damage] * power(1 - global.ItemIndex[#other.stats.Item_id, ItemStat.DamageDrop], PointDistance), 
			false, 
			stats.Object, 
			stats.Item_id,
			2,
			128
		);	
	}
}
#endregion

#region Normal bullet tracer
if(image_index == 0){
	if(PointDistance <= global.ItemIndex[#stats.Item_id, ItemStat.Range]){
		if(distance_to_point(stats.Starting_x, stats.Starting_y) >= PointDistance){
			create_bullet(
				stats.Shot_x,
				stats.Shot_y,
				stats.Damage,
				stats.Starting_x,
				stats.Starting_y,
				stats.Object,
				stats.Item_id,
				stats.Penetration_damage*10,
				image_index,
				stats.Object_index,
				stats.Object_name,
				direction
			);
			ParticleCreate(
				global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5, 
				.8, 
				random(360), 
				spr_MovementParticle, 
				global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5, 
				random_range(-90, 90),
				random(360),
				1,
				choose(true, false),
				false,
				0,
				stats.Shot_x,
				stats.Shot_y
			);
			if(instance_exists(oParticleSystem)){
				part_particles_create(global.ParticleSystem, stats.Shot_x, stats.Shot_y, oParticleSystem.Spark, ceil(global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5));
			}
			instance_destroy(id);
		}
	}else{
		var RandomX = 0;
		var RandomY = 0;
		if(distance_to_point(stats.Starting_x, stats.Starting_y) >= PointDistance){
			RandomX = random_range(
				stats.Shot_x - global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object), 
				stats.Shot_x + global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object)
			);
			
			RandomY = random_range(
				stats.Shot_y - global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object), 
				stats.Shot_y + global.ItemIndex[#stats.Item_id, ItemStat.Inaccuracy]*inaccuracy_formula(stats.Item_id, stats.Object)
			);
			var BX = stats.Starting_x +
			lengthdir_x(global.ItemIndex[#stats.Item_id, ItemStat.Range], point_direction(stats.Starting_x, stats.Starting_y, RandomX, RandomY));
			var BY = stats.Starting_y + 
			lengthdir_y(global.ItemIndex[#stats.Item_id, ItemStat.Range], point_direction(stats.Starting_x, stats.Starting_y, RandomX, RandomY));
			create_bullet(
				BX,
				BY,
				stats.Damage,
				stats.Starting_x,
				stats.Starting_y,
				stats.Object,
				stats.Item_id,
				stats.Penetration_damage*10,
				image_index,
				stats.Object_index,
				stats.Object_name,
				direction
			);
			ParticleCreate(
				global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5, 
				.8, 
				random(360), 
				spr_MovementParticle, 
				global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5, 
				random_range(-90, 90),
				random(360),
				1,
				choose(true, false),
				false,
				0,
				BX,
				BY
			);
			if(instance_exists(oParticleSystem)){
				part_particles_create(global.ParticleSystem, BX, BY, oParticleSystem.Spark, ceil(global.ItemIndex[#stats.Item_id, ItemStat.Damage]/5));
			}
			instance_destroy(id);
		}	
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

		create_bullet(
			bullet_x,
			bullet_y,
			stats.Damage,
			stats.Starting_x,
			stats.Starting_y,
			stats.Object,
			stats.Item_id,
			stats.Penetration_damage*10,
			image_index,
			stats.Object_index,
			stats.Object_name,
			direction
		);
		ParticleCreate(
			1, 
			.8, 
			random(360), 
			spr_MovementParticle, 
			1,
			random_range(-90, 90),
			random(360),
			1,
			choose(true, false),
			false,
			0,
			x,
			y
		);
		if(instance_exists(oParticleSystem)){
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, 1);
		}

	    // Update tracking for the last bullet created
	    last_bullet_x = bullet_x;
	    last_bullet_y = bullet_y;
	    created_bullets++;
	}
}
#endregion