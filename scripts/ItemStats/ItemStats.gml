/// @description WeaponStat(Id, N, RS, Range, Dmg, CA, MA, T, B, In, ST, Snd, CrShake, CShake, HR, P1, P2, RX, RY, MKB, KBIM, MIM, KBP, RIM, ROX, ROY, SSM, BCID, TypeClass, MSM, PP, DD)
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
/// @param  RIM
/// @param  ROX
/// @param  ROY
/// @param  SSM
/// @param  BCID
/// @param TC
/// @param MSM
/// @param PP
/// @param DD
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
	global.ItemIndex[#ItemID, ItemStat.Bullets] = 1;
    global.ItemIndex[#ItemID, ItemStat.Name] = argument[1];
    global.ItemIndex[#ItemID, ItemStat.ReloadSpeed] = argument[2];
    global.ItemIndex[#ItemID, ItemStat.Range] = argument[3];
    global.ItemIndex[#ItemID, ItemStat.Damage] = argument[4];
    global.ItemIndex[#ItemID, ItemStat.ClipAmmo] = argument[5];
    global.ItemIndex[#ItemID, ItemStat.MaxAmmo] = argument[6];
    global.ItemIndex[#ItemID, ItemStat.WeaponType] = argument[7];
    global.ItemIndex[#ItemID, ItemStat.Inaccuracy] = argument[8];
    global.ItemIndex[#ItemID, ItemStat.ShootTimer] = argument[9];
    global.ItemIndex[#ItemID, ItemStat.SoundID] = argument[10];
    global.ItemIndex[#ItemID, ItemStat.CrosshairShake] = argument[11];
    global.ItemIndex[#ItemID, ItemStat.CameraShake] = argument[12];
    global.ItemIndex[#ItemID, ItemStat.HardRecoil] = argument[13];
    global.ItemIndex[#ItemID, ItemStat.KBPhase1] = argument[14];
    global.ItemIndex[#ItemID, ItemStat.KBPhase2] = argument[15];
    global.ItemIndex[#ItemID, ItemStat.RecoilX] = argument[16];
    global.ItemIndex[#ItemID, ItemStat.RecoilY] = argument[17];
    global.ItemIndex[#ItemID, ItemStat.KickBackInaccuracyMultiplier] = argument[18];
    global.ItemIndex[#ItemID, ItemStat.MovingInaccuracyMultiplier] = argument[19];
    global.ItemIndex[#ItemID, ItemStat.KickBackPower] = argument[20];
    global.ItemIndex[#ItemID, ItemStat.accuracy_drop] = argument[21];
    global.ItemIndex[#ItemID, ItemStat.RecoilOffsetX] = argument[22];
    global.ItemIndex[#ItemID, ItemStat.RecoilOffsetY] = argument[23];
    global.ItemIndex[#ItemID, ItemStat.ShootSpdMul] = argument[24];
    global.ItemIndex[#ItemID, ItemStat.BulletCasingID] = argument[25];
    global.ItemIndex[#ItemID, ItemStat.WeaponTypeClass] = argument[26];
    global.ItemIndex[#ItemID, ItemStat.MovingSpdMul] = argument[27];
    global.ItemIndex[#ItemID, ItemStat.PenetrationPower] = argument[28];
    global.ItemIndex[#ItemID, ItemStat.DamageDrop] = argument[29];
    global.ItemIndex[#ItemID, ItemStat.EquipTime] = argument[30];
    global.ItemIndex[#ItemID, ItemStat.ReloadSpdMul] = argument[31];
    global.ItemIndex[#ItemID, ItemStat.Cost] = argument[32];
    global.ItemIndex[#ItemID, ItemStat.KBResetMultiplier] = argument[33];
    global.ItemIndex[#ItemID, ItemStat.reward] = argument[34];
    global.ItemIndex[#ItemID, ItemStat.is_locked] = argument[35];
    global.ItemIndex[#ItemID, ItemStat.caliber] = argument[36];
    global.ItemIndex[#ItemID, ItemStat.caliber_type] = argument[37];
}


function ArmourStats(ID, Name, Weight, Defense){
	ItemID = argument[0];
	global.ItemIndex[#ItemID, ItemStat.Name] = argument[1];
	global.ItemIndex[#ItemID, ItemStat.Weight] = argument[2];
	global.ItemIndex[#ItemID, ItemStat.Defense] = argument[3];
	global.ItemIndex[#ItemID, ItemStat.Cost] = argument[4];
}