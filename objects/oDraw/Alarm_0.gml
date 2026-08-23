if(!IS_NET){
	BackGround = sprite_create_from_surface(application_surface, 0, 0, global.GuiW, global.GuiH, false, true, 0, 0);
	instance_deactivate_all(true);
	instance_activate_object(oParticleSystem);
	instance_activate_object(oCamera);
	instance_activate_object(oGameEndMenu);
	instance_activate_object(oRatingController);
	instance_activate_object(objUIImage);
	instance_activate_object(oRoundEndMenu);
	instance_activate_object(oWeapon);
	instance_activate_object(objUIGrid);
instance_activate_object(oDamageTable);
instance_activate_object(oStatisticsTable);
instance_activate_object(objUILabel);
	instance_activate_object(objUISliderHandle);
	instance_activate_object(objUISlider);
	instance_activate_object(objUIButton);
	instance_activate_object(objUIWindowCaption);
	instance_activate_object(objZUIMain);
	instance_activate_object(objUIBlack);
	instance_activate_object(oPause);
	instance_activate_object(oConsole);
	instance_activate_object(oPlayer);
}else{
	BackGround = -2;
}
part_particles_clear(global.ParticleSystem);
