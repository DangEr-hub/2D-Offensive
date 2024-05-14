event_inherited();
texture_width = 384 * global.GUIMultiplier;
texture_height = 128 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(texture_width, texture_height);


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = global.ItemIndex[#global.weapon_id[oPlayer.WeaponID], ItemStat.Name];
	draggable = 1;
}

weapon_width = 256 * global.GUIMultiplier;
weapon_height = 128 * global.GUIMultiplier;
weapon_x = zui_get_width() * .5;
weapon_y = zui_get_height() * .33 - (16 * global.GUIMultiplier);
with(zui_create(weapon_x, weapon_y, objUIImage)){
	zui_set_size(other.weapon_width, other.weapon_height);
	zui_set_anchor(0.5, 0);
	clickable = false;
	sprite_image_index = global.weapon_id[oPlayer.WeaponID];
	sprite = spr_Items;
	sprite_width_size = other.weapon_width;
	sprite_height_size = other.weapon_height;
}

gap = 16 * global.GUIMultiplier;
scope_drop_x = zui_get_width() * .1;
scope_drop_y = zui_get_height() * .25;
scope_caption = "Empty";

if(global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope] != Item.None){
	scope_caption = "Drop";
	with(zui_create(scope_drop_x, scope_drop_y + gap, objUIImage)){
		zui_set_size(other.weapon_width*.5, other.weapon_height*.5);
		zui_set_anchor(0.5, 0);
		clickable = false;
		sprite_image_index = global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope];
		sprite = spr_Items;
		sprite_width_size = other.weapon_width*.5;
		sprite_height_size = other.weapon_height*.5;
	}
}

with(zui_create(scope_drop_x, scope_drop_y, objUIButton)){
	zui_set_size(32 * global.GUIMultiplier, 16 * global.GUIMultiplier);
	caption_color = MAIN_COLOR;
	caption = other.scope_caption;
	callback = function(){
		GainItem(
			global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope],
			1,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			false
		);
		global.weapon_attachments[min(oPlayer.WeaponID, 1)][weapon_attachments.weapon_scope] = Item.None;	
	};
}
