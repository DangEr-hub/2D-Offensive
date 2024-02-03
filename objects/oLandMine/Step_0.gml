if (alpha_timer > -1) {
    alpha_timer--;
} else {
    image_alpha -= .05;
    image_alpha = max(image_alpha, .1);
}

if (!explode) {
    explode = shouldExplode(oPlayer, Object) || shouldExplode(oEnemy, Object) || shouldExplode(oGrenade, Object);
}

if(explode == true){
	if (image_timer < explosion_timer) {
	    image_timer++;
	    var progress = image_timer / explosion_timer;
	    image_index = lerp(ImageIndex, ImageIndex + 3, progress);
	}else{
	    image_index = ImageIndex + 3;
		ExplosionCreate(
			global.ItemIndex[#Id, ItemStat.AmmoSpriteID],
			x,
			y,
			global.ItemIndex[#Id, ItemStat.Damage],
			true,
			Object,
			global.ItemIndex[#Id, ItemStat.PenetrationPower],
			global.ItemIndex[#Id, ItemStat.DamageDrop],
			Id
		);
	}
}
