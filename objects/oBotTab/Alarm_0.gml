if(!instance_exists(target_bot) || !target_bot.Visible){
	zui_destroy();
	exit;
}

var bot_name = target_bot.stats.Name;
var bot_team = target_bot.stats.Team;
var team_name = bot_team == TEAM.POLICE ? "Police" : "Terrorist";
var team_color = bot_team == TEAM.POLICE ? c_blue : c_red;
var primary_name = target_bot.WeaponID[0] == Item.None
	? "None"
	: global.ItemIndex[# target_bot.WeaponID[0], ItemStat.Name];
var secondary_name = target_bot.WeaponID[1] == Item.None
	? "None"
	: global.ItemIndex[# target_bot.WeaponID[1], ItemStat.Name];
var helmet_name = target_bot.HelmetID == Item.None
	? "None"
	: global.ItemIndex[# target_bot.HelmetID, ItemStat.Name];
var armour_name = target_bot.ArmourID == Item.None
	? "None"
	: global.ItemIndex[# target_bot.ArmourID, ItemStat.Name];
var health_text = "Health: " + string(round(target_bot.stats.Health_points)) + "/" + string(round(target_bot.stats.Max_health_points));
var weight_text = "Weight: " + string_format(target_bot.stats.Weight, 0, 1) + " kg";
var height_text = "Height: " + string_format(target_bot.stats.Height, 0, 1) + " cm";
var age_text = "Age: " + string(round(target_bot.stats.Age)) + " years";
var helmet_text = "Helmet: " + helmet_name;
var armour_text = "Body: " + armour_name;
var primary_text = "Primary weapon: " + primary_name;
var secondary_text = "Secondary weapon: " + secondary_name;
var he_grenade_text = "HE grenades: " + string(target_bot.Grenades[0]);
var flash_grenade_text = "Flash grenades: " + string(target_bot.Grenades[1]);
var smoke_grenade_text = "Smoke grenades: " + string(target_bot.Grenades[2]);
var molotov_grenade_text = "Molotov grenades: " + string(target_bot.Grenades[3]);
var health_pack_text = "Health packs: " + string(target_bot.health_packs);

draw_set_font(set_font("GUI_small"));
var start_x = zui_get_width() * .08;
var start_y = zui_get_height() * .125;
var row_height = string_height("A") * 1.35;
var team_value_x = start_x + string_width("Team: ");

with(zui_create(0, 0, objUIWindowCaption, depth - 1)){
	caption = bot_name;
	draggable = 1;
}

with(zui_create(start_x, start_y, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = "Team:";
}
with(zui_create(team_value_x, start_y, objUILabel)){
	font = set_font("GUI_small");
	color = team_color;
	caption = team_name;
}
with(zui_create(start_x, start_y + row_height, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = health_text;
}
with(zui_create(start_x, start_y + row_height * 2, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = weight_text;
}
with(zui_create(start_x, start_y + row_height * 3, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = height_text;
}
with(zui_create(start_x, start_y + row_height * 4, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = age_text;
}
with(zui_create(start_x, start_y + row_height * 6, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = helmet_text;
}
with(zui_create(start_x, start_y + row_height * 7, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = armour_text;
}
with(zui_create(start_x, start_y + row_height * 9, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = primary_text;
}
with(zui_create(start_x, start_y + row_height * 10, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = secondary_text;
}
with(zui_create(start_x, start_y + row_height * 12, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = he_grenade_text;
}
with(zui_create(start_x, start_y + row_height * 13, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = flash_grenade_text;
}
with(zui_create(start_x, start_y + row_height * 14, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = smoke_grenade_text;
}
with(zui_create(start_x, start_y + row_height * 15, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = molotov_grenade_text;
}
with(zui_create(start_x, start_y + row_height * 17, objUILabel)){
	font = set_font("GUI_small");
	color = c_white;
	caption = health_pack_text;
}
