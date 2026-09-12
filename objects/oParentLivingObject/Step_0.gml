var hs_x = 73;
var hs_y = 33;

if (moving_state == STATES_PLAYER.prone_state) { 
	hs_x = 137;
	hs_y = 38;
}

var hs_pos = local_to_world(hs_x, hs_y, RotationAngle);
headshot_x = hs_pos[0];
headshot_y = hs_pos[1];

if(hit_timer > -1){
	hit_timer --;
}

if (stats.Health_points > 0
&& (is_undefined(FlashLight) || FlashLight == noone)
&& instance_exists(oLightRenderer)) {
	FlashLight = new BulbLight(oLightRenderer.lighting, sLightTorch, 0, x, y);
	FlashLight.alpha = FLASHLIGHT_ALPHA;
	FlashLight.penumbraSize = 30;
	FlashLight.xscale = 2;
	FlashLight.yscale = 2;
	FlashLight.blend = c_white;
}

if(col_timer > -1){ col_timer --; }
if(object_index == oBot && col_timer == -1){
	
	#region Wall collision
	col_timer = col_time;
	var tile = instance_place(x, y, oParentTile);

	if (tile != noone) {
		var dir = MoveDirection + 180;
		if(instance_exists(ChasingObject)){
			dir = point_direction(x, y, ChasingObject.x, ChasingObject.y);
		}
		
	    var pushSpeed = 5;
    
	    var escapeSpeed = pushSpeed - 2; // Just under the pushSpeed to check for being more than 1 pixel in
	    var escapeX = x - lengthdir_x(escapeSpeed, dir);
	    var escapeY = y - lengthdir_y(escapeSpeed, dir);
    
	    if (instance_place(escapeX, escapeY, oParentTile) != noone) {
	        x += lengthdir_x(pushSpeed, dir);
	        y += lengthdir_y(pushSpeed, dir);
	    }
	}
	#endregion

}

#region Visibility

if (VisibilityTimer > -1) VisibilityTimer--;
if (VisibilityTimer == 0) Visible = false;
if(check_vis_timer > -1){ check_vis_timer --; }

if(check_vis_timer == -1){
	check_vis_timer = check_vis_time;
	var observer = global.local_player;
	var is_target = (object_index == oBot) || (object_index == oPlayer && is_remote);

	// lokální hráč je vždy viditelný
	if (id == observer || stats.Team == observer.stats.Team) {
	    Visible = true;
		VisibilityTimer = -1;
	}else if (is_target) {

	    if (!global.enemy_visibility) {

			var in_fov =
		        point_in_triangle(bbox_left,  bbox_top,    observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy) ||
		        point_in_triangle(bbox_right, bbox_top,    observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy) ||
		        point_in_triangle(bbox_left,  bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy) ||
		        point_in_triangle(bbox_right, bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy);

	        var force_visible = stats.Health_points <= 0 || (object_index == oBot && (State == STATES.ThrowGrenade || State == STATES.LayDownLandMine || HPTimer != -1));
	        if (in_fov || force_visible) {
				var ignore_machine_gun_floor = observer.moving_state == STATES_PLAYER.machine_gun_state;
				var tile_blocks_view = tile_blocks_target_view(
					observer.x, observer.y,
					x, y,
					id,
					ignore_machine_gun_floor,
					observer
				);
				var col_smoke = collision_line(x, y, observer.x, observer.y, oSmokeTile,  true, false);

	            if (tile_blocks_view || col_smoke != noone) {
					if (Visible && VisibilityTimer == -1)
						VisibilityTimer = VisibilityTime;
				}else{
					Visible = true;
					VisibilityTimer = -1;
				}
	        } else {
	            if (Visible && VisibilityTimer == -1)
	                VisibilityTimer = VisibilityTime;
	        }

	    } else {
	        Visible = true;
			VisibilityTimer = -1;
	    }
	}


	if(FlashLight != undefined && FlashLight.visible != Visible){
		FlashLight.visible = Visible;
	}
	HeadHB.Visible  = Visible;
	BodyHB.Visible  = Visible;
	ArmHB.Visible   = Visible;
	Weapon.Visible      = Visible;
	Legs.Visible        = Visible && stats.Health_points > 0;

}

#endregion


if(stats.Health_points <= 0){
	event_user(0);	
}

#region Muzzle flash light
if(flash_effect_timer > -1){
	flash_effect_timer --;	
}

if(MuzzleFlashLight != undefined){
	MuzzleFlashLight.alpha -= ALPHA_SPEED*5;
	MuzzleFlashLight.x = FlashLightX;
	MuzzleFlashLight.y = FlashLightY;
	if(flash_effect_timer <= -1){
		MuzzleFlashLight.Destroy();
		MuzzleFlashLight = undefined;
	}
}
#endregion

#region Infra vision
if(global.local_player.stats.Health_points > 0){
	if(global.local_player.ToggleInfraVision == true || global.local_player.ToggleNightVision == true){
		if(infra_vision_light == undefined){
			infra_vision_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
			infra_vision_light.alpha = 1;
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

	if(infra_vision_light != undefined){
		infra_vision_light.x = x;
		infra_vision_light.y = y;
		if(Visible == false){
			infra_vision_light.alpha = 0;
		}else{
			infra_vision_light.alpha = 1;
		}
	}
}
	
#endregion

#region Aimpunch
if(AimPunchTimer > -1){
	AimPunchTimer --;
}

if(AimPunchTimer == 0){
	AimPunchMultiplier = 1;	
}
#endregion
