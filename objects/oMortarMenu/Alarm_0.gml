var mortar = instance_nearest(global.local_player.x, global.local_player.y, oMortar);
var bomb_x = mortar.x + global.local_player.mortar_coordinates[0];
var bomb_y = mortar.y - global.local_player.mortar_coordinates[1];
var missile = instance_create_layer(bomb_x, bomb_y, "OtherO", oMortarMissile);
missile.stats = mortar.stats;