if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && visible == true){
	if(other.stats.Object != MainObject || other.stats.Tracer_image == 2){
		var ObjectArmourID = global.ArmourID[0];
		var ObjectHelmetID = global.ArmourID[1];
		if(MainObject.object_index != oPlayer){ ///Pokud to neni hitbox hrace
			ObjectArmourID = MainObject.ArmourID;
			ObjectHelmetID = MainObject.HelmetID;
			MainObject.enemy_aimpunch_direction = point_direction(other.stats.Starting_x, other.stats.Starting_y, other.x, other.y);
			if(instance_exists(MainObject.ChasingObject)){
				if(other.stats.Object != oPlayer){
					if(MainObject.ChasingObject != other.stats.Object){
						MainObject.ChasingObject = other.stats.Object;
					}
				}else{
					MainObject.ChasingObject = oPlayer;
				}
			}
		}
		hit_entity(MainObject, image_index, other, ObjectArmourID, ObjectHelmetID);
		instance_destroy(other);
	}
}

