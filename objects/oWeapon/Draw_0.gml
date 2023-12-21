/// @description Insert description here
// You can write your code in this editor
if(Visible == true){
	gpu_set_tex_filter(true);
	draw_self();
	gpu_set_tex_filter(false);
}

with(oEnemy){
	if(Visible == true && State != States.Death){
		if(CanShoot == false && ShootTimer >= global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootTimer]/1.5 && healing == false){
			draw_sprite_ext(spr_MuzzleFlash, 0, Weapon.x + lengthdir_x(WeaponDistance, RotationAngle), 
			Weapon.y + lengthdir_y(WeaponDistance, RotationAngle), 1, 1, RotationAngle, c_white, 1);
		}	
	}
}

with(oPlayer){
	if(CanShoot == false && ShootTimer >= global.ItemIndex[#global.weapon_id[min(WeaponID, 2)], ItemStat.ShootTimer]/1.5 && Healing == false){
		draw_sprite_ext(spr_MuzzleFlash, 0, FlashLightX, 
		FlashLightY, 1, 1, RotationAngle, c_white, 1);
	}
}