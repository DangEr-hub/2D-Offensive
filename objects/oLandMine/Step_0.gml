if (alpha_timer > -1) {
    alpha_timer -= global.time_step;
} else {
    image_alpha -= .05 * global.time_step;
    image_alpha = max(image_alpha, min_alpha);
}

if (!explode) {
    explode = should_explode(oPlayer, stats.Object) || should_explode(oBot, stats.Object) || should_explode(oGrenade, stats.Object);
}

if(explode == true){
	if (image_timer < explosion_timer) {
	    image_timer += global.time_step;
	    var progress = image_timer / explosion_timer;
	    image_index = lerp(ImageIndex, ImageIndex + 3, progress);
	}else{
	    image_index = ImageIndex + 3;
		explosion_create(
			global.ItemIndex[#stats.Item_id, ItemStat.AmmoSpriteID],
			[x, y],
			global.ItemIndex[#stats.Item_id, ItemStat.Damage],
			true,
			stats.Object,
			stats.Item_id
		);
	}
}
