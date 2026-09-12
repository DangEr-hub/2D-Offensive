/// @description Change key
event_inherited();
if(waiting_keybind){
    if(keyboard_check_pressed(vk_anykey)){
        var key = keyboard_lastkey;

        global.KeyBinds[| waiting_index] = key;

        if(instance_exists(waiting_button)){
            with(waiting_button){
                caption = keycode_to_string(key);
                zui_set_width(min(string_width(caption) * global.gui_scale, 128 * global.gui_scale));
            }
        }

        waiting_keybind = false;
        waiting_index = -1;
        waiting_button = noone;
    }
}


