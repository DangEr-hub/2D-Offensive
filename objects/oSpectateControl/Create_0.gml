candidate_bots = [];
selected_index = -1;
menu_button = noone;

if(!instance_exists(global.local_player) || IS_NET){
	instance_destroy();
	exit;
}

var nearby_bots = ds_list_create();
var bot_count = collision_circle_list(x, y, BOT_SELECT_RADIUS, oBot,
	false, false, nearby_bots, true);
for(var bot_index = 0; bot_index < bot_count; bot_index++){
	var bot = nearby_bots[| bot_index];
	if(bot.stats.Team == global.local_player.stats.Team
	&& bot.stats.Health_points > 0
	&& point_distance(x, y, bot.x, bot.y) <= BOT_SELECT_RADIUS){
		array_push(candidate_bots, bot);
	}
}
ds_list_destroy(nearby_bots);

show_menu = function(){
	oDraw.spectating = false;
	oDraw.spectate_target = noone;
	if(instance_exists(menu_button)){
		with(menu_button) zui_destroy();
		menu_button = noone;
	}
	with(oRoundEndMenu) zui_set_visible(true);
	with(oGameEndMenu) zui_set_visible(true);
	with(objUIBlack) zui_set_visible(true);
	var living_bot_found = false;
	for(var bot_index = 0; bot_index < array_length(candidate_bots); bot_index++){
		var bot = candidate_bots[bot_index];
		if(instance_exists(bot) && bot.stats.Health_points > 0){
			living_bot_found = true;
			break;
		}
	}
	if(!living_bot_found && instance_exists(oRoundEndMenu)
	&& instance_exists(oRoundEndMenu.spectate_button)){
		with(oRoundEndMenu.spectate_button) zui_set_visible(false);
	}
};

select_next_bot = function(){
	var bot_count = array_length(candidate_bots);
	for(var offset = 1; offset <= bot_count; offset++){
		var next_index = (selected_index + offset) mod bot_count;
		var bot = candidate_bots[next_index];
		if(instance_exists(bot) && bot.stats.Team == global.local_player.stats.Team && bot.stats.Health_points > 0){
			selected_index = next_index;
			oDraw.spectate_target = bot;
			return true;
		}
	}
	return false;
};

begin_spectate = function(){
	if(instance_exists(oGameController) && oGameController.round_ended) return;
	var nearest_distance = 1000000000;
	selected_index = -1;
	for(var bot_index = 0; bot_index < array_length(candidate_bots); bot_index++){
		var bot = candidate_bots[bot_index];
		if(instance_exists(bot) && bot.stats.Team == global.local_player.stats.Team && bot.stats.Health_points > 0){
			var bot_distance = point_distance(x, y, bot.x, bot.y);
			if(bot_distance < nearest_distance){
				nearest_distance = bot_distance;
				selected_index = bot_index;
			}
		}
	}
	if(selected_index < 0){
		show_menu();
		return;
	}

	oDraw.spectate_target = candidate_bots[selected_index];
	oDraw.spectating = true;
	with(oRoundEndMenu) zui_set_visible(false);
	with(oGameEndMenu) zui_set_visible(false);
	with(objUIBlack) zui_set_visible(false);

	with(zui_main()){
		other.menu_button = zui_create(zui_get_width() * .5, zui_get_height() * .82, objUIButton, -999);
	}
	with(menu_button){
		zui_set_anchor(.5, 0);
		zui_set_width(160 * global.gui_scale);
		zui_set_height(28 * global.gui_scale);
		caption = "Respawn menu";
		callback = function(){ with(oSpectateControl) show_menu(); };
	}
};
