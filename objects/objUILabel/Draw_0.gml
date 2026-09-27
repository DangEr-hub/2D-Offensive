
draw_set_alpha(alpha * alpha_value);
draw_set_font(font);

if(drawable == true){
	if(description = ""){
		var display_caption = caption;
		var translated_caption = tr(string_replace_all(caption, " ", "_"));
		if(translated_caption != ""){
			display_caption = translated_caption;
		}else{
			var separator = string_pos(":", caption);
			if(separator == 0) separator = string_pos(" - ", caption);
			if(separator > 0){
				var label_key = string_replace_all(string_copy(caption, 1, separator - 1), " ", "_");
				translated_caption = tr(label_key);
				if(translated_caption != ""){
					display_caption = translated_caption + string_delete(caption, 1, separator - 1);
				}
			}
		}
		draw_text_outlined(0, 0, display_caption, color, outline_color, 1);
		if(icon_image_index != -1 && icon_sprite_index != -1){
			if(icon_after == false){
				draw_sprite_ext(icon_sprite_index, icon_image_index, 0 - sprite_get_width(icon_sprite_index) - string_width(" ") + icon_offset[0], icon_offset[1], sprite_scale, sprite_scale, 0, c_white, alpha * alpha_value);
			}else{
				draw_sprite_ext(icon_sprite_index, icon_image_index, 0 + string_width(display_caption) + sprite_get_width(icon_sprite_index)*.1 + icon_offset[0], icon_offset[1], sprite_scale, sprite_scale, 0, c_white, alpha * alpha_value);
			}
		}
	}else if(description == "Inventory"){
		var Id = item_id;
		if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Armour" || global.ItemIndex[#Id, ITEMSTATS.Type] == "Helmet" || global.ItemIndex[#Id, ITEMSTATS.Type] == "Shield"){
			var DescriptionString = string_wrap(tr_desc(Id), 300 * global.gui_scale);
			var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
			var StartDescriptionY = y + DescriptionStringHeight/2;
			draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
		}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Item" || global.ItemIndex[#Id, ITEMSTATS.Type] == "Grenade" || global.ItemIndex[#Id, ITEMSTATS.Type] == "Landmine" || global.ItemIndex[#Id, ITEMSTATS.Type] == "Bomb"){
			draw_set_font(set_font("GUI_grid"));
			var DescriptionString = string_wrap(tr_desc(Id), 300 * global.gui_scale);
			var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
			var StartDescriptionY = y + DescriptionStringHeight/2;
			draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
		
			var offset_y = 64 * global.gui_scale;
			var statistics_string = "";
			var statistics_x = x;
			var statistics_y = y + offset_y;
			if (Id == ITEM.suppressor) {
				var accuracy = (1 - global.ItemIndex[#Id, ITEMSTATS.KickBackPower]) * 100;
				var spotted_chance = (1 - global.ItemIndex[#Id, ITEMSTATS.KickBackInaccuracyMultiplier]) * 100;
				var attack_power = (1 - global.ItemIndex[#Id, ITEMSTATS.Defense]) * 100;

				draw_string_line(statistics_x, statistics_y, tr("Accuracy") + ": ", accuracy, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 20, tr("Getting_spotted_chance") + ": ", -spotted_chance, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 40, tr("Attack_power") + ": ", -attack_power, c_red, " %");
			} else if (Id == ITEM.vertical_grip) {
				var vertical_recoil = (1 - global.ItemIndex[#Id, ITEMSTATS.KickBackInaccuracyMultiplier]) * 100;
				var horizontal_recoil = (1 - global.ItemIndex[#Id, ITEMSTATS.KickBackPower]) * 100;

				draw_string_line(statistics_x, statistics_y, tr("Vertical_recoil") + ": ", -vertical_recoil, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 20, tr("Horizontal_recoil") + ": ", -horizontal_recoil, c_red, " %");
			} else if (Id == ITEM.horizontal_grip) {
				var horizontal_recoil = (1 - global.ItemIndex[#Id, ITEMSTATS.KickBackPower]) * 100;
				var vertical_recoil = (1 - global.ItemIndex[#Id, ITEMSTATS.KickBackInaccuracyMultiplier]) * 100;

				draw_string_line(statistics_x, statistics_y, tr("Horizontal_recoil") + ": ", -horizontal_recoil, c_green, " %");
				draw_string_line(statistics_x, statistics_y + 20, tr("Vertical_recoil") + ": ", -vertical_recoil, c_red, " %");
			}
		}else if(global.ItemIndex[#Id, ITEMSTATS.Type] == "Weapon"){
			var DescriptionString = string_wrap(tr_desc(Id), 300 * global.gui_scale);
			var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
			var StartDescriptionY = y + DescriptionStringHeight/2;
			draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
		
			var offset_y = DescriptionStringHeight * 3;
			var disadvantages_string = tr_adv(Id, false);
			var disadvantages_height = string_count_lines(disadvantages_string) * font_get_size(draw_get_font());
			var advantages_string = tr_adv(Id, true);
			var advantages_height = string_count_lines(advantages_string) * font_get_size(draw_get_font());
			var disadvantages_x = x + string_width(advantages_string)*1.1;
			var advantages_x = x;
			var advantages_y = y + offset_y;
			draw_text_outlined(disadvantages_x, advantages_y, disadvantages_string, c_red, c_black, 1);
			draw_text_outlined(advantages_x, advantages_y, advantages_string, c_yellow, c_black, 1);
		}
	}else if(description == "Buy_menu"){
		var Id = item_id;
		var DescriptionString = string_wrap(tr_desc(Id), max_width);
		var DescriptionStringHeight = string_count_lines(DescriptionString) * font_get_size(draw_get_font());
		var StartDescriptionY = y + 96 + DescriptionStringHeight/2;
		draw_text_outlined(x, StartDescriptionY, DescriptionString, c_white, c_black, 1);
	}
	gpu_set_tex_filter(false);
	draw_set_alpha(1);

}

