/// @description Movement
/* End step */
if(stats.Health_points <= 0){
	exit;
}

var hasLegs = instance_exists(Legs);
if(XSpeed == 0 && YSpeed == 0){
	if(hasLegs){
		Legs.image_speed = 0;
	}
	exit;
}
if(hasLegs){
	Legs.image_speed = (1 * global.time_step);
}

// --------------------
// Y AXIS (hybrid move)
// --------------------
var ys = YSpeed * global.time_step;
if(ys != 0){
	var ystep = sign(ys);
	// try full move
	if(!place_meeting(x, y + ys, oParentTile)){
		y += ys;
		HeadHB.y += ys;
		BodyHB.y += ys;
		ArmHB.y += ys;
		Weapon.y += ys;
	}else{
		repeat(abs(ys)){
			// slopes only if blocked
			if(place_meeting(x, y + ystep, oParentTile)){
				if(!place_meeting(x - 1, y + ystep, oParentTile)){
					x -= 1;
					HeadHB.x -= 1;
					BodyHB.x -= 1;
					ArmHB.x -= 1;
					Weapon.x -= 1;
				}else if(!place_meeting(x + 1, y + ystep, oParentTile)){
					x += 1;
					HeadHB.x += 1;
					BodyHB.x += 1;
					ArmHB.x += 1;
					Weapon.x += 1;
				}
			}

			if(!place_meeting(x, y + ystep, oParentTile)){
				y += ystep;
				HeadHB.y += ystep;
				BodyHB.y += ystep;
				ArmHB.y += ystep;
				Weapon.y += ystep;
			}else{
				YSpeed = 0;
				break;
			}
		}
	}
}

// --------------------
// X AXIS (hybrid move)
// --------------------
var xs = XSpeed * global.time_step;
if(xs != 0){
	var xstep = sign(xs);

	// try full move
	if(!place_meeting(x + xs, y, oParentTile)){
		x += xs;
		HeadHB.x += xs;
		BodyHB.x += xs;
		ArmHB.x += xs;
		Weapon.x += xs;
	}else{
		repeat(abs(xs)){
			// slopes only if blocked
			if(place_meeting(x + xstep, y, oParentTile)){
				if(!place_meeting(x + xstep, y - 1, oParentTile)){
					y -= 1;
					HeadHB.y -= 1;
					BodyHB.y -= 1;
					ArmHB.y -= 1;
					Weapon.y -= 1;
				}else if(!place_meeting(x + xstep, y + 1, oParentTile)){
					y += 1;
					HeadHB.y += 1;
					BodyHB.y += 1;
					ArmHB.y += 1;
					Weapon.y += 1;
				}
			}

			if(!place_meeting(x + xstep, y, oParentTile)){
				x += xstep;
				HeadHB.x += xstep;
				BodyHB.x += xstep;
				ArmHB.x += xstep;
				Weapon.x += xstep;
			}else{
				XSpeed = 0;
				break;
			}
		}
	}
}

// stop legs if fully blocked
if(hasLegs && XSpeed == 0 && YSpeed == 0){
	Legs.image_speed = 0;
}

// --------------------
// Stay away from walls
// --------------------
if(place_meeting(x + 1, y, oParentTile)){
	MoveTime = random_range(9, 18);
	MoveDirection = 180 + random_range(-45, 45);
}else if(place_meeting(x - 1, y, oParentTile)){
	MoveTime = random_range(9, 18);
	MoveDirection = 0 + random_range(-45, 45);
}else if(place_meeting(x, y - 1, oParentTile)){
	MoveTime = random_range(9, 18);
	MoveDirection = 270 + random_range(-45, 45);
}else if(place_meeting(x, y + 1, oParentTile)){
	MoveTime = random_range(9, 18);
	MoveDirection = 90 + random_range(-45, 45);
}