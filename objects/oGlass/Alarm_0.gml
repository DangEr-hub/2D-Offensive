/// @description Create building entrance
var entrance = instance_create_layer(x, y, "OtherO", oRoofTrigger);
var w = bbox_right - bbox_left;
var h = bbox_bottom - bbox_top;
entrance.image_xscale = w/sprite_get_width(spr_TileCollision) * .9;
entrance.image_yscale = h/sprite_get_height(spr_TileCollision) * .9;
entrance.building_id = building_id;












