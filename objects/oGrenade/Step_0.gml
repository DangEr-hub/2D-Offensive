/// @description Insert description here
// You can write your code in this editor
if(stuck == false){
	x += lengthdir_x(stats.Speed, stats.Direction);
	y += lengthdir_y(stats.Speed, stats.Direction);
	stats.Speed *= .95;
	
	if!(place_meeting(x, y, oParentTile) && place_meeting(x, y, oEnemy)){
		image_angle += stats.Speed*2;
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
if(stats.Speed < .1 && stats.Speed > .0001){
	if(ExplosionTimer == -1){
		ExplosionTimer = ExplosionTime;
	}
}

if(ExplosionTimer > -1){
	ExplosionTimer --;
}

if(ExplosionTimer == -1){
	if(stats.Speed < .1){
		if(stats.Item_id == Item.HEGrenade){
			
			#region Create explosion effect
			ExplosionCreate(
				30, 
				x, 
				y, 
				global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
			#endregion
			
		}else if(stats.Item_id == Item.FlashBangGrenade){
			ExplosionCreate(
				5, 
				x, 
				y, 
				global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
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
		}else if(stats.Item_id == Item.SmokeGrenade){
				
			#region Create smoke effect
				instance_destroy(id);
				var Fog = instance_create_layer(x, y, "OtherO", oFog);
				with(Fog){
					smoke_effect_create(
						random_range(100, 150),
						random(360),
						0.1,
						random_range(.1, .5),
						11,
						.9,
						.75,
						5 * game_get_speed(gamespeed_fps)
					);
				}
			#endregion
				
		}else if(stats.Item_id == Item.StickyGrenade){
			
			#region Create explosion effect
			ExplosionCreate(
				30,
				x, 
				y, 
				global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
				true, 
				stats.Object, 
				stats.Item_id
			);
			#endregion
		}
	}
}

if(ExplodeTimer == -1){
	if(stats.Item_id == Item.HEGrenade){
		ExplosionCreate(
			30, 
			x, 
			y, 
			global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
			true, 
			stats.Object, 
			stats.Item_id
		);
	}else if(stats.Item_id == Item.FlashBangGrenade){
		ExplosionCreate(
			5, 
			x, 
			y, 
			global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
			true, 
			stats.Object, 
			stats.Item_id
		);
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
	}else if(stats.Item_id == Item.SmokeGrenade){
				
		#region Create smoke effect
			instance_destroy(id);
			var Fog = instance_create_layer(x, y, "OtherO", oFog);
			with(Fog){
				smoke_effect_create(
					random_range(100, 150),
					random(360),
					0.1,
					random_range(.1, .5),
					11,
					.9,
					.75,
					5 * game_get_speed(gamespeed_fps)
				);
			}
		#endregion
			
	}else if(stats.Item_id == Item.StickyGrenade){
			
		#region Create explosion effect
		ExplosionCreate(
			30,
			x, 
			y, 
			global.ItemIndex[#stats.Item_id, ItemStat.Damage], 
			true, 
			stats.Object, 
			stats.Item_id
		);
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
	x += lengthdir_x(stats.Speed, stats.Direction);
	if (place_meeting(x, y, oParentTile)) {
		// Reflect off wall
		stats.Speed *= .75;
		stats.Direction = -stats.Direction * random_range(.9, 1);
		x -= lengthdir_x(stats.Speed, stats.Direction);  // Move out of collision
	}

	y += lengthdir_y(stats.Speed, stats.Direction);
	if (place_meeting(x, y, oParentTile)) {
		stats.Speed *= .75;
		stats.Direction = (180 - stats.Direction) * random_range(.9, 1);
		y -= lengthdir_y(stats.Speed, stats.Direction);  // Move out of collision
	}
	#endregion

	#region Collision with enemy

	x += lengthdir_x(stats.Speed, stats.Direction);
	if (place_meeting(x, y, oEnemy)) {
		var EnemyNearest = instance_nearest(x, y, oEnemy);
		if (place_meeting(x, y, EnemyNearest) && stats.Object != EnemyNearest) {
			stats.Speed *= .75;
		    stats.Direction = -stats.Direction * random_range(.75, 1);
		    x -= lengthdir_x(stats.Speed, stats.Direction);  // Move out of collision
		}
	}

	y += lengthdir_y(stats.Speed, stats.Direction);
	if(instance_exists(oEnemy)){
		var EnemyNearest = instance_nearest(x, y, oEnemy);
		if (place_meeting(x, y, EnemyNearest) && stats.Object != EnemyNearest) {
			stats.Speed *= .75;
		    stats.Direction = (180 - stats.Direction) * random_range(.75, 1);
		    y -= lengthdir_y(stats.Speed, stats.Direction);  // Move out of collision
		}
	}

	#endregion

}


