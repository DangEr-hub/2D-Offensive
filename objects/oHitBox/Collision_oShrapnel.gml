/// @description Insert description here
// You can write your code in this editor
if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && visible == true){
	var player_armour = global.player_stats_struct.Armour;
	var ObjectArmourID = global.ArmourID[0];
	var ObjectHelmetID = global.ArmourID[1];
	var attack_damage = other.Damage * power(1 - other.DamageDrop, point_distance(x, y, other.StartingX, other.StartingY));
	if(MainObject.object_index != oPlayer){ ///Pokud to neni hitbox hrace
		player_armour = 0;
		ObjectArmourID = MainObject.ArmourID;
		ObjectHelmetID = MainObject.HelmetID;
		if(instance_exists(MainObject.ChasingObject)){
			if(other.Object != oPlayer){
				if(MainObject.ChasingObject != other.Object && other.Object != MainObject){
					MainObject.ChasingObject = other.Object;
				}
			}else{
				MainObject.ChasingObject = oPlayer;
			}
		}
	}
	if(instance_exists(other.Object)){
		hit_entity(MainObject, attack_damage * (1 - player_armour), image_index, -1, other.Object, other.PenetrationPower, other.PenetrationDamage, ObjectArmourID, ObjectHelmetID);	
	}
	instance_destroy(other);
}