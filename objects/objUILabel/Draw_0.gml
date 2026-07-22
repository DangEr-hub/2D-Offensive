
draw_set_alpha(alpha * alpha_value);
draw_set_font(font);

if(drawable == true){
	if(description = ""){
		draw_text_outlined(0, 0, caption, color, outline_color, 1);
		if(icon_image_index != -1 && icon_sprite_index != -1){
			if(icon_after == false){
				draw_sprite_ext(icon_sprite_index, icon_image_index, 0 - sprite_get_width(icon_sprite_index) - string_width(" "), 0, sprite_scale, sprite_scale, 0, c_white, alpha * alpha_value);
			}else{
				draw_sprite_ext(icon_sprite_index, icon_image_index, 0 + string_width(caption) + sprite_get_width(icon_sprite_index)*.1, 0, sprite_scale, sprite_scale, 0, c_white, alpha * alpha_value);
			}
		}
	}else if(description == "Inventory"){
		var Id = item_id;
		if(global.ItemIndex[#Id, ItemStat.Type] == "Armour" || global.ItemIndex[#Id, ItemStat.Type] == "Helmet"){
			var DescriptionString = string_wrap(global.ItemIndex[#Id, ItemStat.Description], 300 * global.GUIMultiplier);
			var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
			var StartDescriptionY = y + DescriptionStringHeight/2;
			draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
		}else if(global.ItemIndex[#Id, ItemStat.Type] == "Item" || global.ItemIndex[#Id, ItemStat.Type] == "Grenade" || global.ItemIndex[#Id, ItemStat.Type] == "Landmine"){
			draw_set_font(set_font("GUI_grid"));
			var DescriptionString = string_wrap(global.ItemIndex[#Id, ItemStat.Description], 300 * global.GUIMultiplier);
			var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
			var StartDescriptionY = y + DescriptionStringHeight/2;
			draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
		
			var offset_y = 64 * global.GUIMultiplier;
			var statistics_string = "";
			var statistics_x = x;
			var statistics_y = y + offset_y;
			if (Id == Item.advanced_suppressor) {
				var accuracy = (1 - global.ItemIndex[#Id, ItemStat.KickBackPower]) * 100;
				var spotted_chance = (1 - global.ItemIndex[#Id, ItemStat.KickBackInaccuracyMultiplier]) * 100;
				var attack_power = (1 - global.ItemIndex[#Id, ItemStat.Defense]) * 100;

				draw_string_line(statistics_x, statistics_y, "Accuracy: ", accuracy, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 20, "Getting spotted chance: ", -spotted_chance, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 40, "Attack power: ", -attack_power, c_red, " %");
			} else if (Id == Item.vertical_grip) {
				var vertical_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackInaccuracyMultiplier]) * 100;
				var horizontal_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackPower]) * 100;

				draw_string_line(statistics_x, statistics_y, "Vertical recoil: ", -vertical_recoil, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 20, "Horizontal recoil: ", -horizontal_recoil, c_red, " %");
			} else if (Id == Item.horizontal_grip) {
				var horizontal_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackPower]) * 100;
				var vertical_recoil = (1 - global.ItemIndex[#Id, ItemStat.KickBackInaccuracyMultiplier]) * 100;

				draw_string_line(statistics_x, statistics_y, "Horizontal recoil: ", -horizontal_recoil, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 20, "Vertical recoil: ", -vertical_recoil, c_red, " %");
			}
		}else if(global.ItemIndex[#Id, ItemStat.Type] == "Weapon"){
			var DescriptionString = string_wrap(global.ItemIndex[#Id, ItemStat.Description], 300 * global.GUIMultiplier);
			var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
			var StartDescriptionY = y + DescriptionStringHeight/2;
			draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
		
			var offset_y = DescriptionStringHeight * 2.35;
			var disadvantages_string = global.ItemIndex[#Id, ItemStat.disadvantages];
			var disadvantages_height = string_count_lines(disadvantages_string) * font_get_size(draw_get_font());
			var advantages_string = global.ItemIndex[#Id, ItemStat.advantages];
			var advantages_height = string_count_lines(advantages_string) * font_get_size(draw_get_font());
			var disadvantages_x = x + string_width(advantages_string)*1.1;
			var advantages_x = x;
			var advantages_y = y + offset_y;
			draw_text_outlined(disadvantages_x, advantages_y, disadvantages_string, c_red, c_black, 1);
			draw_text_outlined(advantages_x, advantages_y, advantages_string, c_yellow, c_black, 1);
		}
	}else if(description == "Buy_menu"){
		var Id = item_id;
		var DescriptionString = string_wrap(global.ItemIndex[#Id, ItemStat.Description], max_width);
		var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
		var StartDescriptionY = y + 96 + DescriptionStringHeight/2;
		draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
	}
	gpu_set_tex_filter(false);
	draw_set_alpha(1);

}

