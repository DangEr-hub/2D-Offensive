if(stats.update_haze_pos == true){
	if(instance_exists(stats.follow_object)){
		x = stats.follow_object.x;
		y = stats.follow_object.y;		
	}else{
		if(alarm[0] == -1){
			alarm[0] = stats.timer;	
		}
	}
	if(stats.haze_object != -1){
		if(stats.haze_type == "Circle"){
			haze_circle_pos(stats.haze_object, x, y);
		}else{
			haze_rect_pos(stats.haze_object, x, y);
		}
	}
}










