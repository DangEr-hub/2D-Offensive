function keycode_to_string(keycode){
    switch(keycode){
        // Modifikátory
        case vk_shift:     return "Shift";
        case vk_control:   return "Ctrl";
        case vk_lcontrol:  return "Left Ctrl";
        case vk_alt:       return "Alt";

        // Speciální
        case vk_space:     return "Space";
        case vk_escape:    return "Esc";
        case vk_enter:     return "Enter";
        case vk_tab:       return "Tab";
        case vk_backspace: return "Backspace";

        // Šipky
        case vk_up:        return "Up";
        case vk_down:      return "Down";
        case vk_left:      return "Left";
        case vk_right:     return "Right";

        // Funkční klávesy
        case vk_f1:  return "F1";
        case vk_f2:  return "F2";
        case vk_f3:  return "F3";
        case vk_f4:  return "F4";
        case vk_f5:  return "F5";
        case vk_f6:  return "F6";
        case vk_f7:  return "F7";
        case vk_f8:  return "F8";
        case vk_f9:  return "F9";
        case vk_f10: return "F10";
        case vk_f11: return "F11";
        case vk_f12: return "F12";

        // Myš
        case mb_left:      return "LMB";
        case mb_right:     return "RMB";
        case mb_middle:    return "MMB";

        // Konzole
        case 192:          return ";";

        // --- NUMPAD ---
        case vk_numpad0: return "Num 0";
        case vk_numpad1: return "Num 1";
        case vk_numpad2: return "Num 2";
        case vk_numpad3: return "Num 3";
        case vk_numpad4: return "Num 4";
        case vk_numpad5: return "Num 5";
        case vk_numpad6: return "Num 6";
        case vk_numpad7: return "Num 7";
        case vk_numpad8: return "Num 8";
        case vk_numpad9: return "Num 9";

        case vk_add:      return "Num +";
        case vk_subtract: return "Num -";
        case vk_multiply: return "Num *";
        case vk_divide:   return "Num /";
        case vk_decimal:  return "Num .";

        default:
            // PÍSMENA A–Z
            if(keycode >= ord("A") && keycode <= ord("Z")){
                return chr(keycode);
            }

            // HORNÍ ČÍSLA 0–9
            if(keycode >= ord("0") && keycode <= ord("9")){
                return chr(keycode);
            }

            return "Unknown";
    }
}
