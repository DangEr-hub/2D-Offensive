event_inherited();
damage_table_width_tab = min(768 * global.gui_scale, 1080);
damage_table_height_tab = max(128 * global.gui_scale + ((ds_map_size(global.local_player.HitMap) + 2)*32*global.gui_scale), 352);
alpha = 1;
black = -1;

draw_set_font(set_font("GUI_small"));
zui_set_size(damage_table_width_tab, damage_table_height_tab);

killed_by_y = max(zui_get_height() * .1, 64);
offset_position_y = 32;
offset_position_x = 32;
grid_height = min((ds_map_size(global.local_player.HitMap) + 2), 10) * (32 * global.gui_scale);
button_width = 128 * global.gui_scale;
button_height = 32 * global.gui_scale;
var local_player_died = instance_exists(global.local_player)
	&& global.local_player.stats.Health_points <= 0;
if(local_player_died){
	offset_position_y = 128;
	killed_by_weapon = oDraw.KilledByWeapon;
	killed_by_name = oDraw.KilledByName;
	KilledByString = "killed by: " + string(killed_by_name) + " by " + string(killed_by_weapon);
	
	with (zui_create(zui_get_width() * .5 - string_width(KilledByString)/1.75, killed_by_y, objUILabel)) {
		caption = "You died - " + other.KilledByString;
	}
}else{
	with (zui_create(zui_get_width() * .5, killed_by_y, objUILabel)) {
		caption = "";
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
		with(oDamageTable.black){
			zui_destroy();
		}
		with(oDamageTable){
			zui_destroy();
		}
	}
}

with(zui_create(zui_get_width() * .5 - string_width("Opponent(alive)")*5/2, offset_position_y, objUIGrid)){
	zui_set_anchor(0, 0);
}
