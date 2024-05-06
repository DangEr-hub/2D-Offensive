if(player_has_machine_gun()){
	for(var i = 0;i<weapon_attachments.Total;i++){
		global.weapon_attachments[0][i] = Item.None;
	}
	global.weapon_id[0] = Item.None;
	global.ClipAmmo[0] = 0;
	global.Ammo[0] = 0;
	global.MaxAmmo[0] = 0;
}
with(zui_main()){
	zui_destroy();
}
surface_free(NightVisionSurface);
surface_free(zoomSurface);
surface_free(GrayScaleSurface);
surface_free(BlurSurface);
surface_free(Surface1);
surface_free(Surface2);
if(sprite_exists(BackGround) && BackGround != -1){sprite_delete(BackGround);}