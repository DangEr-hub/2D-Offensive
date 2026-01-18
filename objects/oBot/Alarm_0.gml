/// @description Movement
/* Alarm 0 */
if(stats.Health_points <= 0){
	exit;
}

if(State == STATES.MoveCommand){
    alarm[0] = random_range(50, 100) * rank_less;
    return;
}
var rand = random(100);    
if(ChasingObjectSpotted == true && Flashed == false){
	if(ReactionTimer <= 0){
		if(State != STATES.Chase){	
			if(SpottedDanger == false){
			
				#region Move away when low health
				if (stats.Health_points <= stats.Max_health_points / 3) {
					if (Ammo[WeaponPositionID] <= 0 && Reloading == false) {
						reload_ai();
					} else if (healing == false && rand < (50 * rank_boost)) {
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

							if(rand < t1){
								if(State != STATES.MoveAwayFromGrenade){
									State = STATES.MoveAwayFromGrenade;
								}
							}else if(rand < t2){
								if(State != STATES.MoveShoot){
									State = STATES.MoveShoot;
								}
							}else if(rand < t3){
								ThrowGrenadeAI();
							}else{
								LayDownLandMineAI();
							}
						}else{
							set_state(STATES.MoveAwayFromGrenade);
						}
						#endregion
							
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
}
alarm[0] = random_range(50, 100) * rank_less;