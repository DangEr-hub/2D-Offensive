/// @description Insert description
	// YSpeed
	for (i = 0; i < abs(YSpeed); ++i) {
	    // UP slope
	    if (place_meeting(x, y + sign(YSpeed), oParentTile) && !place_meeting(x - 1, y + sign(YSpeed), oParentTile)){
	        --x;
			--HeadHitBox.x;
			--BodyHitBox.x;
			--ArmHitBox.x;
			--Weapon.x;
		}
		
		if(instance_exists(Legs)){
			Legs.image_speed = 1;
		}
    
	    if (place_meeting(x, y + sign(YSpeed), oParentTile) && !place_meeting(x + 1, y + sign(YSpeed), oParentTile)){
	        ++x;
			++HeadHitBox.x;
			++BodyHitBox.x;
			++ArmHitBox.x;
			++Weapon.x;
		}
		
		if(instance_exists(Legs)){
			Legs.image_speed = 1;
		}

		if (!place_meeting(x, y + sign(YSpeed), oParentTile)){
		    y += sign(YSpeed);
			HeadHitBox.y += sign(YSpeed);
			BodyHitBox.y += sign(YSpeed);
			ArmHitBox.y += sign(YSpeed);
			Weapon.y += sign(YSpeed);
		}
		else {
		    YSpeed = 0;
			if(instance_exists(Legs)){
				Legs.image_speed = 0;
			}
		    break;
		}
	}

	// XSpeed
	for (i = 0; i < abs(XSpeed); ++i) { 
	    // Slopes
	    if (place_meeting(x + sign(XSpeed), y, oParentTile) && !place_meeting(x + sign(XSpeed), y - 1, oParentTile)){
	        --y;
			--HeadHitBox.y;
			--BodyHitBox.y;
			--ArmHitBox.y;
			--Weapon.y;
		}
		
		if(instance_exists(Legs)){
			Legs.image_speed = 1;
		}
    
	    if (place_meeting(x + sign(XSpeed), y, oParentTile) && !place_meeting(x + sign(XSpeed), y + 1, oParentTile)){
	        ++y;
			++HeadHitBox.y;
			++BodyHitBox.y;
			++ArmHitBox.y;
			++Weapon.y;
		}
		
		if(instance_exists(Legs)){
			Legs.image_speed = 1;
		}
         
		if (!place_meeting(x + sign(XSpeed), y, oParentTile)){
		    x += sign(XSpeed); 
			HeadHitBox.x += sign(XSpeed);
			BodyHitBox.x += sign(XSpeed);
			ArmHitBox.x += sign(XSpeed);
			Weapon.x += sign(XSpeed);
		}
		else {
		    XSpeed = 0;
			if(instance_exists(Legs)){
				Legs.image_speed = 0;
			}
		    break;
		}
	}
	
// Stay away from walls
if (place_meeting(x + 1, y, oParentTile)) {
	MoveTime = random_range(9, 18);
	MoveDirection  = 180 + random_range(-45, 45);
}

if (place_meeting(x - 1, y, oParentTile)) {
	MoveTime = random_range(9, 18);
	MoveDirection  = 0 + random_range(-45, 45);
}

if (place_meeting(x, y - 1, oParentTile)) {
	MoveTime = random_range(9, 18);
	MoveDirection  = 270 + random_range(-45, 45);
}

if (place_meeting(x, y + 1, oParentTile)) {
	MoveTime = random_range(9, 18);
	MoveDirection  = 90 + random_range(-45, 45);
}