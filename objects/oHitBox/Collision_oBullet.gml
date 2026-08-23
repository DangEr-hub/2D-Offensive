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

			var attacker = other.stats.Object;
			if (instance_exists(attacker)
			&& variable_instance_exists(attacker, "stats")
			&& is_struct(attacker.stats)
			&& variable_struct_exists(attacker.stats, "Team")
			&& variable_struct_exists(attacker.stats, "Health_points")
			&& attacker.stats.Team != MainObject.stats.Team
			&& attacker.stats.Health_points > 0) {
				MainObject.ChasingObject = attacker;
			}
		}
		hit_living_object(MainObject, image_index, other, ObjectArmourID, ObjectHelmetID, ObjectShieldID, other.x, other.y);
		instance_destroy(other);
	}
}

