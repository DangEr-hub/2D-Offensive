/// @description Create background image
_surface = surface_create(global.GuiW, global.GuiH);
BackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
instance_deactivate_all(true);
instance_activate_object(oPlayer);
instance_activate_object(oConsole);