/// @description Check if ChasingObject is still available
alarm[6] = check_chasing_timer;
chasing_available = check_if_available(ChasingObject);
if(!chasing_available && ChasingObjectSpotted){
	FacingX = last_seen_x + random_range(-64, 64) * rank_less;
	FacingY = last_seen_y + random_range(-64, 64) * rank_less;
}














