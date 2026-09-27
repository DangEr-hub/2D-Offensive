if(!instance_exists(oDraw) || !oDraw.spectating || !instance_exists(oDraw.spectate_target)) exit;

draw_set_font(set_font("GUI_small"));
var take_prompt = "Take [" + keycode_to_string(global.KeyBinds[| KEY.TakeBot]) + "]";
draw_text_outlined(round(global.GuiW * .5 - string_width(take_prompt) * .5),
	round(global.GuiH * .9), take_prompt, c_white, c_black, 1);
