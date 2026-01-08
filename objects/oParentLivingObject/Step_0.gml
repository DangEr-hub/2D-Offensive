var hs_x = 73;
var hs_y = 33;

if (moving_state == states_player.prone_state) { 
	hs_x = 137;
	hs_y = 38;
}

var hs_pos = local_to_world(hs_x, hs_y, RotationAngle);
headshot_x = hs_pos[0];
headshot_y = hs_pos[1];

if(hit_timer > -1){
	hit_timer --;
}

if(object_index == oBot){
	
	#region Wall collision
	var tile = instance_place(x, y, oParentTile);

	if (tile != noone) {
	    var player = instance_nearest(x, y, oPlayer);
	    var dir = point_direction(x, y, player.x, player.y);
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

// kdo je pozorovatel
var observer = global.local_player;

// jestli tenhle objekt má být skrýván
var is_target = (object_index == oBot) || (object_index == oPlayer && is_remote);

// lokální hráč je vždy viditelný
if (id == observer || team == TEAM.FRIENDLY) {
    Visible = true;
}else if (is_target) {

    if (!global.enemy_visibility) {

		var in_fov =
	        point_in_triangle(bbox_left,  bbox_top,    observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy) ||
	        point_in_triangle(bbox_right, bbox_top,    observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy) ||
	        point_in_triangle(bbox_left,  bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy) ||
	        point_in_triangle(bbox_right, bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy);

        var force_visible = stats.Health_points <= 0 || (object_index == oBot && (State == States.ThrowGrenade || State == States.LayDownLandMine || HPTimer != -1));

        if (in_fov || force_visible) {

            var col = collision_line(x, y, observer.x, observer.y, oParentTile, true, false)
                   || collision_line(x, y, observer.x, observer.y, oSmokeTile,  true, false);

            if (col) {
               if (instance_exists(col) && observer.moving_state == states_player.machine_gun_state && col.object_index == oMachineGunFloor){
					Visible = true;   
			   }else{
	                if (Visible && VisibilityTimer == -1)
	                    VisibilityTimer = VisibilityTime;
			   }

            } else {
                Visible = true;
            }

        } else {
            if (Visible && VisibilityTimer == -1)
                VisibilityTimer = VisibilityTime;
        }

    } else {
        Visible = true;
    }
}


if(FlashLight != undefined){
	FlashLight.visible = Visible;
}
HeadHitBox.Visible  = Visible;
BodyHitBox.Visible  = Visible;
ArmHitBox.Visible   = Visible;
Weapon.Visible      = Visible;
Legs.Visible        = Visible;

#endregion


if(stats.Health_points <= 0){
	event_user(0);	
}

#region Muzzle flash light
if(flash_effect_timer > -1){
	flash_effect_timer --;	
}

if(MuzzleFlashLight != undefined){
	MuzzleFlashLight.alpha -= ALPHA_SPEED;
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