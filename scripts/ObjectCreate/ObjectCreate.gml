// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GrenadeCreate(PositionX, PositionY, ID, GrenadeSpeed, TargetX, TargetY, ItemID, ObjectType = id){
	GrenadeObject = instance_create_depth(PositionX, PositionY, depth + 1, oGrenade);	
	GrenadeObject.Object = ObjectType;
	GrenadeObject.Id = ItemID;
	GrenadeObject.image_index = ID;
	GrenadeObject.Direction = point_direction(PositionX, PositionY, TargetX, TargetY);				
	ObjectSpeed = sqrt(power(XSpeed, 2) + power(YSpeed, 2));
	MoveDirX = dcos(MoveDirection) * ObjectSpeed;
	MoveDirY = -dsin(MoveDirection) * ObjectSpeed;
	GrenadeDirX = dcos(GrenadeObject.Direction) * GrenadeSpeed;
	GrenadeDirY = -dsin(GrenadeObject.Direction) * GrenadeSpeed;
	DotProduct = dot_product(MoveDirX, MoveDirY, GrenadeDirX, GrenadeDirY);			
	GrenadeObject.Speed = max(GrenadeSpeed + (DotProduct * 0.1), 1);
}

function ParticleCreate(Number, Friction, Angle, Sprite, Speed, AngleRandomness, Dir, ImageSpeed, CanStay, CanBounce, ImageIndex, xPosition, yPosition, Alpha = 1, FadeAwayTime = 1){
	if(global.DrawParticles == true){
		repeat(Number){
			Particle = instance_create_layer(xPosition, yPosition, "ItemsO", oParticle);
			with(Particle){
				sprite_index = Sprite;
				image_angle = Angle;
				fric = Friction;
				image_speed = ImageSpeed;
				Stay = CanStay;
				Bounce = CanBounce;
				image_index = ImageIndex;
				image_alpha = Alpha;
				FadeAwayTimer = FadeAwayTime;
				motion_add(Dir + AngleRandomness, Speed);
			}
		}
	}
}

function ExplosionCreate(ShrapnelNumber, PositionX, PositionY, ExplosionDamage, Destroy, ObjectType, ObjectPenetrationPower, ObjectDamageDrop, Id = Item.None, ExplosionDistance = max(power(ExplosionDamage / 10, 2), 256)){
	randomize();
	Explosion = instance_create_depth(PositionX, PositionY, -99, oExplosion);
	Explosion.ExplosionPower = min(ExplosionDamage / 10, 2);
	Explosion.Angle = random(360);	
	Explosion.ExplosionWidth = bbox_right - bbox_left;
	Explosion.ExplosionHeight = bbox_bottom - bbox_top;
	Explosion.LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, PositionX, PositionY);
	Explosion.LightObject.xscale = ExplosionDamage/10;
	Explosion.LightObject.yscale = ExplosionDamage/10;
	if!(audio_is_playing(snd_Explosion)){
		play_sound(PositionX, PositionY, snd_Explosion, 100, 2500, .75, Explosion);
	}
	for(i=0;i<ShrapnelNumber;i++){
		Shrapnel = instance_create_depth(
			random_range(PositionX - Explosion.ExplosionWidth/2 * Explosion.ExplosionPower, PositionX + Explosion.ExplosionWidth/2 * Explosion.ExplosionPower),
			random_range(PositionY - Explosion.ExplosionHeight/2 * Explosion.ExplosionPower, PositionY + Explosion.ExplosionHeight/2 * Explosion.ExplosionPower),
			depth,
			oShrapnel
		);	
		Shrapnel.Id = Id;
		Shrapnel.direction = i * (360/ShrapnelNumber);
		Shrapnel.image_angle = Shrapnel.direction;
		Shrapnel.speed = global.BulletSpeed * .75;
		Shrapnel.Distance = ExplosionDistance;
		Shrapnel.Object = ObjectType;
		Shrapnel.DamageDrop = ObjectDamageDrop;
		Shrapnel.Damage = ExplosionDamage;
		Shrapnel.PenetrationPower = ObjectPenetrationPower;
	}
	
	Fog = instance_create_layer(x, y, "OtherO", oFog);
	with(Fog){
		smoke_effect_create(
			clamp(random_range(ExplosionDamage, 1.5*ExplosionDamage), 50, 75),
			random(360),
			0.1,
			random_range(.1, .5),
			clamp(ceil(ExplosionDamage/10), 5, 7.5),
			clamp(ExplosionDamage/250, .5, .9),
			clamp(ExplosionDamage/250, .1, .75),
			2 * game_get_speed(gamespeed_fps)
		);	
	}
	
	
	
	if(Destroy == true){
		instance_destroy(id);
	}
}

function LandMineCreate(PositionX, PositionY, ItemID, ObjectType = id){
	LandMine = instance_create_depth(PositionX, PositionY, ObjectType.depth + 1, oLandMine);
	LandMine.Id = ItemID;
	LandMine.ImageIndex = global.ItemIndex[#LandMine.Id, ItemStat.BulletCasingID];
	LandMine.Object = ObjectType;
	LandMine.image_index = LandMine.ImageIndex;
}

























