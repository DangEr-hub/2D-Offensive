function console_submit(argument0) {
	global.console=argument0;

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
								/*global.GuiW = global.window_width*(1920/global.window_width);
								global.GuiH = global.window_height*(1080/global.window_height);
								application_surface_draw_enable(false);
								surface_resize(application_surface, global.GuiW, global.GuiH);
								surface_free(oDraw.Surface1); 
								surface_free(oDraw.Surface2); 
								surface_free(oDraw.NightVisionSurface); 
								surface_free(oDraw.BlurGrayScaleSurface); 
								surface_free(oDraw.BlurSurface);*/
							
								//show_debug_message(display_aa);
								display_reset(0, false);
								window_set_size(global.window_width, global.window_height);
								window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
								
							}
						}
					break;
					case "hostage":
						if(no == 1 && string_digits(c[1]) != "") then global.Hostage = real(c[1]);
					break;
					case "rank_modifier":
						if(no == 1 && string_digits(c[1]) != "") then global.RankMultiplier = real(c[1]);
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
								if(instance_exists(oInventory)){
									instance_destroy(oInventory);
									instance_destroy(oSlot);
									InventoryCreate();
								}

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
							if(instance_exists(oSunLight)){
								oSunLight.CurrentHour = floor(real(c[1])/60);
								oSunLight.CurrentMinute = real(c[1]) % 60;
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
						if(no == 1 && string_digits(c[1]) != "") then global.DrawParticles = real(c[1]);
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
					            global.CrosshairColor = make_color_rgb(r, g, b);
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
								window_set_size(global.window_width, global.window_height);
								window_set_position(display_get_width()/2 - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
							}
					    }
					break;
					
	                /*
	                case "infinite_ammo":
	                    if no == 1 then global.InfiniteAmmo = real(c[1]);
	                break;
	                case "draw_damage":
	                    if no == 1 then global.ShowDamage = real(c[1]);
	                break;
	                case "blackness_value":
	                    if(no == 1) then global.Blackness_Value = real(c[1]);
	                break;
	                case "r_drawparticles":if(no == 1) then global.DrawParticles = real(c[1]);break;
	                case "r_drawtracers":if(no == 1) then global.DrawTracers = real(c[1]);break;
	                case "net_graph_position_x":if(no == 1) then global.AdminHUDPositionX = real(c[1]);break;
	                case "net_graph_position_y":if(no == 1) then global.AdminHUDPositionY = real(c[1]);break;
	                case "airplane_chance":if(no == 1) then global.AirPlaneChance = real(c[1]);break;
	                case "bullet_impact_type":if(no == 1) then global.BulletImpactType = real(c[1]);break;
	                case "no_sway":if(no == 1) then global.NoGunSway = real(c[1]);break;
	                case "draw_headhitbox":if(no == 1) then global.DrawHeadHitBox = real(c[1]);break;
	                case "draw_ui":if(no == 1) then global.DrawUI = real(c[1]);break;
	                case "one_taps_sound":if(no == 1) then global.OneTaps = real(c[1]);break;
	                case "rain":if(no == 1) then global.Rain = real(c[1]);break;
	                case "snow":if(no == 1) then global.Snow = real(c[1]);break;
	                case "hp":if(no == 1) then global.HP = real(c[1]);break;
	                case "timer":if(no == 1) then obj_Alarms.alarm[6] = real(c[1]);break;
	                case "buy_time":if(no == 1) then global.BuyTimer = real(c[1]);break;
	                case "money":if(no == 1) then global.Money = real(c[1]);break;
	                case "bullet_time":if(no == 1) then global.SlowMotion = real(c[1]);break;
	                case "gems":if(no == 1) then global.Gems = real(c[1]);break;
	                case "declare_guns":GunDeclare();break;
	                case "enemy_canshoot":if no == 1 then global.EnemyCanShoot = real(c[1]);break;
	                case "skill_points":if(no == 1) then global.SkillPoints = real(c[1]);break;
	                case "r_drawblood":if(no == 1) then global.DrawBlood = real(c[1]);break;
	                case "player_solid_collision":if(no == 1) then global.PlayerSolid = real(c[1]);break;
	                case "draw_bloom_shader":if(no == 1) then global.DrawBloom = real(c[1]);break;
	                case "crosshair_alpha":if(no == 1) then global.CrosshairAlpha = real(c[1]);break;
	                case "crosshair_color":if(no == 1) then global.CrosshairColor = real(c[1]);break;
	                case "crosshair_scale":if(no == 1) then global.CrosshairSize = real(c[1]);break;
	                case "elo":if(no == 1) then global.Elo = real(c[1]);break;
	                case "player_min_speed":if(no == 1) then global.MinSpeed = round(real(c[1])/60);break;
	                case "player_max_speed":if(no == 1) then global.MaxSpeed = round(real(c[1])/60);break;
	                case "complex_recoil":if(no == 1) then global.ComplexRecoil = real(c[1]);break;
	                case "draw_bodyhitbox":if(no == 1) then global.DrawBodyHitBox = real(c[1]);break;
	                case "draw_solid_collision":if(no == 1) then global.DrawSolidCollision = real(c[1]);break;
	                case "temperature":if(no==1)then global.Temperature = real(c[1]);break;
	                case "temperature_min":if(no==1)then global.TemperatureMin = real(c[1]);break;
	                case "temperature_max":if(no==1)then global.TemperatureMax = real(c[1]);break;
	                case "spawn_terrorist":instance_create(obj_Crosshair.x, obj_Crosshair.y, obj_Terrorist);break;
	                case "spawn_obstacle":instance_create(obj_Crosshair.x, obj_Crosshair.y, obj_WoodenBox);break;
	                case "draw_gun_inaccuracy":global.DrawGunInaccuracy = real(c[1]);break;
	                case "enemy_unlimited_hp":if(no==1)then global.EnemyUnlimitedHP = real(c[1]);break;
	                case "competetive_games":if(no==1)then global.CompetetiveGames = real(c[1]);break;
	                case "max_hp":if(no==1) then global.MaxHP = real(c[1]);break;
	                case "developer_mode":global.Money = 100000; global.BuyTimer = 50000;obj_Alarms.alarm[6] = 100000 * room_speed;for(i=0;i<ds_grid_width(global.WeaponDic);i++){global.WeaponDic[#i, WeaponStats.Unlocked] = true;}global.God = true;break;
	                //case "bind
	                case "unlock_all_weapons":
	                    if(no == 1){
	                        for(i=0;i<ds_grid_width(global.WeaponDic);i++){
	                            global.WeaponDic[#i, WeaponStats.Unlocked] = true;
	                        }
	                    }
	                break;
					*/
	            } 
	        }
	        global.console[? "string"] = "";
	        global.console[? "string_pos"] = 1;
	        console_preset(global.my_console);
	        return true;
        
	    }
	}







}
