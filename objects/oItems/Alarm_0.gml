/// @description Post-create event
ItemDeclare();
LightObject = instance_create_depth(x, y, depth, oObjectLightCircle);
LightObject.light[| eLight.Range] = sprite_width;
LightObject.light[| eLight.Color] = global.ItemIndex[#image_index, ItemStat.ItemColor];