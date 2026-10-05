function return_logical_value(input){
	var output = 0;
	if(input >= .5){
		output = 1;
	}
	return output;
}

function console_has_authority(){
	return !instance_exists(oNetworkManager)
		|| !oNetworkManager.is_connected
		|| oNetworkManager.is_server;
}

function console_sudo_enabled(){
	return global.sudo == true;
}

function console_command_requires_sudo(command){
	switch(command){
		case "game restart":
		case "reset game":
		case "room restart":
		case "give item":
		case "draw bullet impact":
		case "draw admin hud":
		case "set hitbox alpha":
		case "change team":
		case "godmode":
		case "set enemy movement":
		case "set fov angle":
		case "set time":
		case "set buy time":
		case "set time speed":
		case "toggle camera shake":
		case "set player inaccuracy":
		case "set weather":
		case "draw other models":
		case "draw damage":
		case "set player rating":
		case "set enemy visibility":
		case "set enemy rating":
		case "set played games":
		case "set money":
		case "unlock all items":
			return true;
	}
	return false;
}

function console_command_word_count(words, start_index, last_index){
	var first_word = words[start_index];
	if(first_word == "sudo" || first_word == "godmode") return 1;
	if(start_index + 1 > last_index) return 1;
	if(first_word == "unlock") return 3;
	if(first_word == "game" || first_word == "reset" || first_word == "room"
	|| first_word == "give" || first_word == "change" || first_word == "clear"
	|| first_word == "get" || first_word == "show") return 2;

	if(first_word == "draw"){
		if(start_index + 2 <= last_index
		&& (words[start_index + 1] == "bullet"
		|| words[start_index + 1] == "admin"
		|| words[start_index + 1] == "other")) return 3;
		return 2;
	}

	if(first_word == "toggle"){
		return words[start_index + 1] == "camera" ? 3 : 2;
	}

	if(first_word == "set"){
		var second_word = words[start_index + 1];
		if(second_word == "time" && start_index + 2 <= last_index && words[start_index + 2] == "speed") return 3;
		if(second_word == "money" || second_word == "fullscreen" || second_word == "time"
		|| second_word == "weather" || second_word == "saturation"
		|| second_word == "aberration") return 2;
		return 3;
	}

	return 1;
}

function console_autocomplete_value(suggestion){
	var cut_position = string_length(suggestion) + 1;
	var markers = [" <", "<", " {", " (", " ["];
	for(var marker_index = 0; marker_index < array_length(markers); marker_index++){
		var marker_position = string_pos(markers[marker_index], suggestion);
		if(marker_position > 0){
			cut_position = min(cut_position, marker_position);
		}
	}
	return string_copy(suggestion, 1, cut_position - 1);
}

function console_delete_input_selection(c){
	var selected = console_selection_bounds(c, -1, string_length(c[? "string"]));
	if(selected[1] <= selected[0]) return false;
	c[? "string"] = string_delete(c[? "string"], selected[0], selected[1] - selected[0]);
	c[? "string_pos"] = selected[0];
	console_selection_clear(c);
	return true;
}

