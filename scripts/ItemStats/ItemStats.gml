/// @description WeaponStat(Id, Name, RS, Range, Dmg, CA, MA, Type, Bullets, In, ST, Sound, CrShake, CShake, HR, P1, P2, RX, RY, MKB, KBIM, MIM, KBP, RIM, ROX, ROY, SSM, BCID, TypeClass, MSM, PP, DD)
/// @param Id
/// @param  Name
/// @param  RS
/// @param  Range
/// @param  Dmg
/// @param  CA
/// @param  MA
/// @param  Type
/// @param  Bullets
/// @param  In
/// @param  ST
/// @param  Sound
/// @param  CrShake
/// @param  CShake
/// @param  HR
/// @param  P1
/// @param  P2
/// @param  RX
/// @param  RY
/// @param  MKB
/// @param  KBIM
/// @param  MIM
/// @param  KBP
/// @param  RIM
/// @param  ROX
/// @param  ROY
/// @param  SSM
/// @param  BCID
/// @param TypeClass
/// @param MSM
/// @param PP
/// @param DD
/// @param EQT
function WeaponStats(){
	ItemID = argument[0];
	global.ItemIndex[#ItemID, ItemStat.Name] = argument[1];
	global.ItemIndex[#ItemID, ItemStat.ReloadSpeed] = argument[2];
	global.ItemIndex[#ItemID, ItemStat.Range] = argument[3];
	global.ItemIndex[#ItemID, ItemStat.Damage] = argument[4];
	global.ItemIndex[#ItemID, ItemStat.ClipAmmo] = argument[5];
	global.ItemIndex[#ItemID, ItemStat.MaxAmmo] = argument[6];
	global.ItemIndex[#ItemID, ItemStat.WeaponType] = argument[7];
	global.ItemIndex[#ItemID, ItemStat.Bullets] = argument[8];
	global.ItemIndex[#ItemID, ItemStat.Inaccuracy] = argument[9];
	global.ItemIndex[#ItemID, ItemStat.ShootTimer] = argument[10];
	global.ItemIndex[#ItemID, ItemStat.SoundID] = argument[11];
	global.ItemIndex[#ItemID, ItemStat.CrosshairShake] = argument[12];
	global.ItemIndex[#ItemID, ItemStat.CameraShake] = argument[13];
	global.ItemIndex[#ItemID, ItemStat.HardRecoil] = argument[14];
	global.ItemIndex[#ItemID, ItemStat.KBPhase1] = argument[15];
	global.ItemIndex[#ItemID, ItemStat.KBPhase2] = argument[16];
	global.ItemIndex[#ItemID, ItemStat.RecoilX] = argument[17];
	global.ItemIndex[#ItemID, ItemStat.RecoilY] = argument[18];
	global.ItemIndex[#ItemID, ItemStat.MaxKickBack] = argument[19];
	global.ItemIndex[#ItemID, ItemStat.KickBackInaccuracyMultiplier] = argument[20];
	global.ItemIndex[#ItemID, ItemStat.MovingInaccuracyMultiplier] = argument[21];
	global.ItemIndex[#ItemID, ItemStat.KickBackPower] = argument[22];
	global.ItemIndex[#ItemID, ItemStat.RangeInaccuracyMultiplier] = argument[23];
	global.ItemIndex[#ItemID, ItemStat.RecoilOffsetX] = argument[24];
	global.ItemIndex[#ItemID, ItemStat.RecoilOffsetY] = argument[25];
	global.ItemIndex[#ItemID, ItemStat.ShootSpdMul] = argument[26];
	global.ItemIndex[#ItemID, ItemStat.BulletCasingID] = argument[27];
	global.ItemIndex[#ItemID, ItemStat.WeaponTypeClass] = argument[28];
	global.ItemIndex[#ItemID, ItemStat.Ammo] = global.ItemIndex[#ItemID, ItemStat.MaxAmmo];
	global.ItemIndex[#ItemID, ItemStat.MovingSpdMul] = argument[29];
	global.ItemIndex[#ItemID, ItemStat.PenetrationPower] = argument[30];
	global.ItemIndex[#ItemID, ItemStat.DamageDrop] = argument[31];
	global.ItemIndex[#ItemID, ItemStat.EquipTime] = argument[32];
}

function ArmourStats(ID, Name, Weight, Defense){
	ItemID = argument[0];
	global.ItemIndex[#ItemID, ItemStat.Name] = argument[1];
	global.ItemIndex[#ItemID, ItemStat.Weight] = argument[2];
	global.ItemIndex[#ItemID, ItemStat.Defense] = argument[3];
}