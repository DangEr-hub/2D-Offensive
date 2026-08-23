/* Begin step */
if(stats.Health_points <= 0){
	exit;
}
var ReloadingSpeedMultiplier = 1;
var ShootingSpeedMultiplier = 1;
var MovingSpeedMultiplier = 1;

if(Reloading == true){
	ReloadingSpeedMultiplier = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ReloadSpdMul];
}

if(CanShoot == false){
	ShootingSpeedMultiplier = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.ShootSpdMul];	
}

if(XSpeed != 0 || YSpeed != 0){
	MovingSpeedMultiplier = global.ItemIndex[#WeaponID[WeaponPositionID], ItemStat.MovingSpdMul];
}
MaxSpeed = min(2.5 * rank_boost, 5.75) * ReloadingSpeedMultiplier * ShootingSpeedMultiplier * MovingSpeedMultiplier;

