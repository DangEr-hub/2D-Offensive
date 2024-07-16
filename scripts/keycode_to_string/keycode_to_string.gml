function keycode_to_string(keycode) {
    switch (keycode) {
        case vk_shift: return "Shift"; 
        case vk_control: return "Control"; 
        case vk_alt: return "Alt"; 
		case mb_left: return "MB left"; 
		case mb_right: return "MB right"; 
		case ord("G"): return  "G"; 
		case ord("Q"): return "Q"; 
		case ord("E"): return "E"; 
		case ord("F"): return "F"; 
		case ord("W"): return "W"; 
		case ord("A"): return "A"; 
		case ord("S"): return "S"; 
		case ord("D"): return "D"; 
		case ord("R"): return "R"; 
		case ord("V"): return "V"; 
		case ord("Y"): return "Y"; 
		case vk_space: return "Space";
        default: return "Key"; 
    }
}