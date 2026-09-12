/// @description Check other enemies
if(stats.Health_points <= 0){
	exit;
}
alarm[5] = check_other_enemies_time;
var share_range = 256 * rank_boost;
var bot_count = instance_number(oBot);

for (var i = 0; i < bot_count; i++){
    var other_bot = instance_find(oBot, i);
    if (!instance_exists(other_bot)){ continue };

    // neřeš sám sebe
    if (other_bot == id){ continue };

    // jen stejný stats.Team
    if (other_bot.stats.Team != stats.Team){ continue };

    // vzdálenost
    var dist = point_distance(x, y, other_bot.x, other_bot.y);
    if (dist > share_range){ continue };

    // Bot v okolí sdílí pouze cíl, o kterém skutečně ví.
    if (other_bot.ChasingObjectSpotted
	&& bot_target_is_enemy(other_bot.ChasingObject)
	&& !ChasingObjectSpotted
	&& percent_chance(clamp(40 * rank_boost, 10, 90))){
		ChasingObject = other_bot.ChasingObject;
		ChasingObjectSpot(chasing_time);
		break; // stačí jeden bot z okolí
	}
}





