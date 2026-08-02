if(lottery_active){
    lottery_timer++;

    var progress = clamp(lottery_timer / lottery_duration, 0, 1);
    var eased_progress = 1 - power(1 - progress, 4);

    lottery_scroll = lerp(lottery_scroll_start, lottery_scroll_target, eased_progress);

    if(progress >= 1){
        lottery_scroll = lottery_scroll_target;

        var nearest_index = round(lottery_scroll);
        nearest_index = clamp(nearest_index, 0, array_length(lottery_items) - 1);

        lottery_result = lottery_items[nearest_index];
        lottery_active = false;
    }
}