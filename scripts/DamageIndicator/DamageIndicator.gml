function DamageIndicator(DamageIndicatorString, PositionX, PositionY, DamageIndicatorColor, DamageIndicatorSprite, DamageIndicatorSpriteID) {
	Indicator = instance_create_depth(PositionX, PositionY, -100, oDamageIndicator);
	Indicator.Damage_Indicator = DamageIndicatorString;
	Indicator.Color = DamageIndicatorColor;
	Indicator.Sprite = DamageIndicatorSprite;
	Indicator.SpriteID = DamageIndicatorSpriteID;
}
