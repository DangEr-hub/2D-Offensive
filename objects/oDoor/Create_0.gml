event_inherited();
image_speed = 0;
opened = false;
main_angle = image_angle;
network_ip = "";
alarm[0] = 5;
usrname = "";
passwd = "";

open_door = function(relative_object = noone, manual = false, state = false){
	var previous_angle = image_angle;
	var target_angle = main_angle;
	var target_opened = manual ? state : !opened;

	if(target_opened){
		var door_center_x = (bbox_left + bbox_right) * 0.5;
		var door_center_y = (bbox_top + bbox_bottom) * 0.5;

		if(instance_exists(relative_object)){
			var dx = relative_object.x - door_center_x;
			var dy = relative_object.y - door_center_y;
			if(main_angle == 0 || main_angle == 180){
				target_angle = dy < 0 ? 270 : 90;
			}else{
				target_angle = dx < 0 ? 0 : 180;
			}
		}else{
			if(main_angle == 0 || main_angle == 180){
				target_angle = choose(270, 90);
			}else{
				target_angle = choose(0, 180);
			}
		}
	}

	image_angle = target_angle;
	var blocked = place_meeting(x, y, oPlayer) || place_meeting(x, y, oBot) || place_meeting(x, y, oHostage);

	if(blocked){
		image_angle = previous_angle;
	}else{
		opened = target_opened;

		if(door_light != undefined){
			door_light.blend = opened ? c_lime : c_red;
		}
		if(opened){
			play_sound(x, y, snd_Beep);
		}
	}
}

door_light = undefined;
if(instance_exists(oLightRenderer)){
	var light_x = x + lengthdir_x(48 * image_xscale, image_angle);
	var light_y = y + lengthdir_y(48 * image_xscale, image_angle);
	door_light = new BulbLight(oLightRenderer.lighting, sLight128, 0, light_x, light_y);
	door_light.castShadows = false;
	door_light.xscale = 0.15;
	door_light.yscale = 0.15;
	door_light.alpha = 0.75;
	door_light.blend = c_red;
}

network_name = "";
