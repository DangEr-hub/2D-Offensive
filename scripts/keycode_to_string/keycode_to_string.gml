function keycode_to_string(keycode) {
    switch (keycode) {
        case vk_shift: return "Shift"; break;
        case vk_control: return "Control"; break;
        case vk_alt: return "Alt"; break;
		case mb_left: return "MB left"; break;
		case mb_right: return "MB right"; break;
		case ord("G"): return  "G"; break;
		case ord("Q"): return "Q"; break;
		case ord("E"): return "E"; break;
		case ord("F"): return "F"; break;
		case ord("W"): return "W"; break;
		case ord("A"): return "A"; break;
		case ord("S"): return "S"; break;
		case ord("D"): return "D"; break;
		case ord("R"): return "R"; break;
		case ord("V"): return "V"; break;
		case ord("Y"): return "Y"; break;
        default: return "Key"; break;
    }
}