/// @description Check other enemies
var enemy_count = instance_number(oEnemy);

for (var i = 0; i < enemy_count; i++) {
    var other_enemy = instance_find(oEnemy, i);

	if(instance_exists(other_enemy)){
	    if (other_enemy != id) {
	        var dist = point_distance(x, y, other_enemy.x, other_enemy.y);

	        if (dist <= 128 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) {
	            if (other_enemy.ChasingObjectSpotted == true) {
	                ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])));
	            }
	        }
	   }
	}
}
alarm[5] = check_other_enemies_time;




