/// @description Movement
function decide_movement() {
    if (InSmoke == false) {
        handle_basic_movement();
    } else {
        handle_smoke_movement();
    }
}

function handle_basic_movement() {
    if (PercentChance(25 * get_rank_boost()) && State != States.MoveAway) {
        State = States.MoveAway;
    } else if (PercentChance(50 * get_rank_less()) && State != States.MoveShoot) {
        State = States.MoveShoot;
    } else {
        choose_offensive_action();
    }
}

function handle_smoke_movement() {
    if (PercentChance(75 * get_rank_boost()) && State != States.MoveInSmoke) {
        State = States.MoveInSmoke;
    } else if (PercentChance(50 * get_rank_less()) && State != States.MoveAway) {
        State = States.MoveAway;
    } else if (State != States.MoveShoot) {
        State = States.MoveShoot;
    }
}

function choose_offensive_action() {
    if (PercentChance(50)) {
        ThrowGrenadeAI();
    } else {
        LayDownLandMineAI();
    }
}



if(instance_exists(ChasingObject) && State != States.Death){
    randomize();
    alarm[0] = random_range(15, 25) * get_rank_less();
	
	if(CheckIfAvailable(ChasingObject) || ChasingObjectSpotted == true && global.EnemyCanMove == true){
		if(ChasingObjectSpotted == false){
			ReactionTimer = ReactionTime;
			ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost()));
		}
		if(ReactionTimer <= 0){
			if(State != States.Chase){	
				
				if(Flashed == false){
					if(SpottedDanger == false){
			
						#region Move away when low HP
						if (HP <= MaxHP / 3) {
						    if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
						        reload_ai();
						    } else if (healing == false && PercentChance(50 * get_rank_boost())) {
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
		
						#region Moving when not low HP
						if(HP > MaxHP/3){
				
							if(Ammo[WeaponPositionID] <= 0){
								if(Reloading == true){
									reload_ai();
								}				
							}else{	
								if(InSmoke == false){
					
								#region Basic movement
								if(PercentChance(50 * get_rank_less())){
									if(State != States.Move){
										State = States.Move;
									}
								}else if(PercentChance(75 * get_rank_boost())){
									if(State != States.MoveShoot){
										State = States.MoveShoot;	
									}
								}else if(PercentChance(25 * get_rank_less())){
									if(State != States.MoveToward){
										State = States.MoveToward;	
									}
								}else{
									if(PercentChance(50)){
										ThrowGrenadeAI();
									}else{
										LayDownLandMineAI();
									}
								}
								#endregion
								
								}else{
								
									#region In smoke movement
									if(PercentChance(50 * get_rank_boost())){
										if(State != States.MoveInSmoke){
											State = States.MoveInSmoke;
										}
									}else if(PercentChance(50 * get_rank_less())){
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
									if(PercentChance(50 * get_rank_boost())){
										if(State != States.MoveAwayFromGrenade){
											State = States.MoveAwayFromGrenade;
										}
									}else if (PercentChance(50 * get_rank_less())){
										if(State != States.MoveShoot){
											State = States.MoveShoot;	
										}
									}else{
										if(PercentChance(50)){
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
		
		if(distance_to_object(oPlayer) <= ChasingDistance*2){
		
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
			if(PercentChance(10)){
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
				if(PercentChance(50 * get_rank_boost())){
					MoveRunAway(ChasingObject.headshot_x, ChasingObject.headshot_y);
				}
			}
		break;
		
		case States.MoveInSmoke:
			if(ReactionTimer <= 0){
				if(PercentChance(10 * get_rank_less())){
					MoveIdle();
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