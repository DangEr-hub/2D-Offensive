function console_submit(Console) {
	global.console= Console;

	if global.console[? "active"] {

	    var list = global.console[? "history"];
	    var sug = global.console[? "suggestions"];
	    var i,sep,len,no,c;
	    sep = global.console[? "sep"];
	    len = string_length(sep)-1;
	    var t;
    
	    //Pasting text
	    if(keyboard_check(vk_control)){
	        if(keyboard_check_pressed(ord("V"))) {
    
	        var clip = clipboard_get_text();
	        clip = string_replace_all(clip,chr(10),"");
	        clip = string_replace_all(clip,chr(13),"");
	        clip = string_replace_all(clip,"#","");
	        global.console[? "string"] = string_insert(clip,global.console[? "string"],global.console[? "string_pos"]);
	        global.console[? "string_pos"] += string_length(clip);
        
	        } 
	        if keyboard_check_pressed(vk_backspace){
	            global.console[? "string_pos"] -= string_length(global.console[? "string"]);
	            global.console[? "string"] = "" ;
	        }
			if keyboard_check_pressed(vk_left){
				if global.console[? "string_pos"] > 1 then global.console[? "string_pos"] = 1;   
			}	
			if keyboard_check_pressed(vk_right) {
				global.console[? "string_pos"] += string_length(global.console[? "string"]);   
			}
	    }
	    else
	    /* String input */
	    if keyboard_check_pressed(vk_anykey) 
	    {
	        /* Delete */
	        if keyboard_check_pressed(vk_backspace) 
	        {
	            if global.console[? "string_pos"] > 1 then global.console[? "string_pos"] -= 1;
	            global.console[? "string"] = string_delete(global.console[? "string"],global.console[? "string_pos"],1);
	        } 
	        else 
	        /* Back one position */
			if keyboard_check_pressed(vk_left) 
	        {
				if global.console[? "string_pos"] > 1 then global.console[? "string_pos"] -= 1;  
	        } 
	        else 
	        /* Forward one position */ 
	        if keyboard_check_pressed(vk_right) 
	        {
				global.console[? "string_pos"] += 1;
	        } 
			else 
	        /* Selected last entered command */
	        if keyboard_check_pressed(vk_up) {
        
	            if global.console[? "dir"] = 1 {
	                global.console[? "dir"] = -1;
	                global.console[? "select"] = 0;
	            }
	            var last = ds_list_find_value(global.console[? "history"],global.console[? "select"]);
	            if !is_undefined(last) {
	                global.console[? "string"] = last;
	                global.console[? "string_pos"] = string_length(last)+1;
	            }
	            if global.console[? "select"] < ds_list_size(global.console[? "history"]) then
	            global.console[? "select"] += 1 else global.console[? "select"] = 0;
            
	        } else 
        
	        /* Selected suggested command */
	        if keyboard_check_pressed(vk_down) 
	        {
	            if global.console[? "dir"] = -1 
	            {
	                global.console[? "dir"] = 1;
	                global.console[? "select"] = 0;
	            }
	            sug = ds_list_find_value(global.console[? "suggestions"],global.console[? "select"]);
            
	            if !(is_undefined(sug))
	            {
	                sug = string_delete(sug,string_pos(sep,sug),string_length(sug));
	                global.console[? "string"] = sug;
	                global.console[? "string_pos"] = string_length(sug)+1;
	            }
	            if global.console[? "select"] < ds_list_size(global.console[? "suggestions"]) then global.console[? "select"] += 1 else global.console[? "select"] = 0;   
	        }
	        else
	        {

	        /* Insert character */
	        if !(keyboard_check_pressed(vk_enter))
	        {
	            global.console[? "string"] = string_insert(keyboard_lastchar,global.console[? "string"],global.console[? "string_pos"]);
	            if keyboard_lastchar != "" then global.console[? "string_pos"] += 1;  
	        }
	        /* Reset last character */
	        keyboard_lastchar = "";
	    }
	}
    
	if(keyboard_check_released(vk_anykey))
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
	        var str = global.console[? "string"];
	        // Add to history
	        ds_list_insert(list,0,str);
	        // Split console string
	        no = string_count(sep,str);
	        for(i=0; i<=no; i++) 
	        {
	            c[i] = str;
	            repeat (i)
	            c[i] = string_delete(c[i],1,string_pos(sep,c[i])+len);
	            c[i] = string_delete(c[i],string_pos(sep,c[i]),string_length(c[i]));
	        }
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
	            switch(c[0]) 
	            {
	                case "op_game_restart": game_restart(); break;
	                case "op_game_end": game_end(); break;
					case "set_dynamic_crosshair": 
						if(no == 1 && string_digits(c[1]) != ""){
							global.DynamicCrosshair = real(c[1]);
						}
					break;
					case "set_crosshair_alpha": 
						if(no == 1 && string_digits(c[1]) != ""){
							global.CrosshairAlpha = real(c[1]);
						}
					break;
					case "draw_bullet_impact": 
						if(no == 1 && string_digits(c[1]) != ""){
							global.DrawBulletImpact = real(c[1]);
						}
					break;
					case "give_id":
						if(no == 1){
							GiveItem = instance_create_layer(oPlayer.x, oPlayer.y, "ItemsO", oItems);
							GiveItem.image_index = real(c[1]);
						}
					break;
					case "draw_admin_hud": 
						if(no == 1 && string_digits(c[1]) != ""){
							global.AdminHUD = real(c[1]);
						}
					break;
					case "set_hitbox_alpha":
						if(no == 1 && string_digits(c[1]) != ""){
							global.HitBoxAlpha = real(c[1]);	
						}
					break;
	                case "op_room_restart": room_restart(); break;
					case "op_godmode":
						if(no == 1 && string_digits(c[1]) != ""){
							global.GodMode = real(c[1]);
						}
					break;
	                case "set_window_fullscreen": 
	                    if(no == 1 && string_digits(c[1]) != ""){
							window_set_fullscreen(real(c[1])); 
							
							if(real(c[1]) == 0){
								display_set_gui_size(global.window_width, global.window_height);
								surface_resize(application_surface, global.window_width, global.window_height);
								window_set_size(global.window_width, global.window_height);
								window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
								
							}
						}
					break;
					case "hostage":
						if(no == 1 && string_digits(c[1]) != "") then global.Hostage = real(c[1]);
					break;
					case "enemy_can_move":
						if(no == 1 && string_digits(c[1]) != "") then global.EnemyCanMove = real(c[1]);
					break;
					case "set_console_height":
						if(no == 1 && string_digits(c[1]) != "") then global.ConsoleHeight = real(c[1]);
					break;
					case "set_console_width":
						if(no == 1 && string_digits(c[1]) != "") then global.ConsoleWidth = real(c[1]);
					break;
					case "set_gui_scale":
						if(no == 1 && string_digits(c[1]) != ""){
							if(real(c[1]) != global.GUIMultiplier){
								global.GUIMultiplier = real(c[1]);
								reset_gui();
							}
						}
					break;
					case "set_fov_angle":
						if(no == 1 && string_digits(c[1]) != "") then global.FieldOfView = real(c[1]);
					break;
					case "toggle_bloom_shader":
						if(no == 1 && string_digits(c[1]) != "") then global.BloomShader = real(c[1]);
					break;
					case "set_time":
						if(no == 1 && string_digits(c[1]) != ""){
							if(instance_exists(oLightRenderer)){
								oLightRenderer.CurrentHour = floor(real(c[1])/60);
								oLightRenderer.CurrentMinute = real(c[1]) % 60;
							}
						}
					break;			
					case "set_time_speed":
						if(no == 1 && string_digits(c[1]) != "") then global.TimeSpeed = real(c[1]);
					break;	
					case "set_camera_crosshair_shake":
						if(no == 1 && string_digits(c[1]) != "") then global.ViewShake = real(c[1]);
					break;	
					case "set_player_inaccuracy":
						if(no == 1 && string_digits(c[1]) != "") then global.PlayerInaccuracy = real(c[1]);
					break;	
					
					case "clear_particles":
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
					
					case "draw_particles":
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
							global.DrawParticles = real(c[1]);
						}
					break;	
					
					case "set_weather":
						if(no == 1 && string_digits(c[1]) != ""){
							switch(real(c[1])){
								case 0:
									global.Weather = "sun";
								break;
								
								case 1:
									global.Weather = "rain";
								break;
								
								case 2:
									global.Weather = "snow";
								break;
								
								default:
									global.Weather = "sun";
								break;
							}
						}
					break;
					
					case "set_crosshair_color":
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
					
					case "draw_other_models":
						if(no == 1 && string_digits(c[1]) != "") then global.draw_other_models = real(c[1]);
					break;
					
					case "set_window_size":
					    if (no >= 2 && string_digits(c[1]) != "" && string_digits(c[2]) != "") {
					        global.window_width = real(string_digits(c[1]));
					        global.window_height = real(string_digits(c[2]));
							
							if(window_get_fullscreen() == false){
								display_set_gui_size(global.window_width, global.window_height);
								surface_resize(application_surface, global.window_width, global.window_height);
								window_set_size(global.window_width, global.window_height);
								window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
							}
					    }
					break;
					
					case "set_player_eggy_points":
						if(no == 1 && string_digits(c[1]) != ""){
							global.player_elo_struct.Elo = convert_to_eggy_scale(real(c[1]));	
						}
					break;
					
					case "set_enemy_visibility":
						if(no == 1 && string_digits(c[1]) != ""){
							global.enemy_visibility = real(c[1]);
						}
					break;
					
					case "set_enemy_eggy_points":
						if(no == 1 && string_digits(c[1]) != ""){
							global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game] = convert_to_eggy_scale(real(c[1]));
						}
					break;
	            } 
	        }
	        global.console[? "string"] = "";
	        global.console[? "string_pos"] = 1;
	        console_preset(global.my_console);
	        return true;
        
	    }
	}







}
