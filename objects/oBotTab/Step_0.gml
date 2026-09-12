event_inherited();

var invalid_target = !instance_exists(target_bot);
var hidden_target = !invalid_target && !target_bot.Visible;
var blocked_enemy = !invalid_target
	&& !global.sudo
	&& instance_exists(global.local_player)
	&& target_bot.stats.Team != global.local_player.stats.Team;
var game_menu_open = instance_exists(oDraw)
	&& (oDraw.PauseMenu || oDraw.RespawnMenu || oDraw.GameEndMenu);
var crosshair_too_far = !instance_exists(oCrosshair)
	|| (!invalid_target && point_distance(oCrosshair.x, oCrosshair.y, target_bot.x, target_bot.y) > 256);

if(invalid_target || hidden_target || blocked_enemy || game_menu_open || crosshair_too_far){
	zui_destroy();
}
