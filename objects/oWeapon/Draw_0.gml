/// @description Insert description here
// You can write your code in this editor
var owner_can_draw = instance_exists(Owner) && Owner.stats.Health_points > 0;

if(Visible == true && owner_can_draw){
	draw_self();
}

if(owner_can_draw && Owner.object_index == oBot && Owner.Visible == true){
	if(Owner.CanShoot == false
	&& Owner.ShootTimer >= global.ItemIndex[# Owner.WeaponID[Owner.WeaponPositionID], ItemStat.ShootTimer] / 1.5
	&& Owner.healing == false){
		draw_sprite_ext(
			spr_MuzzleFlash,
			0,
			Owner.Weapon.x + lengthdir_x(Owner.WeaponDistance, Owner.RotationAngle),
			Owner.Weapon.y + lengthdir_y(Owner.WeaponDistance, Owner.RotationAngle),
			1,
			1,
			Owner.RotationAngle,
			c_white,
			1
		);
	}
}
