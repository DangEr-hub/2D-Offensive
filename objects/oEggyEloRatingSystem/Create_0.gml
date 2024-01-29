/// @description Insert description here
// You can write your code in this editor
get_accuracy = function(AllShots, HitShots){
	var accuracy = 0;
	if(AllShots != 0){
		accuracy = HitShots/AllShots;
	}
	
	return accuracy;
};

hit_shots = 0;
all_shots = 0;
player_win = false;
headshots = 0;
kills = 0;
current_round = 0;
playing_time = 0;
round_ended = false;






