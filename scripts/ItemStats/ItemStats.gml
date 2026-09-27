/// @description WeaponStat(Id, N, RS, Range, Dmg, CA, MA, T, In, ST, Snd, CrShake, CShake, HR, P1, P2, RX, RY, KBIM, MIM, KBP, ROX, ROY, SSM, BCID, TypeClass, MSM, PP, EQT, RSM, C, KBR, R, lck, cal, calt)
/// @param Id
/// @param  Nm
/// @param  RS
/// @param  Rng
/// @param  Dmg
/// @param  CA
/// @param  MA
/// @param  Typ
/// @param  In
/// @param  ST
/// @param  Snd
/// @param  CrS
/// @param  CS
/// @param  HR
/// @param  P1
/// @param  P2
/// @param  RX
/// @param  RY
/// @param  KBIM
/// @param  MIM
/// @param  KBP
/// @param  ROX
/// @param  ROY
/// @param  SSM
/// @param  BCID
/// @param TC
/// @param MSM
/// @param PP
/// @param EQT
/// @param RSM
/// @param C
/// @param KBR
/// @param R
/// @param lck
/// @param cal
/// @param calt

function WeaponStats(){
    ItemID = argument[0];
	global.ItemIndex[#ItemID, ITEMSTATS.Bullets] = 1;
    global.ItemIndex[#ItemID, ITEMSTATS.Name] = argument[1];
    global.ItemIndex[#ItemID, ITEMSTATS.ReloadSpeed] = argument[2];
    global.ItemIndex[#ItemID, ITEMSTATS.Range] = argument[3];
    global.ItemIndex[#ItemID, ITEMSTATS.Damage] = argument[4];
    global.ItemIndex[#ItemID, ITEMSTATS.ClipAmmo] = argument[5];
    global.ItemIndex[#ItemID, ITEMSTATS.MaxAmmo] = argument[6];
    global.ItemIndex[#ItemID, ITEMSTATS.WeaponType] = argument[7];
    global.ItemIndex[#ItemID, ITEMSTATS.Inaccuracy] = argument[8];
    global.ItemIndex[#ItemID, ITEMSTATS.ShootTimer] = argument[9];
    global.ItemIndex[#ItemID, ITEMSTATS.SoundID] = argument[10];
    global.ItemIndex[#ItemID, ITEMSTATS.CrosshairShake] = argument[11];
    global.ItemIndex[#ItemID, ITEMSTATS.CameraShake] = argument[12];
    global.ItemIndex[#ItemID, ITEMSTATS.HardRecoil] = argument[13];
    global.ItemIndex[#ItemID, ITEMSTATS.KBPhase1] = argument[14];
    global.ItemIndex[#ItemID, ITEMSTATS.KBPhase2] = argument[15];
    global.ItemIndex[#ItemID, ITEMSTATS.RecoilX] = argument[16];
    global.ItemIndex[#ItemID, ITEMSTATS.RecoilY] = argument[17];
    global.ItemIndex[#ItemID, ITEMSTATS.KickBackInaccuracyMultiplier] = argument[18];
    global.ItemIndex[#ItemID, ITEMSTATS.MovingInaccuracyMultiplier] = argument[19];
    global.ItemIndex[#ItemID, ITEMSTATS.KickBackPower] = argument[20];
    global.ItemIndex[#ItemID, ITEMSTATS.RecoilOffsetX] = argument[21];
    global.ItemIndex[#ItemID, ITEMSTATS.RecoilOffsetY] = argument[22];
    global.ItemIndex[#ItemID, ITEMSTATS.ShootSpdMul] = argument[23];
    global.ItemIndex[#ItemID, ITEMSTATS.BulletCasingID] = argument[24];
    global.ItemIndex[#ItemID, ITEMSTATS.WeaponTypeClass] = argument[25];
    global.ItemIndex[#ItemID, ITEMSTATS.MovingSpdMul] = argument[26];
    global.ItemIndex[#ItemID, ITEMSTATS.PenetrationPower] = argument[27];
    global.ItemIndex[#ItemID, ITEMSTATS.EquipTime] = argument[28];
    global.ItemIndex[#ItemID, ITEMSTATS.ReloadSpdMul] = argument[29];
    global.ItemIndex[#ItemID, ITEMSTATS.Cost] = argument[30];
    global.ItemIndex[#ItemID, ITEMSTATS.KBResetMultiplier] = argument[31];
    global.ItemIndex[#ItemID, ITEMSTATS.reward] = argument[32];
    global.ItemIndex[#ItemID, ITEMSTATS.is_locked] = argument[33];
    global.ItemIndex[#ItemID, ITEMSTATS.caliber] = argument[34];
    global.ItemIndex[#ItemID, ITEMSTATS.caliber_type] = argument[35];
}


function ArmourStats(ID, Name, Weight, Defense, Cost){
	ItemID = argument[0];
	global.ItemIndex[#ItemID, ITEMSTATS.Name] = argument[1];
	global.ItemIndex[#ItemID, ITEMSTATS.Weight] = argument[2];
	global.ItemIndex[#ItemID, ITEMSTATS.Defense] = argument[3];
	global.ItemIndex[#ItemID, ITEMSTATS.Cost] = argument[4];
	global.ItemIndex[# ItemID, ITEMSTATS.WeaponType] = -1;
}
