/// @description Insert description here
// You can write your code in this editor

if(instance_exists(MainObject)){
	x = MainObject.x;
	y = MainObject.y;
	image_angle = MainObject.RotationAngle;
	
	
	if(MainObject.object_index == oEnemy){
		
		#region Knife hit
		var knife_object = instance_nearest(x, y, oKnife);
		if (instance_exists(knife_object)) {
		    if (instance_exists(knife_object.stats.Object) && knife_object.stats.Object_index == oPlayer) {
		        if (knife_object.stats.Object.knife_attack_timer >= 5 && MainObject.hit_timer == -1) {
		            var hitbox_corners = get_hitbox_corners(knife_object, 25, 50, 20, knife_object.stats.Object.RotationAngle);

		            // Get the min and max x and y coordinates from the hitbox corners to define the bounding box
		            var min_x = min(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
		            var max_x = max(hitbox_corners[0][0], hitbox_corners[1][0], hitbox_corners[2][0], hitbox_corners[3][0]);
		            var min_y = min(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);
		            var max_y = max(hitbox_corners[0][1], hitbox_corners[1][1], hitbox_corners[2][1], hitbox_corners[3][1]);

		            if (collision_rectangle(min_x, min_y, max_x, max_y, id, true, false)) {
						// Znemožnění dát hlavu s nožem - max(image_index, HitBox.BodyWithoutWeapon)
						hit_living_object(MainObject, max(image_index, HitBox.BodyWithoutWeapon), knife_object, MainObject.ArmourID, MainObject.HelmetID);
						
						MainObject.hit_timer = knife_object.stats.Hit_timer;
		            }
		        }
		    }
		}
		#endregion

		if(instance_exists(MainObject.ChasingObject)){
			if(MainObject.ChasingObject.object_index != oPlayer){
				MainObject.ChasingObject = oPlayer;
			}
		}
	}
}