/// @description Insert description here
// You can write your code in this editor
if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && visible == true){
	if(other.Object != MainObject){
		var attack_damage = other.Damage * power(1 - global.ItemIndex[#other.Weapon, ItemStat.DamageDrop], point_distance(x, y, other.StartingX, other.StartingY));
		if(MainObject.object_index != oPlayer){ ///Pokud to neni hitbox hrace
			var ObjectArmourID = MainObject.ArmourID;
			var ObjectHelmetID = MainObject.HelmetID;
			MainObject.enemy_aimpunch_direction = point_direction(other.StartingX, other.StartingY, other.x, other.y);
			if(instance_exists(MainObject.ChasingObject)){
				if(other.Object != oPlayer){
					if(MainObject.ChasingObject != other.Object && MainObject.State != States.Death){
						MainObject.ChasingObject = other.Object;
					}
				}else{
					MainObject.ChasingObject = oPlayer;
				}
			}
		}else{
			var ObjectArmourID = global.ArmourID[0];
			var ObjectHelmetID = global.ArmourID[1];
		}
		HitEntity(MainObject, attack_damage, image_index, other.Weapon, other.Object,
		global.ItemIndex[#other.Weapon, ItemStat.PenetrationPower], other.PenetrationDamage, ObjectArmourID, ObjectHelmetID);	
		instance_destroy(other);
	}
}