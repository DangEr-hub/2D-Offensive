var player_team = instance_exists(global.local_player)
	? global.local_player.stats.Team
	: global.player_stats.Player_team;
var enemy_team = player_team == TEAM.POLICE ? TEAM.TERRORIST : TEAM.POLICE;

repeat(5){
	var spawn_direction = image_angle + random_range(-fov * 0.5, fov * 0.5);
	var spawn_distance = random_range(96, fov_size * 0.5);
	var spawn_x = x + lengthdir_x(spawn_distance, spawn_direction);
	var spawn_y = y + lengthdir_y(spawn_distance, spawn_direction);
	var bot = instance_create_layer(spawn_x, spawn_y, "LivingO", oBot);

	bot.stats.Team = enemy_team;
	bot.has_defuse_kit = enemy_team == TEAM.POLICE && percent_chance(25);
	bot.sprite_index = enemy_team == TEAM.TERRORIST
		? choose(spr_TerroristChar, spr_TerroristChar2, spr_TerroristChar3, spr_TerroristChar4)
		: choose(spr_PoliceChar, spr_PoliceChar2, spr_PoliceChar3);
}
