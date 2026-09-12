function lottery_pick_weapon(pool){
    var total_weight = 0;

    for(var i = 0; i < array_length(pool); i++){
        var weapon = pool[i];
        var rarity = global.ItemIndex[# weapon, ItemStat.Rarity];
        total_weight += lottery_rarity_weight(rarity);
    }

    var roll = random(total_weight);

    for(var i = 0; i < array_length(pool); i++){
        var weapon = pool[i];
        var rarity = global.ItemIndex[# weapon, ItemStat.Rarity];

        roll -= lottery_rarity_weight(rarity);

        if(roll <= 0){return weapon;}
    }

    return pool[array_length(pool) - 1];
}

function lottery_rarity_color(rarity){
    switch(rarity){
        case RARITY.COMMON: return make_color_rgb(130, 130, 130);
        case RARITY.UNCOMMON: return make_color_rgb(70, 120, 255);
        case RARITY.RARE: return make_color_rgb(150, 70, 255);
        case RARITY.LEGENDARY: return make_color_rgb(255, 170, 40);
    }

    return c_gray;
}

function lottery_rarity_weight(rarity){
    switch(rarity){
        case RARITY.COMMON: return 100;
        case RARITY.UNCOMMON: return 35;
        case RARITY.RARE: return 25;
        case RARITY.LEGENDARY: return 10;
    }

    return 1;
}

function lottery_start(){
	if(lottery_active == false){
		lottery_last_center_index = -1;
	    lottery_items = [];

	    var item_count = 50;

	    for(var i = 0; i < item_count; i++){
	        array_push(lottery_items, lottery_pick_weapon(lottery_weapon_pool));
	    }

	    lottery_winner_index = item_count - irandom_range(5, 8);

	    lottery_scroll_start = 0;
	    lottery_scroll_target = lottery_winner_index;
	    lottery_scroll = lottery_scroll_start;

	    lottery_timer = 0;
	    lottery_duration = irandom_range(240, 360);
	    lottery_result = -1;
	    lottery_active = true;
	}
}

function draw_lottery(pos_x, pos_y, w, h){
    draw_set_alpha(global.GUIHUDAlpha);
    draw_set_color(MENU_COLOR);
    draw_rectangle(pos_x, pos_y, pos_x + w, pos_y + h, false);
		
	draw_set_alpha(1);
	draw_set_color(c_white);
    var center_x = pos_x + w * 0.5;
    var center_y = pos_y + h * 0.5;

    var slot_width = 64 * global.gui_scale;
    var slot_height = h - 8 * global.gui_scale;
    var item_count = array_length(lottery_items);

    for(var i = 0; i < item_count; i++){
        var slot_x = center_x + (i - lottery_scroll) * slot_width;
        var distance_from_center = abs(slot_x - center_x);

        if(slot_x + slot_width * 0.5 < pos_x){continue;}
        if(slot_x - slot_width * 0.5 > pos_x + w){continue;}

        var proximity = 1 - clamp(distance_from_center / (w * 0.5), 0, 1);
        var scale = lerp(0.7, 1.15, proximity);

        var weapon = lottery_items[i];
        var rarity = global.ItemIndex[# weapon, ItemStat.Rarity];
        var rarity_color = lottery_rarity_color(rarity);

        var current_slot_width = slot_width * 0.9 * scale;
        var current_slot_height = slot_height * scale;
		
	    draw_set_color(MAIN_COLOR);
	    draw_rectangle(pos_x, pos_y, pos_x + w, pos_y + h, true);
		draw_set_alpha(1);
        draw_set_color(rarity_color);
        draw_rectangle(
            slot_x - current_slot_width * 0.5 - 5,
            center_y - current_slot_height * 0.5 - 5,
            slot_x + current_slot_width * 0.5 + 5,
            center_y + current_slot_height * 0.5 + 5,
            false
        );

		// Draw item card border
        draw_set_color(c_black);
        draw_set_alpha(global.GUIHUDAlpha * 0.5);
        draw_rectangle(
            slot_x - current_slot_width * 0.5 + 3,
            center_y - current_slot_height * 0.5 + 3,
            slot_x + current_slot_width * 0.5 - 3,
            center_y + current_slot_height * 0.5 - 3,
            false
        );

        draw_set_alpha(global.GUIHUDAlpha);

		// Draw item
        draw_sprite_ext(
            spr_Items,
            weapon,
            slot_x,
            center_y,
            scale,
            scale,
            0,
            c_white,
            global.GUIHUDAlpha
        );

		/// Draw vertical line
	    draw_set_color(c_red);
	    draw_line_width(
	        center_x,
	        pos_y,
	        center_x,
	        pos_y + h,
	        4 * global.gui_scale
	    );
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		


    }

}