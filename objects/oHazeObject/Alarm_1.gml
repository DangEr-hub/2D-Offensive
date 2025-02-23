/// @description Post-create event
if(stats.haze_type == "Circle"){
	stats.haze_object = haze_circle_add(stats.haze_x, stats.haze_y, stats.haze_width);
}else{
	stats.haze_object = haze_rect_add(stats.haze_x, stats.haze_y, stats.haze_width, stats.haze_height);
}










