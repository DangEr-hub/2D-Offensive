/// @description Insert description here
// You can write your code in this editor
if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && visible == true){
	if(MainObject.object_index != oPlayer){ ///Pokud to neni hitbox hrace
		ObjectArmourID = MainObject.ArmourID;
		ObjectHelmetID = MainObject.HelmetID;
		if(instance_exists(MainObject.ChasingObject)){
			if(other.Object != oPlayer){
				if(MainObject.ChasingObject != other.Object && MainObject.State != States.Death && other.Object != MainObject){
					MainObject.ChasingObject = other.Object;
				}
			}else{
				MainObject.ChasingObject = oPlayer;
			}
		}
	}else{
		ObjectArmourID = global.ArmourID[0];
		ObjectHelmetID = global.ArmourID[1];
	}
	HitEntity(MainObject, other.Damage* 
	power(1 - other.DamageDrop, point_distance(x, y, other.StartingPointX, other.StartingPointY)), image_index, -1, other.Object, other.PenetrationPower, other.PenetrationDamage, ObjectArmourID, ObjectHelmetID);	
	instance_destroy(other);
}