event_inherited();
respawn_menu_width_tab = 768 * global.GUIMultiplier;
respawn_menu_height_tab = 512 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(respawn_menu_width_tab, respawn_menu_height_tab);

#region Callbacks
popup_respawn_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
	room_restart();	
};

respawn_callback = function(){
	ui_show_popup("Respawn?", "Respawn", "Yes", "No", 256 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_respawn_callback_positive, -1);		
};

popup_exit_callback_positive = function(){
	with(objZUIMain){
		zui_destroy();	
	}
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
#endregion

offset_position_y = 0;
offset_position_x = 32;
grid_height = min((ds_map_size(oPlayer.HitMap) + 2), 10) * (32 * global.GUIMultiplier);
button_width = 128 * global.GUIMultiplier;
button_height = 32 * global.GUIMultiplier;
if(oEggyEloRatingSystem.player_win == false){
	offset_position_y = 128;
	killed_by_weapon = oDraw.KilledByWeapon;
	killed_by_name = oDraw.KilledByName;
	KilledByString = "killed by: " + string(killed_by_name) + " by " + string(killed_by_weapon);
	
	with (zui_create(zui_get_width() * .5 - string_width(KilledByString)/2, zui_get_height() * .1, objUILabel)) {
		caption = "You died - " + other.KilledByString;
	}
}

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Damage table";
	draggable = 1;
}
with(zui_create(zui_get_width() * .5, offset_position_y + grid_height, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(other.button_width);
	zui_set_height(other.button_height);
	caption = "Close";
	callback = function(){
		with(oDamageTable){
			zui_destroy();
		}
	}
}

with(zui_create(zui_get_width() * .5 - string_width("Opponent(alive)")*5/2, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
}