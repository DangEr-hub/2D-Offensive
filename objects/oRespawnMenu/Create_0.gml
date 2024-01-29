event_inherited();
respawn_menu_width_tab = 768 * global.GUIMultiplier;
respawn_menu_height_tab = 512 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(respawn_menu_width_tab, respawn_menu_height_tab);

offset_position_x = 32;
offset_position_y = 64;
grid_height = min((ds_map_size(oPlayer.HitMap) + 2), 10) * (32 * global.GUIMultiplier);

killed_by_name = "No one";
killed_by_weapon = "nothing";
if(oDraw.KilledBy != noone){
	killed_by_weapon = oDraw.KilledBy.KilledByWeapon;
	killed_by_name = global.player_stats_struct.Name;
	if(oDraw.KilledBy.object_index == oEnemy){
		killed_by_name = oDraw.KilledBy.stats.Name;
	}
}
with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	var KilledByString = "killed by: " + string(other.killed_by_name) + " by " + string(other.killed_by_weapon);
	caption = "You died - " + KilledByString;
	draggable = 1;
}

popup_respawn_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	save_game();
	room_restart();	
};

respawn_callback = function(){
	ui_show_popup("Respawn?", "Respawn", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_respawn_callback_positive, -1);		
};

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	save_game();
	game_end();	
};

exit_callback = function(){
	ui_show_popup("Exit game?", "Exit", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_exit_callback_positive, -1);		
};

popup_main_menu_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();
	}
	room_goto(rm_main_menu);
};

main_menu_callback = function(){
	ui_show_popup("Leave to main menu?", "Leave", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_main_menu_callback_positive, -1);	
};

with (zui_create(zui_get_width() * .5 - string_width("Time alive: " + string(oEggyEloRatingSystem.playing_time/game_get_speed(gamespeed_fps)) + " s")/2, offset_position_y + grid_height, objUILabel)) {
	icon_sprite_index = spr_Icons;
	icon_image_index = icons.time;
	color = c_white;
	caption = "Time alive: " + string(oEggyEloRatingSystem.playing_time/game_get_speed(gamespeed_fps)) + " s";
}

button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;
with(zui_create(zui_get_width() * .5, offset_position_y + grid_height + string_height("a")*2, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Respawn";
	callback = other.respawn_callback;
}
with(zui_create(zui_get_width() * .5, offset_position_y + grid_height + string_height("a")*2 + button_height*1.5, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Main menu";
	callback = other.main_menu_callback;
}

with(zui_create(zui_get_width() * .5, offset_position_y + grid_height + string_height("a")*2 + button_height*1.5*2, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Exit";
	callback = other.exit_callback;
}
with(zui_create(zui_get_width() * .5 - string_width("Opponent(alive)")*5/2, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
}