/// @description Movement
if(State == States.MoveCommand){
    alarm[0] = random_range(15, 25) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
    return;
}


function decide_movement() {
    if (hidden == false) {
        handle_basic_movement();
    } else {
        handle_smoke_movement();
    }
}

function handle_basic_movement() {
	if(stats.Health_points <= stats.Max_health_points / 3){
	    if (percent_chance(25 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])) && State != States.MoveAway) {
	        State = States.MoveAway;
	    } else if (percent_chance(40 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])) && State != States.MoveShoot) {
	        State = States.MoveShoot;
	    } else if(percent_chance(50 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])) && State != States.MovePredictive){
			State = States.MovePredictive;
		} else {
	        choose_offensive_action();
	    }
	}else{
		if(percent_chance(10 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.Move);
		}else if(percent_chance(10 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.MoveShoot);
		}else if(percent_chance(75 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.MoveToward);
	    } else if(percent_chance(50 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
			set_state(States.MovePredictive);
		}else{
			choose_offensive_action();
		}
	}
}

function handle_smoke_movement() {
    if (percent_chance(75 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])) && State != States.MoveInSmoke) {
		set_state(States.MoveInSmoke);
    } else if (percent_chance(50 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])) && State != States.MoveAway) {
			set_state(States.MoveAway);
    } else {
		set_state(States.MoveShoot);
    }
}

function choose_offensive_action() {
    if (percent_chance(50)) {
        ThrowGrenadeAI();
    } else {
        LayDownLandMineAI();
    }
}

    
alarm[0] = random_range(15, 25) * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]);
	
if(instance_exists(ChasingObject) && (check_if_available(ChasingObject) || ChasingObjectSpotted == true)){
	if(ChasingObjectSpotted == false){
		ReactionTimer = ReactionTime;
		ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
	}
	if(ReactionTimer <= 0){
		if(State != States.Chase){	
				
			if(Flashed == false){
				if(SpottedDanger == false){
			
					#region Move away when low health
					if (stats.Health_points <= stats.Max_health_points / 3) {
						if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
							reload_ai();
						} else if (healing == false && percent_chance(50 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))) {
							if (health_packs > 0) {
								healing_ai();
							    healing = true;
								health_packs --;
							} else {
							    decide_movement();
							}
						} else {
							decide_movement();
						}
					}
					#endregion
		
					#region Moving when not low health
					if(stats.Health_points > stats.Max_health_points/3){
				
						if(Ammo[WeaponPositionID] <= 0){
							if(Reloading == true){
								reload_ai();
							}				
						}else{	
							decide_movement();
						}
					}
					#endregion
				
				}else{
					
					#region Move away from grenade or landmine
						if(Ammo[WeaponPositionID] <= 0){
							if(Reloading == true){
								reload_ai();
							}				
						}else{
							
							#region Basic movement
							if(NearestDangerObject != id){
								if(percent_chance(50 * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
									if(State != States.MoveAwayFromGrenade){
										State = States.MoveAwayFromGrenade;
									}
								}else if (percent_chance(50 * get_rank_less(global.rating_struct.Enemy_ep[global.rating_struct.Current_game]))){
									if(State != States.MoveShoot){
										State = States.MoveShoot;	
									}
								}else{
									if(percent_chance(50)){
										ThrowGrenadeAI();
									}else{
										LayDownLandMineAI();
									}
								}
							}else{
								if(State != States.MoveAwayFromGrenade){
									State = States.MoveAwayFromGrenade;	
								}
							}
							#endregion
							
						}
					#endregion
				
				}				
			}else{
					
				#region Move flashed
				if(State != States.MoveFlashed){
					State = States.MoveFlashed;
				}			
				#endregion
					
			}
		}else{	
				
			#region Chase when player has hostage
			if(Ammo[WeaponPositionID] <= 0){
				if(Reloading == true){
					reload_ai();
				}
			
			}
			#endregion
		
		}
	}
}else{
		
	if((instance_exists(ChasingObject) && distance_to_object(ChasingObject) <= ChasingDistance*2) || !instance_exists(ChasingObject)){
		
		if(Flashed == false){
			
			#region Move idle
			if(State != States.Idle){
				//ChasingObjectSpotted = false;
				State = States.Idle;
			}
			#endregion
			
		}else{
			
			#region Move flashed
			if(State != States.MoveFlashed){
				State = States.MoveFlashed;
			}			
			#endregion
			
		}
		
	}
}