/// @description Insert description here
// You can write your code in this editor
if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && visible == true){
	if(other.stats.Object != MainObject || other.stats.Tracer_image == 2){
		//var player_armour = global.player_stats_struct.Armour;
		var ObjectArmourID = global.ArmourID[0];
		var ObjectHelmetID = global.ArmourID[1];
		//var attack_damage = other.Damage * power(1 - global.ItemIndex[#other.Weapon, ItemStat.DamageDrop], point_distance(x, y, other.stats.Starting_x, other.stats.Starting_y));
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
		//hit_entity(MainObject, attack_damage * (1 - player_armour), image_index, other.Weapon, other.stats.Object,
		//global.ItemIndex[#other.Weapon, ItemStat.PenetrationPower], other.PenetrationDamage, ObjectArmourID, ObjectHelmetID);	
		instance_destroy(other);
	}
}