
if(transparent == true){
	target_alpha = (global.local_player.current_building_id == building_id) ? 0 : 1;
}

image_alpha = lerp(image_alpha, target_alpha, fade_speed);

if(image_alpha < 0.1) image_alpha = 0;
if(image_alpha > 0.9) image_alpha = 1;