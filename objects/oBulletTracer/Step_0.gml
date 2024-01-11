var MaxDistanceToTarget = 256;
var PointDistance = point_distance(ShotX, ShotY, BulletTracerX, BulletTracerY);

#region Infra vision
if(oPlayer.ToggleInfraVision == true){
	if!(instance_exists(infra_vision_light)){
		infra_vision_light = instance_create_depth(x, y, depth, oObjectLightCircle);
		infra_vision_light.Object = self;		
		with(infra_vision_light){
			light[| eLight.Range] = 128;
			light[| eLight.Intensity] = 1.5;	
			light[| eLight.Color] = $FF0000FF;
		}
	}	
}else{
	if(instance_exists(infra_vision_light)){
		instance_destroy(infra_vision_light);
	}
}
#endregion

#region Bullet enemy penetration
if(instance_exists(oEnemy)){
	var Enemy = instance_nearest(x, y, oEnemy);
	if(instance_exists(Enemy)){
		if(instance_exists(Enemy.HeadHitBox) && instance_exists(Enemy.BodyHitBox) && instance_exists(Enemy.ArmHitBox)){
			if(collision_line(xprevious, yprevious, x, y, Enemy.HeadHitBox, true, false) || 
			collision_line(xprevious, yprevious, x, y, Enemy.BodyHitBox, true, false) || 
			collision_line(xprevious, yprevious, x, y, Enemy.ArmHitBox, true, false)){	
		        if(ds_list_find_index(HitList, Enemy.id) == -1){
				   if(ds_list_size(HitList) != 0){
		                PenetrationDamage += 0.1 / global.ItemIndex[#Weapon, ItemStat.PenetrationPower];
				   }
		            ds_list_add(HitList, Enemy.id);
		        }
			}
		}
	}
}
#endregion

#region Homing anti-tank missile bullet tracer
if(image_index == 1){
	var MotorAngle = direction - 180;
	part_type_orientation(oParticleSystem.FlameParticle, MotorAngle, MotorAngle, 0, 0, 0);
	part_type_direction(oParticleSystem.FlameParticle,MotorAngle,MotorAngle,0,0);
	part_particles_create(global.ParticleSystem, x, y, oParticleSystem.FlameParticle, 50);
	if(PointDistance <= global.ItemIndex[#Weapon, ItemStat.Range]){
		var NearestTargetX = ShotX;
		var NearestTargetY = ShotY;
		if(instance_exists(NearestEnemy) && NearestEnemy != noone){
			if(distance_to_object(NearestEnemy) <= MaxDistanceToTarget && NearestEnemy.State != States.Death && NearestEnemy.Visible == true){
				NearestTargetX = NearestEnemy.x;
				NearestTargetY = NearestEnemy.y;
			}
		}
	}else{
		var RandomX, RandomY;
		var NearestTargetX, NearestTargetY;
		if(instance_exists(Object) && Object != noone){
			RandomX = random_range(
				ShotX - global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object), 
				ShotX + global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object)
			);
			
			RandomY = random_range(
				ShotY - global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object), 
				ShotY + global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object)
			);
		}else{
			RandomX = ShotX;
			RandomY = ShotY;
		}
		NearestTargetX = BulletTracerX +
		lengthdir_x(global.ItemIndex[#Weapon, ItemStat.Range], point_direction(BulletTracerX, BulletTracerY, RandomX, RandomY));
		NearestTargetY = BulletTracerY + 
		lengthdir_y(global.ItemIndex[#Weapon, ItemStat.Range], point_direction(BulletTracerX, BulletTracerY, RandomX, RandomY));
	}
	var Angle = point_direction(BulletTracerX, BulletTracerY, NearestTargetX, NearestTargetY);
	direction += get_angle(Angle, 16);
			
	if(position_meeting(NearestTargetX, NearestTargetY, self) || distance_to_point(NearestTargetX, NearestTargetY) <= 64){	
		ExplosionCreate(
			30, 
			NearestTargetX, 
			NearestTargetY, 
			global.ItemIndex[#Weapon, ItemStat.Damage] * power(1 - global.ItemIndex[#other.Weapon, ItemStat.DamageDrop], PointDistance), 
			false, 
			Object, 
			global.ItemIndex[#Weapon, ItemStat.PenetrationPower], 
			global.ItemIndex[#Weapon, ItemStat.DamageDrop], 
			128,
			80
		);	
		instance_destroy(self);
	}
}
#endregion

#region Normal bullet tracer
if(image_index == 0){
	if(PointDistance <= global.ItemIndex[#Weapon, ItemStat.Range]){
		if(distance_to_point(BulletTracerX, BulletTracerY) >= PointDistance){
			var Bullet = instance_create_layer(ShotX, ShotY, "ItemsO", oBullet);
			Bullet.Damage = Damage;
			Bullet.StartingX = BulletTracerX;
			Bullet.StartingY = BulletTracerY;
			Bullet.Object = Object;
			Bullet.Weapon = Weapon;
			Bullet.PenetrationDamage = PenetrationDamage*10;
			Bullet.Tracer = id;
			Bullet.direction = direction;
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
				ShotX,
				ShotY
			);
			part_particles_create(global.ParticleSystem, ShotX, ShotY, oParticleSystem.Spark, ceil(global.ItemIndex[#Weapon, ItemStat.Damage]/5));
			instance_destroy(self);
		}
	}else{
		var RandomX, RandomY;
		if(distance_to_point(BulletTracerX, BulletTracerY) >= PointDistance){
			if(instance_exists(Object) && Object != noone){
				RandomX = random_range(
					ShotX - global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object), 
					ShotX + global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object)
				);
			
				RandomY = random_range(
					ShotY - global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object), 
					ShotY + global.ItemIndex[#Weapon, ItemStat.Inaccuracy]*inaccuracy_formula(Weapon, Object)
				);
			}else{
				RandomX = ShotX;
				RandomY = ShotY;
			}
			var BX = BulletTracerX +
			lengthdir_x(global.ItemIndex[#Weapon, ItemStat.Range], point_direction(BulletTracerX, BulletTracerY, RandomX, RandomY));
			var BY = BulletTracerY + 
			lengthdir_y(global.ItemIndex[#Weapon, ItemStat.Range], point_direction(BulletTracerX, BulletTracerY, RandomX, RandomY));
			var Bullet = instance_create_layer(BX, BY, "ItemsO", oBullet);
			Bullet.Damage = Damage;
			Bullet.StartingX = BulletTracerX;
			Bullet.StartingY = BulletTracerY;
			Bullet.Object = Object;
			Bullet.Weapon = Weapon;
			Bullet.PenetrationDamage = PenetrationDamage*10;
			Bullet.Tracer = id;
			Bullet.direction = direction;
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
				BX,
				BY
			);
			part_particles_create(global.ParticleSystem, BX, BY, oParticleSystem.Spark, ceil(global.ItemIndex[#Weapon, ItemStat.Damage]/5));
			instance_destroy(self);
		}	
	}
}
#endregion

#region Bullet wall hit
if(instance_exists(oParentTile)){
	if(collision_line(xprevious, yprevious, x, y, oParentTile, true, false)){
		if(image_index == 0){
			PenetrationDamage ++;
			if(WallHit == false){
				randomize();
				var Wall = instance_nearest(x, y, oParentTile);
				var WallParticles = irandom_range(global.ItemIndex[#Weapon, ItemStat.Damage], global.ItemIndex[#Weapon, ItemStat.Damage]*2);
				if(Wall.Type == "Concrete"){
					var ParticleTexture = choose(spr_WallParticle, spr_WallParticleTwo);
					ParticleCreate(WallParticles, 0.8, random(360), ParticleTexture, 
					random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, false, false, 0, x, y);
					ParticleCreate(ceil(WallParticles/2), 0.8, random(360), ParticleTexture, 
					random_range(-5, -10), random_range(-90, 90), other.image_angle, 1, true, false, 0, x, y);
				}
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
					x,
					y
				);
				part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, ceil(global.ItemIndex[#Weapon, ItemStat.Damage]/5));
				play_sound(x, y, snd_BulletConcrete);
				WallHit = true;
			}
		}else{
			ExplosionCreate(30, x, y, global.ItemIndex[#Weapon, ItemStat.Damage], false, Object, global.ItemIndex[#Weapon, ItemStat.PenetrationPower], global.ItemIndex[#Weapon, ItemStat.DamageDrop], Item.None, 128);	
			part_particles_create(global.ParticleSystem, x, y, oParticleSystem.Spark, ceil(global.ItemIndex[#Weapon, ItemStat.Damage]/5));
			play_sound(x, y, snd_BulletConcrete);
			instance_destroy(self);
		}
	}else{
		WallHit = false;
	}
}
#endregion