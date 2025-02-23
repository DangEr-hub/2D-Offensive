if(stats.haze_type == "Circle"){
	haze_circle_delete(stats.haze_object);
}else{
	haze_rect_delete(stats.haze_object);
}
instance_destroy();