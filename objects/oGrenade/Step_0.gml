/// @description Insert description here
// You can write your code in this editor
if(stuck == false){
	x += lengthdir_x(Speed, Direction);
	y += lengthdir_y(Speed, Direction);
	Speed *= .95;
	
	if!(place_meeting(x, y, oParentTile) && place_meeting(x, y, oEnemy)){
		image_angle += Speed*2;
	}

}

if(Id == Item.StickyGrenade){
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
		if(instance_exists(oEnemy)){
		    var collision_instance = instance_place(x, y, oEnemy);
		    if (collision_instance != noone) {
		        stuck = true;
		        stuck_to = collision_instance;
		        stuck_offset_x = x - stuck_to.x;
		        stuck_offset_y = y - stuck_to.y;
		    }
		}
	} else {
		if(instance_exists(stuck_to)){
			if(stuck_to.object_index = oEnemy){
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

if(ExplodeTimer > -1){
	ExplodeTimer --;
}

#region Explode
if(Speed < .1 && Speed > .0001){
	if(ExplosionTimer == -1){
		ExplosionTimer = ExplosionTime;
	}
}

if(ExplosionTimer > -1){
	ExplosionTimer --;
}

if(ExplosionTimer == -1){
	if(Speed < .1){
		if(Id == Item.HEGrenade){
			
			#region Create explosion effect
			ExplosionCreate(30, x, y, global.ItemIndex[#Id, ItemStat.Damage], true, Object, global.ItemIndex[#Id, ItemStat.PenetrationPower], global.ItemIndex[#Id, ItemStat.DamageDrop]);
			#endregion
			
		}else if(Id == Item.FlashBangGrenade){
			ExplosionCreate(5, x, y, global.ItemIndex[#Id, ItemStat.Damage], true, Object, global.ItemIndex[#Id, ItemStat.PenetrationPower], global.ItemIndex[#Id, ItemStat.DamageDrop]);
			if!(collision_line(x, y, oPlayer.x, oPlayer.y, oParentTile, true, false)){
				if (point_distance(x, y, oPlayer.x, oPlayer.y) < global.FlashBangMaxDistance) {
					
					#region Flash player
					if(global.GodMode == false){
						var angular_diff = abs(point_direction(oPlayer.x, oPlayer.y, x, y) - oPlayer.RotationAngle);
						if (angular_diff > 180){
							angular_diff = 360 - angular_diff;
						}
						oPlayer.FlashedBackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
						oPlayer.Flashed = true;
						oPlayer.FlashedAlpha = (1 - (angular_diff / 180)) * (1 - (point_distance(x, y, oPlayer.x, oPlayer.y) / global.FlashBangMaxDistance)*.1);
						oPlayer.FlashedAlpha = clamp(oPlayer.FlashedAlpha, 0, 1);
					}
					#endregion
					
					#region Flash enemy
					if(instance_exists(oEnemy)){
						var angular_diff = abs(point_direction(oEnemy.x, oEnemy.y, x, y) - oEnemy.RotationAngle);
						if (angular_diff > 180){
							angular_diff = 360 - angular_diff;
						}
						oEnemy.Flashed = true;
						oEnemy.FlashedTimer = ceil(oEnemy.FlashedTime * (1 - (angular_diff / 180)) * (1 - (point_distance(x, y, oEnemy.x, oEnemy.y) / global.FlashBangMaxDistance)*.1));
					}
					#endregion
					
				}
			}			
		}else if(Id == Item.SmokeGrenade){
				
			#region Create smoke effect
				instance_create_layer(x, y, "OtherO", oFog);
				instance_destroy(self);
				#endregion
				
		}else if(Id == Item.StickyGrenade){
			
			#region Create explosion effect
			ExplosionCreate(10, x, y, global.ItemIndex[#Id, ItemStat.Damage], true, Object, global.ItemIndex[#Id, ItemStat.PenetrationPower], global.ItemIndex[#Id, ItemStat.DamageDrop]);
			#endregion
		}
	}
}

if(ExplodeTimer == -1){
	if(Id == Item.HEGrenade){
		ExplosionCreate(30, x, y, global.ItemIndex[#Id, ItemStat.Damage], true, Object, global.ItemIndex[#Id, ItemStat.PenetrationPower], global.ItemIndex[#Id, ItemStat.DamageDrop]);	
	}else if(Id == Item.FlashBangGrenade){
		ExplosionCreate(5, x, y, global.ItemIndex[#Id, ItemStat.Damage], true, Object, global.ItemIndex[#Id, ItemStat.PenetrationPower], global.ItemIndex[#Id, ItemStat.DamageDrop]);
		if!(collision_line(x, y, oPlayer.x, oPlayer.y, oParentTile, true, false)){
			if (point_distance(x, y, oPlayer.x, oPlayer.y) < global.FlashBangMaxDistance) {
				
				#region Flash player
				if(global.GodMode == false){
					var angular_diff = abs(point_direction(oPlayer.x, oPlayer.y, x, y) - oPlayer.RotationAngle);
					if (angular_diff > 180){
						angular_diff = 360 - angular_diff;
					}
					oPlayer.FlashedBackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
					oPlayer.Flashed = true;
					oPlayer.FlashedAlpha = (1 - (angular_diff / 180)) * (1 - (point_distance(x, y, oPlayer.x, oPlayer.y) / global.FlashBangMaxDistance)*.1);
					oPlayer.FlashedAlpha = clamp(oPlayer.FlashedAlpha, 0, 1);
				}
				#endregion
				
				#region Flash enemy
				if(instance_exists(oEnemy)){
					var angular_diff = abs(point_direction(oEnemy.x, oEnemy.y, x, y) - oEnemy.RotationAngle);
					if (angular_diff > 180){
						angular_diff = 360 - angular_diff;
					}
					oEnemy.Flashed = true;
					oEnemy.FlashedTimer = ceil(oEnemy.FlashedTime * (1 - (angular_diff / 180)*.1) * (1 - (point_distance(x, y, oEnemy.x, oEnemy.y) / global.FlashBangMaxDistance)*.1));
				}
				#endregion
			}
		}			
	}else if(Id == Item.SmokeGrenade){
				
		#region Create smoke effect
			instance_create_layer(x, y, "OtherO", oFog);
			instance_destroy(self);
			#endregion
			
	}else if(Id == Item.StickyGrenade){
			
		#region Create explosion effect
		ExplosionCreate(10, x, y, global.ItemIndex[#Id, ItemStat.Damage], true, Object, global.ItemIndex[#Id, ItemStat.PenetrationPower], global.ItemIndex[#Id, ItemStat.DamageDrop]);
		#endregion
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


scale = 1 + (z/100);

image_xscale = scale;
image_yscale = scale;
#endregion

if(stuck == false){
	
	#region Collision with wall
	x += lengthdir_x(Speed, Direction);
	if (place_meeting(x, y, oParentTile)) {
		// Reflect off wall
		Speed *= .75;
		Direction = -Direction * random_range(.9, 1);
		x -= lengthdir_x(Speed, Direction);  // Move out of collision
	}

	y += lengthdir_y(Speed, Direction);
	if (place_meeting(x, y, oParentTile)) {
		Speed *= .75;
		Direction = (180 - Direction) * random_range(.9, 1);
		y -= lengthdir_y(Speed, Direction);  // Move out of collision
	}
	#endregion

	#region Collision with enemy

	x += lengthdir_x(Speed, Direction);
	if (place_meeting(x, y, oEnemy)) {
		EnemyNearest = instance_nearest(x, y, oEnemy);
		if (place_meeting(x, y, EnemyNearest) && EnemyNearest.State != States.Death && Object != EnemyNearest) {
			Speed *= .75;
		    Direction = -Direction * random_range(.75, 1);
		    x -= lengthdir_x(Speed, Direction);  // Move out of collision
		}
	}

	y += lengthdir_y(Speed, Direction);
	if(instance_exists(oEnemy)){
		EnemyNearest = instance_nearest(x, y, oEnemy);
		if (place_meeting(x, y, EnemyNearest) && EnemyNearest.State != States.Death && Object != EnemyNearest) {
			Speed *= .75;
		    Direction = (180 - Direction) * random_range(.75, 1);
		    y -= lengthdir_y(Speed, Direction);  // Move out of collision
		}
	}

	#endregion

}


