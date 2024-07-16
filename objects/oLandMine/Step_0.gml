if (alpha_timer > -1) {
    alpha_timer--;
} else {
    image_alpha -= .05;
    image_alpha = max(image_alpha, .1);
}

if (!explode) {
    explode = shouldExplode(oPlayer, stats.Object) || shouldExplode(oEnemy, stats.Object) || shouldExplode(oGrenade, stats.Object);
}

if(explode == true){
	if (image_timer < explosion_timer) {
	    image_timer++;
	    var progress = image_timer / explosion_timer;
	    image_index = lerp(ImageIndex, ImageIndex + 3, progress);
	}else{
	    image_index = ImageIndex + 3;
		explosion_create(
			global.ItemIndex[#stats.Item_id, ItemStat.AmmoSpriteID],
			x,
			y,
			global.ItemIndex[#stats.Item_id, ItemStat.Damage],
			true,
			stats.Object,
			stats.Item_id
		);
	}
}
