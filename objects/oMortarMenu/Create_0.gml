event_inherited();
texture_width = 384 * global.gui_scale;
texture_height = 128 * global.gui_scale;

draw_set_font(set_font("GUI_small"));
zui_set_size(texture_width, texture_height);


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Mortar";
	draggable = 1;
}

function parse_coordinates(coord_str){
    var mortar = instance_nearest(global.local_player.x, global.local_player.y, oMortar);

    // přesně jedno 'j'
    if(string_count("j", coord_str) != 1){
        return [mortar.x, mortar.y];
    }

    var j_pos = string_pos("j", coord_str);
    if(j_pos <= 1) return [mortar.x, mortar.y];

    // znaménko je znak TĚSNĚ před 'j'
    var s = string_char_at(coord_str, j_pos - 1);
    if(s != "+" && s != "-"){
        return [mortar.x, mortar.y];
    }

    // X je všechno před tím znaménkem
    var x_str = string_copy(coord_str, 1, j_pos - 2);
    // Y je všechno za 'j' (BEZ znaménka)
    var y_str = string_copy(coord_str, j_pos + 1, string_length(coord_str) - j_pos);

    if(x_str == "" || y_str == "") return [mortar.x, mortar.y];
    if(!is_real(real(x_str)) || !is_real(real(y_str))) return [mortar.x, mortar.y];

    var x_val = real(x_str);
    var y_val = real(y_str);

    if(s == "-"){
        y_val = -y_val;
    }

    return [x_val, y_val];
}
	

coordinates_callback_positive = function(InputText){
	var coordinates = parse_coordinates(InputText);
	global.local_player.mortar_coordinates[0] = coordinates[0];
	global.local_player.mortar_coordinates[1] = coordinates[1];
};

position_x = zui_get_width() * .1;
position_y = zui_get_height() * .25;


launch_button = zui_create(zui_get_width() * .5, position_y + string_height("a")*3, objUIButton);
with(launch_button){
	zui_set_anchor(0.5, 0);
	zui_set_width(128 * global.gui_scale);
	zui_set_height(32 * global.gui_scale);
	caption = "Launch!";
	callback = function(){
		var mortar = instance_nearest(global.local_player.x, global.local_player.y, oMortar);
		if(mortar.shoot_timer == -1){
			mortar.shoot_timer = mortar.shoot_time;
			oMortarMenu.launch_button.alpha = 0.25;
			var bomb_x = mortar.x + global.local_player.mortar_coordinates[0];
			var bomb_y = mortar.y - global.local_player.mortar_coordinates[1];
			var missile = instance_create_layer(bomb_x, bomb_y, "OtherO", oMissile);
			missile.stats = mortar.stats;
		}
	}
}

with (zui_create(position_x, position_y, objUILabel)) {
	color = c_white;
	caption = "Complex coordinates: ";
}

with(zui_create(position_x + string_width("Complex coordinates: "), position_y - string_height("a")/2, objUITextInput)){
	zui_set_anchor(0, 0);
	init_text = "0+j0";
	keyboard_lastchar = "";
	max_string_length = string_length("1000+j1000");
	callback = other.coordinates_callback_positive;
}
