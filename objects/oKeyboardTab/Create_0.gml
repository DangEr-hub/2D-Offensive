event_inherited();
tab_width = 768 * global.GUIMultiplier;
tab_height = 512 * global.GUIMultiplier;
draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);

pos_x = zui_get_width() * .01;
pos_y = zui_get_height() * .1;
gap = 170 * global.GUIMultiplier;
text_height = string_height("a")*1.75;
popup = noone;

waiting_keybind = false;
waiting_index = -1;
waiting_button = noone;

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Keyboard configuration";
	draggable = 1;
}

draw_set_font(set_font("Console"));

captions = [
	"Up", "Left", "Down", "Right",
	"Open inventory", "Pick up", "Cycle item left",
	"Cycle item right", "Shoot", "Reload",
	"Grenade throw", "Pause", "Toggle night vision", "Change shooting mode",
	"Prone", "Show attachments", "Select bot", "Command bot",
	"Open buy menu", "Hold stamina", "Drop weapon", "Cycle inventory left",
	"Cycle inventory right", "Cycle inventory up", "Cycle inventory down",
	"Open console", "Knife light attack", "Knife heavy attack", "Use item",
	"Scope",
];

var rows = floor(tab_height/text_height) - 2;
var count = array_length(captions);

for(i = 0;i < rows;i ++){

	with(zui_create(pos_x, pos_y + i*text_height, objUILabel)){
		color = c_white;
		caption = other.captions[other.i];
	}

	with(zui_create(pos_x + gap, pos_y + i*text_height - text_height/3, objUIButton)){
		zui_set_anchor(0.5, 0);
		idx = other.i;
		caption = keycode_to_string(global.KeyBinds[| other.i]);
		zui_set_width(min(string_width(caption) * global.GUIMultiplier, 128 * global.GUIMultiplier));
		zui_set_height(16 * global.GUIMultiplier);
	
	    callback = function(){
	        oKeyboardTab.waiting_keybind = true;
	        oKeyboardTab.waiting_index = idx;
	        oKeyboardTab.waiting_button = id;
	        caption = "-";
	    };
	}

}

for(var k = 0; k < rows; k++){
    idx = k + rows;
    if(idx >= count){ break; }

    with(zui_create(pos_x + gap * 1.5, pos_y + k * text_height, objUILabel)){
        color = c_white;
        caption = other.captions[other.idx];
    }

    with(zui_create(pos_x + gap * 2.5, pos_y + k * text_height - text_height / 3, objUIButton)){
        zui_set_anchor(0.5, 0);
		idx = other.idx;
        caption = keycode_to_string(global.KeyBinds[| idx]);
        zui_set_width(min(string_width(caption) * global.GUIMultiplier, 128 * global.GUIMultiplier));
        zui_set_height(16 * global.GUIMultiplier);
	    callback = function(){
	        oKeyboardTab.waiting_keybind = true;
	        oKeyboardTab.waiting_index = idx;
	        oKeyboardTab.waiting_button = id;
	        caption = "-";
	    };
    }
}

reset_callback = function(){
	oKeyboardTab.popup = ui_show_popup("Are you sure?", "Exit", "Yes", "No", 288 * global.GUIMultiplier, 128 * global.GUIMultiplier, popup_reset_callback_positive, -1);
}

popup_reset_callback_positive = function(){
	// přepiš keybindy na default
	ds_list_copy(global.KeyBinds, global.DefaultKeyBinds);

	// projdi všechny UI buttony v tomhle tabu a updatuj caption
	with(objUIButton){
		if(idx != -1){
		    caption = keycode_to_string(global.KeyBinds[| idx]);
		    zui_set_width(
		        min(string_width(caption) * global.GUIMultiplier, 128 * global.GUIMultiplier)
		    );
		}
	}	
	
	with (oKeyboardTab.popup) {
		with (black){
			zui_destroy();
		}

		zui_destroy();
	}
}

with(zui_create(zui_get_width() * .5, zui_get_height() * .9, objUIButton)){
    zui_set_anchor(0.5, 0);
    zui_set_width(128 * global.GUIMultiplier);
    zui_set_height(16 * global.GUIMultiplier);
	caption = "Reset";
	callback = oKeyboardTab.reset_callback;
}






