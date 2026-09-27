
if(active == false && active_timer == -1){
	active_timer = CAM_ACTIVE_TIME;
}

if(active_timer > 0){
	active_timer --;
}



if(!active || alarm_triggered) exit;
if(IS_NET && (!instance_exists(oNetworkManager) || !oNetworkManager.is_server)) exit;
if(alarm[0] >= 0) exit;

scan_timer--;
if(scan_timer > 0) exit;
scan_timer = 5;

var watched_team = instance_exists(global.local_player)
	? global.local_player.stats.Team
	: global.player_stats.Player_team;
var triangle_left = min(x, lx1, lx2);
var triangle_right = max(x, lx1, lx2);
var triangle_top = min(y, ly1, ly2);
var triangle_bottom = max(y, ly1, ly2);
var detected = false;

for(var player_index = 0; player_index < instance_number(oPlayer); player_index++){
	var player = instance_find(oPlayer, player_index);
	if(player.stats.Team != watched_team || player.stats.Health_points <= 0) continue;
	if(player.x < triangle_left || player.x > triangle_right || player.y < triangle_top || player.y > triangle_bottom) continue;

	if(collision_triangle(x, y, lx1, ly1, lx2, ly2, player) != noone){
		detected = true;
		break;
	}
}

if(!detected){
	for(var bot_index = 0; bot_index < instance_number(oBot); bot_index++){
		var bot = instance_find(oBot, bot_index);
		if(bot.stats.Team != watched_team || bot.stats.Health_points <= 0) continue;
		if(bot.x < triangle_left || bot.x > triangle_right || bot.y < triangle_top || bot.y > triangle_bottom) continue;

		if(collision_triangle(x, y, lx1, ly1, lx2, ly2, bot) != noone){
			detected = true;
			break;
		}
	}
}

if(detected){
	alarm_triggered = true;
	if(spawn_n < max_spawn){
		alarm[2] = 20 * game_get_speed(gamespeed_fps);
	}
	alarm[1] = 1 * game_get_speed(gamespeed_fps);
}









