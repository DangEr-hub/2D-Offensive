/// @description Create background image
BackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
instance_deactivate_all(true);
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