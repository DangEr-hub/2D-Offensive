/* Begin step */
if(stats.Health_points <= 0){
	exit;
}
var ReloadingSpeedMultiplier = 1;
var ShootingSpeedMultiplier = 1;
var MovingSpeedMultiplier = 1;
var cmd_mod = 1;

if(Reloading == true){
	ReloadingSpeedMultiplier = global.ItemIndex[#WeaponID[WeaponPositionID], ITEMSTATS.ReloadSpdMul];
}

if(CanShoot == false){
	ShootingSpeedMultiplier = global.ItemIndex[#WeaponID[WeaponPositionID], ITEMSTATS.ShootSpdMul];	
}

if(XSpeed != 0 || YSpeed != 0){
	MovingSpeedMultiplier = global.ItemIndex[#WeaponID[WeaponPositionID], ITEMSTATS.MovingSpdMul];
}

if(State == STATES.MoveCommand){
	cmd_mod = 1.25;	
}

MaxSpeed = min(2 * rank_boost, 4.5) * ReloadingSpeedMultiplier * ShootingSpeedMultiplier * MovingSpeedMultiplier * cmd_mod;
