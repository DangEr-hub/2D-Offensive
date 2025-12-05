
if(player_has_machine_gun()){
	for(var i = 0;i<weapon_attachments.Total;i++){
		global.weapon_attachments[0][i] = Item.None;
	}
	global.Inventory[# OtherSlot.Primary, Index.slot_id] = Item.None;
	global.Inventory[# OtherSlot.Primary, Index.slot_ammo] = 0;
	global.Inventory[# OtherSlot.Primary, Index.slot_clip_ammo] = 0;
	global.ItemIndex[# global.Inventory[# OtherSlot.Primary, Index.slot_id], ItemStat.MaxAmmo] = 0;
}
with(zui_main()){
	zui_destroy();
}
/*surface_free(NightVisionSurface);
surface_free(zoomSurface);
surface_free(GrayScaleSurface);
surface_free(BlurSurface);
surface_free(Surface1);
surface_free(Surface2);*/

ds_list_destroy(hazePoints);
ds_list_destroy(hazeAreas);
//surface_free(hazeSurf);

if surface_exists(post_surface) surface_free(post_surface);
if surface_exists(haze_point_surface) surface_free(haze_point_surface);
if surface_exists(haze_final_surface) surface_free(haze_final_surface);
if surface_exists(nightvision_surface) surface_free(nightvision_surface);
if surface_exists(bloom_surface1) surface_free(bloom_surface1);
if surface_exists(bloom_surface2) surface_free(bloom_surface2);


if(sprite_exists(BackGround) && BackGround > -1){sprite_delete(BackGround);}