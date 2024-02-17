/// @description Insert description here
// You can write your code in this editor
if(oDraw.RespawnMenu == false && oDraw.PauseMenu == false && visible == true){
	if(other.Object != MainObject){
		var player_armour = global.player_stats_struct.Armour;
		var ObjectArmourID = global.ArmourID[0];
		var ObjectHelmetID = global.ArmourID[1];
		var attack_damage = other.Damage * power(1 - global.ItemIndex[#other.Weapon, ItemStat.DamageDrop], point_distance(x, y, other.starting_x, other.starting_y));
		if(MainObject.object_index != oPlayer){ ///Pokud to neni hitbox hrace
			player_armour = 0;
			ObjectArmourID = MainObject.ArmourID;
			ObjectHelmetID = MainObject.HelmetID;
			MainObject.enemy_aimpunch_direction = point_direction(other.starting_x, other.starting_y, other.x, other.y);
			if(instance_exists(MainObject.ChasingObject)){
				if(other.Object != oPlayer){
					if(MainObject.ChasingObject != other.Object){
						MainObject.ChasingObject = other.Object;
					}
				}else{
					MainObject.ChasingObject = oPlayer;
				}
			}
		}
		hit_entity(MainObject, attack_damage * (1 - player_armour), image_index, other.Weapon, other.Object,
		global.ItemIndex[#other.Weapon, ItemStat.PenetrationPower], other.PenetrationDamage, ObjectArmourID, ObjectHelmetID);	
		instance_destroy(other);
	}
}