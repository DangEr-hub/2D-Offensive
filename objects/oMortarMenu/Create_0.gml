event_inherited();
texture_width = 384 * global.GUIMultiplier;
texture_height = 192 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(texture_width, texture_height);


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = "Mortar";
	draggable = 1;
}

function parse_euler_coordinates(coord_str) {
    // Find the position of the 'e^j'
    var euler_pos = string_pos("e^j", coord_str);

    // Validate the format
    if (euler_pos <= 0) {
        return[global.local_player.x, global.local_player.y]; // Invalid input if 'e^j' is not present
    }

    // Extract the amplitude and angle strings
    var amplitude_str = string_copy(coord_str, 1, euler_pos - 1);
    var angle_str = string_copy(coord_str, euler_pos + 3, string_length(coord_str) - euler_pos - 2);

    // Validate extracted strings
    if (amplitude_str == "" || angle_str == "" || !is_real(real(amplitude_str)) || !is_real(real(angle_str))) {
        return[global.local_player.x, global.local_player.y]; // Invalid input if either part is not a real number
    }

    // Convert to real numbers
    var amplitude = real(amplitude_str);
    var angle = real(angle_str);

    // Convert angle from degrees to radians
    var angle_rad = angle * pi / 180;

    // Calculate Cartesian coordinates
    var xx = amplitude * cos(angle_rad);
    var yy = amplitude * sin(angle_rad);

    return [xx, yy];
}

function parse_coordinates(coord_str) {
    var separator_pos;
    var separator;
	
    // Check if the string contains 'j'
    if (string_pos("j", coord_str) <= 0) {
        return[global.local_player.x, global.local_player.y]; // Invalid input if 'j' is not present
    }
	
    // Remove 'j' from the string
    coord_str = string_replace_all(coord_str, "j", "");
    
    // Find the separator position
    if (string_pos("+", coord_str) > 0) {
        separator_pos = string_pos("+", coord_str);
        separator = "+";
    } else if (string_pos("-", coord_str) > 0) {
        separator_pos = string_pos("-", coord_str);
        separator = "-";
    } else {
        return[global.local_player.x, global.local_player.y]; // Fallback, should not happen with valid input
    }
    
    var x_str = string_copy(coord_str, 1, separator_pos - 1);
    var y_str = string_copy(coord_str, separator_pos + 1, string_length(coord_str) - separator_pos);
	
    // Validate extracted strings
    if (x_str == "" || y_str == "" || !is_real(real(x_str)) || !is_real(real(y_str))) {
        return[global.local_player.x, global.local_player.y];
    }
    
    // Add back the separator for y if it's negative
    if (separator == "-") {
        y_str = "-" + y_str;
    }
    
    // Convert to real numbers
    var xx = real(x_str);
    var yy = real(y_str);
    
    return [xx, yy];
}
	
angle_coordinates_callback_positive = function(InputText){
	var coordinates = parse_euler_coordinates(InputText);
	global.local_player.mortar_coordinates[0] = coordinates[0];
	global.local_player.mortar_coordinates[1] = coordinates[1];
}

coordinates_callback_positive = function(InputText){
	var coordinates = parse_coordinates(InputText);
	global.local_player.mortar_coordinates[0] = coordinates[0];
	global.local_player.mortar_coordinates[1] = coordinates[1];
};

position_x = zui_get_width() * .1;
position_y = zui_get_height() * .25;

with(zui_create(zui_get_width() * .5, position_y + string_height("a")*3, objUIButton)){
	zui_set_anchor(0.5, 0);
	zui_set_width(128 * global.GUIMultiplier);
	zui_set_height(32 * global.GUIMultiplier);
	caption = "Launch!";
	callback = function(){
		with(instance_nearest(global.local_player.x, global.local_player.y, oMortar)){
			stats = {
				Item_id: Item.base_explosion,
				Damage: global.ItemIndex[#Item.base_explosion, ItemStat.Damage],
				Object_index: global.local_player,
				Owner_name: instance_nearest(x, y, global.local_player).Name,
				Object: instance_nearest(x, y, global.local_player),
				Health_points: 100
			};

			explosion_create(30, global.local_player.mortar_coordinates[0], global.local_player.mortar_coordinates[1], stats.Damage, false, stats.Object, stats.Item_id);
		}
		//instance_create_layer(global.local_player.mortar_coordinates[0], global.local_player.mortar_coordinates[1], "OtherO", oMortarMissile);
	}
}

with (zui_create(position_x, position_y, objUILabel)) {
	color = c_white;
	caption = "Complex coordinates: ";
}

with(zui_create(position_x + string_width("Complex coordinates: "), position_y - string_height("a"), objUITextInput)){
	zui_set_anchor(0, 0);

	text = "0+j0";
	max_string_length = string_length("1000+j1000");
	callback = other.coordinates_callback_positive;
}

with (zui_create(position_x, position_y + string_height("a")*1.75, objUILabel)) {
	color = c_white;
	caption = "Complex magnitude and angle: ";
}

with(zui_create(position_x + string_width("Complex magnitude and angle: "), position_y + string_height("a")*.75, objUITextInput)){
	zui_set_anchor(0, 0);

	text = "0*e^j0";
	max_string_length = string_length("1000*e^j1000");
	callback = other.angle_coordinates_callback_positive;
}

