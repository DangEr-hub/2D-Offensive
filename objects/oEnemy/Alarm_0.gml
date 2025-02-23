/// @description Movement
function decide_movement() {
    if (hidden == false) {
        handle_basic_movement();
    } else {
        handle_smoke_movement();
    }
}

function handle_basic_movement() {
	if(stats.Health_points <= stats.Max_health_points / 3){
	    if (percent_chance(25 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) && State != States.MoveAway) {
	        State = States.MoveAway;
	    } else if (percent_chance(40 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) && State != States.MoveShoot) {
	        State = States.MoveShoot;
	    } else if(percent_chance(50 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) && State != States.MovePredictive){
			State = States.MovePredictive;
		} else {
	        choose_offensive_action();
	    }
	}else{
		if(percent_chance(10 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
			if(State != States.Move){
				State = States.Move;
			}
		}else if(percent_chance(10 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
			if(State != States.MoveShoot){
				State = States.MoveShoot;	
			}
		}else if(percent_chance(75 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
			if(State != States.MoveToward){
				State = States.MoveToward;	
			}
	    } else if(percent_chance(50 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) && State != States.MovePredictive){
			State = States.MovePredictive;
		}else{
			choose_offensive_action();
		}
	}
}

function handle_smoke_movement() {
    if (percent_chance(75 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) && State != States.MoveInSmoke) {
        State = States.MoveInSmoke;
    } else if (percent_chance(50 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])) && State != States.MoveAway) {
        State = States.MoveAway;
    } else if (State != States.MoveShoot) {
        State = States.MoveShoot;
    }
}

function choose_offensive_action() {
    if (percent_chance(50)) {
        ThrowGrenadeAI();
    } else {
        LayDownLandMineAI();
    }
}



if(instance_exists(ChasingObject) && ChasingObject != noone){
    
    alarm[0] = random_range(15, 25) * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]);
	
	if(check_if_available(ChasingObject) || ChasingObjectSpotted == true && global.EnemyCanMove == true){
		if(ChasingObjectSpotted == false){
			ReactionTimer = ReactionTime;
			ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game])));
		}
		if(ReactionTimer <= 0){
			if(State != States.Chase){	
				
				if(Flashed == false){
					if(SpottedDanger == false){
			
						#region Move away when low health
						if (stats.Health_points <= stats.Max_health_points / 3) {
						    if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
						        reload_ai();
						    } else if (healing == false && percent_chance(50 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))) {
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
									if(percent_chance(50 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
										if(State != States.MoveAwayFromGrenade){
											State = States.MoveAwayFromGrenade;
										}
									}else if (percent_chance(50 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
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
		
		if(distance_to_object(ChasingObject) <= ChasingDistance*2){
		
			if(Flashed == false){
			
				#region Move idle
				if(State != States.Idle){
					ChasingObjectSpotted = false;
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

if(global.EnemyCanMove == true){
	
	#region States
	switch(State){
		case States.MoveAway:
			if(ReactionTimer <= 0){
				MoveRunAway(ChasingObject.x, ChasingObject.y);
			}
		break;
		
		case States.MoveShoot:
			if(ReactionTimer <= 0){
				bot_move_shooting(ChasingObject.x, ChasingObject.y);
			}
		break;
		
		case States.Move:
			if(ReactionTimer <= 0){
				MoveRandom();
			}
		break;
		
		case States.Idle:
			if(percent_chance(10 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
				MoveIdle();
			}
		break;
		
		case States.MoveToward:
			if(ReactionTimer <= 0){
				MoveTowards(ChasingObject.x, ChasingObject.y, Acceleration);
			}
		break;
		
		case States.MoveAwayFromGrenade:
			if(ReactionTimer <= 0){
				MoveRunAway(NearestDangerX, NearestDangerY);
			}
		break;
		
		case States.ThrowGrenade:
			if(ReactionTimer <= 0){
				EnemyThrowGrenade(ChasingObject.x, ChasingObject.y);	
			}
		break;
	
		case States.LayDownLandMine:
			if(ReactionTimer <= 0){
				EnemyLayDownLandMine();	
			}
		break;
		
		case States.Chase:
			if(ReactionTimer <= 0){
				MoveTowards(ChasingObject.x, ChasingObject.y, Acceleration*2);
			}
		break;
		
		case States.MoveFlashed:
			if(ReactionTimer <= 0){
				if(percent_chance(50 * get_rank_boost(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
					MoveRunAway(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveInSmoke:
			if(ReactionTimer <= 0){
				if(percent_chance(10 * get_rank_less(global.player_elo_struct.Enemy_elo[global.player_elo_struct.Tracking_game]))){
					MoveIdle();
				}
			}
		break;
		
		case States.MoveHealing:
			if(ReactionTimer <= 0){
				MoveRunAway(ChasingObject.x, ChasingObject.y);
			}
		break;
		
		case States.MovePredictive:
			if(ReactionTimer <= 0){
				move_predictive(ChasingObject.x, ChasingObject.y)
			}
		break;
	}
	#endregion	

}

	
}