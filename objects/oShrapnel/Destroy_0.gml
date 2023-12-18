/// @description Insert description here
// You can write your code in this editor
if(Id == Item.CELandMine){
	ExplosionCreate(
		global.ItemIndex[#Id, ItemStat.AmmoSpriteID]/5,
		x,
		y,
		global.ItemIndex[#Id, ItemStat.Damage]/2,
		true,
		Object,
		global.ItemIndex[#Id, ItemStat.PenetrationPower]/2,
		global.ItemIndex[#Id, ItemStat.DamageDrop]*2,
		Item.None,
	);
}