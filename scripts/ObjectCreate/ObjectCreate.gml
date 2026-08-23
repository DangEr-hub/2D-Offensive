function create_fog(xx, yy, radius, dir, spd, rot_spd, num, alpha, fade, time, moving = [0, 0, false]){
	if(instance_number(oFog) < MAX_FOG){
		var Fog = instance_create_layer(xx, yy, "OtherO", oFog);
		Fog.moving = moving[2];
		Fog.moving_x = moving[0];
		Fog.moving_y = moving[1];
		with(Fog){
			smoke_setup(radius, dir, spd, rot_spd, num, alpha, fade, time * global.time_step);	
		}
		return Fog;
	}
	
	return noone;
}


function create_grenade(PositionX, PositionY, ID, GrenadeSpeed, TargetX, TargetY, ItemID, ObjectType = id){
	if(IS_NET && instance_exists(oNetworkManager) && !oNetworkManager.is_server && oNetworkManager.is_connected){
		send_grenade_spawn_request(ID, GrenadeSpeed, TargetX, TargetY, ItemID);
		return noone;
	}

	var owner_id = -1;
	if(instance_exists(ObjectType) && variable_instance_exists(ObjectType, "network_id")){
		owner_id = ObjectType.network_id;
	}

	ObjectSpeed = sqrt(power(XSpeed, 2) + power(YSpeed, 2));
	MoveDirX = dcos(MoveDirection) * ObjectSpeed;
	MoveDirY = -dsin(MoveDirection) * ObjectSpeed;
	GrenadeDirX = dcos(point_direction(PositionX, PositionY, TargetX, TargetY)) * GrenadeSpeed;
	GrenadeDirY = -dsin(point_direction(PositionX, PositionY, TargetX, TargetY)) * GrenadeSpeed;
	DotProduct = dot_product(MoveDirX, MoveDirY, GrenadeDirX, GrenadeDirY);		
	GrenadeObject = instance_create_depth(PositionX, PositionY, depth + 1, oGrenade);
	GrenadeObject.stats = {
		Object_index: ObjectType.object_index,
		Owner_name: ObjectType.stats.Name,
		Speed: max(GrenadeSpeed * global.time_step + (DotProduct * .1), 1),
		Object: ObjectType,
		Item_id: ItemID,
		Owner_id: owner_id,
		Direction: point_direction(PositionX, PositionY, TargetX, TargetY)
	};
	GrenadeObject.image_index = ID;

	if(IS_NET && instance_exists(oNetworkManager) && oNetworkManager.is_server){
		GrenadeObject.network_id = compute_grenade_network_id();
		GrenadeObject.network_owner_pid = 255;
		GrenadeObject.network_authority = true;
		GrenadeObject.network_visual_only = false;
		GrenadeObject.grenade_explosion_broadcasted = false;

		if(ObjectType.object_index == oPlayer){
			GrenadeObject.network_owner_pid = ObjectType.network_id;
		}

		ds_map_set(oNetworkManager.grenade_registry, GrenadeObject.network_id, GrenadeObject);
		server_grenade_spawn_broadcast(GrenadeObject);
	}

	return GrenadeObject;
}

function create_molotov_impact(PositionX, PositionY, Damage, ObjectType, ItemID, OwnerName = "Noone", OwnerID = -1, CanDamage = true){
	var impact = instance_create_layer(PositionX, PositionY, "ItemsO", oMolotovImpact);
	var object_index_value = -1;
	if(instance_exists(ObjectType)){
		object_index_value = ObjectType.object_index;
	}

	impact.can_damage = CanDamage;
	impact.stats = {
		Damage: Damage,
		Starting_x: PositionX,
		Starting_y: PositionY,
		Object: ObjectType,
		Item_id: ItemID,
		Penetration_damage: 0,
		Tracer_image: 4,
		Object_index: object_index_value,
		Owner_name: OwnerName,
		Owner_id: OwnerID
	};

	return impact;
}

