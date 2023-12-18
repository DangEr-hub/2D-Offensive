function shouldExplode(obj) {
	if(instance_exists(oEnemy)){
	    if (obj == oEnemy && oEnemy.State == States.Death) {
	        return false;
	    }
	}

    return (distance_to_object(obj) <= explosion_distance && (Object == noone || Object.object_index != obj));
}

if (alpha_timer > -1) {
    alpha_timer--;
} else {
    image_alpha -= .05;
    image_alpha = max(image_alpha, .1);
}

if (!explode) {
    explode = shouldExplode(oPlayer) || shouldExplode(oEnemy) || shouldExplode(oGrenade);
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
