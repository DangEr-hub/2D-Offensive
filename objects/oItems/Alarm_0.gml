/// @description Post-create event
ItemDeclare();
LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
LightObject.castShadows = false;
LightObject.xscale = .5;
LightObject.yscale = .5;
LightObject.blend = global.ItemIndex[#image_index, ItemStat.ItemColor];