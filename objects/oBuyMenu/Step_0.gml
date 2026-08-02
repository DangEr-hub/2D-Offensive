event_inherited();

with(buy_time_cap){
	caption = "Buy time remaining: " + string(ceil(oDraw.buy_time / 60)) + " s";
}
if(oDraw.buy_time <= 0){
	global.local_player.player_can_move = true;
	global.local_player.player_can_shoot = true;
	zui_destroy();
}