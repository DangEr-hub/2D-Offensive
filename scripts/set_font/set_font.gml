// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_font(Font){
	var draw_font;
	switch(Font){
		case "Console":
			if(global.gui_scale >= 2){
				draw_font = fnt_ConsoleMedium;
			}else if(global.gui_scale < 2){
				draw_font = fnt_ConsoleSmall;
			}
		break;
		
		case "GUI_grid":
			if(global.gui_scale >= 2){
				draw_font = fnt_GUIGridMedium;
			}else if(global.gui_scale < 2){
				draw_font = fnt_GUIGridSmall;
			}
		break;
		
		case "Title":
			if(global.gui_scale >= 2){
				draw_font = fnt_GUITitleMedium;
			}else if(global.gui_scale < 2){
				draw_font = fnt_GUITitleSmall;
			}
		break;
		
		case "GUI_small":
			if(global.gui_scale >= 2){
				draw_font = fnt_GUISmallMedium;
			}else if(global.gui_scale < 2){
				draw_font = fnt_GUISmallSmall;
			}
		break;
		
		case "Title_large":
			if(global.gui_scale >= 2){
				draw_font = fnt_GUITitleLargeMedium;
			}else if(global.gui_scale < 2){
				draw_font = fnt_GUITitleLargeSmall;
			}
		break;
		
		case "GUI_medium":
			if(global.gui_scale >= 2){
				draw_font = fnt_GUIMediumMedium;
			}else if(global.gui_scale < 2){
				draw_font = fnt_GUIMediumSmall;
			}
		break;
	}
	
	return draw_font;
}