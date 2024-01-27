draw_set_alpha(alpha * alpha_value);
if(type == "Respawn menu"){
	
	#region Respawn menu
	var max_rows = 8;
	var Columns = ["Opponent(alive)", "Hits from", "Damage from", "Hits given", "Damage given"];
	var NumColumns = array_length(Columns);
	var CellWidth = string_width("Opponent(alive)");
	var CellHeight = 32 * global.GUIMultiplier;
	var cell_x = x;
	var cell_y = y;
	var Keys = ds_map_keys_to_array(oPlayer.HitMap);
	var Damages = array_create(ds_map_size(oPlayer.HitMap), -1);
	var NumRows = ds_map_size(oPlayer.HitMap) + 1; // +1 for header row
	
	for (var i = 0; i < ds_map_size(oPlayer.HitMap); i++) {
		var entity_id = Keys[i];
		var Data = oPlayer.HitMap[? entity_id];
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
	            if (oPlayer.HitMap[? Keys[j]][? "DamageReceived"] > oPlayer.HitMap[? Keys[maxIndex]][? "DamageReceived"]) {
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
		draw_set_color(global.GoldColor);
		draw_rectangle(cell_x + col * CellWidth, cell_y, cell_x + (col + 1) * CellWidth, cell_y + CellHeight, true);
	}
	#endregion
	
	#region Draw data
	for (var row = 1; row < NumRows; row++) {
		var EntityId = Keys[row - 1];
		var Data = oPlayer.HitMap[? EntityId];
	
		var EntityName = global.player_stats_struct.Name + string(" (You)");
		if(EntityId.object_index != oPlayer){
			EntityName = EntityId.stats.Name;
		}
    
		var RowData = [string(EntityName), 
			            string(Data[? "HitsReceived"]), 
			            string(Data[? "DamageReceived"]), 
			            string(Data[? "HitsGiven"]), 
			            string(Data[? "DamageGiven"])];
    
		for (var col = 0; col < NumColumns; col++) {
			
			var TextX = x + (CellWidth - string_width(RowData[col])) / 2;
			var TextY = y + (CellHeight - string_height(RowData[col])) / 2;
	
			draw_text_outlined(TextX + col * CellWidth, TextY + row * CellHeight + CellHeight/4, RowData[col], c_white, c_black, 1);
			draw_set_color(global.GoldColor);
			draw_rectangle(cell_x + col * CellWidth, cell_y + row * CellHeight, cell_x + (col + 1) * CellWidth, cell_y + (row + 1) * CellHeight, true);
		}
	}
	#endregion
	#endregion
	
}else if(type == "Weapon description"){
	
	#region Weapon description		
	#endregion
	
}else if(type == "Armour description"){
	 
	#region Armour description
	var rows = 1;
	var columns = 3;
	var cell_height = ITEM_CELL_HEIGHT * global.GUIMultiplier;
	var statTitles = ["Weight: ", "Defense modifier: ", "Durability: "];
						
	#region Draw grid
	for (var i = 0; i < rows; i++) {
		for (var j = 0; j < columns; j++) {
			var cell_x = x + j * cell_width;
			var cell_y = y + i * cell_height;
			draw_set_color(global.GoldColor);
			draw_rectangle(cell_x, cell_y, cell_x + cell_width, cell_y + cell_height, true);
			draw_set_color(c_white);
							
			draw_set_font(set_font("GUI_grid"));
			var Id = global.Inventory[#oDraw.var_slot, InventoryIndex.SlotID];
			var text = "";
			var statIndex = ItemStat.Weight + i * columns + j;
			if (statIndex - ItemStat.Weight <= array_length(statTitles)){
								
				#region Specific cases
				switch(statIndex){
										
					case ItemStat.BaseDurability:
						text = 
							statTitles[statIndex - ItemStat.Weight] + 
							string(global.Inventory[#oDraw.var_slot, InventoryIndex.SlotDurability]/global.ItemIndex[#Id, ItemStat.BaseDurability]*100) +
							"%";
					break;
					default:
						text = statTitles[statIndex - ItemStat.Weight] + string(global.ItemIndex[#Id, statIndex]);
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
	
}else if(type == "Item description"){

	#region Item description
	
	#endregion

}