function particle_create(Number, Friction, Angle, Sprite, Speed, AngleRandomness, Dir, ImageSpeed, CanStay, CanBounce, ImageIndex, xPosition, yPosition, Alpha = 1, FadeAwayTime = 1){
	if(global.DrawParticles == true){
		repeat(Number){
			Particle = instance_create_layer(xPosition, yPosition, "ItemsO", oParticle);
			with(Particle){
				sprite_index = Sprite;
				image_angle = Angle;
				fric = Friction;
				image_speed = ImageSpeed * global.time_step;
				Stay = CanStay;
				Bounce = CanBounce;
				image_index = ImageIndex;
				alpha = Alpha;
				FadeAwayTimer = FadeAwayTime * global.time_step;
				motion_add(Dir + AngleRandomness, Speed * global.time_step);
			}
		}
	}
}

function explosion_create(ShrapnelNumber, pos, ExplosionDamage, Destroy, ObjectType, Id, ShrapnelInaccuracy = 2, ExplosionDistance = max(power(ExplosionDamage / 10, 2), 256), Attribution = undefined, scale = 1){
	
	Explosion = instance_create_depth(pos[0], pos[1], -99, oExplosion);
	Explosion.ExplosionPower = min(ExplosionDamage / 10, 2);
	Explosion.image_xscale = scale;
	Explosion.image_yscale = scale;
	Explosion.Angle = random(360);	
	Explosion.ExplosionWidth = bbox_right - bbox_left;
	Explosion.ExplosionHeight = bbox_bottom - bbox_top;
	Explosion.LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, pos[0], pos[1]);
	Explosion.LightObject.blend = c_orange;
	Explosion.LightObject.xscale = ExplosionDamage/10;
	Explosion.LightObject.yscale = ExplosionDamage/10;

	play_sound(pos[0], pos[1], snd_Explosion, Explosion, 100, 2500, .75);
	var attribution_object_index = stats.Object_index;
	var attribution_owner_name = stats.Owner_name;
	var attribution_owner_id = variable_struct_exists(stats, "Owner_id") ? stats.Owner_id : -1;
	if (is_struct(Attribution)) {
		attribution_object_index = Attribution.object_index;
		attribution_owner_name = Attribution.owner_name;
		attribution_owner_id = Attribution.owner_id;
	}

	for(i=0;i<ShrapnelNumber;i++){
		var shrapnel = create_bullet_tracer(
			[random_range(pos[0] - Explosion.ExplosionWidth/2 * Explosion.ExplosionPower, pos[0] + Explosion.ExplosionWidth/2 * Explosion.ExplosionPower), 
			random_range(pos[1] - Explosion.ExplosionHeight/2 * Explosion.ExplosionPower, pos[1] + Explosion.ExplosionHeight/2 * Explosion.ExplosionPower)],
			[pos[0] + lengthdir_x(ExplosionDistance, i * (360/ShrapnelNumber)),
			pos[1] + lengthdir_y(ExplosionDistance, i * (360/ShrapnelNumber))],
			2,
			[
				Id,
				i * (360/ShrapnelNumber),
				BULLET_SPEED * global.time_step,
				ExplosionDistance,
			],
			ObjectType,
			ExplosionDamage,
			attribution_object_index,
			[attribution_owner_name, false],
			noone,
			[pos[0], pos[1]],
			false,
			[true, false],
			[-1, -1],
			true
		);
		if (instance_exists(shrapnel)) {
			shrapnel.stats.Owner_id = attribution_owner_id;
		}
	}
	create_fog(pos[0], pos[1], clamp(random_range(ExplosionDamage, 1.5*ExplosionDamage), 50, 75), random(360), 0.1, random_range(.1, .5), 
		clamp(round(ExplosionDamage/10), 5, 7.5), 
		clamp(ExplosionDamage/250, .5, .9), 
		clamp(ExplosionDamage/250, .1, .75), 2 * game_get_speed(gamespeed_fps)
	);
	
	
	
	if(Destroy == true){
		instance_destroy(id);
	}
}

function landmine_create(PositionX, PositionY, ItemID, ObjectType = id){
	LandMine = instance_create_layer(PositionX, PositionY, "ItemsO", oLandMine);
	LandMine.ImageIndex = global.ItemIndex[#ItemID, ItemStat.BulletCasingID];
	LandMine.image_index = LandMine.ImageIndex;
	LandMine.stats = {
		Owner_name: ObjectType.stats.Name,
		Object: ObjectType,
		Item_id: ItemID,
		Object_index: ObjectType.object_index
	};
}

























