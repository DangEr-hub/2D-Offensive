/// @description Movement
function decide_movement() {
    if (InSmoke == false) {
        handle_basic_movement();
    } else {
        handle_smoke_movement();
    }
}

function handle_basic_movement() {
    if (percent_chance(25) && State != States.MoveAway) {
        State = States.MoveAway;
    } else if (percent_chance(50) && State != States.MoveShoot) {
        State = States.MoveShoot;
    } else {
        choose_offensive_action();
    }
}

function handle_smoke_movement() {
    if (percent_chance(75) && State != States.MoveInSmoke) {
        State = States.MoveInSmoke;
    } else if (percent_chance(50) && State != States.MoveAway) {
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
    randomize();
    alarm[0] = random_range(15, 25);
	
	if(CheckIfAvailable(ChasingObject) || ChasingObjectSpotted == true && global.EnemyCanMove == true){
		if(ChasingObjectSpotted == false){
			ReactionTimer = ReactionTime;
			ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps)));
		}
		if(ReactionTimer <= 0){
			if(State != States.Chase){	
				
				if(Flashed == false){
					if(SpottedDanger == false){
			
						#region Move away when low health
						if (stats.Health_points <= stats.Max_health_points / 3) {
						    if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
						        reload_ai();
						    } else if (healing == false && percent_chance(50)) {
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
								if(InSmoke == false){
					
								#region Basic movement
								if(percent_chance(50)){
									if(State != States.Move){
										State = States.Move;
									}
								}else if(percent_chance(75)){
									if(State != States.MoveShoot){
										State = States.MoveShoot;	
									}
								}else if(percent_chance(25)){
									if(State != States.MoveToward){
										State = States.MoveToward;	
									}
								}else{
									if(percent_chance(50)){
										ThrowGrenadeAI();
									}else{
										LayDownLandMineAI();
									}
								}
								#endregion
								
								}else{
								
									#region In smoke movement
									if(percent_chance(50)){
										if(State != States.MoveInSmoke){
											State = States.MoveInSmoke;
										}
									}else if(percent_chance(50)){
										if(State != States.MoveAway){
											State = States.MoveAway;	
										}
									}else{
										if(State != States.MoveShoot){
											State = States.MoveShoot;	
										}
									}
									#endregion
								
								}
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
									if(percent_chance(50)){
										if(State != States.MoveAwayFromGrenade){
											State = States.MoveAwayFromGrenade;
										}
									}else if (percent_chance(50)){
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
				MoveShooting(ChasingObject.x, ChasingObject.y);
			}
		break;
		
		case States.Move:
			if(ReactionTimer <= 0){
				MoveRandom();
			}
		break;
		
		case States.Idle:
			if(percent_chance(10)){
				MoveIdle(true);
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
				if(percent_chance(50)){
					MoveRunAway(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveInSmoke:
			if(ReactionTimer <= 0){
				if(percent_chance(10)){
					MoveIdle(true);
				}
			}
		break;
		
		case States.MoveHealing:
			if(ReactionTimer <= 0){
				MoveRunAway(ChasingObject.x, ChasingObject.y);
			}
		break;
	}
	#endregion	

}
























	
}