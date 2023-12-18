// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_font(Font){
	switch(Font){
		case "Console":
			if(global.GUIMultiplier >= 2){
				draw_set_font(fnt_ConsoleMedium);	
			}else if(global.GUIMultiplier < 2){
				draw_set_font(fnt_ConsoleSmall);
			}
		break;
		
		case "GUI_button":
			if(global.GUIMultiplier >= 2){
				draw_set_font(fnt_GUIButtonMedium);	
			}else if(global.GUIMultiplier < 2){
				draw_set_font(fnt_GUIButtonSmall);
			}
		break;
		
		case "GUI_grid":
			if(global.GUIMultiplier >= 2){
				draw_set_font(fnt_GUIGridMedium);	
			}else if(global.GUIMultiplier < 2){
				draw_set_font(fnt_GUIGridSmall);
			}
		break;
		
		case "Title":
			if(global.GUIMultiplier >= 2){
				draw_set_font(fnt_GUITitleMedium);	
			}else if(global.GUIMultiplier < 2){
				draw_set_font(fnt_GUITitleSmall);
			}
		break;
	}
}