draw_set_alpha(alpha * alpha_value);
if(show_stats){
	var grid_width = __width;
	var grid_height = __height;
	var row_height = clamp(30 * global.GUIMultiplier, 34, 42);
	var section_height = grid_height * .5;
	var columns = ["Player", "K", "A", "D", "K/D", "Money"];
	var column_ratios = [.38, .1, .1, .1, .14, .18];
	var local_team = instance_exists(global.local_player) ? global.local_player.stats.Team : TEAM.POLICE;
	var enemy_team = local_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE;
	var friendly_title = local_team == TEAM.POLICE ? "POLICE" : "TERRORISTS";
	var enemy_title = enemy_team == TEAM.POLICE ? "POLICE" : "TERRORISTS";
	var local_kills = global.game_struct.Match_kills;
	var local_assists = global.game_struct.Match_assists;
	var local_deaths = global.game_struct.Match_deaths;
	if(IS_NET && instance_exists(oNetworkManager) && instance_exists(global.local_player)){
		var local_stats = ds_map_find_value(oNetworkManager.player_stats, global.local_player.network_id);
		if(!is_undefined(local_stats)){
			if(ds_map_exists(local_stats, "Kills")) local_kills = local_stats[? "Kills"];
			if(ds_map_exists(local_stats, "Assists")) local_assists = local_stats[? "Assists"];
			if(ds_map_exists(local_stats, "Deaths")) local_deaths = local_stats[? "Deaths"];
		}
	}
	var local_rows = [[
		global.player_stats.Name,
		local_kills,
		local_assists,
		local_deaths,
		local_deaths > 0 ? local_kills / local_deaths : 0,
		global.player_stats.Money
	]];
	var remote_rows = [];

	if(IS_NET && instance_exists(oNetworkManager)){
		for(var player_index = 0; player_index < instance_number(oPlayer); player_index++){
			var remote_player = instance_find(oPlayer, player_index);
			if(instance_exists(remote_player) && remote_player.is_remote){
				var kills = 0;
				var assists = 0;
				var deaths = 0;
				var money = 0;
				var player_data = ds_map_find_value(oNetworkManager.player_stats, remote_player.network_id);
				if(!is_undefined(player_data)){
					if(ds_map_exists(player_data, "Kills")) kills = player_data[? "Kills"];
					if(ds_map_exists(player_data, "Assists")) assists = player_data[? "Assists"];
					if(ds_map_exists(player_data, "Deaths")) deaths = player_data[? "Deaths"];
					if(ds_map_exists(player_data, "Money")) money = player_data[? "Money"];
				}
				var display_name = remote_player.stats.Name + " [" + string(remote_player.network_id) + "]";
				array_push(remote_rows, [display_name, kills, assists, deaths, deaths > 0 ? kills / deaths : 0, money]);
			}
		}
	}else{
		var friendly_bot_rows = [];
		var enemy_bot_rows = [];
		for(var bot_index = 0; bot_index < array_length(global.BotMatchStats); bot_index++){
			var bot_stats = global.BotMatchStats[bot_index];
			if(bot_stats.Room != room) continue;

			var bot_row = [
				bot_stats.Name,
				bot_stats.Kills,
				bot_stats.Assists,
				bot_stats.Deaths,
				bot_stats.Deaths > 0 ? bot_stats.Kills / bot_stats.Deaths : 0,
				bot_stats.Money
			];
			if(bot_stats.Team == local_team){
				array_push(friendly_bot_rows, bot_row);
			}else if(bot_stats.Team == enemy_team){
				array_push(enemy_bot_rows, bot_row);
			}
		}

		for(var i = 0; i < array_length(friendly_bot_rows) - 1; i++){
			for(var j = i + 1; j < array_length(friendly_bot_rows); j++){
				if(friendly_bot_rows[j][1] > friendly_bot_rows[i][1]){
					var swap_row = friendly_bot_rows[i];
					friendly_bot_rows[i] = friendly_bot_rows[j];
					friendly_bot_rows[j] = swap_row;
				}
			}
		}

		for(var i = 0; i < array_length(enemy_bot_rows) - 1; i++){
			for(var j = i + 1; j < array_length(enemy_bot_rows); j++){
				if(enemy_bot_rows[j][1] > enemy_bot_rows[i][1]){
					var swap_row = enemy_bot_rows[i];
					enemy_bot_rows[i] = enemy_bot_rows[j];
					enemy_bot_rows[j] = swap_row;
				}
			}
		}

		for(var i = 0; i < min(5, array_length(friendly_bot_rows)); i++){
			array_push(local_rows, friendly_bot_rows[i]);
		}
		for(var i = 0; i < min(5, array_length(enemy_bot_rows)); i++){
			array_push(remote_rows, enemy_bot_rows[i]);
		}
	}

	var draw_scoreboard_section = function(_title, _rows, _top, _height, _row_height, _grid_width, _columns, _column_ratios){
		draw_set_font(set_font("GUI_grid"));
		draw_text_outlined(x, _top, _title, MAIN_COLOR, c_black, 1);
		var table_top = _top + _row_height;
		var current_x = x;

		for(var col = 0; col < array_length(_columns); col++){
			var width = _grid_width * _column_ratios[col];
			var header_x = current_x + (width - string_width(_columns[col])) * .5;
			draw_text_outlined(header_x, table_top + (_row_height - string_height(_columns[col])) * .5, _columns[col], c_white, c_black, 1);
			draw_set_color(MAIN_COLOR);
			draw_rectangle(current_x, table_top, current_x + width, table_top + _row_height, true);
			current_x += width;
		}
		draw_set_color(MAIN_COLOR);
		draw_line(x, table_top, x + _grid_width, table_top);

		var max_rows = max(1, floor((_height - _row_height * 2) / _row_height));
		for(var row = 0; row < min(array_length(_rows), max_rows); row++){
			current_x = x;
			var row_top = table_top + (row + 1) * _row_height;
			for(var col = 0; col < array_length(_columns); col++){
				var width = _grid_width * _column_ratios[col];
				var value = _rows[row][col];
				var value_string = (col == 4 && is_real(value)) ? string_format(value, 0, 2) : string(value);
				var text_x = current_x + (width - string_width(value_string)) * .5;
				if(col == 0) text_x = current_x + max(8 * global.GUIMultiplier, 10);
				draw_text_outlined(text_x, row_top + (_row_height - string_height(value_string)) * .5, value_string, c_white, c_black, 1);
				draw_set_color(MAIN_COLOR);
				draw_rectangle(current_x, row_top, current_x + width, row_top + _row_height, true);
				current_x += width;
			}
		}
	};

	draw_scoreboard_section(friendly_title, local_rows, y, section_height, row_height, grid_width, columns, column_ratios);
	draw_scoreboard_section(enemy_title, remote_rows, y + section_height, section_height, row_height, grid_width, columns, column_ratios);
	draw_set_alpha(1);
}else if(type == "Respawn menu"){
	
	#region Respawn menu
	var max_rows = 8;
	var Columns = ["Opponent(alive)", "Hits from", "Damage from", "Hits given", "Damage given"];
	var NumColumns = array_length(Columns);
	var CellWidth = string_width("Opponent(alive)");
	var CellHeight = 32 * global.GUIMultiplier;
	var cell_x = x;
	var cell_y = y;
	var Keys = ds_map_keys_to_array(global.local_player.HitMap);
	var Damages = array_create(ds_map_size(global.local_player.HitMap), -1);
	var NumRows = ds_map_size(global.local_player.HitMap) + 1; // +1 for header row
	
	for (var i = 0; i < ds_map_size(global.local_player.HitMap); i++) {
		var entity_id = Keys[i];
		var Data = global.local_player.HitMap[? entity_id];
		Damages[i] = Data[? "DamageReceived"];
	}

	// Sort entities based on damage
	for (var i = 0; i < array_length(Damages) - 1; i++) {
		for (var j = i + 1; j < array_length(Damages); j++) {
			if (Damages[j] > Damages[i]) {
			    // Swap Damages
			    var TempArray = Damages[i];
			    Damages[i] = Damages[j];
			    Damages[j] = TempArray;

			    // Swap corresponding Keys
			    TempArray = Keys[i];
			    Keys[i] = Keys[j];
			    Keys[j] = TempArray;
			}
		}
	}

	if (array_length(Keys) > max_rows) {
	    var SortedKeys = array_create(max_rows);

	    // Sort based on DamageReceived
	    for (var i = 0; i < max_rows; i++) {
	        var maxIndex = i;
	        for (var j = i + 1; j < array_length(Keys); j++) {
	            if (global.local_player.HitMap[? Keys[j]][? "DamageReceived"] > global.local_player.HitMap[? Keys[maxIndex]][? "DamageReceived"]) {
	                maxIndex = j;
	            }
	        }
	        if (maxIndex != i) {
	            // Swap Keys
	            var TempKey = Keys[i];
	            Keys[i] = Keys[maxIndex];
	            Keys[maxIndex] = TempKey;
	        }
	        SortedKeys[i] = Keys[i];
	    }

	    // Update Keys and NumRows
	    Keys = SortedKeys;
	    NumRows = max_rows + 1;
	}


	#region Draw header
	for (var col = 0; col < NumColumns; col++) {

		var TextX = x + (CellWidth - string_width(Columns[col])) / 2;
		var TextY = y + (CellHeight - string_height(Columns[col])) / 2;
	
		draw_text_outlined(TextX + col * CellWidth, TextY + CellHeight/4, Columns[col], c_white, c_black, 1);
		draw_set_color(MAIN_COLOR);
		draw_rectangle(cell_x + col * CellWidth, cell_y, cell_x + (col + 1) * CellWidth, cell_y + CellHeight, true);
	}
	#endregion
	
	#region Draw data
	for (var row = 1; row < NumRows; row++) {
		var EntityId = Keys[row - 1];
		var Data = global.local_player.HitMap[? EntityId];   
		var RowData = [string(Data[? "Name"]), 
			            string(Data[? "HitsReceived"]), 
			            string(Data[? "DamageReceived"]), 
			            string(Data[? "HitsGiven"]), 
			            string(Data[? "DamageGiven"])];
    
		for (var col = 0; col < NumColumns; col++) {
			
			var TextX = x + (CellWidth - string_width(RowData[col])) / 2;
			var TextY = y + (CellHeight - string_height(RowData[col])) / 2;
	
			draw_text_outlined(TextX + col * CellWidth, TextY + row * CellHeight + CellHeight/4, RowData[col], c_white, c_black, 1);
			draw_set_color(MAIN_COLOR);
			draw_rectangle(cell_x + col * CellWidth, cell_y + row * CellHeight, cell_x + (col + 1) * CellWidth, cell_y + (row + 1) * CellHeight, true);
		}
	}
	#endregion
	
	#endregion
	
}else if(type == "Weapon description"){
	
	#region Weapon description	
	var rows = 3;
	var columns = 3;
	var cell_height = ITEM_CELL_HEIGHT * global.GUIMultiplier;
	var statTitles = [
		"Damage: ", "Ammo: ", "Reload time: ", "Max. range: ", "RPM: ",
		"Class: ", "Moving speed: ", "Penetration: ", ""
	];					
					
	#region Draw grid
	for (var i = 0; i < rows; i++) {
		for (var j = 0; j < columns; j++) {
			var cell_x = x + j * cell_width;
			var cell_y = y + i * cell_height;
			draw_set_color(MAIN_COLOR);
			draw_rectangle(cell_x, cell_y, cell_x + cell_width, cell_y + cell_height, true);
			draw_set_color(c_white);
							
			draw_set_font(set_font("GUI_grid"));
			var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
			var text = "";
			var statIndex = ItemStat.Damage + i * columns + j;
			if (statIndex <= array_length(statTitles)){
								
				switch(statIndex){
										
					case ItemStat.MaxAmmo:
						text = statTitles[statIndex] + string(global.Inventory[#oDraw.var_slot, Index.slot_ammo]) + "/" + string(global.Inventory[#oDraw.var_slot, Index.slot_clip_ammo]);
					break;
									
					case ItemStat.ReloadSpeed:
						text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]/game_get_speed(gamespeed_fps)) + " s";
					break;

					case ItemStat.MovingSpdMul:
						text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]*100) + " %";
					break;

					case ItemStat.PenetrationPower:
						text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]*100) + " %";
					break;
									
					case ItemStat.ShootTimer:
						text = statTitles[statIndex] + string(game_get_speed(gamespeed_fps)/global.ItemIndex[#Id, statIndex]*60);
					break;

					case ItemStat.Range:
						text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]) + " Units";
					break;
										
					case ItemStat.ShootingMode:
						text = statTitles[statIndex] + get_shooting_modes_string(Id);
					break;
					
					case ItemStat.WeaponTypeClass:
						text = get_wpn_type(Id);
					break;
									
					default:
						text = statTitles[statIndex] + string(global.ItemIndex[#Id, statIndex]);
					break;
				}
								
			}
			var text_x = cell_x + cell_width / 2 - string_width(text) / 2;
			var text_y = cell_y + cell_height/2;
			draw_text_outlined(text_x, text_y, text, c_white, c_black, 1);
		}
	}		
	#endregion
	
	#endregion
	
}else if(type == "Armour description"){
	 
	#region Armour description
	var rows = 1;
	var columns = 3;
	var cell_height = ITEM_CELL_HEIGHT * global.GUIMultiplier;
	var statTitles = ["Weight: ", "Defense: ", "Durability: "];
						
	#region Draw grid
	for (var i = 0; i < rows; i++) {
		for (var j = 0; j < columns; j++) {
			var cell_x = x + j * cell_width;
			var cell_y = y + i * cell_height;
			draw_set_color(MAIN_COLOR);
			draw_rectangle(cell_x, cell_y, cell_x + cell_width, cell_y + cell_height, true);
			draw_set_color(c_white);
							
			draw_set_font(set_font("GUI_grid"));
			var Id = global.Inventory[#oDraw.var_slot, Index.slot_id];
			var text = "";
			var statIndex = ItemStat.Weight + i * columns + j;
			if (statIndex - ItemStat.Weight <= array_length(statTitles)){
								
				#region Specific cases
				switch(statIndex){
										
					case ItemStat.BaseDurability:
						text = 
							statTitles[statIndex - ItemStat.Weight] + 
							string(global.Inventory[#oDraw.var_slot, Index.slot_durability]/global.ItemIndex[#Id, ItemStat.BaseDurability]*100) +
							" %";
					break;
					case ItemStat.Defense:
						text = 
							statTitles[statIndex - ItemStat.Weight] + 
							string_format((1 - global.ItemIndex[# Id, ItemStat.Defense]) * 100, 0, 1) +
							" %";
					break;
					case ItemStat.Weight:
						text = 
							statTitles[statIndex - ItemStat.Weight] + 
							string_format(global.ItemIndex[# Id, ItemStat.Weight], 0, 1) +
							" kg";
					break;
				}
				#endregion
								
			}
			var text_x = cell_x + cell_width / 2 - string_width(text) / 2;
			var text_y = cell_y + cell_height/2;
			draw_text_outlined(text_x, text_y, text, c_white, c_black, 1);
		}
	}
	#endregion
	
	#endregion
	
}else if(type == "Usable item description"){

	#region Item description
	var rows = 1;
	var cell_height = ITEM_CELL_HEIGHT * global.GUIMultiplier;
	var statTitles = ["Damage: ", "Penetration power: "];
	var columns = array_length(statTitles);
						
	#region Draw grid
	for (var i = 0; i < rows; i++) {
		for (var j = 0; j < columns; j++) {
			var cell_x = x + j * cell_width;
			var cell_y = y + i * cell_height;
			draw_set_color(MAIN_COLOR);
			draw_rectangle(cell_x, cell_y, cell_x + cell_width, cell_y + cell_height, true);
			draw_set_color(c_white);
							
			draw_set_font(set_font("GUI_grid"));
			var text = "";
			
			switch(statTitles[j]){			
				case "Damage: ":
					text = statTitles[0] + string(global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.Damage]);
				break;
				
				case "Penetration power: ":
					text = statTitles[1] + string(global.ItemIndex[#global.Inventory[#oDraw.var_slot, Index.slot_id], ItemStat.PenetrationPower]*100) + " %";
				break;
			}
			
			var text_x = cell_x + cell_width / 2 - string_width(text) / 2;
			var text_y = cell_y + cell_height/2;
			draw_text_outlined(text_x, text_y, text, c_white, c_black, 1);
		}
	}
	#endregion
	
	#endregion

}
