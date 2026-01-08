/// @description Movement
/* Alarm 0 */
if(stats.Health_points <= 0){
	exit;
}

if(State == States.MoveCommand){
    alarm[0] = random_range(15, 25) * rank_less;
    return;
}


var rng = random(100);    
if(instance_exists(ChasingObject) && ChasingObjectSpotted == true){
	if(ReactionTimer <= 0){
		if(State != States.Chase){	
				
			if(Flashed == false){
				if(SpottedDanger == false){
			
					#region Move away when low health
					if (stats.Health_points <= stats.Max_health_points / 3) {
						if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
							reload_ai();
						} else if (healing == false && rng < (50 * rank_boost)) {
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
					
					#region Move away from grenade or landmine or bomb
						if(Ammo[WeaponPositionID] <= 0){
							if(Reloading == true){
								reload_ai();
							}				
						}else{
							
							#region Basic movement
							if(NearestDangerObject != id){
								var t1 = 50 * rank_boost;
								var t2 = t1 + (50 * rank_less);
								var t3 = t2 + 25; // grenade
								// zbytek = landmine

								if(rng < t1){
									if(State != States.MoveAwayFromGrenade){
										State = States.MoveAwayFromGrenade;
									}
								}else if(rng < t2){
									if(State != States.MoveShoot){
										State = States.MoveShoot;
									}
								}else if(rng < t3){
									ThrowGrenadeAI();
								}else{
									LayDownLandMineAI();
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

alarm[0] = random_range(15, 25) * rank_less;