function console_submit(Console) {
	global.console= Console;

	if global.console[? "active"] {

	    var list = global.console[? "history"];
	    var input_list = global.console[? "input_history"];
	    var sug = global.console[? "suggestions"];
	    var i,sep,no,c;
	    sep = global.console[? "sep"];
	    var t;
    
	    //Pasting text
	    if(keyboard_check(vk_control)){
			global.console[? "backspace_hold"] = 0;
			global.console[? "left_hold"] = 0;
			global.console[? "right_hold"] = 0;
			if(keyboard_check_pressed(ord("A"))){
				global.console[? "selection_anchor_line"] = -1;
				global.console[? "selection_focus_line"] = -1;
				global.console[? "selection_anchor_pos"] = 1;
				global.console[? "selection_focus_pos"] = string_length(global.console[? "string"]) + 1;
				global.console[? "string_pos"] = global.console[? "selection_focus_pos"];
			}
			if(keyboard_check_pressed(ord("C"))){
				var copied_text = "";
				var anchor_line = global.console[? "selection_anchor_line"];
				var focus_line = global.console[? "selection_focus_line"];
				var copy_password_input = global.console[? "terminal_mode"]
					&& instance_exists(oTerminal) && oTerminal.sudo_login_stage == 2;
				if(anchor_line == -1 && focus_line == -1 && !copy_password_input){
					var selected_input = console_selection_bounds(global.console, -1, string_length(global.console[? "string"]));
					copied_text = string_copy(global.console[? "string"], selected_input[0], selected_input[1] - selected_input[0]);
				}else if(anchor_line >= 0 && focus_line >= 0){
					for(var copy_row = max(anchor_line, focus_line); copy_row >= min(anchor_line, focus_line); copy_row--){
						if(copy_row >= ds_list_size(list)) continue;
						var copy_line = string(list[| copy_row]);
						var selected_line = console_selection_bounds(global.console, copy_row, string_length(copy_line));
						if(copy_row < max(anchor_line, focus_line)) copied_text += "\n";
						copied_text += string_copy(copy_line, selected_line[0], selected_line[1] - selected_line[0]);
					}
				}
				if(copied_text != "") clipboard_set_text(copied_text);
			}
	        if(keyboard_check_pressed(ord("V"))) {
    
	        var clip = clipboard_get_text();
	        clip = string_replace_all(clip,chr(10),"");
	        clip = string_replace_all(clip,chr(13),"");
	        clip = string_replace_all(clip,"#","");
			console_delete_input_selection(global.console);
			console_selection_clear(global.console);
	        global.console[? "string"] = string_insert(clip,global.console[? "string"],global.console[? "string_pos"]);
	        global.console[? "string_pos"] += string_length(clip);
        
	        } 
	        if keyboard_check_pressed(vk_backspace){
				if(!console_delete_input_selection(global.console)){
					global.console[? "string_pos"] = 1;
					global.console[? "string"] = "";
				}
				console_selection_clear(global.console);
	        }
			if keyboard_check_pressed(vk_left){
				if global.console[? "string_pos"] > 1 then global.console[? "string_pos"] = 1;
				console_selection_clear(global.console);
			}	
			if keyboard_check_pressed(vk_right) {
				global.console[? "string_pos"] = string_length(global.console[? "string"]) + 1;
				console_selection_clear(global.console);
			}
	    }
	    else
	    /* String input */
	{
		var repeat_backspace = false;
		var repeat_left = false;
		var repeat_right = false;
		if(keyboard_check(vk_backspace)){
			global.console[? "backspace_hold"]++;
			repeat_backspace = keyboard_check_pressed(vk_backspace)
				|| (global.console[? "backspace_hold"] > 20 && global.console[? "backspace_hold"] mod 3 == 0);
		}else{
			global.console[? "backspace_hold"] = 0;
		}
		if(keyboard_check(vk_left)){
			global.console[? "left_hold"]++;
			repeat_left = keyboard_check_pressed(vk_left)
				|| (global.console[? "left_hold"] > 15 && global.console[? "left_hold"] mod 3 == 0);
		}else{
			global.console[? "left_hold"] = 0;
		}
		if(keyboard_check(vk_right)){
			global.console[? "right_hold"]++;
			repeat_right = keyboard_check_pressed(vk_right)
				|| (global.console[? "right_hold"] > 15 && global.console[? "right_hold"] mod 3 == 0);
		}else{
			global.console[? "right_hold"] = 0;
		}

	    if keyboard_check_pressed(vk_anykey) || repeat_backspace || repeat_left || repeat_right
	    {
	        /* Delete */
	        if repeat_backspace
	        {
				global.console[? "dir"] = -1;
				global.console[? "select"] = 0;
				if(!console_delete_input_selection(global.console)){
					if global.console[? "string_pos"] > 1 then global.console[? "string_pos"] -= 1;
					global.console[? "string"] = string_delete(global.console[? "string"],global.console[? "string_pos"],1);
				}
				console_selection_clear(global.console);
	        } 
	        else 
	        /* Back one position */
			if repeat_left
	        {
				var left_selection = console_selection_bounds(global.console, -1, string_length(global.console[? "string"]));
				if(left_selection[1] > left_selection[0]) global.console[? "string_pos"] = left_selection[0];
				else if global.console[? "string_pos"] > 1 then global.console[? "string_pos"] -= 1;
				console_selection_clear(global.console);
	        } 
	        else 
	        /* Forward one position */ 
	        if repeat_right
	        {
				var right_selection = console_selection_bounds(global.console, -1, string_length(global.console[? "string"]));
				if(right_selection[1] > right_selection[0]) global.console[? "string_pos"] = right_selection[1];
				else global.console[? "string_pos"] = min(global.console[? "string_pos"] + 1, string_length(global.console[? "string"]) + 1);
				console_selection_clear(global.console);
	        } 
			else 
	        /* Selected last entered command */
	        if keyboard_check_pressed(vk_up) {
			console_selection_clear(global.console);
			if(global.console[? "dir"] == 1 && ds_list_size(global.console[? "suggestions"]) > 0){
				global.console[? "select"] = max(0, global.console[? "select"] - 1);
				sug = ds_list_find_value(global.console[? "suggestions"], global.console[? "select"]);
				sug = console_autocomplete_value(sug);
				global.console[? "string"] = sug;
				global.console[? "string_pos"] = string_length(sug) + 1;
			}else{
				global.console[? "dir"] = -1;
				var last = ds_list_find_value(input_list, global.console[? "input_select"]);
				if(!is_undefined(last)){
					global.console[? "string"] = last;
					global.console[? "string_pos"] = string_length(last) + 1;
				}
				if(global.console[? "input_select"] < ds_list_size(input_list) - 1){
					global.console[? "input_select"]++;
				}
			}
            
	        } else 
        
	        /* Selected suggested command */
	        if keyboard_check_pressed(vk_down) 
	        {
			console_selection_clear(global.console);
			var suggestion_count = ds_list_size(global.console[? "suggestions"]);
			if(suggestion_count > 0){
				if(global.console[? "dir"] == -1){
					global.console[? "dir"] = 1;
					global.console[? "select"] = 0;
				}else{
					global.console[? "select"] = min(global.console[? "select"] + 1, suggestion_count - 1);
				}

				sug = ds_list_find_value(global.console[? "suggestions"], global.console[? "select"]);
				sug = console_autocomplete_value(sug);
				global.console[? "string"] = sug;
				global.console[? "string_pos"] = string_length(sug) + 1;
			}
	        }
	        else
	        {

	        /* Insert character */
			var terminal_console_key = global.console[? "terminal_mode"]
				&& keyboard_check_pressed(global.KeyBinds[| KEY.Console]);
	        if !(keyboard_check_pressed(vk_enter)) && !terminal_console_key
	        {
			if(keyboard_lastchar != ""){
				console_delete_input_selection(global.console);
				console_selection_clear(global.console);
			}
	            global.console[? "string"] = string_insert(keyboard_lastchar,global.console[? "string"],global.console[? "string_pos"]);
	            if keyboard_lastchar != "" {
					global.console[? "string_pos"] += 1;
					global.console[? "dir"] = -1;
					global.console[? "select"] = 0;
				}
	        }
	        /* Reset last character */
	        keyboard_lastchar = "";
	    }
	}
	}
    
	if(keyboard_check_released(vk_anykey) && global.console[? "dir"] != 1)
	{
	    if(ds_exists(global.console[? "text"],ds_type_list))
	    {
	        var cmd = global.console[? "string"];
	        var txt = global.console[? "text"];
	        if(ds_exists(global.console[? "suggestions"],ds_type_list))
	        {
	            var sugs = global.console[? "suggestions"];
	            ds_list_clear(sugs);
	            if(string_length(keyboard_string) > 0)
	            {
	                for(t=0;t<ds_list_size(txt);t++) 
	                {
	                    var line = txt[| t];
	                    if string_copy(line,1,string_length(cmd)) = cmd then ds_list_add(sugs,line);
	                }
	            }
	        }
	    }
	}

	    if keyboard_check_pressed(vk_enter) && global.console[? "string"] != "" 
	    {
	        // Get command string
	        var str = string_trim(global.console[? "string"]);
			while(string_pos("  ", str) > 0){
				str = string_replace_all(str, "  ", " ");
			}
			var submit_terminal_mode = ds_map_exists(global.console, "terminal_mode") && global.console[? "terminal_mode"];
			var terminal_instance = submit_terminal_mode ? instance_find(oTerminal, 0) : noone;
			var credential_input = instance_exists(terminal_instance) && terminal_instance.sudo_login_stage > 0;
			var password_input = instance_exists(terminal_instance) && terminal_instance.sudo_login_stage == 2;

			// Passwords are displayed as hidden and are not stored in command history.
			ds_list_insert(list, 0, password_input ? "********" : str);
			if(!credential_input){
				ds_list_insert(input_list, 0, str);
			}
			global.console[? "input_select"] = 0;

			if(submit_terminal_mode){
				global.console[? "command"] = str;
				global.console[? "arguments"] = [str];
				global.console[? "count"] = 0;
				keyboard_string = "";

				if(instance_exists(terminal_instance)){
					terminal_instance.terminal_command_submit(str);
				}

				global.console[? "string"] = "";
				global.console[? "string_pos"] = 1;
				console_selection_clear(global.console);
				global.console[? "select"] = 0;
				global.console[? "dir"] = -1;
				console_preset(global.my_console);
				return true;
			}

	        // Split console string
			c = string_split(str, sep);
			no = array_length(c) - 1;
			var raw_last_index = no;
			var sudo_prefix = false;
			var command_start = 0;
			if(c[0] == "sudo" && no >= 1 && c[1] != "su" && string_digits(c[1]) == ""){
				sudo_prefix = true;
				command_start = 1;
			}

			var command_words = console_command_word_count(c, command_start, raw_last_index);
			command_words = min(command_words, raw_last_index - command_start + 1);
			var command_name = c[command_start];
			for(var command_word = 1; command_word < command_words; command_word++){
				command_name += " " + c[command_start + command_word];
			}

			var parsed_command = [command_name];
			for(var argument_index = command_start + command_words; argument_index <= raw_last_index; argument_index++){
				array_push(parsed_command, c[argument_index]);
			}
			c = parsed_command;
			no = array_length(c) - 1;

	        // Store command
	        global.console[? "command"] = c[0];
	        global.console[? "arguments"] = c;
	        global.console[? "count"] = no;
	        /* Clear keyboard string */
	        keyboard_string = "";
	        if global.console[? "close"] 
	        {
	            global.console[? "active"] = false;
	            global.console[? "select"] = 0;
	        }
	        if global.console[? "preset"] 
	        {
			var requires_sudo = console_command_requires_sudo(c[0]);
			if(sudo_prefix && !console_has_authority()){
				console_write_debug("[CONSOLE] Only singleplayer or the server host can use sudo.");
			}else if(requires_sudo && !console_sudo_enabled() && !sudo_prefix){
				console_write_debug("[CONSOLE] This command requires sudo.");
			}else{
	            switch(c[0]) 
	            {
					case "sudo":
						if(no == 1 && c[1] == "su"){
							if(console_has_authority()){
								global.sudo = true;
								console_write_debug("[CONSOLE] sudo = true");
							}else{
								console_write_debug("[CONSOLE] Only singleplayer or the server host can use sudo su.");
							}
						}else if(no == 1 && string_digits(c[1]) != ""){
							if(!instance_exists(oNetworkManager) || !oNetworkManager.is_connected || !oNetworkManager.is_server){
								console_write_debug("[CONSOLE] sudo <player id> can only be used by the server host.");
							}else{
								var sudo_player_id = round(real(c[1]));
								if(sudo_player_id == oNetworkManager.my_pid){
									global.sudo = true;
									console_write_debug("[CONSOLE] sudo = true");
								}else if(server_set_client_sudo(sudo_player_id, true)){
									console_write_debug("[CONSOLE] Granted sudo to player " + string(sudo_player_id) + ".");
								}else{
									console_write_debug("[CONSOLE] Player " + string(sudo_player_id) + " was not found.");
								}
							}
						}else{
							console_write_debug("[CONSOLE] Usage: sudo su, sudo <player id>, or sudo <command>.");
						}
					break

					case "draw hud":
						if(no == 1 && string_digits(c[1]) != ""){
							global.draw_hud = return_logical_value(real(c[1]));
						}
					break;

	                case "game restart": game_restart(); break;
	                case "game exit": game_end(); break;
					case "reset game":
						if(room == rm_main_menu){
							reset_singleplayer_game();
							console_write_debug("[CONSOLE] Singleplayer game reset.");
						}else{
							console_write_debug("[CONSOLE] reset game can only be used in the main menu.");
						}
					break;
					case "set dynamic crosshair":
						if(no == 1 && string_digits(c[1]) != ""){
							global.DynamicCrosshair = return_logical_value(real(c[1]));
						}
					break;
					case "set crosshair alpha":
						if(no == 1 && string_digits(c[1]) != ""){
							global.CrosshairAlpha = clamp(real(c[1]), 0, 1);
						}
					break;
					case "draw bullet impact":
						if(no == 1 && string_digits(c[1]) != ""){
							global.draw_bullet_impact = return_logical_value(real(c[1]));
						}
					break;
					case "give item":
						if(no == 1 && string_digits(c[1]) != ""){
							GiveItem = instance_create_layer(global.local_player.x, global.local_player.y, "ItemsO", oItems);
							GiveITEM.image_index = clamp(round(real(c[1])), 0, ITEM.Total - 1);
						}
					break;
					case "draw admin hud":
						if(no == 1 && string_digits(c[1]) != ""){
							global.draw_advanced_hud = return_logical_value(real(c[1]));
						}
					break;
					case "set hitbox alpha":
						if(no == 1 && string_digits(c[1]) != ""){
							global.HitBoxAlpha = clamp(real(c[1]), 0, 1);
						}
					break;
	                case "room restart": room_restart(); break;
					case "change team":
						if(no == 1 && string_digits(c[1]) != ""){
							var requested_team = round(real(c[1])) + 1;
							if(requested_team == TEAM.POLICE || requested_team == TEAM.TERRORIST){
								global.player_stats.Player_team = requested_team;
								room_restart();
							}
						}
					break;
					case "godmode":
						if(no == 1 && string_digits(c[1]) != ""){
							global.GodMode = return_logical_value(real(c[1]));
						}
					break;
	                case "set fullscreen":
	                    if(no == 1 && string_digits(c[1]) != ""){
							window_set_fullscreen(real(c[1])); 
						}
					break;
					case "set enemy movement":
						if(no == 1 && string_digits(c[1]) != "") then global.EnemyCanMove = return_logical_value(real(c[1]));
					break;
					case "set console height":
						if(no == 1 && string_digits(c[1]) != "") then global.ConsoleHeight = clamp(real(c[1]), 128, display_get_height());
					break;
					case "set console width":
						if(no == 1 && string_digits(c[1]) != "") then global.ConsoleWidth = clamp(real(c[1]), 128, display_get_width());
					break;
					case "set gui scale":
						if(no == 1 && string_digits(c[1]) != ""){
							if(real(c[1]) != global.gui_scale){
								global.gui_scale = real(c[1]) < 2 ? 1 : 2;
								reset_gui();
							}
						}
					break;
					case "set fov angle":
						if(no == 1 && string_digits(c[1]) != "") then global.FieldOfView = real(c[1]) % 360;
					break;
					case "toggle bloom":
						if(no == 1 && string_digits(c[1]) != "") then global.bloom_shader = return_logical_value(real(c[1]));
					break;
					case "set time":
						if(no == 1 && string_digits(c[1]) != ""){
							if(instance_exists(oLightRenderer)){
								oLightRenderer.CurrentHour = floor(real(c[1])/60);
								oLightRenderer.CurrentMinute = real(c[1]) % 60;
							}
						}
					break;	
					case "set buy time":
						if(no == 1 && string_digits(c[1]) != "") then oDraw.buy_time = max(real(c[1]) * 60, 0);
					break;
					case "set time speed":
						if(no == 1 && string_digits(c[1]) != "") then global.TimeSpeed = real(c[1]);
					break;	
					case "toggle camera shake":
						if(no == 1 && string_digits(c[1]) != "") then global.ViewShake = return_logical_value(real(c[1]));
					break;	
					case "set player inaccuracy":
						if(no == 1 && string_digits(c[1]) != "") then global.PlayerInaccuracy = real(c[1]);
					break;	
					
					case "clear particles":
						if(no == 1 && string_digits(c[1]) != ""){
							with(oParticleSurface){
								surface_set_target(ParticleSurface);
								draw_clear_alpha(0, 0);
								surface_reset_target();
								surface_free(ParticleSurface);
								if!(surface_exists(ParticleSurface)){
									ParticleSurface = surface_create(room_width, room_height);
									surface_set_target(ParticleSurface);
									draw_clear_alpha(0, 0);
									surface_reset_target();
								}
							}
						}
					break;
					
					case "draw particles":
						if(no == 1 && string_digits(c[1]) != ""){
							var submit_value = real(c[1]);
							if(submit_value == 0){
								if(instance_exists(oParticleSystem)){
									instance_destroy(oParticleSystem);
								}
							}else{
								if!(instance_exists(oParticleSystem)){
									instance_create_layer(oPlayer.x, oPlayer.y, "OtherO", oParticleSystem);
								}
							}
							global.DrawParticles = return_logical_value(real(c[1]));
						}
					break;	
					
					case "set weather":
						if(no == 1 && string_digits(c[1]) != ""){
							global.Weather = real(c[1]);
							if(global.Weather != WEATHER.RAIN){
								audio_stop_sound(snd_Rain);	
							}
							if(IS_NET){
								send_weather_broadcast();
							}
						}
					break;
					
					case "set crosshair color":
					    if (no == 1 && string_digits(c[1]) != "") {
							set_crosshair_color(string_digits(c[1]));
					        var colorString = string_digits(c[1]);
					        if (string_length(colorString) == 9) {
					            var r = string_copy(colorString, 1, 3);
					            var g = string_copy(colorString, 4, 3);
					            var b = string_copy(colorString, 7, 3);

					            // Convert to integers
					            r = real(r);
					            g = real(g);
					            b = real(b);

					            // Clamp values to valid range
					            r = clamp(r, 0, 255);
					            g = clamp(g, 0, 255);
					            b = clamp(b, 0, 255);

					            // Set crosshair color
					            global.crosshair_color = make_color_rgb(r, g, b);
					        }
					    }
					break;
					
					case "draw other models":
						if(no == 1 && string_digits(c[1]) != "") then global.draw_other_models = return_logical_value(real(c[1]));
					break;
					
					case "draw damage":
						if(no == 1 && string_digits(c[1]) != "") then global.draw_damage = return_logical_value(real(c[1]));
					break;
					
					case "set window size":
					    if (no >= 2 && string_digits(c[1]) != "" && string_digits(c[2]) != "") {
					        global.window_width = clamp(real(string_digits(c[1])), 540, display_get_width());
					        global.window_height = clamp(real(string_digits(c[2])), 480, display_get_height());
							
							if(window_get_fullscreen() == false){
								ui_scale_set_window_size(clamp(real(string_digits(c[1])), 540, display_get_width()), clamp(real(string_digits(c[2])), 480, display_get_height()));
							}
					    }
					break;
					
					case "set player rating":
						if(no == 1 && string_digits(c[1]) != ""){
							global.game_struct.Player_ep = real(c[1]);	
						}
					break;
					
					case "set enemy visibility":
						if(no == 1 && string_digits(c[1]) != ""){
							global.enemy_visibility = return_logical_value(real(c[1]));
						}
					break;
					
					case "set enemy rating":
						if(no == 1 && string_digits(c[1]) != ""){
							global.game_struct.Enemy_ep[global.game_struct.Current_game] = convert_to_eggy_scale(real(c[1]));
						}
					break;
					
					case "set played games":
						if(no == 1 && string_digits(c[1]) != ""){
							global.game_struct.Played_games = real(c[1]);
						}
					break;

					case "set saturation":
						if(no == 1 && string_digits(c[1]) != ""){
							global.saturation_level = real(c[1]);
						}
					break;
					
					case "set aberration":
						if(no == 1 && string_digits(c[1]) != ""){
							global.aberration_level = real(c[1]);
						}
					break;
					
					case "set clear timer":
						if(no == 1 && string_digits(c[1]) != ""){
							global.clear_particles_timer = real(c[1]);
							
							if(instance_exists(oParticleSurface)){
								oParticleSurface.alarm[0] = global.clear_particles_timer;
							}
						}
					break;
					
					case "set money":
						if(no >= 1 && string_digits(c[1]) != ""){
							var money_value = round(real(c[1]));
							var local_player_id = instance_exists(oNetworkManager) && oNetworkManager.is_connected ? oNetworkManager.my_pid : 0;
							var target_player_id = local_player_id;
							if(no >= 2 && string_digits(c[2]) != ""){
								target_player_id = round(real(c[2]));
							}

							if(!IS_NET || target_player_id == local_player_id){
								global.player_stats.Money = money_value;
								if(instance_exists(global.local_player)){
									global.local_player.stats.Money = money_value;
								}
							}else if(!oNetworkManager.is_server){
								console_write_debug("[CONSOLE] Only the server host can target another player.");
								break;
							}

							if(IS_NET && oNetworkManager.is_server){
								var target_player = find_instance_by_network_id(oPlayer, target_player_id);
								var target_stats = ds_map_find_value(oNetworkManager.player_stats, target_player_id);
								if(!instance_exists(target_player)){
									console_write_debug("[CONSOLE] Player " + string(target_player_id) + " was not found.");
									break;
								}
								if(is_undefined(target_stats)){
									target_stats = ds_map_create();
									ds_map_add(target_stats, "Kills", target_player.stats.Kills);
									ds_map_add(target_stats, "Assists", target_player.stats.Assists);
									ds_map_add(target_stats, "Deaths", target_player.stats.Deaths);
									ds_map_add(oNetworkManager.player_stats, target_player_id, target_stats);
								}
								target_player.stats.Money = money_value;
								ds_map_set(target_stats, "Money", money_value);
								send_stats_broadcast();
							}
							console_write_debug("[CONSOLE] Player " + string(target_player_id) + " money = " + string(money_value));
						}
					break;

					case "get id":
						if(no == 0){
							var player_id = instance_exists(oNetworkManager) && oNetworkManager.is_connected ? oNetworkManager.my_pid : 0;
							console_write_debug("[CONSOLE] Player ID: " + string(player_id));
						}
					break;
					
					case "get latency":
						if(no == 0 && IS_NET && instance_exists(oNetworkManager)){
							console_write_debug("[LATENCY] " + string(oNetworkManager.ping_ms) + " ms");	
						}
					break;
					
					case "set crosshair scale":
						if(no == 1 && string_digits(c[1]) != ""){
							global.crosshair_scale = real(c[1]);
						}
					break;
					
					case "unlock all items":
						if(no == 1 && string_digits(c[1]) != ""){
							if(return_logical_value(real(c[1])) == true){
								reset_gui();
								
								for(var w = 0; w < ITEM.Total; w ++){
									if(global.ItemIndex[# w, ITEMSTATS.Type] != "Weapon" && global.ItemIndex[# w, ITEMSTATS.Type] != "Grenade" &&
									global.ItemIndex[# w, ITEMSTATS.Type] != "Armour" && global.ItemIndex[# w, ITEMSTATS.Type] != "Helmet" &&
									global.ItemIndex[# w, ITEMSTATS.Type] != "Shield"){
										continue;
									}
									
									if(global.ItemIndex[# w, ITEMSTATS.is_locked] == true){
										global.ItemIndex[# w, ITEMSTATS.is_locked] = false;
										if(ds_list_find_index(global.unlocked_items, w) == -1){
											ds_list_add(global.unlocked_items, w);
										}
									}
		
								}		
								if(instance_exists(oBuyMenu)){
									with(oBuyMenu){ zui_destroy(); }
									with(oBuyMenuDescription){ zui_destroy(); }
									with (zui_main()) zui_create(zui_get_width()*.5, zui_get_height()*.5, oBuyMenu);
								}
								save_game();
							}
						}
					break;
	            }
			}
	        }
	        global.console[? "string"] = "";
	        global.console[? "string_pos"] = 1;
		console_selection_clear(global.console);
	        global.console[? "select"] = 0;
	        global.console[? "dir"] = -1;
	        console_preset(global.my_console);
	        return true;
        
	    }
	}







}
