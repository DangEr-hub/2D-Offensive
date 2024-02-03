/// @description Insert description here
// You can write your code in this editor
//event_inherited();
headshot_x = x - 20;
headshot_y = y - 18;

if(stats.Health_points <= 0){
	event_user(0);	
}

#region Muzzle flash light
if(DestroyTimer > -1){
	DestroyTimer --;	
}

if(MuzzleFlashLight != undefined){
	MuzzleFlashLight.x = FlashLightX;
	MuzzleFlashLight.y = FlashLightY;
	if(DestroyTimer <= -1){
		MuzzleFlashLight.Destroy();
		MuzzleFlashLight = undefined;
	}
}
#endregion

#region Infra vision
if(oPlayer.stats.Health_points > 0){
	if(oPlayer.ToggleInfraVision == true || oPlayer.ToggleNightVision == true){
		if(infra_vision_light == undefined){
			infra_vision_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
			infra_vision_light.alpha = 1;
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