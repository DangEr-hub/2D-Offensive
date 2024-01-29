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