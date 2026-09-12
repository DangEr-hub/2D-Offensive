event_inherited();
global.ranked_game = true;
play_unranked_tab_width = 720 * global.gui_scale;
play_unranked_tab_height = 405 * global.gui_scale;

draw_set_font(set_font("GUI_small"));
zui_set_size(play_unranked_tab_width, play_unranked_tab_height);

unranked_description_string = "Commit to a full scale match\nwhich affects your eggy points.\nEnemies have eggy points in\ncorrelation with your eggy points.";
checkbox_gap = 8 * global.gui_scale;
hard_mode_checkbox_width = 16 * global.gui_scale;
hard_mode_checkbox_height = 16 * global.gui_scale;
map_play_button_width = 72 * global.gui_scale;
map_play_button_height = 16 * global.gui_scale;
map_image_sprite_height = 72 * global.gui_scale;
map_image_sprite_width = 128 * global.gui_scale;
map_image_position_x = 32;
map_image_position_y = 64;
map_image_gap = map_image_sprite_width * 1.1;

if(global.MapID != -1){
	global.map_rounds[global.MapID][0] = global.game_struct.Rounds_win;
	global.map_rounds[global.MapID][1] = global.game_struct.Rounds_lost;
	global.game_struct.Rounds_win = 0;
	global.game_struct.Rounds_lost = 0;	
}

for(var j=0;j<MAP.Total;j++){
	map_name_array[j] = global.MapProperties[#j, MAP_STAT.Name];	
}


map_callbacks = [
    function() { 
		if(global.MapID != MAP.Desert){ reset_singleplayer_game(); }
		global.ranked_game = true;
		map_init(MAP.Desert);
		room_goto(rm_Desert);
	},
    function() { 
		if(global.MapID != MAP.RainForest){ reset_singleplayer_game(); }
		global.ranked_game = true;
		map_init(MAP.RainForest);
		room_goto(rm_RainForest); 
	}
];

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Play ranked game";
	draggable = 1;
}

for(i=0;i<array_length(map_callbacks);i++){
	with (zui_create(map_image_position_x + i*map_image_gap, map_image_position_y, objUIImage)){
		zui_set_anchor(0, 0);
		sprite = spr_MapImage;
		sprite_image_index = other.i;
		sprite_width_size = other.map_image_sprite_width;
		sprite_height_size = other.map_image_sprite_height;
	}
	
	with (zui_create(map_image_position_x + (map_image_sprite_width)/2 - string_width(map_name_array[i])/2 + i*map_image_gap, map_image_position_y + map_image_sprite_height * 1.1, objUILabel)) {
		color = c_dkgray;
		caption = other.map_name_array[other.i];
	}
	
	with (zui_create(map_image_position_x + (map_image_sprite_width)/2 - map_play_button_width/2 + i*map_image_gap, map_image_position_y + map_image_sprite_height * 1.25, objUIButton)) {
		zui_set_anchor(0, 0);
		zui_set_size(other.map_play_button_width, other.map_play_button_height);

		caption = "Play!";
		callback = other.map_callbacks[other.i];
	}
}

with (zui_create(play_unranked_tab_width * .85, 64, objUICheckbox)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.hard_mode_checkbox_width, other.hard_mode_checkbox_height);
	value = global.hard_mode;
	value_type = "hard_mode";
	callback = function(){
		value = !value;
		global.hard_mode = value;
	};
}

with (zui_create(play_unranked_tab_width * .85 + hard_mode_checkbox_width + checkbox_gap, 64 + hard_mode_checkbox_height/2, objUILabel)) {
	color = c_white;
	caption = "Hardmode";
}

network_button_width = map_play_button_width * 1.5;
network_button_height = map_play_button_height;
network_center_x = zui_get_width() * .5;
host_button_y = zui_get_height() * .7;
join_row_y = zui_get_height() * .8;
network_control_gap = 12 * global.gui_scale;
ip_label_text = "IP address: ";
ip_label_width = string_width(ip_label_text);
ip_input_width = 128 * global.gui_scale;
ip_input_height = 32;
join_row_width = ip_label_width + network_control_gap + ip_input_width + network_control_gap + network_button_width;
join_row_x = network_center_x - join_row_width * .5;
ip_input_x = join_row_x + ip_label_width + network_control_gap;
join_button_x = ip_input_x + ip_input_width + network_control_gap;

with (zui_create(network_center_x - network_button_width * .5, host_button_y, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.network_button_width, other.network_button_height);

	caption = "Host server";
	callback = function(){
		global.ranked_game = true;
		/* Creating server - Menu button */
		if (!IS_NET) {
		    instance_create_layer(100, 100, "OtherO", oNetworkManager);
		}
    
		// Start server
		if (start_server()) {
		    show_debug_message("Server started successfully!");
		    room_goto(rm_ServerTest);
		} else {
		    show_debug_message("Failed to start server!");
		}
	};
}

with (zui_create(join_row_x, join_row_y + network_button_height * .5, objUILabel)) {
	color = c_white;
	caption = other.ip_label_text;
}

ip_address_input = zui_create(ip_input_x, join_row_y + (network_button_height - ip_input_height) * .5, objUITextInput);
with (ip_address_input) {
	zui_set_anchor(0, 0);
	zui_set_size(other.ip_input_width, other.ip_input_height);
	init_text = global.saved_server_ip;
	max_string_length = 15;
}

with (zui_create(join_button_x, join_row_y, objUIButton)) {
	zui_set_anchor(0, 0);
	zui_set_size(other.network_button_width, other.network_button_height);

	caption = "Join server";
	callback = function(){
		global.ranked_game = true;
		/* Joining the game - Menu button */
		if (!IS_NET) {
		    instance_create_layer(100, 100, "OtherO", oNetworkManager);
		}
    
		var ip_address = string_trim(oPlayRankedTab.ip_address_input.text);
		if(ip_address == ""){
			ip_address = "127.0.0.1";
		}
		global.saved_server_ip = ip_address;
		save_game();
		var port = 50000;  
    
		// Connect to server
		if (connect_to_server(ip_address, port)) {
		    show_debug_message("Connecting to server...");
		} else {
		    show_debug_message("Failed to connect to server!");
		} 
	};
}
