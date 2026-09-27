if(stats.Item_id == ITEM.CELandMine){
	explosion_create(
		global.ItemIndex[#stats.Item_id, ITEMSTATS.AmmoSpriteID]/5,
		[x, y],
		global.ItemIndex[#stats.Item_id, ITEMSTATS.Damage]/2,
		true,
		stats.Object,
		ITEM.base_explosion
	);
}


