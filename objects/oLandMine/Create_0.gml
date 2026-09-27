Visible = true;
min_alpha = .05;
alpha_color = [c_red, c_aqua, c_yellow];
image_speed = 0;
alpha_timer = 1 * game_get_speed(gamespeed_fps);
explosion_distance = 48;
image_timer = -1;
explosion_timer = 1 * game_get_speed(gamespeed_fps);
image_angle = random(359);
explode = false;
image_index = choose(0, 4, 8);
ImageIndex = image_index;
alarm[0] = 1;


stats = {
	Owner_name: "No one",
	Object: noone,
	Item_id: ITEM.None,
	Object_index: -1
};

switch(image_index){
	case 0: stats.Item_id = ITEM.HELandMine; stats.Owner_name = global.ItemIndex[# ITEM.HELandMine, ITEMSTATS.Name]; break;
	case 4: stats.Item_id = ITEM.CELandMine;stats.Owner_name = global.ItemIndex[# ITEM.CELandMine, ITEMSTATS.Name];  break;
	case 8: stats.Item_id = ITEM.LELandMine;stats.Owner_name = global.ItemIndex[# ITEM.LELandMine, ITEMSTATS.Name]; break;
}