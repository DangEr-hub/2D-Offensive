/// @description Reloading
if(global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.Defense] != 1){
		
	#region Normal reloading
	if(WeaponID[WeaponPositionID] != Item.Spas && WeaponID[WeaponPositionID] != Item.Javelin){
		particle_create(1, 0.75, random(360), spr_AmmoType, random_range(10, 30),
		random_range(-90, 90), point_direction(x, y, x + lengthdir_x(35, RotationAngle - 90), y + lengthdir_y(40, RotationAngle - 90)), 0, true, true, global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.AmmoSpriteID], x, y);		
	}
	if (Ammo[WeaponPositionID] < MaxAmmo[WeaponPositionID] && ClipAmmo[WeaponPositionID] > 0) {
		if (ClipAmmo[WeaponPositionID] > AmmoNeeded) {
			ClipAmmo[WeaponPositionID] -= AmmoNeeded;
			Ammo[WeaponPositionID] += AmmoNeeded;
		}else if (ClipAmmo[WeaponPositionID] < AmmoNeeded) {
			Ammo[WeaponPositionID] += ClipAmmo[WeaponPositionID];
			ClipAmmo[WeaponPositionID] -= ClipAmmo[WeaponPositionID];
		} else if (Ammo[WeaponPositionID] + ClipAmmo[WeaponPositionID] = MaxAmmo[WeaponPositionID]) {
			Ammo[WeaponPositionID] = MaxAmmo[WeaponPositionID];
			ClipAmmo[WeaponPositionID] = 0;
		}
	}
	Reloading = false;
	ReloadTime = 0;
	#endregion
		
}else{
		
	#region Fractionating reloading
	Reloading = false;
	ReloadTime = 0;
	if (Ammo[WeaponPositionID] < MaxAmmo[WeaponPositionID] && ClipAmmo[WeaponPositionID] > 0) {
		ClipAmmo[WeaponPositionID] -= 1;
		Ammo[WeaponPositionID] += 1;
	}
	if(Ammo[WeaponPositionID] < MaxAmmo[WeaponPositionID]){
		Reloading = true;
		alarm[4] = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpeed];
	}
	#endregion
		
}