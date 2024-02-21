if(stats.Item_id == Item.CELandMine){
	ExplosionCreate(
		global.ItemIndex[#stats.Item_id, ItemStat.AmmoSpriteID]/5,
		x,
		y,
		global.ItemIndex[#stats.Item_id, ItemStat.Damage]/2,
		true,
		stats.Object,
		Item.base_explosion
	);
}


