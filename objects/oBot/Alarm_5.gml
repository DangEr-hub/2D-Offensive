/// @description Check other enemies
var share_range = 256 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
var bot_count = instance_number(oBot);

for (var i = 0; i < bot_count; i++){
    var other_bot = instance_find(oBot, i);
    if (!instance_exists(other_bot)){ continue };

    // neřeš sám sebe
    if (other_bot == id){ continue };

    // jen stejný team
    if (other_bot.team != team){ continue };

    // vzdálenost
    var dist = point_distance(x, y, other_bot.x, other_bot.y);
    if (dist > share_range){ continue };

    // bot v okolí má cíl, já ne
    if (instance_exists(other_bot.ChasingObject) && !instance_exists(ChasingObject)){
        ChasingObject = other_bot.ChasingObject;
        ChasingObjectSpot(
            ceil(
                5 * game_get_speed(gamespeed_fps)
                * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])
            )
        );

        break; // stačí jeden bot z okolí
    }
}

alarm[5] = check_other_enemies_time;





