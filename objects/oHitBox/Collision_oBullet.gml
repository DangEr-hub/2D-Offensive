if(other.is_remote == false){
	if(other.stats.Object != MainObject || other.stats.Tracer_image == 2){
		var ObjectArmourID = global.Inventory[# OtherSlot.Armour, Index.slot_id];
		var ObjectHelmetID = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
		var ObjectShieldID = global.Inventory[# OtherSlot.Shield, Index.slot_id];
		if(MainObject.object_index != oPlayer){ ///Pokud to neni hitbox hrace
			ObjectArmourID = MainObject.ArmourID;
			ObjectHelmetID = MainObject.HelmetID;
			ObjectShieldID = MainObject.ShieldID;
			MainObject.enemy_aimpunch_direction = point_direction(other.stats.Starting_x, other.stats.Starting_y, other.x, other.y);
			if(instance_exists(MainObject.ChasingObject)){
				if(other.stats.Object != global.local_player){
					if(MainObject.ChasingObject != other.stats.Object){
						MainObject.ChasingObject = other.stats.Object;
					}
				}else{
					MainObject.ChasingObject = global.local_player;
				}
			}
		}
		hit_living_object(MainObject, image_index, other, ObjectArmourID, ObjectHelmetID, ObjectShieldID, other.x, other.y);
		instance_destroy(other);
	}
}

