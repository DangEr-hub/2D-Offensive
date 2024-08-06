event_inherited();
texture_width = 384 * global.GUIMultiplier;
texture_height = 192 * global.GUIMultiplier;

draw_set_font(set_font("Menu_small"));
zui_set_size(texture_width, texture_height);


with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
	caption = global.ItemIndex[# global.Inventory[# oPlayer.WeaponID, Index.slot_id], ItemStat.Name];//global.ItemIndex[#global.weapon_id[oPlayer.WeaponID], ItemStat.Name];
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
	sprite_image_index = global.Inventory[# oPlayer.WeaponID, Index.slot_id]//global.weapon_id[oPlayer.WeaponID];
	sprite = spr_Items;
	sprite_width_size = other.weapon_width;
	sprite_height_size = other.weapon_height;
}

gap = 4 * global.GUIMultiplier;

#region Scope drop button
scope_drop_x = zui_get_width() * .1;
scope_drop_y = zui_get_height() * .25 + (8 * global.GUIMultiplier);
scope_caption = "Empty";

if(global.GUIMultiplier <= 1){
	scope_drop_y = zui_get_height() * .39;
}

if(global.Inventory[# oPlayer.WeaponID, Index.slot_scope] != Item.None){
	scope_caption = "Unequip";
	with(zui_create(scope_drop_x, scope_drop_y + gap, objUIImage)){
		zui_set_size(other.weapon_width*.5, other.weapon_height*.5);
		zui_set_anchor(0.5, 0);
		clickable = false;
		sprite_image_index = global.Inventory[# oPlayer.WeaponID, Index.slot_scope];
		sprite = spr_Items;
		sprite_width_size = other.weapon_width*.5;
		sprite_height_size = other.weapon_height*.5;
	}
}

with(zui_create(scope_drop_x, scope_drop_y, objUIButton)){
	zui_set_size(48 * global.GUIMultiplier, 16 * global.GUIMultiplier);
	caption_color = MAIN_COLOR;
	caption = other.scope_caption;
	callback = function(){
		if(global.Inventory[# oPlayer.WeaponID, Index.slot_scope] != Item.None){
			GainItem(
				global.Inventory[# oPlayer.WeaponID, Index.slot_scope],
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
			global.Inventory[# oPlayer.WeaponID, Index.slot_scope] = Item.None;	
			if(instance_exists(oWeaponAttachments)){
				with(oWeaponAttachments){
					zui_destroy();
				}
			}
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
				}
			}
		}
	};
}
#endregion

#region Barrel drop button
barrel_drop_x = zui_get_width() * .25;
barrel_drop_y = zui_get_height() * .25 + (8 * global.GUIMultiplier);
barrel_caption = "Empty";

if(global.GUIMultiplier <= 1){
	barrel_drop_y = zui_get_height() * .39;
}

if(global.Inventory[# oPlayer.WeaponID, Index.slot_barrel] != Item.None){
	barrel_caption = "Unequip";
	with(zui_create(barrel_drop_x, barrel_drop_y + gap, objUIImage)){
		zui_set_size(other.weapon_width*.5, other.weapon_height*.5);
		zui_set_anchor(0.5, 0);
		clickable = false;
		sprite_image_index = global.Inventory[# oPlayer.WeaponID, Index.slot_barrel];
		sprite = spr_Items;
		sprite_width_size = other.weapon_width*.5;
		sprite_height_size = other.weapon_height*.5;
	}
}

with(zui_create(barrel_drop_x, barrel_drop_y, objUIButton)){
	zui_set_size(48 * global.GUIMultiplier, 16 * global.GUIMultiplier);
	caption_color = MAIN_COLOR;
	caption = other.barrel_caption;
	callback = function(){
		if(global.Inventory[# oPlayer.WeaponID, Index.slot_barrel] != Item.None){
			GainItem(
				global.Inventory[# oPlayer.WeaponID, Index.slot_barrel],
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
			global.Inventory[# oPlayer.WeaponID, Index.slot_barrel] = Item.None;	
			if(instance_exists(oWeaponAttachments)){
				with(oWeaponAttachments){
					zui_destroy();
				}
			}
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
				}
			}
		}
	};
}
#endregion

#region Grip drop button
grip_drop_x = zui_get_width() * .75;
grip_drop_y = zui_get_height() * .25 + (8 * global.GUIMultiplier);
grip_caption = "Empty";

if(global.GUIMultiplier <= 1){
	grip_drop_y = zui_get_height() * .39;
}

if(global.Inventory[# oPlayer.WeaponID, Index.slot_grip] != Item.None){
	grip_caption = "Unequip";
	with(zui_create(grip_drop_x, grip_drop_y + gap, objUIImage)){
		zui_set_size(other.weapon_width*.5, other.weapon_height*.5);
		zui_set_anchor(0.5, 0);
		clickable = false;
		sprite_image_index = global.Inventory[# oPlayer.WeaponID, Index.slot_grip];
		sprite = spr_Items;
		sprite_width_size = other.weapon_width*.5;
		sprite_height_size = other.weapon_height*.5;
	}
}

with(zui_create(grip_drop_x, grip_drop_y, objUIButton)){
	zui_set_size(48 * global.GUIMultiplier, 16 * global.GUIMultiplier);
	caption_color = MAIN_COLOR;
	caption = other.grip_caption;
	callback = function(){
		if(global.Inventory[# oPlayer.WeaponID, Index.slot_grip] != Item.None){
			GainItem(
				global.Inventory[# oPlayer.WeaponID, Index.slot_grip],
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
			global.Inventory[# oPlayer.WeaponID, Index.slot_grip] = Item.None;	
			if(instance_exists(oWeaponAttachments)){
				with(oWeaponAttachments){
					zui_destroy();
				}
			}
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
				}
			}
		}
	};
}
#endregion

#region Suppressor drop button
suppressor_drop_x = zui_get_width() * .9;
suppressor_drop_y = zui_get_height() * .25 + (8 * global.GUIMultiplier);
suppressor_caption = "Empty";

if(global.GUIMultiplier <= 1){
	suppressor_drop_y = zui_get_height() * .39;
}

if(global.Inventory[# oPlayer.WeaponID, Index.slot_suppressor] != Item.None){
	suppressor_caption = "Unequip";
	with(zui_create(suppressor_drop_x, suppressor_drop_y + gap, objUIImage)){
		zui_set_size(other.weapon_width*.5, other.weapon_height*.5);
		zui_set_anchor(0.5, 0);
		clickable = false;
		sprite_image_index = global.Inventory[# oPlayer.WeaponID, Index.slot_suppressor];
		sprite = spr_Items;
		sprite_width_size = other.weapon_width*.5;
		sprite_height_size = other.weapon_height*.5;
	}
}

with(zui_create(suppressor_drop_x, suppressor_drop_y, objUIButton)){
	zui_set_size(48 * global.GUIMultiplier, 16 * global.GUIMultiplier);
	caption_color = MAIN_COLOR;
	caption = other.suppressor_caption;
	callback = function(){
		if(global.Inventory[# oPlayer.WeaponID, Index.slot_suppressor] != Item.None){
			GainItem(
				global.Inventory[# oPlayer.WeaponID, Index.slot_suppressor],
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
			global.Inventory[# oPlayer.WeaponID, Index.slot_suppressor] = Item.None;	
			if(instance_exists(oWeaponAttachments)){
				with(oWeaponAttachments){
					zui_destroy();
				}
			}
			with(zui_main()){
				with(zui_create(zui_get_width() * .5, zui_get_height() * .75, oWeaponAttachments)){
						
				}
			}
		}
	};
}
#endregion
