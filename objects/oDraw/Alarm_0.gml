with(zui_main()){
	if(other.RoundEndMenu == false && other.GameEndMenu == false){
		with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oRespawnMenu, -1000)) {
			alpha_value = 0;
			alpha = global.GUIHUDAlpha * 2.25; 
			window_id = id;
		}
	}else if(other.RoundEndMenu == true){
		with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oRoundEndMenu, -1000)) {
			alpha_value = 0;
			alpha = global.GUIHUDAlpha * 2.25; 
			window_id = id;
		}
	}else if(other.GameEndMenu == true){
		with (zui_create(zui_get_width() * 0.5, zui_get_height() * 0.5, oGameEndMenu, -1000)) {
			alpha_value = 0;
			alpha = global.GUIHUDAlpha * 2.25; 
			window_id = id;
		}
	}
}
instance_deactivate_object(obj_light_renderer);
BackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
instance_deactivate_all(true);
instance_activate_object(oGameEndMenu);
instance_activate_object(oEggyEloRatingSystem);
instance_activate_object(objUIImage);
instance_activate_object(oRoundEndMenu);
instance_activate_object(oWeapon);
instance_activate_object(objUIGrid);
instance_activate_object(oRespawnMenu);
instance_activate_object(objUILabel);
instance_activate_object(objUISliderHandle);
instance_activate_object(objUISlider);
instance_activate_object(objUIButton);
instance_activate_object(objUIWindowCaption);
instance_activate_object(objZUIMain);
instance_activate_object(oPause);
instance_activate_object(oPlayer);
instance_activate_object(oConsole);